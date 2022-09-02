Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D05AB3BC
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiIBOeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiIBOcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:32:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D5C27B32;
        Fri,  2 Sep 2022 06:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B86EB82AE3;
        Fri,  2 Sep 2022 12:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67022C433D6;
        Fri,  2 Sep 2022 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122252;
        bh=/67D0l64kojxp9yNGoxfMK9Sz6bEFeIamMgjd0pcGog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3NhFNAU3LKf8IcbW156UkFAva5H3cKvbG8IMQKdnNI0Sfhhbjzclt75/AY3UUMEd
         1jO7ot/JutqLA6urcJ2F4EO0wBOumbYKcXp5XVdP5PYgs9Ai6qkzbUKpJ3EO6nNCXb
         TF67aDylqiYyavE6CITa81tQEpU79GMnID/3v3/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 30/72] mmc: sdhci-of-dwcmshc: rename rk3568 to rk35xx
Date:   Fri,  2 Sep 2022 14:19:06 +0200
Message-Id: <20220902121405.778878038@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 86e1a8e1f9b555af342c53ae06284eeeab9a4263 ]

Prepare driver for rk3588 support by renaming the internal data
structures.

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20220504213251.264819-11-sebastian.reichel@collabora.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c | 46 ++++++++++++++---------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index 3a1b5ba364051..f5fd88c7adef1 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -56,14 +56,14 @@
 #define DLL_LOCK_WO_TMOUT(x) \
 	((((x) & DWCMSHC_EMMC_DLL_LOCKED) == DWCMSHC_EMMC_DLL_LOCKED) && \
 	(((x) & DWCMSHC_EMMC_DLL_TIMEOUT) == 0))
-#define RK3568_MAX_CLKS 3
+#define RK35xx_MAX_CLKS 3
 
 #define BOUNDARY_OK(addr, len) \
 	((addr | (SZ_128M - 1)) == ((addr + len - 1) | (SZ_128M - 1)))
 
-struct rk3568_priv {
+struct rk35xx_priv {
 	/* Rockchip specified optional clocks */
-	struct clk_bulk_data rockchip_clks[RK3568_MAX_CLKS];
+	struct clk_bulk_data rockchip_clks[RK35xx_MAX_CLKS];
 	struct reset_control *reset;
 	u8 txclk_tapnum;
 };
@@ -178,7 +178,7 @@ static void dwcmshc_rk3568_set_clock(struct sdhci_host *host, unsigned int clock
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *dwc_priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *priv = dwc_priv->priv;
+	struct rk35xx_priv *priv = dwc_priv->priv;
 	u8 txclk_tapnum = DLL_TXCLK_TAPNUM_DEFAULT;
 	u32 extra, reg;
 	int err;
@@ -281,7 +281,7 @@ static const struct sdhci_ops sdhci_dwcmshc_ops = {
 	.adma_write_desc	= dwcmshc_adma_write_desc,
 };
 
-static const struct sdhci_ops sdhci_dwcmshc_rk3568_ops = {
+static const struct sdhci_ops sdhci_dwcmshc_rk35xx_ops = {
 	.set_clock		= dwcmshc_rk3568_set_clock,
 	.set_bus_width		= sdhci_set_bus_width,
 	.set_uhs_signaling	= dwcmshc_set_uhs_signaling,
@@ -296,18 +296,18 @@ static const struct sdhci_pltfm_data sdhci_dwcmshc_pdata = {
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
-static const struct sdhci_pltfm_data sdhci_dwcmshc_rk3568_pdata = {
-	.ops = &sdhci_dwcmshc_rk3568_ops,
+static const struct sdhci_pltfm_data sdhci_dwcmshc_rk35xx_pdata = {
+	.ops = &sdhci_dwcmshc_rk35xx_ops,
 	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
 		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
 		   SDHCI_QUIRK2_CLOCK_DIV_ZERO_BROKEN,
 };
 
-static int dwcmshc_rk3568_init(struct sdhci_host *host, struct dwcmshc_priv *dwc_priv)
+static int dwcmshc_rk35xx_init(struct sdhci_host *host, struct dwcmshc_priv *dwc_priv)
 {
 	int err;
-	struct rk3568_priv *priv = dwc_priv->priv;
+	struct rk35xx_priv *priv = dwc_priv->priv;
 
 	priv->reset = devm_reset_control_array_get_optional_exclusive(mmc_dev(host->mmc));
 	if (IS_ERR(priv->reset)) {
@@ -319,14 +319,14 @@ static int dwcmshc_rk3568_init(struct sdhci_host *host, struct dwcmshc_priv *dwc
 	priv->rockchip_clks[0].id = "axi";
 	priv->rockchip_clks[1].id = "block";
 	priv->rockchip_clks[2].id = "timer";
-	err = devm_clk_bulk_get_optional(mmc_dev(host->mmc), RK3568_MAX_CLKS,
+	err = devm_clk_bulk_get_optional(mmc_dev(host->mmc), RK35xx_MAX_CLKS,
 					 priv->rockchip_clks);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "failed to get clocks %d\n", err);
 		return err;
 	}
 
-	err = clk_bulk_prepare_enable(RK3568_MAX_CLKS, priv->rockchip_clks);
+	err = clk_bulk_prepare_enable(RK35xx_MAX_CLKS, priv->rockchip_clks);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "failed to enable clocks %d\n", err);
 		return err;
@@ -348,7 +348,7 @@ static int dwcmshc_rk3568_init(struct sdhci_host *host, struct dwcmshc_priv *dwc
 static const struct of_device_id sdhci_dwcmshc_dt_ids[] = {
 	{
 		.compatible = "rockchip,rk3568-dwcmshc",
-		.data = &sdhci_dwcmshc_rk3568_pdata,
+		.data = &sdhci_dwcmshc_rk35xx_pdata,
 	},
 	{
 		.compatible = "snps,dwcmshc-sdhci",
@@ -371,7 +371,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	struct sdhci_pltfm_host *pltfm_host;
 	struct sdhci_host *host;
 	struct dwcmshc_priv *priv;
-	struct rk3568_priv *rk_priv = NULL;
+	struct rk35xx_priv *rk_priv = NULL;
 	const struct sdhci_pltfm_data *pltfm_data;
 	int err;
 	u32 extra;
@@ -426,8 +426,8 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	host->mmc_host_ops.request = dwcmshc_request;
 	host->mmc_host_ops.hs400_enhanced_strobe = dwcmshc_hs400_enhanced_strobe;
 
-	if (pltfm_data == &sdhci_dwcmshc_rk3568_pdata) {
-		rk_priv = devm_kzalloc(&pdev->dev, sizeof(struct rk3568_priv), GFP_KERNEL);
+	if (pltfm_data == &sdhci_dwcmshc_rk35xx_pdata) {
+		rk_priv = devm_kzalloc(&pdev->dev, sizeof(struct rk35xx_priv), GFP_KERNEL);
 		if (!rk_priv) {
 			err = -ENOMEM;
 			goto err_clk;
@@ -435,7 +435,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 
 		priv->priv = rk_priv;
 
-		err = dwcmshc_rk3568_init(host, priv);
+		err = dwcmshc_rk35xx_init(host, priv);
 		if (err)
 			goto err_clk;
 	}
@@ -452,7 +452,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_disable_unprepare(priv->bus_clk);
 	if (rk_priv)
-		clk_bulk_disable_unprepare(RK3568_MAX_CLKS,
+		clk_bulk_disable_unprepare(RK35xx_MAX_CLKS,
 					   rk_priv->rockchip_clks);
 free_pltfm:
 	sdhci_pltfm_free(pdev);
@@ -464,14 +464,14 @@ static int dwcmshc_remove(struct platform_device *pdev)
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *rk_priv = priv->priv;
+	struct rk35xx_priv *rk_priv = priv->priv;
 
 	sdhci_remove_host(host, 0);
 
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_disable_unprepare(priv->bus_clk);
 	if (rk_priv)
-		clk_bulk_disable_unprepare(RK3568_MAX_CLKS,
+		clk_bulk_disable_unprepare(RK35xx_MAX_CLKS,
 					   rk_priv->rockchip_clks);
 	sdhci_pltfm_free(pdev);
 
@@ -484,7 +484,7 @@ static int dwcmshc_suspend(struct device *dev)
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *rk_priv = priv->priv;
+	struct rk35xx_priv *rk_priv = priv->priv;
 	int ret;
 
 	ret = sdhci_suspend_host(host);
@@ -496,7 +496,7 @@ static int dwcmshc_suspend(struct device *dev)
 		clk_disable_unprepare(priv->bus_clk);
 
 	if (rk_priv)
-		clk_bulk_disable_unprepare(RK3568_MAX_CLKS,
+		clk_bulk_disable_unprepare(RK35xx_MAX_CLKS,
 					   rk_priv->rockchip_clks);
 
 	return ret;
@@ -507,7 +507,7 @@ static int dwcmshc_resume(struct device *dev)
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	struct rk3568_priv *rk_priv = priv->priv;
+	struct rk35xx_priv *rk_priv = priv->priv;
 	int ret;
 
 	ret = clk_prepare_enable(pltfm_host->clk);
@@ -521,7 +521,7 @@ static int dwcmshc_resume(struct device *dev)
 	}
 
 	if (rk_priv) {
-		ret = clk_bulk_prepare_enable(RK3568_MAX_CLKS,
+		ret = clk_bulk_prepare_enable(RK35xx_MAX_CLKS,
 					      rk_priv->rockchip_clks);
 		if (ret)
 			return ret;
-- 
2.35.1



