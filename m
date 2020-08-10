Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5864E2410D2
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgHJTc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbgHJTJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD3FD22B45;
        Mon, 10 Aug 2020 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086572;
        bh=QxI8nMbPMJKIuhodP60C5mUw6z111u/c85LY1GoQevs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjoDxNFyfkVq6At8RCXg9WJ0ZR+8uPkojiTHg427y8LrMwJev2N5DMzzLcC55Y97Q
         +dchBCpGy3quKAqnNukNR2fxEBKmY3xEgcIQ6NyKmAGU4dy0Qvc6TlvrWZlEczUAVz
         Jbn7BlTTOJJIapu0+eY6FLvm3/8utMKdlBE2dG6k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 24/64] mmc: sdhci-cadence: do not use hardware tuning for SD mode
Date:   Mon, 10 Aug 2020 15:08:19 -0400
Message-Id: <20200810190859.3793319-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit adc40a5179df30421a5537bfeb4545100ab97d5e ]

As commit ef6b75671b5f ("mmc: sdhci-cadence: send tune request twice to
work around errata") stated, this IP has an errata. This commit applies
the second workaround for the SD mode.

Due to the errata, it is not possible to use the hardware tuning provided
by SDHCI_HOST_CONTROL2.

Use the software-controlled tuning like the eMMC mode.

Set sdhci_host_ops::platform_execute_tuning instead of overriding
mmc_host_ops::execute_tuning.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lore.kernel.org/r/20200720061141.172944-1-yamada.masahiro@socionext.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-cadence.c | 123 ++++++++++++++++---------------
 1 file changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-cadence.c
index 4a6c9ba825381..4d9f7681817c1 100644
--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -202,57 +202,6 @@ static u32 sdhci_cdns_get_emmc_mode(struct sdhci_cdns_priv *priv)
 	return FIELD_GET(SDHCI_CDNS_HRS06_MODE, tmp);
 }
 
-static void sdhci_cdns_set_uhs_signaling(struct sdhci_host *host,
-					 unsigned int timing)
-{
-	struct sdhci_cdns_priv *priv = sdhci_cdns_priv(host);
-	u32 mode;
-
-	switch (timing) {
-	case MMC_TIMING_MMC_HS:
-		mode = SDHCI_CDNS_HRS06_MODE_MMC_SDR;
-		break;
-	case MMC_TIMING_MMC_DDR52:
-		mode = SDHCI_CDNS_HRS06_MODE_MMC_DDR;
-		break;
-	case MMC_TIMING_MMC_HS200:
-		mode = SDHCI_CDNS_HRS06_MODE_MMC_HS200;
-		break;
-	case MMC_TIMING_MMC_HS400:
-		if (priv->enhanced_strobe)
-			mode = SDHCI_CDNS_HRS06_MODE_MMC_HS400ES;
-		else
-			mode = SDHCI_CDNS_HRS06_MODE_MMC_HS400;
-		break;
-	default:
-		mode = SDHCI_CDNS_HRS06_MODE_SD;
-		break;
-	}
-
-	sdhci_cdns_set_emmc_mode(priv, mode);
-
-	/* For SD, fall back to the default handler */
-	if (mode == SDHCI_CDNS_HRS06_MODE_SD)
-		sdhci_set_uhs_signaling(host, timing);
-}
-
-static const struct sdhci_ops sdhci_cdns_ops = {
-	.set_clock = sdhci_set_clock,
-	.get_timeout_clock = sdhci_cdns_get_timeout_clock,
-	.set_bus_width = sdhci_set_bus_width,
-	.reset = sdhci_reset,
-	.set_uhs_signaling = sdhci_cdns_set_uhs_signaling,
-};
-
-static const struct sdhci_pltfm_data sdhci_cdns_uniphier_pltfm_data = {
-	.ops = &sdhci_cdns_ops,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
-};
-
-static const struct sdhci_pltfm_data sdhci_cdns_pltfm_data = {
-	.ops = &sdhci_cdns_ops,
-};
-
 static int sdhci_cdns_set_tune_val(struct sdhci_host *host, unsigned int val)
 {
 	struct sdhci_cdns_priv *priv = sdhci_cdns_priv(host);
@@ -286,23 +235,24 @@ static int sdhci_cdns_set_tune_val(struct sdhci_host *host, unsigned int val)
 	return 0;
 }
 
-static int sdhci_cdns_execute_tuning(struct mmc_host *mmc, u32 opcode)
+/*
+ * In SD mode, software must not use the hardware tuning and instead perform
+ * an almost identical procedure to eMMC.
+ */
+static int sdhci_cdns_execute_tuning(struct sdhci_host *host, u32 opcode)
 {
-	struct sdhci_host *host = mmc_priv(mmc);
 	int cur_streak = 0;
 	int max_streak = 0;
 	int end_of_streak = 0;
 	int i;
 
 	/*
-	 * This handler only implements the eMMC tuning that is specific to
-	 * this controller.  Fall back to the standard method for SD timing.
+	 * Do not execute tuning for UHS_SDR50 or UHS_DDR50.
+	 * The delay is set by probe, based on the DT properties.
 	 */
-	if (host->timing != MMC_TIMING_MMC_HS200)
-		return sdhci_execute_tuning(mmc, opcode);
-
-	if (WARN_ON(opcode != MMC_SEND_TUNING_BLOCK_HS200))
-		return -EINVAL;
+	if (host->timing != MMC_TIMING_MMC_HS200 &&
+	    host->timing != MMC_TIMING_UHS_SDR104)
+		return 0;
 
 	for (i = 0; i < SDHCI_CDNS_MAX_TUNING_LOOP; i++) {
 		if (sdhci_cdns_set_tune_val(host, i) ||
@@ -325,6 +275,58 @@ static int sdhci_cdns_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	return sdhci_cdns_set_tune_val(host, end_of_streak - max_streak / 2);
 }
 
+static void sdhci_cdns_set_uhs_signaling(struct sdhci_host *host,
+					 unsigned int timing)
+{
+	struct sdhci_cdns_priv *priv = sdhci_cdns_priv(host);
+	u32 mode;
+
+	switch (timing) {
+	case MMC_TIMING_MMC_HS:
+		mode = SDHCI_CDNS_HRS06_MODE_MMC_SDR;
+		break;
+	case MMC_TIMING_MMC_DDR52:
+		mode = SDHCI_CDNS_HRS06_MODE_MMC_DDR;
+		break;
+	case MMC_TIMING_MMC_HS200:
+		mode = SDHCI_CDNS_HRS06_MODE_MMC_HS200;
+		break;
+	case MMC_TIMING_MMC_HS400:
+		if (priv->enhanced_strobe)
+			mode = SDHCI_CDNS_HRS06_MODE_MMC_HS400ES;
+		else
+			mode = SDHCI_CDNS_HRS06_MODE_MMC_HS400;
+		break;
+	default:
+		mode = SDHCI_CDNS_HRS06_MODE_SD;
+		break;
+	}
+
+	sdhci_cdns_set_emmc_mode(priv, mode);
+
+	/* For SD, fall back to the default handler */
+	if (mode == SDHCI_CDNS_HRS06_MODE_SD)
+		sdhci_set_uhs_signaling(host, timing);
+}
+
+static const struct sdhci_ops sdhci_cdns_ops = {
+	.set_clock = sdhci_set_clock,
+	.get_timeout_clock = sdhci_cdns_get_timeout_clock,
+	.set_bus_width = sdhci_set_bus_width,
+	.reset = sdhci_reset,
+	.platform_execute_tuning = sdhci_cdns_execute_tuning,
+	.set_uhs_signaling = sdhci_cdns_set_uhs_signaling,
+};
+
+static const struct sdhci_pltfm_data sdhci_cdns_uniphier_pltfm_data = {
+	.ops = &sdhci_cdns_ops,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+};
+
+static const struct sdhci_pltfm_data sdhci_cdns_pltfm_data = {
+	.ops = &sdhci_cdns_ops,
+};
+
 static void sdhci_cdns_hs400_enhanced_strobe(struct mmc_host *mmc,
 					     struct mmc_ios *ios)
 {
@@ -385,7 +387,6 @@ static int sdhci_cdns_probe(struct platform_device *pdev)
 	priv->hrs_addr = host->ioaddr;
 	priv->enhanced_strobe = false;
 	host->ioaddr += SDHCI_CDNS_SRS_BASE;
-	host->mmc_host_ops.execute_tuning = sdhci_cdns_execute_tuning;
 	host->mmc_host_ops.hs400_enhanced_strobe =
 				sdhci_cdns_hs400_enhanced_strobe;
 	sdhci_enable_v4_mode(host);
-- 
2.25.1

