Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF144AFBF4
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbiBISv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbiBISub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:50:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E943FC01CB31;
        Wed,  9 Feb 2022 10:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7186D612B3;
        Wed,  9 Feb 2022 18:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15068C340E7;
        Wed,  9 Feb 2022 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432335;
        bh=lWQyRUsHNeogGgSlwf5ifeyPlKhUtf9p/geX3mGnQv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYIvq5c7TRjdjvUjIWAuZeP+h7cs+OuUtJSiDalcVVwj3vv+skw8XcuIrPzHLgUs6
         VWTnfb7b0BSvMiOpUis69eeLiGZSDLg67VY4tJRaAVxITd9j7sxPCwClX/VddCIYKO
         z/ZX4zhTcuQUt/cw9/FeyODnsjimYocaBBrvDIfoihddvhqXOjeUvjOvlcqiYoFjou
         h3fHp86iWpv3aW69+wtTZDt+ky+0YFURwKDPwRtxdwzzBaZyaSojVx6geOKKdFmrkC
         4P2FFdocTcpBGHEDWck/g2YwrEf3yM7521RGynGoa24dQel4T64H1prt/vbZB0+dcD
         pt7aj/aO31RpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/8] selftests/zram: Adapt the situation that /dev/zram0 is being used
Date:   Wed,  9 Feb 2022 13:44:57 -0500
Message-Id: <20220209184502.48363-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184502.48363-1-sashal@kernel.org>
References: <20220209184502.48363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

[ Upstream commit 01dabed20573804750af5c7bf8d1598a6bf7bf6e ]

If zram-generator package is installed and works, then we can not remove
zram module because zram swap is being used. This case needs a clean zram
environment, change this test by using hot_add/hot_remove interface. So
even zram device is being used, we still can add zram device and remove
them in cleanup.

The two interface was introduced since kernel commit 6566d1a32bf7("zram:
add dynamic device add/remove functionality") in v4.2-rc1. If kernel
supports these two interface, we use hot_add/hot_remove to slove this
problem, if not, just check whether zram is being used or built in, then
skip it on old kernel.

Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/zram/zram.sh     |  15 +---
 tools/testing/selftests/zram/zram01.sh   |   3 +-
 tools/testing/selftests/zram/zram02.sh   |   1 -
 tools/testing/selftests/zram/zram_lib.sh | 110 +++++++++++++----------
 4 files changed, 66 insertions(+), 63 deletions(-)

diff --git a/tools/testing/selftests/zram/zram.sh b/tools/testing/selftests/zram/zram.sh
index 232e958ec4547..b0b91d9b0dc21 100755
--- a/tools/testing/selftests/zram/zram.sh
+++ b/tools/testing/selftests/zram/zram.sh
@@ -2,9 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TCID="zram.sh"
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
 . ./zram_lib.sh
 
 run_zram () {
@@ -18,14 +15,4 @@ echo ""
 
 check_prereqs
 
-# check zram module exists
-MODULE_PATH=/lib/modules/`uname -r`/kernel/drivers/block/zram/zram.ko
-if [ -f $MODULE_PATH ]; then
-	run_zram
-elif [ -b /dev/zram0 ]; then
-	run_zram
-else
-	echo "$TCID : No zram.ko module or /dev/zram0 device file not found"
-	echo "$TCID : CONFIG_ZRAM is not set"
-	exit $ksft_skip
-fi
+run_zram
diff --git a/tools/testing/selftests/zram/zram01.sh b/tools/testing/selftests/zram/zram01.sh
index ac6e4ddd2604e..8abc9965089d1 100755
--- a/tools/testing/selftests/zram/zram01.sh
+++ b/tools/testing/selftests/zram/zram01.sh
@@ -42,7 +42,7 @@ zram_algs="lzo"
 
 zram_fill_fs()
 {
-	for i in $(seq 0 $(($dev_num - 1))); do
+	for i in $(seq $dev_start $dev_end); do
 		echo "fill zram$i..."
 		local b=0
 		while [ true ]; do
@@ -76,7 +76,6 @@ zram_mount
 
 zram_fill_fs
 zram_cleanup
-zram_unload
 
 if [ $ERR_CODE -ne 0 ]; then
 	echo "$TCID : [FAIL]"
diff --git a/tools/testing/selftests/zram/zram02.sh b/tools/testing/selftests/zram/zram02.sh
index 74569b883737f..3768cfd2e5f83 100755
--- a/tools/testing/selftests/zram/zram02.sh
+++ b/tools/testing/selftests/zram/zram02.sh
@@ -45,7 +45,6 @@ zram_set_memlimit
 zram_makeswap
 zram_swapoff
 zram_cleanup
-zram_unload
 
 if [ $ERR_CODE -ne 0 ]; then
 	echo "$TCID : [FAIL]"
diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 2c1d1c567f854..130d193cbd727 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -14,10 +14,12 @@
 # Author: Alexey Kodanev <alexey.kodanev@oracle.com>
 # Modified: Naresh Kamboju <naresh.kamboju@linaro.org>
 
-MODULE=0
 dev_makeswap=-1
 dev_mounted=-1
-
+dev_start=0
+dev_end=-1
+module_load=-1
+sys_control=-1
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 kernel_version=`uname -r | cut -d'.' -f1,2`
@@ -55,57 +57,72 @@ zram_cleanup()
 {
 	echo "zram cleanup"
 	local i=
-	for i in $(seq 0 $dev_makeswap); do
+	for i in $(seq $dev_start $dev_makeswap); do
 		swapoff /dev/zram$i
 	done
 
-	for i in $(seq 0 $dev_mounted); do
+	for i in $(seq $dev_start $dev_mounted); do
 		umount /dev/zram$i
 	done
 
-	for i in $(seq 0 $(($dev_num - 1))); do
+	for i in $(seq $dev_start $dev_end); do
 		echo 1 > /sys/block/zram${i}/reset
 		rm -rf zram$i
 	done
 
-}
+	if [ $sys_control -eq 1 ]; then
+		for i in $(seq $dev_start $dev_end); do
+			echo $i > /sys/class/zram-control/hot_remove
+		done
+	fi
 
-zram_unload()
-{
-	if [ $MODULE -ne 0 ] ; then
-		echo "zram rmmod zram"
+	if [ $module_load -eq 1 ]; then
 		rmmod zram > /dev/null 2>&1
 	fi
 }
 
 zram_load()
 {
-	# check zram module exists
-	MODULE_PATH=/lib/modules/`uname -r`/kernel/drivers/block/zram/zram.ko
-	if [ -f $MODULE_PATH ]; then
-		MODULE=1
-		echo "create '$dev_num' zram device(s)"
-		modprobe zram num_devices=$dev_num
-		if [ $? -ne 0 ]; then
-			echo "failed to insert zram module"
-			exit 1
-		fi
-
-		dev_num_created=$(ls /dev/zram* | wc -w)
+	echo "create '$dev_num' zram device(s)"
+
+	# zram module loaded, new kernel
+	if [ -d "/sys/class/zram-control" ]; then
+		echo "zram modules already loaded, kernel supports" \
+			"zram-control interface"
+		dev_start=$(ls /dev/zram* | wc -w)
+		dev_end=$(($dev_start + $dev_num - 1))
+		sys_control=1
+
+		for i in $(seq $dev_start $dev_end); do
+			cat /sys/class/zram-control/hot_add > /dev/null
+		done
+
+		echo "all zram devices (/dev/zram$dev_start~$dev_end" \
+			"successfully created"
+		return 0
+	fi
 
-		if [ "$dev_num_created" -ne "$dev_num" ]; then
-			echo "unexpected num of devices: $dev_num_created"
-			ERR_CODE=-1
+	# detect old kernel or built-in
+	modprobe zram num_devices=$dev_num
+	if [ ! -d "/sys/class/zram-control" ]; then
+		if grep -q '^zram' /proc/modules; then
+			rmmod zram > /dev/null 2>&1
+			if [ $? -ne 0 ]; then
+				echo "zram module is being used on old kernel" \
+					"without zram-control interface"
+				exit $ksft_skip
+			fi
 		else
-			echo "zram load module successful"
+			echo "test needs CONFIG_ZRAM=m on old kernel without" \
+				"zram-control interface"
+			exit $ksft_skip
 		fi
-	elif [ -b /dev/zram0 ]; then
-		echo "/dev/zram0 device file found: OK"
-	else
-		echo "ERROR: No zram.ko module or no /dev/zram0 device found"
-		echo "$TCID : CONFIG_ZRAM is not set"
-		exit 1
+		modprobe zram num_devices=$dev_num
 	fi
+
+	module_load=1
+	dev_end=$(($dev_num - 1))
+	echo "all zram devices (/dev/zram0~$dev_end) successfully created"
 }
 
 zram_max_streams()
@@ -119,7 +136,7 @@ zram_max_streams()
 		return 0
 	fi
 
-	local i=0
+	local i=$dev_start
 	for max_s in $zram_max_streams; do
 		local sys_path="/sys/block/zram${i}/max_comp_streams"
 		echo $max_s > $sys_path || \
@@ -131,7 +148,7 @@ zram_max_streams()
 			echo "FAIL can't set max_streams '$max_s', get $max_stream"
 
 		i=$(($i + 1))
-		echo "$sys_path = '$max_streams' ($i/$dev_num)"
+		echo "$sys_path = '$max_streams'"
 	done
 
 	echo "zram max streams: OK"
@@ -141,15 +158,16 @@ zram_compress_alg()
 {
 	echo "test that we can set compression algorithm"
 
-	local algs=$(cat /sys/block/zram0/comp_algorithm)
+	local i=$dev_start
+	local algs=$(cat /sys/block/zram${i}/comp_algorithm)
 	echo "supported algs: $algs"
-	local i=0
+
 	for alg in $zram_algs; do
 		local sys_path="/sys/block/zram${i}/comp_algorithm"
 		echo "$alg" >	$sys_path || \
 			echo "FAIL can't set '$alg' to $sys_path"
 		i=$(($i + 1))
-		echo "$sys_path = '$alg' ($i/$dev_num)"
+		echo "$sys_path = '$alg'"
 	done
 
 	echo "zram set compression algorithm: OK"
@@ -158,14 +176,14 @@ zram_compress_alg()
 zram_set_disksizes()
 {
 	echo "set disk size to zram device(s)"
-	local i=0
+	local i=$dev_start
 	for ds in $zram_sizes; do
 		local sys_path="/sys/block/zram${i}/disksize"
 		echo "$ds" >	$sys_path || \
 			echo "FAIL can't set '$ds' to $sys_path"
 
 		i=$(($i + 1))
-		echo "$sys_path = '$ds' ($i/$dev_num)"
+		echo "$sys_path = '$ds'"
 	done
 
 	echo "zram set disksizes: OK"
@@ -175,14 +193,14 @@ zram_set_memlimit()
 {
 	echo "set memory limit to zram device(s)"
 
-	local i=0
+	local i=$dev_start
 	for ds in $zram_mem_limits; do
 		local sys_path="/sys/block/zram${i}/mem_limit"
 		echo "$ds" >	$sys_path || \
 			echo "FAIL can't set '$ds' to $sys_path"
 
 		i=$(($i + 1))
-		echo "$sys_path = '$ds' ($i/$dev_num)"
+		echo "$sys_path = '$ds'"
 	done
 
 	echo "zram set memory limit: OK"
@@ -191,8 +209,8 @@ zram_set_memlimit()
 zram_makeswap()
 {
 	echo "make swap with zram device(s)"
-	local i=0
-	for i in $(seq 0 $(($dev_num - 1))); do
+	local i=$dev_start
+	for i in $(seq $dev_start $dev_end); do
 		mkswap /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
@@ -215,7 +233,7 @@ zram_makeswap()
 zram_swapoff()
 {
 	local i=
-	for i in $(seq 0 $dev_makeswap); do
+	for i in $(seq $dev_start $dev_end); do
 		swapoff /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
@@ -229,7 +247,7 @@ zram_swapoff()
 
 zram_makefs()
 {
-	local i=0
+	local i=$dev_start
 	for fs in $zram_filesystems; do
 		# if requested fs not supported default it to ext2
 		which mkfs.$fs > /dev/null 2>&1 || fs=ext2
@@ -248,7 +266,7 @@ zram_makefs()
 zram_mount()
 {
 	local i=0
-	for i in $(seq 0 $(($dev_num - 1))); do
+	for i in $(seq $dev_start $dev_end); do
 		echo "mount /dev/zram$i"
 		mkdir zram$i
 		mount /dev/zram$i zram$i > /dev/null || \
-- 
2.34.1

