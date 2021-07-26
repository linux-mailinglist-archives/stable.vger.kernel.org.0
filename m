Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF973D5F53
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbhGZPRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237415AbhGZPPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2103C60FF3;
        Mon, 26 Jul 2021 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314847;
        bh=zlTczvXNNvbkXi8PSx+qc0oRnnyP+lG/tYOCyZwBILA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t739qTjdPIlAWQ0bKviR49u5w+QkBmUUe5ELHmSTBuDVYkRIr9q2Qbr5hsHOj0rwK
         L9saMG9o8yuNsOlMlxsM6Uauvq9B53uSWeO7ompm8w4c1XDpl5RMz7CfLbJJnwPk7j
         3D3EXAK6W89C/B8hYHIApjHaSE6z+fFOXhae7Dgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 114/120] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Mon, 26 Jul 2021 17:39:26 +0200
Message-Id: <20210726153836.135197574@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

commit 5a3c680aa2c12c90c44af383fe6882a39875ab81 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   16 ++--------------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 ------
 2 files changed, 2 insertions(+), 20 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1189,7 +1189,8 @@ static void bcmgenet_power_up(struct bcm
 
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
-		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS);
+		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
+			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
@@ -2908,12 +2909,6 @@ static int bcmgenet_open(struct net_devi
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -3632,7 +3627,6 @@ static int bcmgenet_resume(struct device
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
 	int ret;
-	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3664,12 +3658,6 @@ static int bcmgenet_resume(struct device
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	if (priv->wolopts)
 		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
 
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -166,12 +166,6 @@ int bcmgenet_wol_power_down_cfg(struct b
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	return 0;
 }
 


