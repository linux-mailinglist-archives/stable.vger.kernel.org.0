Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F786041D1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiJSKsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiJSKrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:47:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DA15B122;
        Wed, 19 Oct 2022 03:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B5CB82436;
        Wed, 19 Oct 2022 08:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872F1C433C1;
        Wed, 19 Oct 2022 08:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169911;
        bh=4D97w+ZQu+bU7Fk+WX+tUrif/4N620Eec9wOqEqA3S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8iy/iiGFAuGS+5fJrG5hJMpQbdSwdRiXD/ZJ8aDnpPEHUZda4yyX9C3BdEH2fAN3
         4GRrPJ9xUg1ILJPmV0+Qq3UCOBIXnbmDIlubtMstxhvh3CrymCvs5Zboknz73oDAld
         yj8c/6ABV75bSVChNp+b3YO334H83BhpAxzAs6kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Gongyi <zhaogongyi@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 456/862] selftests/cpu-hotplug: Reserve one cpu online at least
Date:   Wed, 19 Oct 2022 10:29:03 +0200
Message-Id: <20221019083310.133101348@linuxfoundation.org>
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

[ Upstream commit 51d4c851465c32143d9c7b1cfb46fc581922b116 ]

Considering that we can not offline all cpus in any cases,
we need to reserve one cpu online when the test offline all
hotpluggable online cpus, otherwise the test will fail forever.

Fixes: d89dffa976bc ("fault-injection: add selftests for cpu and memory hotplug")

Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/cpu-hotplug/cpu-on-off-test.sh  | 40 ++++++++++---------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
index 32ec7e4489ee..4c1d6d9abecc 100755
--- a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
+++ b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
@@ -149,6 +149,25 @@ offline_cpu_expect_fail()
 	fi
 }
 
+online_all_hot_pluggable_cpus()
+{
+	for cpu in `hotplaggable_offline_cpus`; do
+		online_cpu_expect_success $cpu
+	done
+}
+
+offline_all_hot_pluggable_cpus()
+{
+	local reserve_cpu=$online_max
+	for cpu in `hotpluggable_online_cpus`; do
+		# Reserve one cpu oneline at least.
+		if [ $cpu -eq $reserve_cpu ];then
+			continue
+		fi
+		offline_cpu_expect_success $cpu
+	done
+}
+
 allcpus=0
 online_cpus=0
 online_max=0
@@ -197,25 +216,10 @@ else
 	echo -e "\t online all offline cpus"
 fi
 
-#
-# Online all hot-pluggable CPUs
-#
-for cpu in `hotplaggable_offline_cpus`; do
-	online_cpu_expect_success $cpu
-done
+online_all_hot_pluggable_cpus
 
-#
-# Offline all hot-pluggable CPUs
-#
-for cpu in `hotpluggable_online_cpus`; do
-	offline_cpu_expect_success $cpu
-done
+offline_all_hot_pluggable_cpus
 
-#
-# Online all hot-pluggable CPUs again
-#
-for cpu in `hotplaggable_offline_cpus`; do
-	online_cpu_expect_success $cpu
-done
+online_all_hot_pluggable_cpus
 
 exit $retval
-- 
2.35.1



