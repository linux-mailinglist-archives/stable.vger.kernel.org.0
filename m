Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50215630954
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiKSCM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiKSCMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363567118C;
        Fri, 18 Nov 2022 18:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1AEC62832;
        Sat, 19 Nov 2022 02:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E8CC433D7;
        Sat, 19 Nov 2022 02:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823913;
        bh=XiX+Ep7dbAOGNF6oQIJOeyAKQjrnd2qOY8+7kYrI3oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hx9RC44bmjHWoyn6R4rKnas5qCe4od2GIHm4uU2BuRifRO7EwR6CNE58N/WLgl7wu
         sY+Q/Reu0piqZJ7U3RxKXNYRrtshwmz9mGVRaMRdGfDLuLIfFTlDb/LsPHfcyp6K7q
         pATY0Yc2LzpQet5ymeaCjw2VQN2/pHG0BWljF1x5yWSBsMGD2HTUNgk6T/hmpEDoxa
         okgk8x5cpASYjPB4QDsxULg6dyycfaXX9PTovbmMlXg95QhE4o1stFGVZHlzwebHtI
         x4O+mVun7Ucy9j/8D8sNzOD123KUEEn6C9zWBoHiMUMiY5fdc4ptP5UNbkQp44N1SG
         /sg0bxBV39EfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 13/44] clocksource/drivers/hyperv: add data structure for reference TSC MSR
Date:   Fri, 18 Nov 2022 21:10:53 -0500
Message-Id: <20221119021124.1773699-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Anirudh Rayabharam <anrayabh@linux.microsoft.com>

[ Upstream commit 4ad1aa571214e8d6468a1806794d987b374b5a08 ]

Add a data structure to represent the reference TSC MSR similar to
other MSRs. This simplifies the code for updating the MSR.

Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20221027095729.1676394-2-anrayabh@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/hyperv_timer.c | 29 +++++++++++++++--------------
 include/asm-generic/hyperv-tlfs.h  |  9 +++++++++
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index bb47610bbd1c..18de1f439ffd 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/acpi.h>
+#include <linux/hyperv.h>
 #include <clocksource/hyperv_timer.h>
 #include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
@@ -395,25 +396,25 @@ static u64 notrace read_hv_sched_clock_tsc(void)
 
 static void suspend_hv_clock_tsc(struct clocksource *arg)
 {
-	u64 tsc_msr;
+	union hv_reference_tsc_msr tsc_msr;
 
 	/* Disable the TSC page */
-	tsc_msr = hv_get_register(HV_REGISTER_REFERENCE_TSC);
-	tsc_msr &= ~BIT_ULL(0);
-	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
+	tsc_msr.as_uint64 = hv_get_register(HV_REGISTER_REFERENCE_TSC);
+	tsc_msr.enable = 0;
+	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr.as_uint64);
 }
 
 
 static void resume_hv_clock_tsc(struct clocksource *arg)
 {
 	phys_addr_t phys_addr = virt_to_phys(&tsc_pg);
-	u64 tsc_msr;
+	union hv_reference_tsc_msr tsc_msr;
 
 	/* Re-enable the TSC page */
-	tsc_msr = hv_get_register(HV_REGISTER_REFERENCE_TSC);
-	tsc_msr &= GENMASK_ULL(11, 0);
-	tsc_msr |= BIT_ULL(0) | (u64)phys_addr;
-	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
+	tsc_msr.as_uint64 = hv_get_register(HV_REGISTER_REFERENCE_TSC);
+	tsc_msr.enable = 1;
+	tsc_msr.pfn = HVPFN_DOWN(phys_addr);
+	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr.as_uint64);
 }
 
 #ifdef HAVE_VDSO_CLOCKMODE_HVCLOCK
@@ -495,7 +496,7 @@ static __always_inline void hv_setup_sched_clock(void *sched_clock) {}
 
 static bool __init hv_init_tsc_clocksource(void)
 {
-	u64		tsc_msr;
+	union hv_reference_tsc_msr tsc_msr;
 	phys_addr_t	phys_addr;
 
 	if (!(ms_hyperv.features & HV_MSR_REFERENCE_TSC_AVAILABLE))
@@ -530,10 +531,10 @@ static bool __init hv_init_tsc_clocksource(void)
 	 * (which already has at least the low 12 bits set to zero since
 	 * it is page aligned). Also set the "enable" bit, which is bit 0.
 	 */
-	tsc_msr = hv_get_register(HV_REGISTER_REFERENCE_TSC);
-	tsc_msr &= GENMASK_ULL(11, 0);
-	tsc_msr = tsc_msr | 0x1 | (u64)phys_addr;
-	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
+	tsc_msr.as_uint64 = hv_get_register(HV_REGISTER_REFERENCE_TSC);
+	tsc_msr.enable = 1;
+	tsc_msr.pfn = HVPFN_DOWN(phys_addr);
+	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr.as_uint64);
 
 	clocksource_register_hz(&hyperv_cs_tsc, NSEC_PER_SEC/100);
 
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdce7a4cfc6f..b17c6eeb9afa 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -102,6 +102,15 @@ struct ms_hyperv_tsc_page {
 	volatile s64 tsc_offset;
 } __packed;
 
+union hv_reference_tsc_msr {
+	u64 as_uint64;
+	struct {
+		u64 enable:1;
+		u64 reserved:11;
+		u64 pfn:52;
+	} __packed;
+};
+
 /*
  * The guest OS needs to register the guest ID with the hypervisor.
  * The guest ID is a 64 bit entity and the structure of this ID is
-- 
2.35.1

