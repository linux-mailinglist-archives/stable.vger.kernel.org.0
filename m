Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5594C64A27D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiLLNzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiLLNyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:54:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C06B58
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9387B60FF4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970F3C4339C;
        Mon, 12 Dec 2022 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853275;
        bh=Ol9mwQzdRujNOMXTEVxA5y4NuqSoCpCmJxSOdGLbP+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FMdXqutvLV9To54YgGnL2JraooWSXoLkeWs5SBb1kECsfTa6Z0C7FdB1M2X6aZiO
         fDuHy33lK+3LygNluBbHQ9uxC6iRk9y7BgOO9fWnpGStdtRI/U4xS85MpgltI+XeMK
         jOvrFJaFr3kmBgtmH9UBW9Zh+0M/Fl9HjMpRyZPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 11/31] mmc: sdhci: Fix voltage switch delay
Date:   Mon, 12 Dec 2022 14:19:29 +0100
Message-Id: <20221212130910.580294118@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit c981cdfb9925f64a364f13c2b4f98f877308a408 upstream.

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
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   63 +++++++++++++++++++++++++++++++++++++++++------
 drivers/mmc/host/sdhci.h |    2 +
 2 files changed, 57 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -240,6 +240,7 @@ static void sdhci_init(struct sdhci_host
 	if (soft) {
 		/* force clock reconfiguration */
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	}
 }
@@ -1580,12 +1581,47 @@ void sdhci_set_uhs_signaling(struct sdhc
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
 static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	bool reinit_uhs = host->reinit_uhs;
+	bool turning_on_clk = false;
 	unsigned long flags;
 	u8 ctrl;
 
+	host->reinit_uhs = false;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->flags & SDHCI_DEVICE_DEAD) {
@@ -1611,6 +1647,8 @@ static void sdhci_set_ios(struct mmc_hos
 		sdhci_enable_preset_value(host, false);
 
 	if (!ios->clock || ios->clock != host->clock) {
+		turning_on_clk = ios->clock && !host->clock;
+
 		host->ops->set_clock(host, ios->clock);
 		host->clock = ios->clock;
 
@@ -1637,6 +1675,17 @@ static void sdhci_set_ios(struct mmc_hos
 
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
+		goto out;
+
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if ((ios->timing == MMC_TIMING_SD_HS ||
@@ -1682,6 +1731,7 @@ static void sdhci_set_ios(struct mmc_hos
 			}
 
 			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
+			host->drv_type = ios->drv_type;
 		} else {
 			/*
 			 * According to SDHC Spec v3.00, if the Preset Value
@@ -1709,26 +1759,21 @@ static void sdhci_set_ios(struct mmc_hos
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
 		host->ops->set_clock(host, host->clock);
 	} else
 		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
-
+out:
 	/*
 	 * Some (ENE) controllers go apeshit on some ios operation,
 	 * signalling timeout and CRC errors even on CMD0. Resetting
@@ -2882,6 +2927,7 @@ int sdhci_resume_host(struct sdhci_host
 		sdhci_init(host, 0);
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
@@ -2946,6 +2992,7 @@ int sdhci_runtime_resume_host(struct sdh
 	/* Force clock and power re-program */
 	host->pwr = 0;
 	host->clock = 0;
+	host->reinit_uhs = true;
 	mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 	mmc->ops->set_ios(mmc, &mmc->ios);
 
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -466,6 +466,8 @@ struct sdhci_host {
 
 	unsigned int clock;	/* Current clock (MHz) */
 	u8 pwr;			/* Current voltage */
+	u8 drv_type;		/* Current UHS-I driver type */
+	bool reinit_uhs;	/* Force UHS-related re-initialization */
 
 	bool runtime_suspended;	/* Host is runtime suspended */
 	bool bus_on;		/* Bus power prevents runtime suspend */


