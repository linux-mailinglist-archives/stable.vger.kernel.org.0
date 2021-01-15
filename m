Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7602F7970
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbhAOMgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730548AbhAOMgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857A023403;
        Fri, 15 Jan 2021 12:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714176;
        bh=y+PaLBP2tr8726+mNZx30LCKh/K3zETA89mL99BM15s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U43eH/uaIsMJKca5QnIH/uuQsb+BK2tNhbftdOv4Ov3n4xxj9HhoYnARta0ix9I78
         kYv+Sgi0ZHH0CkXNqRrsAhTfOD/CMAvJ9MZQMzeNg+vebq1AGcAuf3q8Zmea74r585
         SdkJ7SGuxhKW0tcdQEdwRfmBzZdzIgAyOchcyOY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 018/103] net: stmmac: dwmac-sun8i: Balance internal PHY resource references
Date:   Fri, 15 Jan 2021 13:27:11 +0100
Message-Id: <20210115122006.929926675@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 529254216773acd5039c07aa18cf06fd1f9fccdd ]

While stmmac_pltfr_remove calls sun8i_dwmac_exit, the sun8i_dwmac_init
and sun8i_dwmac_exit functions are also called by the stmmac_platform
suspend/resume callbacks. They may be called many times during the
device's lifetime and should not release resources used by the driver.

Furthermore, there was no error handling in case registering the MDIO
mux failed during probe, and the EPHY clock was never released at all.

Fix all of these issues by moving the deinitialization code to a driver
removal callback. Also ensure the EPHY is powered down before removal.

Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   27 +++++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1004,17 +1004,12 @@ static void sun8i_dwmac_exit(struct plat
 	struct sunxi_priv_data *gmac = priv;
 
 	if (gmac->variant->soc_has_internal_phy) {
-		/* sun8i_dwmac_exit could be called with mdiomux uninit */
-		if (gmac->mux_handle)
-			mdio_mux_uninit(gmac->mux_handle);
 		if (gmac->internal_phy_powered)
 			sun8i_dwmac_unpower_internal_phy(gmac);
 	}
 
 	sun8i_dwmac_unset_syscon(gmac);
 
-	reset_control_put(gmac->rst_ephy);
-
 	clk_disable_unprepare(gmac->tx_clk);
 
 	if (gmac->regulator)
@@ -1244,6 +1239,8 @@ static int sun8i_dwmac_probe(struct plat
 
 	return ret;
 dwmac_mux:
+	reset_control_put(gmac->rst_ephy);
+	clk_put(gmac->ephy_clk);
 	sun8i_dwmac_unset_syscon(gmac);
 dwmac_remove:
 	stmmac_dvr_remove(&pdev->dev);
@@ -1255,6 +1252,24 @@ dwmac_deconfig:
 	return ret;
 }
 
+static int sun8i_dwmac_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
+
+	if (gmac->variant->soc_has_internal_phy) {
+		mdio_mux_uninit(gmac->mux_handle);
+		sun8i_dwmac_unpower_internal_phy(gmac);
+		reset_control_put(gmac->rst_ephy);
+		clk_put(gmac->ephy_clk);
+	}
+
+	stmmac_pltfr_remove(pdev);
+
+	return 0;
+}
+
 static const struct of_device_id sun8i_dwmac_match[] = {
 	{ .compatible = "allwinner,sun8i-h3-emac",
 		.data = &emac_variant_h3 },
@@ -1274,7 +1289,7 @@ MODULE_DEVICE_TABLE(of, sun8i_dwmac_matc
 
 static struct platform_driver sun8i_dwmac_driver = {
 	.probe  = sun8i_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove = sun8i_dwmac_remove,
 	.driver = {
 		.name           = "dwmac-sun8i",
 		.pm		= &stmmac_pltfr_pm_ops,


