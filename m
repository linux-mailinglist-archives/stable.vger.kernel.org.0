Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD011B731
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfLKQGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731207AbfLKPMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DAE24656;
        Wed, 11 Dec 2019 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077161;
        bh=5N0dXIqX9zR+hBefD4dbBOvC2I2jlqrej+/vbe9xcgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQvsLoRbGNTmdkoe+zBEvY3ZOFgIn2IHIsTTIOQxu74JTPTCTBc1Nszxnmbq7fnGa
         2ltbxQMlwkUL3CVhf7fxfSKWyQzwhhua3pkA4zIBVsMuTYHYe9c4Cz3SFrCZ7dbV9S
         qd0N7UBH4nLzDmIOtk9oHhTIwhEnBT0xTvjZ/OPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulrich Hecht <uli+renesas@fpond.eu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 038/105] ravb: implement MTU change while device is up
Date:   Wed, 11 Dec 2019 16:05:27 +0100
Message-Id: <20191211150236.134238492@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulrich Hecht <uli+renesas@fpond.eu>

[ Upstream commit 15fb35fa9ff456b81159033eba6397fcee85e671 ]

Pre-allocates buffers sufficient for the maximum supported MTU (2026) in
order to eliminate the possibility of resource exhaustion when changing the
MTU while the device is up.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++-
 drivers/net/ethernet/renesas/ravb_main.c | 26 +++++++++++++-----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index ac9195add8116..7090229398227 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -960,6 +960,8 @@ enum RAVB_QUEUE {
 #define NUM_RX_QUEUE	2
 #define NUM_TX_QUEUE	2
 
+#define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
+
 /* TX descriptors per packet */
 #define NUM_TX_DESC_GEN2	2
 #define NUM_TX_DESC_GEN3	1
@@ -1023,7 +1025,6 @@ struct ravb_private {
 	u32 dirty_rx[NUM_RX_QUEUE];	/* Producer ring indices */
 	u32 cur_tx[NUM_TX_QUEUE];
 	u32 dirty_tx[NUM_TX_QUEUE];
-	u32 rx_buf_sz;			/* Based on MTU+slack. */
 	struct napi_struct napi[NUM_RX_QUEUE];
 	struct work_struct work;
 	/* MII transceiver section. */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 6cacd5e893aca..393644833cd57 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -230,7 +230,7 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 					       le32_to_cpu(desc->dptr)))
 				dma_unmap_single(ndev->dev.parent,
 						 le32_to_cpu(desc->dptr),
-						 priv->rx_buf_sz,
+						 RX_BUF_SZ,
 						 DMA_FROM_DEVICE);
 		}
 		ring_size = sizeof(struct ravb_ex_rx_desc) *
@@ -293,9 +293,9 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
 		/* RX descriptor */
 		rx_desc = &priv->rx_ring[q][i];
-		rx_desc->ds_cc = cpu_to_le16(priv->rx_buf_sz);
+		rx_desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
-					  priv->rx_buf_sz,
+					  RX_BUF_SZ,
 					  DMA_FROM_DEVICE);
 		/* We just set the data size to 0 for a failed mapping which
 		 * should prevent DMA from happening...
@@ -342,9 +342,6 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	int ring_size;
 	int i;
 
-	priv->rx_buf_sz = (ndev->mtu <= 1492 ? PKT_BUF_SZ : ndev->mtu) +
-		ETH_HLEN + VLAN_HLEN + sizeof(__sum16);
-
 	/* Allocate RX and TX skb rings */
 	priv->rx_skb[q] = kcalloc(priv->num_rx_ring[q],
 				  sizeof(*priv->rx_skb[q]), GFP_KERNEL);
@@ -354,7 +351,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 		goto error;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		skb = netdev_alloc_skb(ndev, priv->rx_buf_sz + RAVB_ALIGN - 1);
+		skb = netdev_alloc_skb(ndev, RX_BUF_SZ + RAVB_ALIGN - 1);
 		if (!skb)
 			goto error;
 		ravb_set_buffer_align(skb);
@@ -590,7 +587,7 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 			skb = priv->rx_skb[q][entry];
 			priv->rx_skb[q][entry] = NULL;
 			dma_unmap_single(ndev->dev.parent, le32_to_cpu(desc->dptr),
-					 priv->rx_buf_sz,
+					 RX_BUF_SZ,
 					 DMA_FROM_DEVICE);
 			get_ts &= (q == RAVB_NC) ?
 					RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
@@ -623,11 +620,11 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
 		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
 		desc = &priv->rx_ring[q][entry];
-		desc->ds_cc = cpu_to_le16(priv->rx_buf_sz);
+		desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 
 		if (!priv->rx_skb[q][entry]) {
 			skb = netdev_alloc_skb(ndev,
-					       priv->rx_buf_sz +
+					       RX_BUF_SZ +
 					       RAVB_ALIGN - 1);
 			if (!skb)
 				break;	/* Better luck next round. */
@@ -1814,10 +1811,15 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	if (netif_running(ndev))
-		return -EBUSY;
+	struct ravb_private *priv = netdev_priv(ndev);
 
 	ndev->mtu = new_mtu;
+
+	if (netif_running(ndev)) {
+		synchronize_irq(priv->emac_irq);
+		ravb_emac_init(ndev);
+	}
+
 	netdev_update_features(ndev);
 
 	return 0;
-- 
2.20.1



