Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2468A253C39
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 05:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgH0Duh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 23:50:37 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18255 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgH0Dug (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 23:50:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f472d7e0000>; Wed, 26 Aug 2020 20:50:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 20:50:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 20:50:36 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 03:50:30 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 27 Aug 2020 03:50:30 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f472d860000>; Wed, 26 Aug 2020 20:50:30 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v6 7/7] sdhci: tegra: Add missing TMCLK for data timeout
Date:   Wed, 26 Aug 2020 20:50:01 -0700
Message-ID: <1598500201-5987-8-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
References: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598500222; bh=fU0W0lQH6TUHqegrUenmFQDw6Q7G+5MGgzZQlaMJ8cQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=Ekxk9qz7fgTNb0Q4mkGAUCs7Pv9TrIfAhtcWx/P/eylz+5jroq+p0qt9hKgG08S88
         ntQQhuUQxXRkBA9GRsHLhQHKoSu7oho3XgMF2WbJcRprXNBrWSF23UFHM11XCjpfKt
         sdedBR8LkAuPhh5V0pyB1BcHA6Vnu4TnUiDGuh8eaZZa4uCa6i9y0w2K0tNceHqMRW
         mpKzh+Fv2nY+R+BreDDS64GL+U10SUStM0QKuLu1kGI0+dJofFPVlznXYryHkurUZJ
         1FKPbQdyFf1+ETgh808C0uccWw3KNs3fQFJJWjVcv8DtIuXsMKZYxH/l3y6UGtR4p4
         hkk+QJOx2+QWQ==
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
 drivers/mmc/host/sdhci-tegra.c | 90 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 31ed321..f69ca8d 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -13,6 +13,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_clk.h>
 #include <linux/of_device.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/regulator/consumer.h>
@@ -110,6 +111,12 @@
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
 
@@ -140,6 +147,7 @@ struct sdhci_tegra_autocal_offsets {
 struct sdhci_tegra {
 	const struct sdhci_tegra_soc_data *soc_data;
 	struct gpio_desc *power_gpio;
+	struct clk *tmclk;
 	bool ddr_signaling;
 	bool pad_calib_required;
 	bool pad_control_available;
@@ -1433,7 +1441,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
-		    NVQUIRK_ENABLE_SDR104,
+		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK,
 	.min_tap_delay = 106,
 	.max_tap_delay = 185,
 };
@@ -1471,6 +1480,7 @@ static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
 		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK |
 		    NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING,
 	.min_tap_delay = 84,
 	.max_tap_delay = 136,
@@ -1483,7 +1493,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra194 = {
 		    NVQUIRK_HAS_PADCALIB |
 		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
 		    NVQUIRK_ENABLE_SDR50 |
-		    NVQUIRK_ENABLE_SDR104,
+		    NVQUIRK_ENABLE_SDR104 |
+		    NVQUIRK_HAS_TMCLK,
 	.min_tap_delay = 96,
 	.max_tap_delay = 139,
 };
@@ -1611,15 +1622,76 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
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
+	if (of_clk_get_parent_count(pdev->dev.of_node) == 1) {
+		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK)
+			dev_warn(&pdev->dev,
+				 "missing tmclk in the device tree\n");
+
+		clk = devm_clk_get(&pdev->dev, NULL);
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
+		clk = devm_clk_get(&pdev->dev, "sdhci");
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
 
@@ -1654,6 +1726,7 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 err_rst_get:
 	clk_disable_unprepare(pltfm_host->clk);
 err_clk_get:
+	clk_disable_unprepare(tegra_host->tmclk);
 err_power_req:
 err_parse_dt:
 	sdhci_pltfm_free(pdev);
@@ -1671,6 +1744,7 @@ static int sdhci_tegra_remove(struct platform_device *pdev)
 	reset_control_assert(tegra_host->rst);
 	usleep_range(2000, 4000);
 	clk_disable_unprepare(pltfm_host->clk);
+	clk_disable_unprepare(tegra_host->tmclk);
 
 	sdhci_pltfm_free(pdev);
 
-- 
2.7.4

