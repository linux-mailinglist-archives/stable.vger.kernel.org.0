Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8675E18B5A2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgCSNUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbgCSNUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B83206D7;
        Thu, 19 Mar 2020 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624015;
        bh=CrmheWRDfPW8CivWTD6cUxP9E3g51rF62ri8xwzFQ0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDu39oQ5j+WTA/uOY2lCP+/FgSTA+kbnsnhI8eTbx9SxxkmixXcpKNOoNJ8+1ZvnD
         nICyIrl9pboCK7Zc6S48FIXdY1zZGwQdovoA25461/o1gNUgO4HayedehUK2PnHUtS
         5pVb48qLtoFERVIJq0DTlLY6a3RIAkDhBA6lOeoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/48] mmc: sdhci-omap: Workaround errata regarding SDR104/HS200 tuning failures (i929)
Date:   Thu, 19 Mar 2020 14:03:46 +0100
Message-Id: <20200319123904.478355165@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 961de0a856e3a30c0238d1269c0b17f9b179b6c3 ]

Errata i929 in certain OMAP5/DRA7XX/AM57XX silicon revisions
(SPRZ426D - November 2014 - Revised February 2018 [1]) mentions
unexpected tuning pattern errors. A small failure band may be present
in the tuning range which may be missed by the current algorithm.
Furthermore, the failure bands vary with temperature leading to
different optimum tuning values for different temperatures.

As suggested in the related Application Report (SPRACA9B - October 2017
- Revised July 2018 [2]), tuning should be done in two stages.
In stage 1, assign the optimum ratio in the maximum pass window for the
current temperature. In stage 2, if the chosen value is close to the
small failure band, move away from it in the appropriate direction.

[1] http://www.ti.com/lit/pdf/sprz426
[2] http://www.ti.com/lit/pdf/SPRACA9

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/Kconfig      |  2 +
 drivers/mmc/host/sdhci-omap.c | 90 ++++++++++++++++++++++++++++++++++-
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 694d0828215d2..79b8ac9cdc744 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -935,6 +935,8 @@ config MMC_SDHCI_XENON
 config MMC_SDHCI_OMAP
 	tristate "TI SDHCI Controller Support"
 	depends on MMC_SDHCI_PLTFM && OF
+	select THERMAL
+	select TI_SOC_THERMAL
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  support present in TI's DRA7 SOCs. The controller supports
diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 8a172575bb64f..5698af25caef6 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -27,6 +27,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/sys_soc.h>
+#include <linux/thermal.h>
 
 #include "sdhci-pltfm.h"
 
@@ -290,15 +291,19 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	struct sdhci_host *host = mmc_priv(mmc);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_omap_host *omap_host = sdhci_pltfm_priv(pltfm_host);
+	struct thermal_zone_device *thermal_dev;
 	struct device *dev = omap_host->dev;
 	struct mmc_ios *ios = &mmc->ios;
 	u32 start_window = 0, max_window = 0;
+	bool single_point_failure = false;
 	bool dcrc_was_enabled = false;
 	u8 cur_match, prev_match = 0;
 	u32 length = 0, max_len = 0;
 	u32 phase_delay = 0;
+	int temperature;
 	int ret = 0;
 	u32 reg;
+	int i;
 
 	pltfm_host = sdhci_priv(host);
 	omap_host = sdhci_pltfm_priv(pltfm_host);
@@ -312,6 +317,16 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	if (ios->timing == MMC_TIMING_UHS_SDR50 && !(reg & CAPA2_TSDR50))
 		return 0;
 
+	thermal_dev = thermal_zone_get_zone_by_name("cpu_thermal");
+	if (IS_ERR(thermal_dev)) {
+		dev_err(dev, "Unable to get thermal zone for tuning\n");
+		return PTR_ERR(thermal_dev);
+	}
+
+	ret = thermal_zone_get_temp(thermal_dev, &temperature);
+	if (ret)
+		return ret;
+
 	reg = sdhci_omap_readl(omap_host, SDHCI_OMAP_DLL);
 	reg |= DLL_SWT;
 	sdhci_omap_writel(omap_host, SDHCI_OMAP_DLL, reg);
@@ -329,6 +344,11 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 
 	omap_host->is_tuning = true;
 
+	/*
+	 * Stage 1: Search for a maximum pass window ignoring any
+	 * any single point failures. If the tuning value ends up
+	 * near it, move away from it in stage 2 below
+	 */
 	while (phase_delay <= MAX_PHASE_DELAY) {
 		sdhci_omap_set_dll(omap_host, phase_delay);
 
@@ -336,10 +356,15 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		if (cur_match) {
 			if (prev_match) {
 				length++;
+			} else if (single_point_failure) {
+				/* ignore single point failure */
+				length++;
 			} else {
 				start_window = phase_delay;
 				length = 1;
 			}
+		} else {
+			single_point_failure = prev_match;
 		}
 
 		if (length > max_len) {
@@ -357,13 +382,76 @@ static int sdhci_omap_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		goto tuning_error;
 	}
 
+	/*
+	 * Assign tuning value as a ratio of maximum pass window based
+	 * on temperature
+	 */
+	if (temperature < -20000)
+		phase_delay = min(max_window + 4 * max_len - 24,
+				  max_window +
+				  DIV_ROUND_UP(13 * max_len, 16) * 4);
+	else if (temperature < 20000)
+		phase_delay = max_window + DIV_ROUND_UP(9 * max_len, 16) * 4;
+	else if (temperature < 40000)
+		phase_delay = max_window + DIV_ROUND_UP(8 * max_len, 16) * 4;
+	else if (temperature < 70000)
+		phase_delay = max_window + DIV_ROUND_UP(7 * max_len, 16) * 4;
+	else if (temperature < 90000)
+		phase_delay = max_window + DIV_ROUND_UP(5 * max_len, 16) * 4;
+	else if (temperature < 120000)
+		phase_delay = max_window + DIV_ROUND_UP(4 * max_len, 16) * 4;
+	else
+		phase_delay = max_window + DIV_ROUND_UP(3 * max_len, 16) * 4;
+
+	/*
+	 * Stage 2: Search for a single point failure near the chosen tuning
+	 * value in two steps. First in the +3 to +10 range and then in the
+	 * +2 to -10 range. If found, move away from it in the appropriate
+	 * direction by the appropriate amount depending on the temperature.
+	 */
+	for (i = 3; i <= 10; i++) {
+		sdhci_omap_set_dll(omap_host, phase_delay + i);
+
+		if (mmc_send_tuning(mmc, opcode, NULL)) {
+			if (temperature < 10000)
+				phase_delay += i + 6;
+			else if (temperature < 20000)
+				phase_delay += i - 12;
+			else if (temperature < 70000)
+				phase_delay += i - 8;
+			else
+				phase_delay += i - 6;
+
+			goto single_failure_found;
+		}
+	}
+
+	for (i = 2; i >= -10; i--) {
+		sdhci_omap_set_dll(omap_host, phase_delay + i);
+
+		if (mmc_send_tuning(mmc, opcode, NULL)) {
+			if (temperature < 10000)
+				phase_delay += i + 12;
+			else if (temperature < 20000)
+				phase_delay += i + 8;
+			else if (temperature < 70000)
+				phase_delay += i + 8;
+			else if (temperature < 90000)
+				phase_delay += i + 10;
+			else
+				phase_delay += i + 12;
+
+			goto single_failure_found;
+		}
+	}
+
+single_failure_found:
 	reg = sdhci_omap_readl(omap_host, SDHCI_OMAP_AC12);
 	if (!(reg & AC12_SCLK_SEL)) {
 		ret = -EIO;
 		goto tuning_error;
 	}
 
-	phase_delay = max_window + 4 * (max_len >> 1);
 	sdhci_omap_set_dll(omap_host, phase_delay);
 
 	omap_host->is_tuning = false;
-- 
2.20.1



