Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE3018B5F4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgCSNWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbgCSNWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4676721655;
        Thu, 19 Mar 2020 13:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624163;
        bh=wgmoLWEcseM6n7d6+U/LOI7cmzjZ0l1QeI4r/EulqzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaAKfCe4TxWDwwOUK96yjb9dt2rcKwh0MhEaJQjDT85NO7ggL4iHEwhewiUJ5wgNS
         0J6ABp3UtkJg8eQlt/TZ3lnLf/OI7ybekK03uO4G8z9waaREzIi+hedKPfuaRwrzT+
         vVNlA7lJY4j0PBjJEbVtB0q4wlkcAqmPyliqnerA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/60] net: ll_temac: Add more error handling of dma_map_single() calls
Date:   Thu, 19 Mar 2020 14:04:07 +0100
Message-Id: <20200319123928.689087016@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit d07c849cd2b97d6809430dfb7e738ad31088037a ]

This adds error handling to the remaining dma_map_single() calls, so that
behavior is well defined if/when we run out of DMA memory.

Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 26 +++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index fd578568b3bff..fd4231493449b 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -367,6 +367,8 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 					      XTE_MAX_JUMBO_FRAME_SIZE,
 					      DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr))
+			goto out;
 		lp->rx_bd_v[i].phys = cpu_to_be32(skb_dma_addr);
 		lp->rx_bd_v[i].len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
 		lp->rx_bd_v[i].app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
@@ -863,12 +865,13 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 				      skb_headlen(skb), DMA_TO_DEVICE);
 	cur_p->len = cpu_to_be32(skb_headlen(skb));
+	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr)))
+		return NETDEV_TX_BUSY;
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
 	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
-		lp->tx_bd_tail++;
-		if (lp->tx_bd_tail >= TX_BD_NUM)
+		if (++lp->tx_bd_tail >= TX_BD_NUM)
 			lp->tx_bd_tail = 0;
 
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -876,6 +879,25 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					      skb_frag_address(frag),
 					      skb_frag_size(frag),
 					      DMA_TO_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, skb_dma_addr)) {
+			if (--lp->tx_bd_tail < 0)
+				lp->tx_bd_tail = TX_BD_NUM - 1;
+			cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+			while (--ii >= 0) {
+				--frag;
+				dma_unmap_single(ndev->dev.parent,
+						 be32_to_cpu(cur_p->phys),
+						 skb_frag_size(frag),
+						 DMA_TO_DEVICE);
+				if (--lp->tx_bd_tail < 0)
+					lp->tx_bd_tail = TX_BD_NUM - 1;
+				cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+			}
+			dma_unmap_single(ndev->dev.parent,
+					 be32_to_cpu(cur_p->phys),
+					 skb_headlen(skb), DMA_TO_DEVICE);
+			return NETDEV_TX_BUSY;
+		}
 		cur_p->phys = cpu_to_be32(skb_dma_addr);
 		cur_p->len = cpu_to_be32(skb_frag_size(frag));
 		cur_p->app0 = 0;
-- 
2.20.1



