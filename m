Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40D43D5D7E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhGZPBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235631AbhGZPBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3846D60E08;
        Mon, 26 Jul 2021 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314132;
        bh=iFVQQ7ITy6zb7ITlcrIkQQlxCv+iDPrf+d2y41YyjlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDV3i/XD9jg8vEaOycMEgJQDzm6K+fiH82fvrudCE2V2zzwz70VSc5J+k59baEB2s
         IGMR1HyhXUcT/EBzlT6FmvaF9GWgahEHdqLwXIbcUEZX/iPHT4uuEw39yl/rZB5NO2
         1WP84YWNykPrkItTvjYQ8F185efAGvzv3SSaeW/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 44/47] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
Date:   Mon, 26 Jul 2021 17:39:02 +0200
Message-Id: <20210726153824.361734541@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
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
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   15 +--------------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 ------
 2 files changed, 1 insertion(+), 20 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1094,7 +1094,7 @@ static void bcmgenet_power_up(struct bcm
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
 		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_PHY |
-				EXT_PWR_DOWN_BIAS);
+			 EXT_PWR_DOWN_BIAS | EXT_ENERGY_DET_MASK);
 		/* fallthrough */
 	case GENET_POWER_CABLE_SENSE:
 		/* enable APD */
@@ -2908,12 +2908,6 @@ static int bcmgenet_open(struct net_devi
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -3601,7 +3595,6 @@ static int bcmgenet_resume(struct device
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
 	int ret;
-	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3636,12 +3629,6 @@ static int bcmgenet_resume(struct device
 
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
@@ -167,12 +167,6 @@ int bcmgenet_wol_power_down_cfg(struct b
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Enable the MPD interrupt */
 	cpu_mask_clear = UMAC_IRQ_MPD_R;
 


