Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF2776E19
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfGZPhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388773AbfGZP3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:29:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD2C218D4;
        Fri, 26 Jul 2019 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154960;
        bh=uu3qTDnCNTovUsEE/JifBgDG5Yt/eiY+fHSm5v52wDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvaM8/GcuRxBrFf4HG7c6H6OEPoD6hNZKsvX8871KOCHHfmkJ2OX62lN22/TiKdFl
         OnKboRpwz8Qn/mnFtA7+GwCe8EzeSpyOTtAbCOF9M8QbN7069Pk14ONlg8z9H2zvHz
         OQt+iZBiTLVuWWHnupaFE4Z/p5/fhmn8ATckVxz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 08/62] net: bcmgenet: use promisc for unsupported filters
Date:   Fri, 26 Jul 2019 17:24:20 +0200
Message-Id: <20190726152302.573411272@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit 35cbef9863640f06107144687bd13151bc2e8ce3 ]

Currently we silently ignore filters if we cannot meet the filter
requirements. This will lead to the MAC dropping packets that are
expected to pass. A better solution would be to set the NIC to promisc
mode when the required filters cannot be met.

Also correct the number of MDF filters supported. It should be 17,
not 16.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |   57 +++++++++++--------------
 1 file changed, 26 insertions(+), 31 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3086,39 +3086,42 @@ static void bcmgenet_timeout(struct net_
 	netif_tx_wake_all_queues(dev);
 }
 
-#define MAX_MC_COUNT	16
+#define MAX_MDF_FILTER	17
 
 static inline void bcmgenet_set_mdf_addr(struct bcmgenet_priv *priv,
 					 unsigned char *addr,
-					 int *i,
-					 int *mc)
+					 int *i)
 {
-	u32 reg;
-
 	bcmgenet_umac_writel(priv, addr[0] << 8 | addr[1],
 			     UMAC_MDF_ADDR + (*i * 4));
 	bcmgenet_umac_writel(priv, addr[2] << 24 | addr[3] << 16 |
 			     addr[4] << 8 | addr[5],
 			     UMAC_MDF_ADDR + ((*i + 1) * 4));
-	reg = bcmgenet_umac_readl(priv, UMAC_MDF_CTRL);
-	reg |= (1 << (MAX_MC_COUNT - *mc));
-	bcmgenet_umac_writel(priv, reg, UMAC_MDF_CTRL);
 	*i += 2;
-	(*mc)++;
 }
 
 static void bcmgenet_set_rx_mode(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
-	int i, mc;
+	int i, nfilter;
 	u32 reg;
 
 	netif_dbg(priv, hw, dev, "%s: %08X\n", __func__, dev->flags);
 
-	/* Promiscuous mode */
+	/* Number of filters needed */
+	nfilter = netdev_uc_count(dev) + netdev_mc_count(dev) + 2;
+
+	/*
+	 * Turn on promicuous mode for three scenarios
+	 * 1. IFF_PROMISC flag is set
+	 * 2. IFF_ALLMULTI flag is set
+	 * 3. The number of filters needed exceeds the number filters
+	 *    supported by the hardware.
+	*/
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	if (dev->flags & IFF_PROMISC) {
+	if ((dev->flags & (IFF_PROMISC | IFF_ALLMULTI)) ||
+	    (nfilter > MAX_MDF_FILTER)) {
 		reg |= CMD_PROMISC;
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 		bcmgenet_umac_writel(priv, 0, UMAC_MDF_CTRL);
@@ -3128,32 +3131,24 @@ static void bcmgenet_set_rx_mode(struct
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	}
 
-	/* UniMac doesn't support ALLMULTI */
-	if (dev->flags & IFF_ALLMULTI) {
-		netdev_warn(dev, "ALLMULTI is not supported\n");
-		return;
-	}
-
 	/* update MDF filter */
 	i = 0;
-	mc = 0;
 	/* Broadcast */
-	bcmgenet_set_mdf_addr(priv, dev->broadcast, &i, &mc);
+	bcmgenet_set_mdf_addr(priv, dev->broadcast, &i);
 	/* my own address.*/
-	bcmgenet_set_mdf_addr(priv, dev->dev_addr, &i, &mc);
-	/* Unicast list*/
-	if (netdev_uc_count(dev) > (MAX_MC_COUNT - mc))
-		return;
+	bcmgenet_set_mdf_addr(priv, dev->dev_addr, &i);
 
-	if (!netdev_uc_empty(dev))
-		netdev_for_each_uc_addr(ha, dev)
-			bcmgenet_set_mdf_addr(priv, ha->addr, &i, &mc);
-	/* Multicast */
-	if (netdev_mc_empty(dev) || netdev_mc_count(dev) >= (MAX_MC_COUNT - mc))
-		return;
+	/* Unicast */
+	netdev_for_each_uc_addr(ha, dev)
+		bcmgenet_set_mdf_addr(priv, ha->addr, &i);
 
+	/* Multicast */
 	netdev_for_each_mc_addr(ha, dev)
-		bcmgenet_set_mdf_addr(priv, ha->addr, &i, &mc);
+		bcmgenet_set_mdf_addr(priv, ha->addr, &i);
+
+	/* Enable filters */
+	reg = GENMASK(MAX_MDF_FILTER - 1, MAX_MDF_FILTER - nfilter);
+	bcmgenet_umac_writel(priv, reg, UMAC_MDF_CTRL);
 }
 
 /* Set the hardware MAC address. */


