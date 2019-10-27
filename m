Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21EE6709
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbfJ0VRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730494AbfJ0VRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:33 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF882070B;
        Sun, 27 Oct 2019 21:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211052;
        bh=Rmt2vC1gq7Y1SdH5bjjb7PSiYPSvnWGQM7T5c8N6Eh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rayyjv9mgv+uC/sK2ifmQQf8nefCopQ62oOE00t7G2SkRefAOAcaVgKf4aF+vz3uE
         ykQ9I/ZK3fmRMsdrF/Oi+gGW4KJJMpSr14+8djHRHcbxTPpdcOrpdY12wtA3upepBg
         LmZFZRSkb2FkzsYz7h4U1CIGYO1Em+kU1/2Vp9z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 016/197] ARM: OMAP2+: Fix warnings with broken omap2_set_init_voltage()
Date:   Sun, 27 Oct 2019 21:58:54 +0100
Message-Id: <20191027203352.549707686@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit cf395f7ddb9ebc6b2d28d83b53d18aa4e7c19701 ]

This code is currently unable to find the dts opp tables as ti-cpufreq
needs to set them up first based on speed binning.

We stopped initializing the opp tables with platform code years ago for
device tree based booting with commit 92d51856d740 ("ARM: OMAP3+: do not
register non-dt OPP tables for device tree boot"), and all of mach-omap2
is now booting using device tree.

We currently get the following errors on init:

omap2_set_init_voltage: unable to find boot up OPP for vdd_mpu
omap2_set_init_voltage: unable to set vdd_mpu
omap2_set_init_voltage: unable to find boot up OPP for vdd_core
omap2_set_init_voltage: unable to set vdd_core
omap2_set_init_voltage: unable to find boot up OPP for vdd_iva
omap2_set_init_voltage: unable to set vdd_iva

Let's just drop the unused code. Nowadays ti-cpufreq should be used to
to initialize things properly.

Cc: Adam Ford <aford173@gmail.com>
Cc: André Roth <neolynx@gmail.com>
Cc: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Tested-by: Adam Ford <aford173@gmail.com> #logicpd-torpedo-37xx-devkit
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pm.c | 100 ---------------------------------------
 1 file changed, 100 deletions(-)

diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 1fde1bf53fb65..7ac9af56762df 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -74,83 +74,6 @@ int omap_pm_clkdms_setup(struct clockdomain *clkdm, void *unused)
 	return 0;
 }
 
-/*
- * This API is to be called during init to set the various voltage
- * domains to the voltage as per the opp table. Typically we boot up
- * at the nominal voltage. So this function finds out the rate of
- * the clock associated with the voltage domain, finds out the correct
- * opp entry and sets the voltage domain to the voltage specified
- * in the opp entry
- */
-static int __init omap2_set_init_voltage(char *vdd_name, char *clk_name,
-					 const char *oh_name)
-{
-	struct voltagedomain *voltdm;
-	struct clk *clk;
-	struct dev_pm_opp *opp;
-	unsigned long freq, bootup_volt;
-	struct device *dev;
-
-	if (!vdd_name || !clk_name || !oh_name) {
-		pr_err("%s: invalid parameters\n", __func__);
-		goto exit;
-	}
-
-	if (!strncmp(oh_name, "mpu", 3))
-		/* 
-		 * All current OMAPs share voltage rail and clock
-		 * source, so CPU0 is used to represent the MPU-SS.
-		 */
-		dev = get_cpu_device(0);
-	else
-		dev = omap_device_get_by_hwmod_name(oh_name);
-
-	if (IS_ERR(dev)) {
-		pr_err("%s: Unable to get dev pointer for hwmod %s\n",
-			__func__, oh_name);
-		goto exit;
-	}
-
-	voltdm = voltdm_lookup(vdd_name);
-	if (!voltdm) {
-		pr_err("%s: unable to get vdd pointer for vdd_%s\n",
-			__func__, vdd_name);
-		goto exit;
-	}
-
-	clk =  clk_get(NULL, clk_name);
-	if (IS_ERR(clk)) {
-		pr_err("%s: unable to get clk %s\n", __func__, clk_name);
-		goto exit;
-	}
-
-	freq = clk_get_rate(clk);
-	clk_put(clk);
-
-	opp = dev_pm_opp_find_freq_ceil(dev, &freq);
-	if (IS_ERR(opp)) {
-		pr_err("%s: unable to find boot up OPP for vdd_%s\n",
-			__func__, vdd_name);
-		goto exit;
-	}
-
-	bootup_volt = dev_pm_opp_get_voltage(opp);
-	dev_pm_opp_put(opp);
-
-	if (!bootup_volt) {
-		pr_err("%s: unable to find voltage corresponding to the bootup OPP for vdd_%s\n",
-		       __func__, vdd_name);
-		goto exit;
-	}
-
-	voltdm_scale(voltdm, bootup_volt);
-	return 0;
-
-exit:
-	pr_err("%s: unable to set vdd_%s\n", __func__, vdd_name);
-	return -EINVAL;
-}
-
 #ifdef CONFIG_SUSPEND
 static int omap_pm_enter(suspend_state_t suspend_state)
 {
@@ -208,25 +131,6 @@ void omap_common_suspend_init(void *pm_suspend)
 }
 #endif /* CONFIG_SUSPEND */
 
-static void __init omap3_init_voltages(void)
-{
-	if (!soc_is_omap34xx())
-		return;
-
-	omap2_set_init_voltage("mpu_iva", "dpll1_ck", "mpu");
-	omap2_set_init_voltage("core", "l3_ick", "l3_main");
-}
-
-static void __init omap4_init_voltages(void)
-{
-	if (!soc_is_omap44xx())
-		return;
-
-	omap2_set_init_voltage("mpu", "dpll_mpu_ck", "mpu");
-	omap2_set_init_voltage("core", "l3_div_ck", "l3_main_1");
-	omap2_set_init_voltage("iva", "dpll_iva_m5x2_ck", "iva");
-}
-
 int __maybe_unused omap_pm_nop_init(void)
 {
 	return 0;
@@ -246,10 +150,6 @@ int __init omap2_common_pm_late_init(void)
 	omap4_twl_init();
 	omap_voltage_late_init();
 
-	/* Initialize the voltages */
-	omap3_init_voltages();
-	omap4_init_voltages();
-
 	/* Smartreflex device init */
 	omap_devinit_smartreflex();
 
-- 
2.20.1



