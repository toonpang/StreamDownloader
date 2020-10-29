#!/usr/bin/env bash

# ==============================================================================
# constants
# ==============================================================================
CWD=$(pwd)
SCRIPT_PATH=$(dirname $(realpath -s $BASH_SOURCE[0]))
TMP_DIR=/tmp/download_video

# ==============================================================================
# function
# ==============================================================================
download(){
  mkdir -p $TMP_DIR/$3 && \
  ffmpeg -nostdin -loglevel warning -i $1 -map p:0 -c copy -f segment -segment_list $TMP_DIR/$3/out.list $TMP_DIR/$3/out%03d.ts && \
  ffmpeg -nostdin  -loglevel warning -f concat -safe 0 -i <(for f in $TMP_DIR/$3/*.ts; do echo "file '$f'"; done) -c copy $CWD/$2 && \
  rm -rf $TMP_DIR
}

# ==============================================================================
# main
# ==============================================================================
if [ -z "$1" ]
  then
    echo "Usage:"
    echo -e "\t./download_video.sh <input_csv>"
    exit 1
fi

echo Reading from input file $1
n=0
while read line; do
URL=$(cut -f1 -d, <<< "$line")
FILE_NAME=$(cut -f2 -d, <<< "$line")

echo Working on line $FILE_NAME

download $URL ${FILE_NAME// /_}.mp4 $n
n=$((n+1))
done < $1



