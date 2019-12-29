Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2845B12C8E9
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbfL2R6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387507AbfL2R6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F744206DB;
        Sun, 29 Dec 2019 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642302;
        bh=1ZOMNB7cYCOrtwBPiiZ/25mgMMBo3suo4y9Th8XX67c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4TZAgtDjra422NKA1iXTzRq3C6vd2+uwmmCz9lViMQGJfwvQEsoUE+U/sKULrC7t
         sbQirXJGDIFJtd21mNZcMLpGTh3Y1T1KLZZdR5f6KGzt6RPOTKf+HHurdsRL8ZyTTU
         TFbeMu3q9VfBTnuNxWz/P2G9kHT7rWNeLzbRkm+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 427/434] mmc: sdhci-msm: Correct the offset and value for DDR_CONFIG register
Date:   Sun, 29 Dec 2019 18:28:00 +0100
Message-Id: <20191229172731.616080312@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>

commit fa56ac9792265354b565f28def7164e7d7db2b1e upstream.

The DDR_CONFIG register offset got updated after a specific
minor version of sdcc V4. This offset change has not been properly
taken care of while updating register changes for sdcc V5.

Correcting proper offset for this register.
Also updating this register value to reflect the recommended RCLK
delay.

Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Link: https://lore.kernel.org/r/0101016ea738ec72-fa0f852d-20f8-474a-80b2-4b0ef63b132c-000000@us-west-2.amazonses.com
Fixes: f15358885dda ("mmc: sdhci-msm: Define new Register address map")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-msm.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -99,7 +99,7 @@
 
 #define CORE_PWRSAVE_DLL	BIT(3)
 
-#define DDR_CONFIG_POR_VAL	0x80040853
+#define DDR_CONFIG_POR_VAL	0x80040873
 
 
 #define INVALID_TUNING_PHASE	-1
@@ -148,8 +148,9 @@ struct sdhci_msm_offset {
 	u32 core_ddr_200_cfg;
 	u32 core_vendor_spec3;
 	u32 core_dll_config_2;
+	u32 core_dll_config_3;
+	u32 core_ddr_config_old; /* Applicable to sdcc minor ver < 0x49 */
 	u32 core_ddr_config;
-	u32 core_ddr_config_2;
 };
 
 static const struct sdhci_msm_offset sdhci_msm_v5_offset = {
@@ -177,8 +178,8 @@ static const struct sdhci_msm_offset sdh
 	.core_ddr_200_cfg = 0x224,
 	.core_vendor_spec3 = 0x250,
 	.core_dll_config_2 = 0x254,
-	.core_ddr_config = 0x258,
-	.core_ddr_config_2 = 0x25c,
+	.core_dll_config_3 = 0x258,
+	.core_ddr_config = 0x25c,
 };
 
 static const struct sdhci_msm_offset sdhci_msm_mci_offset = {
@@ -207,8 +208,8 @@ static const struct sdhci_msm_offset sdh
 	.core_ddr_200_cfg = 0x184,
 	.core_vendor_spec3 = 0x1b0,
 	.core_dll_config_2 = 0x1b4,
-	.core_ddr_config = 0x1b8,
-	.core_ddr_config_2 = 0x1bc,
+	.core_ddr_config_old = 0x1b8,
+	.core_ddr_config = 0x1bc,
 };
 
 struct sdhci_msm_variant_ops {
@@ -253,6 +254,7 @@ struct sdhci_msm_host {
 	const struct sdhci_msm_offset *offset;
 	bool use_cdr;
 	u32 transfer_mode;
+	bool updated_ddr_cfg;
 };
 
 static const struct sdhci_msm_offset *sdhci_priv_msm_offset(struct sdhci_host *host)
@@ -924,8 +926,10 @@ out:
 static int sdhci_msm_cm_dll_sdc4_calibration(struct sdhci_host *host)
 {
 	struct mmc_host *mmc = host->mmc;
-	u32 dll_status, config;
+	u32 dll_status, config, ddr_cfg_offset;
 	int ret;
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
 	const struct sdhci_msm_offset *msm_offset =
 					sdhci_priv_msm_offset(host);
 
@@ -938,8 +942,11 @@ static int sdhci_msm_cm_dll_sdc4_calibra
 	 * bootloaders. In the future, if this changes, then the desired
 	 * values will need to be programmed appropriately.
 	 */
-	writel_relaxed(DDR_CONFIG_POR_VAL, host->ioaddr +
-			msm_offset->core_ddr_config);
+	if (msm_host->updated_ddr_cfg)
+		ddr_cfg_offset = msm_offset->core_ddr_config;
+	else
+		ddr_cfg_offset = msm_offset->core_ddr_config_old;
+	writel_relaxed(DDR_CONFIG_POR_VAL, host->ioaddr + ddr_cfg_offset);
 
 	if (mmc->ios.enhanced_strobe) {
 		config = readl_relaxed(host->ioaddr +
@@ -1899,6 +1906,9 @@ static int sdhci_msm_probe(struct platfo
 				msm_offset->core_vendor_spec_capabilities0);
 	}
 
+	if (core_major == 1 && core_minor >= 0x49)
+		msm_host->updated_ddr_cfg = true;
+
 	/*
 	 * Power on reset state may trigger power irq if previous status of
 	 * PWRCTL was either BUS_ON or IO_HIGH_V. So before enabling pwr irq


