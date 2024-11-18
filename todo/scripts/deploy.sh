#!/bin/bash
echo "> 현재 USER NAME을 가져옵니다."
CURRENT_USER=$(whoami)

echo "> download 폴더에서 build된 .jar 파일을 가져옵니다."
cp /home/$CURRENT_USER/download/todo/builds/libs/*.jar /home/$CURRENT_USER/deploy/

echo "> deploy 폴더에서 plain.jar 파일을 찾고, 파일이 있다면 삭제합니다."
find /home/$CURRENT_USER/deploy -name "*plain*" -delete 2>/dev/null || true

echo "> download 폴더를 삭제합니다."
rm -rf /home/$CURRENT_USER/download

echo "> 작동 중인 애플리케이션을 찾습니다."
CURRENT_PID=$(pgrep -f todo-0.0.1-SNAPSHOT.*\.jar)

if [ -z "$CURRENT_PID" ]; then
    echo "> 실행 중인 애플리케이션이 없습니다."
else
    echo "> kill -9 $CURRENT_PID"
    kill -9 $CURRENT_PID
    sleep 3
fi

echo "> 새 애플리케이션을 시작합니다."
cd /home/$CURRENT_USER/deploy
nohup java -jar \
    -Dspring.profiles.active=prod \
    $(ls -t *.jar | grep -v 'plain' | head -n1) \
    1>stdout.txt 2>stderr.txt &

echo "> 새 애플리케이션이 시작되었습니다."
sleep 3