Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20B527C8DE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgI2MFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbgI2Lhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A5023AC2;
        Tue, 29 Sep 2020 11:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379432;
        bh=21Dk2aP0mawlZhSZZ4BdMKCgfu56yphPCl+pNGPepT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8j12RuKduAzTqlmj+CFnl4VLzMeeMALo5MuwQPkQGVtXEdNTXIjs3wxiTXwNStQW
         dKPE1TrdS+o3/pLG5qwRmeTLaG/GExL1+PkWjgnzjafpsievP+pRyk43N4+bwS0JqO
         vudBpNC88tgIib69wy0pc7OELpTLGmLB/gVDIngk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Gerlach <d-gerlach@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Keerthy <j-keerthy@ti.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/388] ARM: OMAP2+: Handle errors for cpu_pm
Date:   Tue, 29 Sep 2020 12:58:04 +0200
Message-Id: <20200929110017.877885521@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



