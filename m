Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9FF3962B0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhEaPA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234132AbhEaO5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA0061CC2;
        Mon, 31 May 2021 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469639;
        bh=nlTcHeTklVjLklF9DpoD4gMA/IBp18zY02GeRa0N93E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HR+12+nuZiLuwPBDvKwCrkPlvxDTzHvwlda99sbTw3+Tn5UpVeNp2LM9vurOzIcqb
         7u4vgGeZrYMByZL1rw52ydHx/K2TvgPBNBAzQBfkpebmDhZ7I1/+l7qsM/rBcsnbPT
         LvHbfiKxBsRn+ltUjLE9m1QQ4d4GIrPny/AGmFSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 274/296] net: lantiq: fix memory corruption in RX ring
Date:   Mon, 31 May 2021 15:15:29 +0200
Message-Id: <20210531130712.951598038@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit c7718ee96dbc2f9c5fc3b578abdf296dd44b9c20 ]

In a situation where memory allocation or dma mapping fails, an
invalid address is programmed into the descriptor. This can lead
to memory corruption. If the memory allocation fails, DMA should
reuse the previous skb and mapping and drop the packet. This patch
also increments rx drop counter.

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver ")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 51ed8a54d380..135ba5b6ae98 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -154,6 +154,7 @@ static int xrx200_close(struct net_device *net_dev)
 
 static int xrx200_alloc_skb(struct xrx200_chan *ch)
 {
+	dma_addr_t mapping;
 	int ret = 0;
 
 	ch->skb[ch->dma.desc] = netdev_alloc_skb_ip_align(ch->priv->net_dev,
@@ -163,16 +164,17 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 		goto skip;
 	}
 
-	ch->dma.desc_base[ch->dma.desc].addr = dma_map_single(ch->priv->dev,
-			ch->skb[ch->dma.desc]->data, XRX200_DMA_DATA_LEN,
-			DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ch->priv->dev,
-				       ch->dma.desc_base[ch->dma.desc].addr))) {
+	mapping = dma_map_single(ch->priv->dev, ch->skb[ch->dma.desc]->data,
+				 XRX200_DMA_DATA_LEN, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ch->priv->dev, mapping))) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 		ret = -ENOMEM;
 		goto skip;
 	}
 
+	ch->dma.desc_base[ch->dma.desc].addr = mapping;
+	/* Make sure the address is written before we give it to HW */
+	wmb();
 skip:
 	ch->dma.desc_base[ch->dma.desc].ctl =
 		LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) |
@@ -196,6 +198,8 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	ch->dma.desc %= LTQ_DESC_NUM;
 
 	if (ret) {
+		ch->skb[ch->dma.desc] = skb;
+		net_dev->stats.rx_dropped++;
 		netdev_err(net_dev, "failed to allocate new rx buffer\n");
 		return ret;
 	}
-- 
2.30.2



