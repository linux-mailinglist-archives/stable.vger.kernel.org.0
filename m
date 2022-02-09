Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407D34AFAF7
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiBISlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240643AbiBISlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:41:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9D1C05CB86;
        Wed,  9 Feb 2022 10:41:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 457BDB821BD;
        Wed,  9 Feb 2022 18:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462DEC340E7;
        Wed,  9 Feb 2022 18:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432086;
        bh=OSHo2PJpIYtB2DIHy0v4CkW2SRFnO9seM4Vk8G09WJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g582IdaVQATm7fAxT4WBtciZaD9MIeWgjCfd9qXPowabF6mRtAgLlPWY/HOEmkmhM
         oH8E6QsjLMJs7VBP0kqteOq2YGoJ5CKSRB9YOGre97j1cHKnbGqE14jZvj/4h8TVtB
         sgNbnZL5F5hlCG+4AEkF5s8DpcMpKvew7vaVn64lipevImuRZCCnR7OpX9hQkVyCZx
         0+lk6cThk64W652u5CYcBYEGkKEz2F6RlyYlpMkBQgBOlnW0XZKzSOGnuUjjXzV+ub
         V1AzFB3P3EA9UnbUBT8SXr3dxqmamNJ3PZfP627jGRZ2qZs0b1kSi4/WhKHunEG7vq
         FbLhMK5/1EAZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/27] selftests/zram: Skip max_comp_streams interface on newer kernel
Date:   Wed,  9 Feb 2022 13:40:42 -0500
Message-Id: <20220209184103.47635-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
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

[ Upstream commit fc4eb486a59d70bd35cf1209f0e68c2d8b979193 ]

Since commit 43209ea2d17a ("zram: remove max_comp_streams internals"), zram
has switched to per-cpu streams. Even kernel still keep this interface for
some reasons, but writing to max_comp_stream doesn't take any effect. So
skip it on newer kernel ie 4.7.

The code that comparing kernel version is from xfstests testsuite ext4/053.

Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/zram/zram_lib.sh | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 6f872f266fd11..f47fc0f27e99e 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -11,6 +11,9 @@ dev_mounted=-1
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+kernel_version=`uname -r | cut -d'.' -f1,2`
+kernel_major=${kernel_version%.*}
+kernel_minor=${kernel_version#*.}
 
 trap INT
 
@@ -25,6 +28,20 @@ check_prereqs()
 	fi
 }
 
+kernel_gte()
+{
+	major=${1%.*}
+	minor=${1#*.}
+
+	if [ $kernel_major -gt $major ]; then
+		return 0
+	elif [[ $kernel_major -eq $major && $kernel_minor -ge $minor ]]; then
+		return 0
+	fi
+
+	return 1
+}
+
 zram_cleanup()
 {
 	echo "zram cleanup"
@@ -86,6 +103,13 @@ zram_max_streams()
 {
 	echo "set max_comp_streams to zram device(s)"
 
+	kernel_gte 4.7
+	if [ $? -eq 0 ]; then
+		echo "The device attribute max_comp_streams was"\
+		               "deprecated in 4.7"
+		return 0
+	fi
+
 	local i=0
 	for max_s in $zram_max_streams; do
 		local sys_path="/sys/block/zram${i}/max_comp_streams"
-- 
2.34.1

