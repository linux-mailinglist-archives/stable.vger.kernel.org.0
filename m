Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A6E2538D5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHZUGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:06:01 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15666 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgHZUFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:05:42 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f46c0880001>; Wed, 26 Aug 2020 13:05:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 13:05:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 26 Aug 2020 13:05:42 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 20:05:37 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Aug 2020 20:05:37 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f46c0900001>; Wed, 26 Aug 2020 13:05:37 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v5 7/7] sdhci: tegra: Add missing TMCLK for data timeout
Date:   Wed, 26 Aug 2020 13:05:14 -0700
Message-ID: <1598472314-30235-8-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
References: <1598472314-30235-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598472328; bh=vcuUzoxEHPbJpZEaocSnEvUTr24rjXRhVAsiKgIaQag=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=HAHQnHNSonkUsxHy9HM40Qw6VEDyECywYulvO7xvfKPTl8P8/4IMIhyZ68ULPDbge
         Sl2ELf0DPwBgwZZ4Yf8DM4HsxFV1M+o6I62whbKkim9LhgQ+37FVNcnXaL0+u4RuEJ
         uP9+1oztKOPYfQIX56/6VPRNCkIOpPoQ5FA1l0oHDqM1CvEIfzz3raR8nkVMs5ueLb
         62jWbEuajxovsGu2keEu381X0d5fITiZiyzQV6MoGCFs+yuVFGmf+8SGEWNqULUPfJ
         4WKkXX4Gbe/4e0iizZOl0DbWkUY4Qwet+mMS87FhvIdpfi+pOjHanwAISJ2RhYp3xu
         RxKlkBK3Lf2xg==
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
Cc: stable <stable@vger.kernel.org> # 5.4
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 89 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 81 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 31ed321..9bcd532 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -110,6 +110,12 @@
 #define NVQUIRK_DIS_CARD_CLK_CONFIG_TAP			BIT(8)
 #define NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING		BIT(9)
 
+/*
+ * NVQUIRK_HAS_TMCLK is for SoC's having separate timeout clock for Tegra
+ * SDMMC hardware data timeout.
+ */
+#define NVQUIRK_HAS_TMCLK				BIT(10)
+
 /* SDMMC CQE Base Address for Tegra Host Ver 4.1 and Higher */
 #define SDHCI_TEGRA_CQE_BASE_ADDR			0xF000
 
@@ -140,6 +146,7 @@ struct sdhci_tegra_autocal_offsets {
 struct sdhci_tegra {
 	const struct sdhci_tegra_soc_data *soc_data;
 	struct gpio_desc *power_gpio;
+	struct clk *tmclk;
 	bool ddr_signaling;
 	bool pad_calib_required;
 	bool pad_control_available;
@@ -1433,7 +1440,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
-		    NVQUIRK_ENABLE_SDR104,
+		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK,
 	.min_tap_delay = 106,
 	.max_tap_delay = 185,
 };
@@ -1471,6 +1479,7 @@ static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
 		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK |
 		    NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING,
 	.min_tap_delay = 84,
 	.max_tap_delay = 136,
@@ -1483,7 +1492,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra194 = {
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
-		    NVQUIRK_ENABLE_SDR104,
+		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK;
 	.min_tap_delay = 96,
 	.max_tap_delay = 139,
 };
@@ -1611,15 +1621,76 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 		goto err_power_req;
 	}
 
-	clk = devm_clk_get(mmc_dev(host->mmc), NULL);
-	if (IS_ERR(clk)) {
-		rc = PTR_ERR(clk);
+	/*
+	 * Tegra210 and later has separate SDMMC_LEGACY_TM clock used for
+	 * hardware data timeout clock and SW can choose TMCLK or SDCLK for
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
+	 *
+	 * Old device tree has single sdhci clock. So with addition of TMCLK,
+	 * retrieving sdhci clock by "sdhci" clock name based on number of
+	 * clocks in sdhci device node.
+	 */
+
+	if (of_clk_get_parent_count(&pdev->dev) == 1) {
+		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK)
+			dev_warn(&pdev->dev,
+				 "missing tmclk in the device tree\n");
+
+		clk = devm_clk_get(dev, NULL)
+		if (IS_ERR(clk)) {
+			rc = PTR_ERR(clk);
 
-		if (rc != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "failed to get clock: %d\n", rc);
+			if (rc != -EPROBE_DEFER)
+				dev_err(&pdev->dev,
+					"failed to get sdhci clock: %d\n", rc);
 
-		goto err_clk_get;
+			goto err_power_req;
+		}
+	} else {
+		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK) {
+			clk = devm_clk_get(&pdev->dev, "tmclk");
+			if (IS_ERR(clk)) {
+				rc = PTR_ERR(clk);
+				if (rc == -EPROBE_DEFER)
+					goto err_power_req;
+
+				dev_warn(&pdev->dev,
+					 "failed to get tmclk: %d\n", rc);
+				clk = NULL;
+			}
+
+			clk_set_rate(clk, 12000000);
+			rc = clk_prepare_enable(clk);
+			if (rc) {
+				dev_err(&pdev->dev,
+					"failed to enable tmclk: %d\n", rc);
+				goto err_power_req;
+			}
+
+			tegra_host->tmclk = clk;
+		}
+
+		clk = devm_clk_get(dev, "sdhci")
+		if (IS_ERR(clk)) {
+			rc = PTR_ERR(clk);
+
+			if (rc != -EPROBE_DEFER)
+				dev_err(&pdev->dev,
+					"failed to get sdhci clock: %d\n", rc);
+
+			goto err_clk_get;
+		}
 	}
+
 	clk_prepare_enable(clk);
 	pltfm_host->clk = clk;
 
@@ -1654,6 +1725,7 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 err_rst_get:
 	clk_disable_unprepare(pltfm_host->clk);
 err_clk_get:
+	clk_disable_unprepare(tegra_host->tmclk);
 err_power_req:
 err_parse_dt:
 	sdhci_pltfm_free(pdev);
@@ -1671,6 +1743,7 @@ static int sdhci_tegra_remove(struct platform_device *pdev)
 	reset_control_assert(tegra_host->rst);
 	usleep_range(2000, 4000);
 	clk_disable_unprepare(pltfm_host->clk);
+	clk_disable_unprepare(tegra_host->tmclk);
 
 	sdhci_pltfm_free(pdev);
 
-- 
2.7.4

