Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6472011853D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 11:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfLJKhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 05:37:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7854 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfLJKhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 05:37:21 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5def755a0000>; Tue, 10 Dec 2019 02:37:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Dec 2019 02:37:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Dec 2019 02:37:20 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 10:37:20 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 10 Dec 2019 10:37:19 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.133.51]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5def755e0000>; Tue, 10 Dec 2019 02:37:19 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
Date:   Tue, 10 Dec 2019 10:37:08 +0000
Message-ID: <20191210103708.7023-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575974234; bh=2bGXIui0+FPjeaGKMP85enM+3xE9shkh4uRgDhLWIV0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=T2piNd8sMrVICKOs4tAJ50+s504S/hb8hERQS0OnRIU8BzamwR04nZYnCf079dC/P
         wz+IKt4vo3ch7IwNWDDsp0DbeJcGiq/KFPFPUd5fBMgtp2s08IIKECbFgVmIE5OtSk
         tnGZa4KZSy5DpAZpzOlrOjeMKpPwlWzw3Vqy/wk51UYfC+3EpYmx6s5u5dikqYYJ9x
         X+XiMCOAqHkfsy3wt/Zhr5RTTVEtyWp44d7RR1dhwTDKy8LDGLr1/TWQDB5BhZV3AF
         QrdgwVxIPzGIZNjenlwQwfTogGHyXeg4KpkgCr+LYna2BEpzjsnA9M4WFYgIftbqdc
         woIJF3ISFwo5g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The suspend entry and exit code for 32-bit Tegra devices assumes that
the PLLM (which is used to provide the clock for external memory)
is always enabled on entry to suspend. Hence, the current code always
disables the PLLM on entry to suspend and re-enables the PLLM on exit
from suspend.

Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
("memory: tegra: Add EMC (external memory controller) driver"), which is
used to scale the EMC frequency, PLLM may not be the current clock
source for the EMC on entry to suspend and hence may not be enabled.
Always enabling the PLLM on exit from suspend can cause the actual
status on the PLL to be different from that reported by the common clock
framework.

On kernels prior to v4.5, the code to set the rate of the PLLM had a
test to verify if the PLL was enabled and if the PLL was enabled,
setting the rate would fail. Since commit 267b62a96951
("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
enabled was removed.

With these earlier kernels, if the PLLM is disabled on entering suspend
and the EMC driver attempts to set the parent of the EMC clock to the
PLLM on exiting suspend, then the set rate for the PLLM will fail and in
turn cause the resume to fail.

We should not be re-enabling the PLLM on resume from suspend unless it
was enabled on entry to suspend. Therefore, fix this by saving the state
of PLLM on entry to suspend and only re-enable it, if it was already
enabled.

Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
Cc: stable@vger.kernel.org

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
index 3341a12bbb9c..c2f0793a424f 100644
--- a/arch/arm/mach-tegra/sleep-tegra30.S
+++ b/arch/arm/mach-tegra/sleep-tegra30.S
@@ -337,26 +337,42 @@ ENTRY(tegra30_lp1_reset)
 	add	r1, r1, #2
 	wait_until r1, r7, r3
 
-	/* enable PLLM via PMC */
+	/* restore PLLM state */
 	mov32	r2, TEGRA_PMC_BASE
+	adr	r7, tegra_pllm_status
+	ldr	r1, [r7]
+	cmp	r2, #(1 << 12)
+	bne	_skip_pllm
+
 	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
 	orr	r1, r1, #(1 << 12)
 	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
 
 	pll_enable r1, r0, CLK_RESET_PLLM_BASE, 0
+	pll_locked r1, r0, CLK_RESET_PLLM_BASE
+
+_skip_pllm:
 	pll_enable r1, r0, CLK_RESET_PLLC_BASE, 0
 	pll_enable r1, r0, CLK_RESET_PLLX_BASE, 0
 
 	b	_pll_m_c_x_done
 
 _no_pll_iddq_exit:
-	/* enable PLLM via PMC */
+	/* restore PLLM state */
 	mov32	r2, TEGRA_PMC_BASE
+	adr	r7, tegra_pllm_status
+	ldr	r1, [r7]
+	cmp	r2, #(1 << 12)
+	bne	_skip_pllm_no_iddq
+
 	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
 	orr	r1, r1, #(1 << 12)
 	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
 
 	pll_enable r1, r0, CLK_RESET_PLLM_BASE, CLK_RESET_PLLM_MISC
+	pll_locked r1, r0, CLK_RESET_PLLM_BASE
+
+_skip_pllm_no_iddq:
 	pll_enable r1, r0, CLK_RESET_PLLC_BASE, CLK_RESET_PLLC_MISC
 	pll_enable r1, r0, CLK_RESET_PLLX_BASE, CLK_RESET_PLLX_MISC
 
@@ -364,7 +380,6 @@ _pll_m_c_x_done:
 	pll_enable r1, r0, CLK_RESET_PLLP_BASE, CLK_RESET_PLLP_MISC
 	pll_enable r1, r0, CLK_RESET_PLLA_BASE, CLK_RESET_PLLA_MISC
 
-	pll_locked r1, r0, CLK_RESET_PLLM_BASE
 	pll_locked r1, r0, CLK_RESET_PLLP_BASE
 	pll_locked r1, r0, CLK_RESET_PLLA_BASE
 	pll_locked r1, r0, CLK_RESET_PLLC_BASE
@@ -526,6 +541,8 @@ __no_dual_emc_chanl:
 ENDPROC(tegra30_lp1_reset)
 
 	.align	L1_CACHE_SHIFT
+tegra_pllm_status:
+	.word	0
 tegra30_sdram_pad_address:
 	.word	TEGRA_EMC_BASE + EMC_CFG				@0x0
 	.word	TEGRA_EMC_BASE + EMC_ZCAL_INTERVAL			@0x4
@@ -624,10 +641,14 @@ tegra30_switch_cpu_to_clk32k:
 	add	r1, r1, #2
 	wait_until r1, r7, r9
 
-	/* disable PLLM via PMC in LP1 */
+	/* disable PLLM, if enabled, via PMC in LP1 */
+	adr	r1, tegra_pllm_status
 	ldr	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
-	bic	r0, r0, #(1 << 12)
-	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
+	and	r2, r0, #(1 << 12)
+	str     r2, [r1]
+	cmp	r2, #(1 << 12)
+	biceq	r0, r0, #(1 << 12)
+	streq	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
 
 	/* disable PLLP, PLLA, PLLC and PLLX */
 	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
-- 
2.17.1

