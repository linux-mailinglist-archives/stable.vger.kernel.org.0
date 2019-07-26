Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7680676CC0
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbfGZP1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388230AbfGZP1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:27:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A539E22CBF;
        Fri, 26 Jul 2019 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154831;
        bh=EvcoB1pQsL5JVbTVWA5/JqkFrYTXo3SGIpJ9K3RWwKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pogZyY7of/eiLgqYTbNT0cQc5m3tIWtxJYstLH9YuxhfrN8PS/jInK+aSM8xV+vRN
         F7dRv2fRoLCQYFv5WzrdfC60LhoZsIEy7u+AWh8l4C5zgnetxqSgmsskpFqWiC83zs
         H3UIeI3/TZmDJOhDiJiCddaYpWNZ7p9I0VzLOzsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 08/66] net: bcmgenet: use promisc for unsupported filters
Date:   Fri, 26 Jul 2019 17:24:07 +0200
Message-Id: <20190726152302.813137100@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
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
@@ -3083,39 +3083,42 @@ static void bcmgenet_timeout(struct net_
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
@@ -3125,32 +3128,24 @@ static void bcmgenet_set_rx_mode(struct
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


