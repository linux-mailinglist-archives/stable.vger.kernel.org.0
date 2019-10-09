Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55200D168E
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732126AbfJIRay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732003AbfJIRYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:06 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95ECC21A4A;
        Wed,  9 Oct 2019 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641845;
        bh=jaQ1a5oZ215Cx3h26Jqy++OBZ3GCo9SChM6Fjaz6eNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuCihMeTkDNFrcpl7dx5pMgQxdVKjBZf16sd906VTCBduqMqBNxivZbo7cfHII0t8
         +WMpw60S1afC7Fi/ILlt3P7/lgOuP9WU0D8sJ8HshdaW1WUcr0Ie3URGt/dfh7pa60
         J2GV+6ggS/Pg6H4MPyIwfYKqj2No1a1Eseu3BTFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/26] ARM: OMAP2+: Fix warnings with broken omap2_set_init_voltage()
Date:   Wed,  9 Oct 2019 13:05:39 -0400
Message-Id: <20191009170558.32517-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index ca03af8fe43ff..ddf96adf65ab3 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -77,83 +77,6 @@ int omap_pm_clkdms_setup(struct clockdomain *clkdm, void *unused)
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
@@ -211,25 +134,6 @@ void omap_common_suspend_init(void *pm_suspend)
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
@@ -249,10 +153,6 @@ int __init omap2_common_pm_late_init(void)
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

