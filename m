Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0B3D28E2
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhGVP75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhGVP6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DCE66135C;
        Thu, 22 Jul 2021 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971949;
        bh=3DHuLyhYUC3S4l43SVoJcd8DC/jsHRZYEX0mr9knNNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4afr2cKPvQqzk9J6VypV1qoQEtMdQNeHb711kD2R+vB/eQcZlRH3UWret741kyN9
         GM1jaDoRbSK8Zc6u1EBiDlE9U2eorgHVpcSk2HIbt+/yuuOHyacHNR8Na5AWU6DtU7
         0mpPrNJYP9CmOKR2gyHQA3iLJOEQpLiNSzCkPSMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 089/125] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Thu, 22 Jul 2021 18:31:20 +0200
Message-Id: <20210722155627.647493028@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   17 ++---------------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 ------
 2 files changed, 2 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1640,7 +1640,8 @@ static void bcmgenet_power_up(struct bcm
 
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
-		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS);
+		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
+			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
@@ -3292,7 +3293,6 @@ static int bcmgenet_open(struct net_devi
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
-	u32 reg;
 	int ret;
 
 	netif_dbg(priv, ifup, dev, "bcmgenet_open\n");
@@ -3318,12 +3318,6 @@ static int bcmgenet_open(struct net_devi
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -4139,7 +4133,6 @@ static int bcmgenet_resume(struct device
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rxnfc_rule *rule;
 	unsigned long dma_ctrl;
-	u32 reg;
 	int ret;
 
 	if (!netif_running(dev))
@@ -4176,12 +4169,6 @@ static int bcmgenet_resume(struct device
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
 
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -187,12 +187,6 @@ int bcmgenet_wol_power_down_cfg(struct b
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


