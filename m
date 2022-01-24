Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8BC49952C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392377AbiAXUvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390179AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C23C061390;
        Mon, 24 Jan 2022 11:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C522D60989;
        Mon, 24 Jan 2022 19:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE24C340E5;
        Mon, 24 Jan 2022 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054115;
        bh=P8FNdST8MIiMSsIkJay1Yf+qqqIZclz8ADarO4rtgH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1S1veKmJsgXsddXj+m945kCxDrZTnJZ23ErNmY1YgiH7QAGfM5crSnzyNWMtO5Cc
         +d/buD//KVDvxt5M5EcpusFS12PCzl6cpH54JgtZbNP3Z/HYrm3Sj6qIxpAv2GJivN
         WIg3kfyw7lHeQJ44Y3jpfhxeBpdKOOMLnfUUqQ+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/563] powerpc/perf: MMCR0 control for PMU registers under PMCC=00
Date:   Mon, 24 Jan 2022 19:40:15 +0100
Message-Id: <20220124184033.066628118@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 91668ab7db4bcfae332e561df1de2401f3f18553 ]

PowerISA v3.1 introduces new control bit (PMCCEXT) for restricting
access to group B PMU registers in problem state when
MMCR0 PMCC=0b00. In problem state and when MMCR0 PMCC=0b00,
setting the Monitor Mode Control Register bit 54 (MMCR0 PMCCEXT),
will restrict read permission on Group B Performance Monitor
Registers (SIER, SIAR, SDAR and MMCR1). When this bit is set to zero,
group B registers will be readable. In other platforms (like power9),
the older behaviour is retained where group B PMU SPRs are readable.

Patch adds support for MMCR0 PMCCEXT bit in power10 by enabling
this bit during boot and during the PMU event enable/disable callback
functions.

Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606409684-1589-8-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg.h        | 1 +
 arch/powerpc/kernel/cpu_setup_power.c | 1 +
 arch/powerpc/kernel/dt_cpu_ftrs.c     | 1 +
 arch/powerpc/perf/core-book3s.c       | 4 ++++
 arch/powerpc/perf/isa207-common.c     | 8 ++++++++
 5 files changed, 15 insertions(+)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index f4b98903064f5..6afb14b6bbc26 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -865,6 +865,7 @@
 #define   MMCR0_BHRBA	0x00200000UL /* BHRB Access allowed in userspace */
 #define   MMCR0_EBE	0x00100000UL /* Event based branch enable */
 #define   MMCR0_PMCC	0x000c0000UL /* PMC control */
+#define   MMCR0_PMCCEXT	ASM_CONST(0x00000200) /* PMCCEXT control */
 #define   MMCR0_PMCC_U6	0x00080000UL /* PMC1-6 are R/W by user (PR) */
 #define   MMCR0_PMC1CE	0x00008000UL /* PMC1 count enable*/
 #define   MMCR0_PMCjCE	ASM_CONST(0x00004000) /* PMCj count enable*/
diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kernel/cpu_setup_power.c
index 0c2191ee139ec..3cca88ee96d71 100644
--- a/arch/powerpc/kernel/cpu_setup_power.c
+++ b/arch/powerpc/kernel/cpu_setup_power.c
@@ -123,6 +123,7 @@ static void init_PMU_ISA31(void)
 {
 	mtspr(SPRN_MMCR3, 0);
 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
+	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
 }
 
 /*
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 1098863e17ee8..9d079659b24d3 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -454,6 +454,7 @@ static void init_pmu_power10(void)
 
 	mtspr(SPRN_MMCR3, 0);
 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
+	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
 }
 
 static int __init feat_enable_pmu_power10(struct dt_cpu_feature *f)
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 91452313489f1..7bda7499d0401 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -95,6 +95,7 @@ static unsigned int freeze_events_kernel = MMCR0_FCS;
 #define SPRN_SIER3		0
 #define MMCRA_SAMPLE_ENABLE	0
 #define MMCRA_BHRB_DISABLE     0
+#define MMCR0_PMCCEXT		0
 
 static inline unsigned long perf_ip_adjust(struct pt_regs *regs)
 {
@@ -1245,6 +1246,9 @@ static void power_pmu_disable(struct pmu *pmu)
 		val |= MMCR0_FC;
 		val &= ~(MMCR0_EBE | MMCR0_BHRBA | MMCR0_PMCC | MMCR0_PMAO |
 			 MMCR0_FC56);
+		/* Set mmcr0 PMCCEXT for p10 */
+		if (ppmu->flags & PPMU_ARCH_31)
+			val |= MMCR0_PMCCEXT;
 
 		/*
 		 * The barrier is to make sure the mtspr has been
diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 5e8eedda45d39..58448f0e47213 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -561,6 +561,14 @@ int isa207_compute_mmcr(u64 event[], int n_ev,
 	if (!(pmc_inuse & 0x60))
 		mmcr->mmcr0 |= MMCR0_FC56;
 
+	/*
+	 * Set mmcr0 (PMCCEXT) for p10 which
+	 * will restrict access to group B registers
+	 * when MMCR0 PMCC=0b00.
+	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		mmcr->mmcr0 |= MMCR0_PMCCEXT;
+
 	mmcr->mmcr1 = mmcr1;
 	mmcr->mmcra = mmcra;
 	mmcr->mmcr2 = mmcr2;
-- 
2.34.1



