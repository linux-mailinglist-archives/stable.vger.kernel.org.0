Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C853D266F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhGVOak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232577AbhGVOaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B51FE610F7;
        Thu, 22 Jul 2021 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626966625;
        bh=wuuiiRALSAYZukEstb3aLaHMWx6445LXZz3Gh59omkM=;
        h=Subject:To:Cc:From:Date:From;
        b=d6HY5iqubfoOs9yGrHnZry5iOpkicvEpZOB5QLlCzkFmYoZbpsfQBrvSnZ0JfAUCU
         kqNi2pMmI/gKFXQSWNDWHy8DwO3w54NJvUGJnsoCPNrIx39lKOYPu0a1KDYcWeXt3X
         Sn1ob3nkTwjya3jTA8dPyFwpSF2Ojmz1w6QHkz/s=
Subject: FAILED: patch "[PATCH] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear" failed to apply to 4.9-stable tree
To:     opendmb@gmail.com, davem@davemloft.net, f.fainelli@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:10:14 +0200
Message-ID: <1626966614152238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5a3c680aa2c12c90c44af383fe6882a39875ab81 Mon Sep 17 00:00:00 2001
From: Doug Berger <opendmb@gmail.com>
Date: Tue, 29 Jun 2021 17:14:19 -0700
Subject: [PATCH] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
logic of the internal PHY to prevent the system from sleeping. Some
internal PHYs will report that energy is detected when the network
interface is closed which can prevent the system from going to sleep
if WoL is enabled when the interface is brought down.

Since the driver does not support waking the system on this logic,
this commit clears the bit whenever the internal PHY is powered up
and the other logic for manipulating the bit is removed since it
serves no useful function.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 41f7f078cd27..35e9956e930c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1640,7 +1640,8 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
-		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS);
+		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
+			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
@@ -3292,7 +3293,6 @@ static int bcmgenet_open(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
-	u32 reg;
 	int ret;
 
 	netif_dbg(priv, ifup, dev, "bcmgenet_open\n");
@@ -3318,12 +3318,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -4139,7 +4133,6 @@ static int bcmgenet_resume(struct device *d)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rxnfc_rule *rule;
 	unsigned long dma_ctrl;
-	u32 reg;
 	int ret;
 
 	if (!netif_running(dev))
@@ -4176,12 +4169,6 @@ static int bcmgenet_resume(struct device *d)
 		if (rule->state != BCMGENET_RXNFC_STATE_UNUSED)
 			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index facde824bcaa..e31a5a397f11 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -186,12 +186,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	reg = UMAC_IRQ_MPD_R;
 	if (hfb_enable)
 		reg |=  UMAC_IRQ_HFB_SM | UMAC_IRQ_HFB_MM;

