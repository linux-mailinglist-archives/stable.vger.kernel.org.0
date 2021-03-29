Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E4734C998
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhC2IaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233902AbhC2I1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BBE76196F;
        Mon, 29 Mar 2021 08:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006375;
        bh=B7Ia/zg4SK2GhrFF/UTt4DefRPW6SgVU28RG9jnOzXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUKHLJIhzL6WbxhBHPCA4lB7Vk8xAn+YSrHtO7SwdM1jQSWqwuSbD8mV03fGEQN9g
         8yw4T1xCNF/onPmrsmB6g2SDKfWAZ6abpcYBxvY+2HqYJGzBeRl5dIR8Oaw2GmvG6H
         dt6U5ZZs3FGC7O45GU/UIZwiYYdSkkvgEM1vLa2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/221] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode
Date:   Mon, 29 Mar 2021 09:58:34 +0200
Message-Id: <20210329075635.241231391@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 1a02556086fc0eb16e0a0d09043e9ffb0e31c7db ]

Update the axienet driver to properly support the Xilinx PCS/PMA PHY
component which is used for 1000BaseX and SGMII modes, including
properly configuring the auto-negotiation mode of the PHY and reading
the negotiated state from the PHY.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/20201028171429.1699922-1-robert.hancock@calian.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  3 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 94 ++++++++++++++-----
 2 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f34c7903ff52..7326ad4d5e1c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -419,6 +419,9 @@ struct axienet_local {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
+	/* Reference to PCS/PMA PHY if used */
+	struct mdio_device *pcs_phy;
+
 	/* Clock for AXI bus */
 	struct clk *clk;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index eea0bb7c23ed..415676c2c11f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1517,10 +1517,27 @@ static void axienet_validate(struct phylink_config *config,
 
 	phylink_set(mask, Asym_Pause);
 	phylink_set(mask, Pause);
-	phylink_set(mask, 1000baseX_Full);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Full);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		phylink_set(mask, 1000baseX_Full);
+		phylink_set(mask, 1000baseT_Full);
+		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+			break;
+		fallthrough;
+	case PHY_INTERFACE_MODE_MII:
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 10baseT_Full);
+	default:
+		break;
+	}
 
 	bitmap_and(supported, supported, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -1533,38 +1550,46 @@ static void axienet_mac_pcs_get_state(struct phylink_config *config,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
-	u32 emmc_reg, fcc_reg;
-
-	state->interface = lp->phy_mode;
-
-	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
-	if (emmc_reg & XAE_EMMC_LINKSPD_1000)
-		state->speed = SPEED_1000;
-	else if (emmc_reg & XAE_EMMC_LINKSPD_100)
-		state->speed = SPEED_100;
-	else
-		state->speed = SPEED_10;
-
-	state->pause = 0;
-	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
-	if (fcc_reg & XAE_FCC_FCTX_MASK)
-		state->pause |= MLO_PAUSE_TX;
-	if (fcc_reg & XAE_FCC_FCRX_MASK)
-		state->pause |= MLO_PAUSE_RX;
 
-	state->an_complete = 0;
-	state->duplex = 1;
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_mii_c22_pcs_get_state(lp->pcs_phy, state);
+		break;
+	default:
+		break;
+	}
 }
 
 static void axienet_mac_an_restart(struct phylink_config *config)
 {
-	/* Unsupported, do nothing */
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+
+	phylink_mii_c22_pcs_an_restart(lp->pcs_phy);
 }
 
 static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 			       const struct phylink_link_state *state)
 {
-	/* nothing meaningful to do */
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+	int ret;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		ret = phylink_mii_c22_pcs_config(lp->pcs_phy, mode,
+						 state->interface,
+						 state->advertising);
+		if (ret < 0)
+			netdev_warn(ndev, "Failed to configure PCS: %d\n",
+				    ret);
+		break;
+
+	default:
+		break;
+	}
 }
 
 static void axienet_mac_link_down(struct phylink_config *config,
@@ -1997,6 +2022,20 @@ static int axienet_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev,
 				 "error registering MDIO bus: %d\n", ret);
 	}
+	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
+	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
+		if (!lp->phy_node) {
+			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
+			ret = -EINVAL;
+			goto free_netdev;
+		}
+		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		if (!lp->pcs_phy) {
+			ret = -EPROBE_DEFER;
+			goto free_netdev;
+		}
+		lp->phylink_config.pcs_poll = true;
+	}
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
@@ -2034,6 +2073,9 @@ static int axienet_remove(struct platform_device *pdev)
 	if (lp->phylink)
 		phylink_destroy(lp->phylink);
 
+	if (lp->pcs_phy)
+		put_device(&lp->pcs_phy->dev);
+
 	axienet_mdio_teardown(lp);
 
 	clk_disable_unprepare(lp->clk);
-- 
2.30.1



