Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09E0630A0A
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiKSCWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiKSCVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:21:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AC8BEB5D;
        Fri, 18 Nov 2022 18:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AA68B825B6;
        Sat, 19 Nov 2022 02:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24B2C433D7;
        Sat, 19 Nov 2022 02:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824053;
        bh=AtO9SezOINz3pi/r9ihqNEXOEzBncb2vaqfaJpfkuhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2Ckk76uLW4pvlFtyOz8Ls/ElvoLAnO/DKqoHTy8eKGXYO9M7u8cw1A/C1Dp/zZio
         iGQ+cI3YgKEBfRvjjlgXiFCd+mSgKEKfhZpHOcmUgqRQtBrGCenzOOnoAS9Zt5uD5u
         xeTPnZfvkrxis1k08JvS/C/8ga8zN2wCdW1KNoeg7f6x4ghgKG6+jEfLC6i+xqBRO2
         W52XLFosa+mNdzCI9dfxiG6ixMOiG2idZUb3vHanT2PMkwzgEEfXYRTMYG71ne+3yH
         5XJPxFSeBUOt9zhcdPb/RFKMqb6bHDGjUlfcPeYvf0b5YKvDYrFev5/j0C9E9RSvdr
         TMeBVx1OpDhQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/27] clocksource/drivers/hyperv: add data structure for reference TSC MSR
Date:   Fri, 18 Nov 2022 21:13:34 -0500
Message-Id: <20221119021352.1774592-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
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
index 56348a541c50..1f314389e2be 100644
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

