Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6067F4F68DF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbiDFSIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240410AbiDFSHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44947188579;
        Wed,  6 Apr 2022 09:46:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29DE723A;
        Wed,  6 Apr 2022 09:46:13 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CC413F73B;
        Wed,  6 Apr 2022 09:46:12 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 12/43] clocksource/drivers/arm_arch_timer: Remove fsl-a008585 parameter
Date:   Wed,  6 Apr 2022 17:45:15 +0100
Message-Id: <20220406164546.1888528-12-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Tianhong <dingtianhong@huawei.com>

commit 5444ea6a7f46276876e94ecf8d44615af1ef22f7 upstream.

Having a command line option to flip the errata handling for a
particular erratum is a little bit unusual, and it's vastly superior to
pass this in the DT. By common consensus, it's best to kill off the
command line parameter.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
[Mark: split patch, reword commit message]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
---
 Documentation/kernel-parameters.txt  |  9 ---------
 drivers/clocksource/arm_arch_timer.c | 14 --------------
 2 files changed, 23 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6c0957c67d20..f2b10986ab88 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -751,15 +751,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			loops can be debugged more effectively on production
 			systems.
 
-	clocksource.arm_arch_timer.fsl-a008585=
-			[ARM64]
-			Format: <bool>
-			Enable/disable the workaround of Freescale/NXP
-			erratum A-008585.  This can be useful for KVM
-			guests, if the guest device tree doesn't show the
-			erratum.  If unspecified, the workaround is
-			enabled based on the device tree.
-
 	clearcpuid=BITNUM [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5d7f83d27093..c2a5e8252cd7 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -101,20 +101,6 @@ EXPORT_SYMBOL_GPL(arch_timer_read_ool_enabled);
 
 static int fsl_a008585_enable = -1;
 
-static int __init early_fsl_a008585_cfg(char *buf)
-{
-	int ret;
-	bool val;
-
-	ret = strtobool(buf, &val);
-	if (ret)
-		return ret;
-
-	fsl_a008585_enable = val;
-	return 0;
-}
-early_param("clocksource.arm_arch_timer.fsl-a008585", early_fsl_a008585_cfg);
-
 u32 __fsl_a008585_read_cntp_tval_el0(void)
 {
 	return __fsl_a008585_read_reg(cntp_tval_el0);
-- 
2.30.2

