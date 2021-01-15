Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884F92F7B6A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733185AbhAONBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbhAOMc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3F12333E;
        Fri, 15 Jan 2021 12:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713960;
        bh=7ZpCsSK2RVJ+ZQfyxTBYcdk3EMLC1D20DrcLXb0mkK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I32R426q0z8+sCMO9doLFkR9HTo6yV6Ijw1IFiVNunkLX1qjcQXQi4s4/VjNC2DbZ
         c+b701JH/xxdwys+JmQcrjz+AcFMQF4EzH7/yDsKjViBQc4ecbH1O449AzDudHn6HW
         7Zk65gtLhYDUVdfSi6Dyr9b49ksGlDLfDj2RVUAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 04/43] net: stmmac: dwmac-sun8i: Balance internal PHY power
Date:   Fri, 15 Jan 2021 13:27:34 +0100
Message-Id: <20210115121957.263251610@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit b8239638853e3e37b287e4bd4d57b41f14c78550 ]

sun8i_dwmac_exit calls sun8i_dwmac_unpower_internal_phy, but
sun8i_dwmac_init did not call sun8i_dwmac_power_internal_phy. This
caused PHY power to remain off after a suspend/resume cycle. Fix this by
recording if PHY power should be restored, and if so, restoring it.

Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |   31 ++++++++++++++++------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -73,6 +73,7 @@ struct emac_variant {
  * @variant:	reference to the current board variant
  * @regmap:	regmap for using the syscon
  * @internal_phy_powered: Does the internal PHY is enabled
+ * @use_internal_phy: Is the internal PHY selected for use
  * @mux_handle:	Internal pointer used by mdio-mux lib
  */
 struct sunxi_priv_data {
@@ -83,6 +84,7 @@ struct sunxi_priv_data {
 	const struct emac_variant *variant;
 	struct regmap_field *regmap_field;
 	bool internal_phy_powered;
+	bool use_internal_phy;
 	void *mux_handle;
 };
 
@@ -518,8 +520,11 @@ static const struct stmmac_dma_ops sun8i
 	.dma_interrupt = sun8i_dwmac_dma_interrupt,
 };
 
+static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv);
+
 static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 {
+	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct sunxi_priv_data *gmac = priv;
 	int ret;
 
@@ -533,13 +538,25 @@ static int sun8i_dwmac_init(struct platf
 
 	ret = clk_prepare_enable(gmac->tx_clk);
 	if (ret) {
-		if (gmac->regulator)
-			regulator_disable(gmac->regulator);
 		dev_err(&pdev->dev, "Could not enable AHB clock\n");
-		return ret;
+		goto err_disable_regulator;
+	}
+
+	if (gmac->use_internal_phy) {
+		ret = sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
+		if (ret)
+			goto err_disable_clk;
 	}
 
 	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(gmac->tx_clk);
+err_disable_regulator:
+	if (gmac->regulator)
+		regulator_disable(gmac->regulator);
+
+	return ret;
 }
 
 static void sun8i_dwmac_core_init(struct mac_device_info *hw,
@@ -809,7 +826,6 @@ static int mdio_mux_syscon_switch_fn(int
 	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
 	u32 reg, val;
 	int ret = 0;
-	bool need_power_ephy = false;
 
 	if (current_child ^ desired_child) {
 		regmap_field_read(gmac->regmap_field, &reg);
@@ -817,13 +833,12 @@ static int mdio_mux_syscon_switch_fn(int
 		case DWMAC_SUN8I_MDIO_MUX_INTERNAL_ID:
 			dev_info(priv->device, "Switch mux to internal PHY");
 			val = (reg & ~H3_EPHY_MUX_MASK) | H3_EPHY_SELECT;
-
-			need_power_ephy = true;
+			gmac->use_internal_phy = true;
 			break;
 		case DWMAC_SUN8I_MDIO_MUX_EXTERNAL_ID:
 			dev_info(priv->device, "Switch mux to external PHY");
 			val = (reg & ~H3_EPHY_MUX_MASK) | H3_EPHY_SHUTDOWN;
-			need_power_ephy = false;
+			gmac->use_internal_phy = false;
 			break;
 		default:
 			dev_err(priv->device, "Invalid child ID %x\n",
@@ -831,7 +846,7 @@ static int mdio_mux_syscon_switch_fn(int
 			return -EINVAL;
 		}
 		regmap_field_write(gmac->regmap_field, val);
-		if (need_power_ephy) {
+		if (gmac->use_internal_phy) {
 			ret = sun8i_dwmac_power_internal_phy(priv);
 			if (ret)
 				return ret;


