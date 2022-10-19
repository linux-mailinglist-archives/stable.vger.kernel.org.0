Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FCD603E3C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiJSJLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiJSJIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:08:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C963AB32;
        Wed, 19 Oct 2022 01:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D07766174B;
        Wed, 19 Oct 2022 08:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CDFC433D6;
        Wed, 19 Oct 2022 08:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169909;
        bh=VCVhEPhtSbllVj8a+QGysUU1wTphg1WLChqnpby9OoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHpsCX5GQcDG84arHUoB0gNpl17c8fqjWvDvJwFOO4/eFsKX76uA+r+x/btxfVv0U
         QyeVrA2jFFW2SXq0aklXL54iigvToYjEq4IBZpskjDzaMj8DFjjRtJ4cNIP/LBjE29
         Fbd7vemBGDyikdtcgvS70I3Np4Hu1GrVT3FxfpQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Gongyi <zhaogongyi@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 455/862] selftests/cpu-hotplug: Delete fault injection related code
Date:   Wed, 19 Oct 2022 10:29:02 +0200
Message-Id: <20221019083310.083958104@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Gongyi <zhaogongyi@huawei.com>

[ Upstream commit 195d74be717af14e5991f818f73f067367bfc1ed ]

Delete fault injection related code since the module has been deleted.

Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 51d4c851465c ("selftests/cpu-hotplug: Reserve one cpu online at least")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cpu-hotplug/config    |  1 -
 .../selftests/cpu-hotplug/cpu-on-off-test.sh  | 87 ++-----------------
 2 files changed, 6 insertions(+), 82 deletions(-)
 delete mode 100644 tools/testing/selftests/cpu-hotplug/config

diff --git a/tools/testing/selftests/cpu-hotplug/config b/tools/testing/selftests/cpu-hotplug/config
deleted file mode 100644
index d4aca2ad5069..000000000000
--- a/tools/testing/selftests/cpu-hotplug/config
+++ /dev/null
@@ -1 +0,0 @@
-CONFIG_NOTIFIER_ERROR_INJECTION=y
diff --git a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
index 940b68c940bb..32ec7e4489ee 100755
--- a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
+++ b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
@@ -116,10 +116,10 @@ online_cpu_expect_fail()
 
 	if online_cpu $cpu 2> /dev/null; then
 		echo $FUNCNAME $cpu: unexpected success >&2
-		exit 1
+		retval=1
 	elif ! cpu_is_offline $cpu; then
 		echo $FUNCNAME $cpu: unexpected online >&2
-		exit 1
+		retval=1
 	fi
 }
 
@@ -142,16 +142,14 @@ offline_cpu_expect_fail()
 
 	if offline_cpu $cpu 2> /dev/null; then
 		echo $FUNCNAME $cpu: unexpected success >&2
-		exit 1
+		retval=1
 	elif ! cpu_is_online $cpu; then
 		echo $FUNCNAME $cpu: unexpected offline >&2
-		exit 1
+		retval=1
 	fi
 }
 
-error=-12
 allcpus=0
-priority=0
 online_cpus=0
 online_max=0
 offline_cpus=0
@@ -159,31 +157,20 @@ offline_max=0
 present_cpus=0
 present_max=0
 
-while getopts e:ahp: opt; do
+while getopts ah opt; do
 	case $opt in
-	e)
-		error=$OPTARG
-		;;
 	a)
 		allcpus=1
 		;;
 	h)
-		echo "Usage $0 [ -a ] [ -e errno ] [ -p notifier-priority ]"
+		echo "Usage $0 [ -a ]"
 		echo -e "\t default offline one cpu"
 		echo -e "\t run with -a option to offline all cpus"
 		exit
 		;;
-	p)
-		priority=$OPTARG
-		;;
 	esac
 done
 
-if ! [ "$error" -ge -4095 -a "$error" -lt 0 ]; then
-	echo "error code must be -4095 <= errno < 0" >&2
-	exit 1
-fi
-
 prerequisite
 
 #
@@ -231,66 +218,4 @@ for cpu in `hotplaggable_offline_cpus`; do
 	online_cpu_expect_success $cpu
 done
 
-#
-# Test with cpu notifier error injection
-#
-
-DEBUGFS=`mount -t debugfs | head -1 | awk '{ print $3 }'`
-NOTIFIER_ERR_INJECT_DIR=$DEBUGFS/notifier-error-inject/cpu
-
-prerequisite_extra()
-{
-	msg="skip extra tests:"
-
-	/sbin/modprobe -q -r cpu-notifier-error-inject
-	/sbin/modprobe -q cpu-notifier-error-inject priority=$priority
-
-	if [ ! -d "$DEBUGFS" ]; then
-		echo $msg debugfs is not mounted >&2
-		exit $ksft_skip
-	fi
-
-	if [ ! -d $NOTIFIER_ERR_INJECT_DIR ]; then
-		echo $msg cpu-notifier-error-inject module is not available >&2
-		exit $ksft_skip
-	fi
-}
-
-prerequisite_extra
-
-#
-# Offline all hot-pluggable CPUs
-#
-echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
-for cpu in `hotpluggable_online_cpus`; do
-	offline_cpu_expect_success $cpu
-done
-
-#
-# Test CPU hot-add error handling (offline => online)
-#
-echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_UP_PREPARE/error
-for cpu in `hotplaggable_offline_cpus`; do
-	online_cpu_expect_fail $cpu
-done
-
-#
-# Online all hot-pluggable CPUs
-#
-echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_UP_PREPARE/error
-for cpu in `hotplaggable_offline_cpus`; do
-	online_cpu_expect_success $cpu
-done
-
-#
-# Test CPU hot-remove error handling (online => offline)
-#
-echo $error > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
-for cpu in `hotpluggable_online_cpus`; do
-	offline_cpu_expect_fail $cpu
-done
-
-echo 0 > $NOTIFIER_ERR_INJECT_DIR/actions/CPU_DOWN_PREPARE/error
-/sbin/modprobe -q -r cpu-notifier-error-inject
-
 exit $retval
-- 
2.35.1



