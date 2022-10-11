Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94F65FB684
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiJKPGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiJKPGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:06:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC65B41D30;
        Tue, 11 Oct 2022 07:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56A83B81632;
        Tue, 11 Oct 2022 14:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B760C433C1;
        Tue, 11 Oct 2022 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499992;
        bh=ojCmeGHkofBLPO9rvISVcCUKCRfazna5eqPo7nU17v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENTD9QJJIonOXqUnyIaZM0BofS5NtLnsm3z0iI2wsl79HvSe4HViaph7OY02XsREq
         X4+rUhFKcc6EShrHx+niAlbYJnPWPc36R1BOYIRX60x7idfSXu14Payi0UvKUl9Uwo
         U4GsoJlFC8kA37TlO5zHkxPyaOSw0qinlD02YpnF9iIYExKXd0SQLleHRe5Xc9wqRJ
         UdVTT4g9eCXv8l7IFkxiF9hLWQYUrcfcILPwGoDqk05JDfMOG03zTzifsjX62QYapY
         TUb8iNvnOiD565/iCn3JSbAHP0G1Z1BmYHls8+qRuMpdKKdQOS/nMzKVQrSQlEV204
         /jW+DKn+D4JPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhao Gongyi <zhaogongyi@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/26] selftests/cpu-hotplug: Use return instead of exit
Date:   Tue, 11 Oct 2022 10:52:33 -0400
Message-Id: <20221011145233.1624013-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Gongyi <zhaogongyi@huawei.com>

[ Upstream commit 972cf4ce51ef5532d56822af17defb148aac0ccb ]

Some cpus will be left in offline state when online
function exits in some error conditions. Use return
instead of exit to fix it.

Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/cpu-hotplug/cpu-on-off-test.sh        | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
index 0d26b5e3f966..940b68c940bb 100755
--- a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
+++ b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
@@ -4,6 +4,7 @@
 SYSFS=
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+retval=0
 
 prerequisite()
 {
@@ -102,10 +103,10 @@ online_cpu_expect_success()
 
 	if ! online_cpu $cpu; then
 		echo $FUNCNAME $cpu: unexpected fail >&2
-		exit 1
+		retval=1
 	elif ! cpu_is_online $cpu; then
 		echo $FUNCNAME $cpu: unexpected offline >&2
-		exit 1
+		retval=1
 	fi
 }
 
@@ -128,10 +129,10 @@ offline_cpu_expect_success()
 
 	if ! offline_cpu $cpu; then
 		echo $FUNCNAME $cpu: unexpected fail >&2
-		exit 1
+		retval=1
 	elif ! cpu_is_offline $cpu; then
 		echo $FUNCNAME $cpu: unexpected offline >&2
-		exit 1
+		retval=1
 	fi
 }
 
@@ -201,7 +202,7 @@ if [ $allcpus -eq 0 ]; then
 		offline_cpu_expect_success $present_max
 		online_cpu $present_max
 	fi
-	exit 0
+	exit $retval
 else
 	echo "Full scope test: all hotplug cpus"
 	echo -e "\t online all offline cpus"
@@ -291,3 +292,5 @@ done
 
 echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
 /sbin/modprobe -q -r cpu-notifier-error-inject
+
+exit $retval
-- 
2.35.1

