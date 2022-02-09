Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1B4AFBCB
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbiBISua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbiBISuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:50:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA56AC1DF812;
        Wed,  9 Feb 2022 10:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E895B82386;
        Wed,  9 Feb 2022 18:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BACAC340E9;
        Wed,  9 Feb 2022 18:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432311;
        bh=0x8uk8ogZkTiQRkXjDuzshmOMcA8a04iiSihN0Uu/A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTby6kELZW4UpUoZ/kzwZK8qcrujnWQAGH9wfelz3WdG5P/U3ZGUG+6dauU6TaK3M
         R1cNko2wGZklaomqmivMrbs65Ud8Pa3PHTbw9WDDqTt4fXfRBYG/YOSqHePwxwOqss
         PE2McFnTHsI3WS+i4HRbKUB21DDVZ3ZAr4zjJdqQry74J8DsZha/NVdmYfUM/kdYeX
         XNh6ljTU0vIYVLnld2dKjowhHMi4+QwIy93keGyAa3i2BVyvkvNpqGzVaDB44pQW1w
         d6A9t0vkkdpjzmF1ijsFAomDcXnBbmhq/ZUiuxgg7sOzZoswD+9pJ8e6o9v3Dl/17i
         MfiHdThyVT8cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/8] selftests/zram: Skip max_comp_streams interface on newer kernel
Date:   Wed,  9 Feb 2022 13:44:55 -0500
Message-Id: <20220209184502.48363-2-sashal@kernel.org>
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
index 9e73a4fb9b0aa..2c1d1c567f854 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -20,6 +20,9 @@ dev_mounted=-1
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+kernel_version=`uname -r | cut -d'.' -f1,2`
+kernel_major=${kernel_version%.*}
+kernel_minor=${kernel_version#*.}
 
 trap INT
 
@@ -34,6 +37,20 @@ check_prereqs()
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
@@ -95,6 +112,13 @@ zram_max_streams()
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

