Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754AE25630C
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 00:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgH1W0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 18:26:14 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14936 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgH1WZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 18:25:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4984640001>; Fri, 28 Aug 2020 15:25:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 15:25:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 28 Aug 2020 15:25:54 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 22:25:53 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 28 Aug 2020 22:25:53 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4984700001>; Fri, 28 Aug 2020 15:25:53 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 4.19 7/7] sdhci: tegra: Add missing TMCLK for data timeout
Date:   Fri, 28 Aug 2020 15:25:17 -0700
Message-ID: <1598653517-13658-8-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598653517-13658-1-git-send-email-skomatineni@nvidia.com>
References: <1598653517-13658-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598653541; bh=tSiUIf238rvXAJaTa4iMFJk91aOfAoCNj+waVfXYd0g=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=ikz+kl7t8XV3mUo3ZXBqklE5vhNFdLp6ysQ/KYd8lRqESyK+yCPqUTOFKI8tQiwdW
         GqeVIQBWtipOGVrkvEJNhQG1esuZyjpLC0gyB8cKlA11XZXLq7j7FZ/lBLouJ5V2Sd
         fDgIagjd3i6ok8rGyMIpH0kC9FUWyedfPssm72AwSZuCVDu2oEO6j8KCPC47YDd0YJ
         93oosjwdZDp/HStwB3sAA2wR0jGVWWELsqL3nWBg/GKdMcph/1R8DJbUfC+rXvGfuv
         AZ/heUsJz3ZKnNnwv2QLTtOFEK7cCQoQt882lRN0UKtjdlwuAhj5kPohRJ+pzMgQ1C
         jCwK5FOvXPooA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

Tegra210 and later has a separate sdmmc_legacy_tm (TMCLK) used by Tegra
SDMMC hawdware for data timeout to achive better timeout than using
SDCLK and using TMCLK is recommended.

USE_TMCLK_FOR_DATA_TIMEOUT bit in Tegra SDMMC register
SDHCI_TEGRA_VENDOR_SYS_SW_CTRL can be used to choose either TMCLK or
SDCLK for data timeout.

Default USE_TMCLK_FOR_DATA_TIMEOUT bit is set to 1 and TMCLK is used
for data timeout by Tegra SDMMC hardware and having TMCLK not enabled
is not recommended.

So, this patch adds quirk NVQUIRK_HAS_TMCLK for SoC having separate
timeout clock and keeps TMCLK enabled all the time.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 4.19
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 5a7c032..ff3340c 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -56,6 +56,12 @@
 #define NVQUIRK_ENABLE_DDR50		BIT(5)
 #define NVQUIRK_HAS_PADCALIB		BIT(6)
 
+/*
+ * NVQUIRK_HAS_TMCLK is for SoC's having separate timeout clock for Tegra
+ * SDMMC hardware data timeout.
+ */
+#define NVQUIRK_HAS_TMCLK				BIT(10)
+
 struct sdhci_tegra_soc_data {
 	const struct sdhci_pltfm_data *pdata;
 	u32 nvquirks;
@@ -64,6 +70,7 @@ struct sdhci_tegra_soc_data {
 struct sdhci_tegra {
 	const struct sdhci_tegra_soc_data *soc_data;
 	struct gpio_desc *power_gpio;
+	struct clk *tmclk;
 	bool ddr_signaling;
 	bool pad_calib_required;
 
@@ -433,6 +440,7 @@ static const struct sdhci_pltfm_data sdhci_tegra210_pdata = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
 	.pdata = &sdhci_tegra210_pdata,
+	.nvquirks = NVQUIRK_HAS_TMCLK,
 };
 
 static const struct sdhci_pltfm_data sdhci_tegra186_pdata = {
@@ -455,6 +463,7 @@ static const struct sdhci_pltfm_data sdhci_tegra186_pdata = {
 
 static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
 	.pdata = &sdhci_tegra186_pdata,
+	.nvquirks = NVQUIRK_HAS_TMCLK,
 };
 
 static const struct of_device_id sdhci_tegra_dt_match[] = {
@@ -510,6 +519,43 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 		goto err_power_req;
 	}
 
+	/*
+	 * Some Tegra SoC's has a separate SDMMC_LEGACY_TM clock used for
+	 * host data timeout clock and SW can choose TMCLK or SDCLK for
+	 * hardware data timeout through the bit USE_TMCLK_FOR_DATA_TIMEOUT
+	 * of the register SDHCI_TEGRA_VENDOR_SYS_SW_CTRL.
+	 *
+	 * USE_TMCLK_FOR_DATA_TIMEOUT bit default is set to 1 and SDMMC uses
+	 * 12Mhz TMCLK which is advertised in host capability register.
+	 * With TMCLK of 12Mhz provides maximum data timeout period that can
+	 * be achieved is 11s better than using SDCLK for data timeout.
+	 *
+	 * So, TMCLK is set to 12Mhz and kept enabled all the time on SoC's
+	 * supporting separate TMCLK.
+	 */
+
+	if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK) {
+		clk = devm_clk_get(&pdev->dev, "tmclk");
+		if (IS_ERR(clk)) {
+			rc = PTR_ERR(clk);
+			if (rc == -EPROBE_DEFER)
+				goto err_power_req;
+
+			dev_warn(&pdev->dev, "failed to get tmclk: %d\n", rc);
+			clk = NULL;
+		}
+
+		clk_set_rate(clk, 12000000);
+		rc = clk_prepare_enable(clk);
+		if (rc) {
+			dev_err(&pdev->dev,
+				"failed to enable tmclk: %d\n", rc);
+			goto err_power_req;
+		}
+
+		tegra_host->tmclk = clk;
+	}
+
 	clk = devm_clk_get(mmc_dev(host->mmc), NULL);
 	if (IS_ERR(clk)) {
 		dev_err(mmc_dev(host->mmc), "clk err\n");
@@ -550,6 +596,7 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 err_rst_get:
 	clk_disable_unprepare(pltfm_host->clk);
 err_clk_get:
+	clk_disable_unprepare(tegra_host->tmclk);
 err_power_req:
 err_parse_dt:
 	sdhci_pltfm_free(pdev);
@@ -567,6 +614,7 @@ static int sdhci_tegra_remove(struct platform_device *pdev)
 	reset_control_assert(tegra_host->rst);
 	usleep_range(2000, 4000);
 	clk_disable_unprepare(pltfm_host->clk);
+	clk_disable_unprepare(tegra_host->tmclk);
 
 	sdhci_pltfm_free(pdev);
 
-- 
2.7.4

