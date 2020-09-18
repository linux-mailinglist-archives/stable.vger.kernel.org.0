Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7F26F345
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbgIRDFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbgIRCE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F1D52344C;
        Fri, 18 Sep 2020 02:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394665;
        bh=21Dk2aP0mawlZhSZZ4BdMKCgfu56yphPCl+pNGPepT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBIYWeHUG4TWzIndFwjb02C2wELY1k9LN93p1v1kF6t6AUdUHJfdcx7Jwdmp6eqM8
         0OCDX3mTmPqlAp9TwmTcj+3KntXrRzERdxcVYWkfnwBimcspTaYs+wOyY+sbHnRUoY
         lIf0ZvxwbhkKWAJi4kn3+sMkeleKQxlhaeRronmQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Dave Gerlach <d-gerlach@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tero Kristo <t-kristo@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 159/330] ARM: OMAP2+: Handle errors for cpu_pm
Date:   Thu, 17 Sep 2020 21:58:19 -0400
Message-Id: <20200918020110.2063155-159-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 55be2f50336f67800513b46c5ba6270e4ed0e784 ]

We need to check for errors when calling cpu_pm_enter() and
cpu_cluster_pm_enter(). And we need to bail out on errors as
otherwise we can enter a deeper idle state when not desired.

I'm not aware of the lack of error handling causing issues yet,
but we need this at least for blocking deeper idle states when
a GPIO instance has pending interrupts.

Cc: Dave Gerlach <d-gerlach@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20200304225433.37336-2-tony@atomide.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/cpuidle34xx.c |  9 +++++++--
 arch/arm/mach-omap2/cpuidle44xx.c | 26 +++++++++++++++++---------
 arch/arm/mach-omap2/pm34xx.c      |  8 ++++++--
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 532a3e4b98c6f..090a8aafb25e1 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -109,6 +109,7 @@ static int omap3_enter_idle(struct cpuidle_device *dev,
 			    int index)
 {
 	struct omap3_idle_statedata *cx = &omap3_idle_data[index];
+	int error;
 
 	if (omap_irq_pending() || need_resched())
 		goto return_sleep_time;
@@ -125,8 +126,11 @@ static int omap3_enter_idle(struct cpuidle_device *dev,
 	 * Call idle CPU PM enter notifier chain so that
 	 * VFP context is saved.
 	 */
-	if (cx->mpu_state == PWRDM_POWER_OFF)
-		cpu_pm_enter();
+	if (cx->mpu_state == PWRDM_POWER_OFF) {
+		error = cpu_pm_enter();
+		if (error)
+			goto out_clkdm_set;
+	}
 
 	/* Execute ARM wfi */
 	omap_sram_idle();
@@ -139,6 +143,7 @@ static int omap3_enter_idle(struct cpuidle_device *dev,
 	    pwrdm_read_prev_pwrst(mpu_pd) == PWRDM_POWER_OFF)
 		cpu_pm_exit();
 
+out_clkdm_set:
 	/* Re-allow idle for C1 */
 	if (cx->flags & OMAP_CPUIDLE_CX_NO_CLKDM_IDLE)
 		clkdm_allow_idle(mpu_pd->pwrdm_clkdms[0]);
diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index fe75d4fa60738..6f5f89711f256 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -122,6 +122,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 {
 	struct idle_statedata *cx = state_ptr + index;
 	u32 mpuss_can_lose_context = 0;
+	int error;
 
 	/*
 	 * CPU0 has to wait and stay ON until CPU1 is OFF state.
@@ -159,7 +160,9 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	 * Call idle CPU PM enter notifier chain so that
 	 * VFP and per CPU interrupt context is saved.
 	 */
-	cpu_pm_enter();
+	error = cpu_pm_enter();
+	if (error)
+		goto cpu_pm_out;
 
 	if (dev->cpu == 0) {
 		pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
@@ -169,13 +172,17 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		 * Call idle CPU cluster PM enter notifier chain
 		 * to save GIC and wakeupgen context.
 		 */
-		if (mpuss_can_lose_context)
-			cpu_cluster_pm_enter();
+		if (mpuss_can_lose_context) {
+			error = cpu_cluster_pm_enter();
+			if (error)
+				goto cpu_cluster_pm_out;
+		}
 	}
 
 	omap4_enter_lowpower(dev->cpu, cx->cpu_state);
 	cpu_done[dev->cpu] = true;
 
+cpu_cluster_pm_out:
 	/* Wakeup CPU1 only if it is not offlined */
 	if (dev->cpu == 0 && cpumask_test_cpu(1, cpu_online_mask)) {
 
@@ -197,12 +204,6 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		}
 	}
 
-	/*
-	 * Call idle CPU PM exit notifier chain to restore
-	 * VFP and per CPU IRQ context.
-	 */
-	cpu_pm_exit();
-
 	/*
 	 * Call idle CPU cluster PM exit notifier chain
 	 * to restore GIC and wakeupgen context.
@@ -210,6 +211,13 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	if (dev->cpu == 0 && mpuss_can_lose_context)
 		cpu_cluster_pm_exit();
 
+	/*
+	 * Call idle CPU PM exit notifier chain to restore
+	 * VFP and per CPU IRQ context.
+	 */
+	cpu_pm_exit();
+
+cpu_pm_out:
 	tick_broadcast_exit();
 
 fail:
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 54254fc92c2ed..fa66534a7ae22 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -194,6 +194,7 @@ void omap_sram_idle(void)
 	int per_next_state = PWRDM_POWER_ON;
 	int core_next_state = PWRDM_POWER_ON;
 	u32 sdrc_pwr = 0;
+	int error;
 
 	mpu_next_state = pwrdm_read_next_pwrst(mpu_pwrdm);
 	switch (mpu_next_state) {
@@ -222,8 +223,11 @@ void omap_sram_idle(void)
 	pwrdm_pre_transition(NULL);
 
 	/* PER */
-	if (per_next_state == PWRDM_POWER_OFF)
-		cpu_cluster_pm_enter();
+	if (per_next_state == PWRDM_POWER_OFF) {
+		error = cpu_cluster_pm_enter();
+		if (error)
+			return;
+	}
 
 	/* CORE */
 	if (core_next_state < PWRDM_POWER_ON) {
-- 
2.25.1

