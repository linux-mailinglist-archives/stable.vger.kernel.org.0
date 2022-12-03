Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9829A641639
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 11:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLCK7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 05:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLCK65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 05:58:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57605A6E6
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 02:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AF8960BA0
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 10:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F5CC433D6;
        Sat,  3 Dec 2022 10:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670065130;
        bh=V6NWFVT/5mfvE8U0IPBUjjfwgWMr2wKsoxO+FjPxszY=;
        h=Subject:To:Cc:From:Date:From;
        b=YIJKmpwzTbrbvI5AtSj0cXc3Bfh3/8qliaaSox23xQE8/bevzk3q3oaNtvIXxj5jQ
         dYpsSjqEGsUso6uGCWTDIKMBJU94hc2BPqvd5xgi0FnwKMq2E2PnbFf+6Fsx/XBISW
         Fa5nNyiyDLY+xtSduvhAwScxd8oD03LaIktZlV/g=
Subject: FAILED: patch "[PATCH] mmc: sdhci: Fix voltage switch delay" failed to apply to 4.9-stable tree
To:     adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 11:58:42 +0100
Message-ID: <16700651226848@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c981cdfb9925 ("mmc: sdhci: Fix voltage switch delay")
fa0910107a9f ("mmc: sdhci: use FIELD_GET for preset value bit masks")
6a6d4ceb7be0 ("mmc: sdhci: Export sdhci_set_ios() from sdhci.c")
d1e4f74f911d ("mmc: sdhci: Do not use spin lock in set_ios paths")
5a436cc0af62 ("mmc: sdhci: Optimize delay loops")
e2ebfb2142ac ("mmc: sdhci: Do not disable interrupts while waiting for clock")
2ce0c7b65505 ("mmc: sdhci-of-at91: Support external regulators")
db9bd1638115 ("mmc: sdhci-msm: Factor out sdhci_msm_hs400")
0fb8a3d46b03 ("mmc: sdhci-msm: Factor out function to set/get msm clock rate")
b54aaa8a4fd8 ("mmc: sdhci-msm: Factor out sdhci_msm_hc_select_mode")
84ec048ba133 ("mmc: sdhci: Fix to handle MMC_POWER_UNDEFINED")
85a882c2e91d ("mmc: sdhci: export sdhci_execute_tuning()")
6b11e70bb72c ("mmc: sdhci: Tidy tuning loop")
da4bc4f2851e ("mmc: sdhci: Factor out tuning helper functions")
d0c3ab59105d ("mmc: sdhci: Use mmc_abort_tuning()")
0760c355525c ("mmc: sdhci: Always allow tuning to fall back to fixed sampling")
5ef5203b95c5 ("mmc: sdhci: Fix tuning reset after exhausting the maximum number of loops")
61e53bd0047d ("mmc: sdhci: Fix recovery from tuning timeout")
2ca71c27eeae ("Revert "mmc: sdhci: Reset cmd and data circuits after tuning failure"")
02e4293dc013 ("sdhci: sdhci-msm: update dll configuration")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c981cdfb9925f64a364f13c2b4f98f877308a408 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Mon, 28 Nov 2022 15:32:56 +0200
Subject: [PATCH] mmc: sdhci: Fix voltage switch delay

Commit 20b92a30b561 ("mmc: sdhci: update signal voltage switch code")
removed voltage switch delays from sdhci because mmc core had been
enhanced to support them. However that assumed that sdhci_set_ios()
did a single clock change, which it did not, and so the delays in mmc
core, which should have come after the first clock change, were not
effective.

Fix by avoiding re-configuring UHS and preset settings when the clock
is turning on and the settings have not changed. That then also avoids
the associated clock changes, so that then sdhci_set_ios() does a single
clock change when voltage switching, and the mmc core delays become
effective.

To do that has meant keeping track of driver strength (host->drv_type),
and cases of reinitialization (host->reinit_uhs).

Note also, the 'turning_on_clk' restriction should not be necessary
but is done to minimize the impact of the change on stable kernels.

Fixes: 20b92a30b561 ("mmc: sdhci: update signal voltage switch code")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20221128133259.38305-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index fef03de85b99..c7ad32a75b57 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -373,6 +373,7 @@ static void sdhci_init(struct sdhci_host *host, int soft)
 	if (soft) {
 		/* force clock reconfiguration */
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	}
 }
@@ -2293,11 +2294,46 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 }
 EXPORT_SYMBOL_GPL(sdhci_set_uhs_signaling);
 
+static bool sdhci_timing_has_preset(unsigned char timing)
+{
+	switch (timing) {
+	case MMC_TIMING_UHS_SDR12:
+	case MMC_TIMING_UHS_SDR25:
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+	case MMC_TIMING_UHS_DDR50:
+	case MMC_TIMING_MMC_DDR52:
+		return true;
+	};
+	return false;
+}
+
+static bool sdhci_preset_needed(struct sdhci_host *host, unsigned char timing)
+{
+	return !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
+	       sdhci_timing_has_preset(timing);
+}
+
+static bool sdhci_presetable_values_change(struct sdhci_host *host, struct mmc_ios *ios)
+{
+	/*
+	 * Preset Values are: Driver Strength, Clock Generator and SDCLK/RCLK
+	 * Frequency. Check if preset values need to be enabled, or the Driver
+	 * Strength needs updating. Note, clock changes are handled separately.
+	 */
+	return !host->preset_enabled &&
+	       (sdhci_preset_needed(host, ios->timing) || host->drv_type != ios->drv_type);
+}
+
 void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	bool reinit_uhs = host->reinit_uhs;
+	bool turning_on_clk = false;
 	u8 ctrl;
 
+	host->reinit_uhs = false;
+
 	if (ios->power_mode == MMC_POWER_UNDEFINED)
 		return;
 
@@ -2323,6 +2359,8 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		sdhci_enable_preset_value(host, false);
 
 	if (!ios->clock || ios->clock != host->clock) {
+		turning_on_clk = ios->clock && !host->clock;
+
 		host->ops->set_clock(host, ios->clock);
 		host->clock = ios->clock;
 
@@ -2349,6 +2387,17 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	host->ops->set_bus_width(host, ios->bus_width);
 
+	/*
+	 * Special case to avoid multiple clock changes during voltage
+	 * switching.
+	 */
+	if (!reinit_uhs &&
+	    turning_on_clk &&
+	    host->timing == ios->timing &&
+	    host->version >= SDHCI_SPEC_300 &&
+	    !sdhci_presetable_values_change(host, ios))
+		return;
+
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if (!(host->quirks & SDHCI_QUIRK_NO_HISPD_BIT)) {
@@ -2392,6 +2441,7 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			}
 
 			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
+			host->drv_type = ios->drv_type;
 		} else {
 			/*
 			 * According to SDHC Spec v3.00, if the Preset Value
@@ -2419,19 +2469,14 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->ops->set_uhs_signaling(host, ios->timing);
 		host->timing = ios->timing;
 
-		if (!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
-				((ios->timing == MMC_TIMING_UHS_SDR12) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR25) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR50) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR104) ||
-				 (ios->timing == MMC_TIMING_UHS_DDR50) ||
-				 (ios->timing == MMC_TIMING_MMC_DDR52))) {
+		if (sdhci_preset_needed(host, ios->timing)) {
 			u16 preset;
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
 			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
 						  preset);
+			host->drv_type = ios->drv_type;
 		}
 
 		/* Re-enable SD Clock */
@@ -3768,6 +3813,7 @@ int sdhci_resume_host(struct sdhci_host *host)
 		sdhci_init(host, 0);
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (mmc->pm_flags & MMC_PM_KEEP_POWER));
@@ -3830,6 +3876,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset)
 		/* Force clock and power re-program */
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 		mmc->ops->set_ios(mmc, &mmc->ios);
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index d750c464bd1e..87a3aaa07438 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -524,6 +524,8 @@ struct sdhci_host {
 
 	unsigned int clock;	/* Current clock (MHz) */
 	u8 pwr;			/* Current voltage */
+	u8 drv_type;		/* Current UHS-I driver type */
+	bool reinit_uhs;	/* Force UHS-related re-initialization */
 
 	bool runtime_suspended;	/* Host is runtime suspended */
 	bool bus_on;		/* Bus power prevents runtime suspend */

