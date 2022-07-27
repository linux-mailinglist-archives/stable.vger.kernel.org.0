Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A884858302A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiG0RfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242415AbiG0Rde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:33:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B61606B4;
        Wed, 27 Jul 2022 09:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F717CE2311;
        Wed, 27 Jul 2022 16:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11BFC433D6;
        Wed, 27 Jul 2022 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940507;
        bh=1cPJDOWf1YZmUIflLvJDJ9vPMZP8ZvGzCyuRVCTr26Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/gPtgBfNAWOmSgNrfOPZ1XA2qbCmSAxSX54k5hEknqlasH1nYvUA/YcUwxxTCova
         ibWcDtbsGPAGbLi87BCzMZKReAK4Ub946H4iXddyi/J6ovDeSrZa8uIS0SUrDnDePJ
         84Is/8nMAreXN8je4+069/iD+2u1I5Lr+A/wtOsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 048/158] stmmac: dwmac-mediatek: fix clock issue
Date:   Wed, 27 Jul 2022 18:11:52 +0200
Message-Id: <20220727161023.445815090@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit fa4b3ca60e8011d3046765b3de8d3f1ffc53af28 ]

The pm_runtime takes care of the clock handling in current
stmmac drivers, and dwmac-mediatek implement the
mediatek_dwmac_clks_config() as the callback for pm_runtime.

Then, stripping duplicated clocks handling in old init()/exit()
to fix clock issue in suspend/resume test.

As to clocks in probe/remove, vendor need symmetric handling to
ensure clocks balance.

Test pass, including suspend/resume and ko insertion/remove.

Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level clocks management")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 49 ++++++++-----------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 6ff88df58767..ca8ab290013c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -576,32 +576,7 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
 		}
 	}
 
-	ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
-	if (ret) {
-		dev_err(plat->dev, "failed to enable clks, err = %d\n", ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(plat->rmii_internal_clk);
-	if (ret) {
-		dev_err(plat->dev, "failed to enable rmii internal clk, err = %d\n", ret);
-		goto err_clk;
-	}
-
 	return 0;
-
-err_clk:
-	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
-	return ret;
-}
-
-static void mediatek_dwmac_exit(struct platform_device *pdev, void *priv)
-{
-	struct mediatek_dwmac_plat_data *plat = priv;
-	const struct mediatek_dwmac_variant *variant = plat->variant;
-
-	clk_disable_unprepare(plat->rmii_internal_clk);
-	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
 }
 
 static int mediatek_dwmac_clks_config(void *priv, bool enabled)
@@ -643,7 +618,6 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
 	plat->addr64 = priv_plat->variant->dma_bit_mask;
 	plat->bsp_priv = priv_plat;
 	plat->init = mediatek_dwmac_init;
-	plat->exit = mediatek_dwmac_exit;
 	plat->clks_config = mediatek_dwmac_clks_config;
 	if (priv_plat->variant->dwmac_fix_mac_speed)
 		plat->fix_mac_speed = priv_plat->variant->dwmac_fix_mac_speed;
@@ -712,13 +686,32 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	mediatek_dwmac_common_data(pdev, plat_dat, priv_plat);
 	mediatek_dwmac_init(pdev, priv_plat);
 
+	ret = mediatek_dwmac_clks_config(priv_plat, true);
+	if (ret)
+		return ret;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret) {
 		stmmac_remove_config_dt(pdev, plat_dat);
-		return ret;
+		goto err_drv_probe;
 	}
 
 	return 0;
+
+err_drv_probe:
+	mediatek_dwmac_clks_config(priv_plat, false);
+	return ret;
+}
+
+static int mediatek_dwmac_remove(struct platform_device *pdev)
+{
+	struct mediatek_dwmac_plat_data *priv_plat = get_stmmac_bsp_priv(&pdev->dev);
+	int ret;
+
+	ret = stmmac_pltfr_remove(pdev);
+	mediatek_dwmac_clks_config(priv_plat, false);
+
+	return ret;
 }
 
 static const struct of_device_id mediatek_dwmac_match[] = {
@@ -733,7 +726,7 @@ MODULE_DEVICE_TABLE(of, mediatek_dwmac_match);
 
 static struct platform_driver mediatek_dwmac_driver = {
 	.probe  = mediatek_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove = mediatek_dwmac_remove,
 	.driver = {
 		.name           = "dwmac-mediatek",
 		.pm		= &stmmac_pltfr_pm_ops,
-- 
2.35.1



