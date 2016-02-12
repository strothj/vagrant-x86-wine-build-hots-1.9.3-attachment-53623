#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
set -e

apt-get update && apt-get install -y git
git clone https://github.com/wine-mirror/wine.git
mkdir -p wine-dirs/wine-build
mv wine wine-dirs/wine-source
cd wine-dirs/wine-source
git checkout tags/wine-1.9.3
patch -p1 </vagrant_data/attachment-53623.diff

cd ../wine-build
apt-get install -y \
  libpcap-dev \
  python-software-properties
apt-get build-dep -y wine
../wine-source/configure
make
mkdir /vagrant_data/build
cp -R * /vagrant_data/build
