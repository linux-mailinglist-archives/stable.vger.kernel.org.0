Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402C9F7D8C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfKKS56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbfKKS55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E162120659;
        Mon, 11 Nov 2019 18:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498676;
        bh=ZnlcyNaHroyJ1MytqjdEBcFRe8vOyE6qvSziZ1A7lCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUK+UYaVOc99h13EnKNWbbjqtEKcqKr+FqjjlC+sZzrHjS5Xmmc7uTlb86GuduDlV
         xWOPBxejE/xU5LFQF6G6o3U6pK4ka5ssDf9t/cvWQMgFJraH8dCYw2QD2DW95xzUUM
         MXImOssK2iwTY0acJy8BzhMjndGHSCzWZD6NLOCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangchun Fu <yangchun@google.com>,
        Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 187/193] gve: Fixes DMA synchronization.
Date:   Mon, 11 Nov 2019 19:29:29 +0100
Message-Id: <20191111181514.893435051@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangchun Fu <yangchun@google.com>

[ Upstream commit 9cfeeb576d49a7b5e643b8066ba64a55e8417c5d ]

Synces the DMA buffer properly in order for CPU and device to see
the most up-to-data data.

Signed-off-by: Yangchun Fu <yangchun@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx.c |  2 ++
 drivers/net/ethernet/google/gve/gve_tx.c | 24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 59564ac99d2a6..edec61dfc8687 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -289,6 +289,8 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 
 	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
 	page_info = &rx->data.page_info[idx];
+	dma_sync_single_for_cpu(&priv->pdev->dev, rx->data.qpl->page_buses[idx],
+				PAGE_SIZE, DMA_FROM_DEVICE);
 
 	/* gvnic can only receive into registered segments. If the buffer
 	 * can't be recycled, our only choice is to copy the data out of
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 778b87b5a06c2..0a9a7ee2a8668 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -390,7 +390,21 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 	seg_desc->seg.seg_addr = cpu_to_be64(addr);
 }
 
-static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
+static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
+				    u64 iov_offset, u64 iov_len)
+{
+	dma_addr_t dma;
+	u64 addr;
+
+	for (addr = iov_offset; addr < iov_offset + iov_len;
+	     addr += PAGE_SIZE) {
+		dma = page_buses[addr / PAGE_SIZE];
+		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
+	}
+}
+
+static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
+			  struct device *dev)
 {
 	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
 	union gve_tx_desc *pkt_desc, *seg_desc;
@@ -432,6 +446,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
 	skb_copy_bits(skb, 0,
 		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
 		      hlen);
+	gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+				info->iov[hdr_nfrags - 1].iov_offset,
+				info->iov[hdr_nfrags - 1].iov_len);
 	copy_offset = hlen;
 
 	for (i = payload_iov; i < payload_nfrags + payload_iov; i++) {
@@ -445,6 +462,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
 		skb_copy_bits(skb, copy_offset,
 			      tx->tx_fifo.base + info->iov[i].iov_offset,
 			      info->iov[i].iov_len);
+		gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
+					info->iov[i].iov_offset,
+					info->iov[i].iov_len);
 		copy_offset += info->iov[i].iov_len;
 	}
 
@@ -473,7 +493,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
 		return NETDEV_TX_BUSY;
 	}
-	nsegs = gve_tx_add_skb(tx, skb);
+	nsegs = gve_tx_add_skb(tx, skb, &priv->pdev->dev);
 
 	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
 	skb_tx_timestamp(skb);
-- 
2.20.1



