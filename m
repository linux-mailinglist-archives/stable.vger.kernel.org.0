Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265042C9C0C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390328AbgLAJOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390324AbgLAJOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C422067D;
        Tue,  1 Dec 2020 09:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814034;
        bh=U/540WdSDlNdB8MiXa9CwxDnUNaX8dDBtbRSQEu7pXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PMCbX1KLBF5rjtWDTJutXaOa6BJz/t6TeKRRd3/Df0CpSeXRZo3wGoQn+R5PwBxP
         uVutPWrk5hXr2pBEH8KFSl55ii4g37rB0NDZ4upNfwfKFvC6IOSvCErbSntRzJY9SD
         NFra4x/S1gk1VJ06QXZhzrkySKwy/NYN8zteAycM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 113/152] net: ena: fix packets addresses for rx_offset feature
Date:   Tue,  1 Dec 2020 09:53:48 +0100
Message-Id: <20201201084726.657345190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit 1396d3148bd250db880573f9ed0abe5d6fba1fce ]

This patch fixes two lines in which the rx_offset received by the device
wasn't taken into account:

- prefetch function:
	In our driver the copied data would reside in
	rx_info->page + rx_headroom + rx_offset

	so the prefetch function is changed accordingly.

- setting page_offset to zero for descriptors > 1:
	for every descriptor but the first, the rx_offset is zero. Hence
	the page_offset value should be set to rx_headroom.

	The previous implementation changed the value of rx_info after
	the descriptor was added to the SKB (essentially providing wrong
	page offset).

Fixes: 68f236df93a9 ("net: ena: add support for the rx offset feature")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 1c978c7987adc..36134fc3e9197 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -920,10 +920,14 @@ static void ena_free_all_io_rx_resources(struct ena_adapter *adapter)
 static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 				    struct ena_rx_buffer *rx_info, gfp_t gfp)
 {
+	int headroom = rx_ring->rx_headroom;
 	struct ena_com_buf *ena_buf;
 	struct page *page;
 	dma_addr_t dma;
 
+	/* restore page offset value in case it has been changed by device */
+	rx_info->page_offset = headroom;
+
 	/* if previous allocated page is not used */
 	if (unlikely(rx_info->page))
 		return 0;
@@ -953,10 +957,9 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 		  "alloc page %p, rx_info %p\n", page, rx_info);
 
 	rx_info->page = page;
-	rx_info->page_offset = 0;
 	ena_buf = &rx_info->ena_buf;
-	ena_buf->paddr = dma + rx_ring->rx_headroom;
-	ena_buf->len = ENA_PAGE_SIZE - rx_ring->rx_headroom;
+	ena_buf->paddr = dma + headroom;
+	ena_buf->len = ENA_PAGE_SIZE - headroom;
 
 	return 0;
 }
@@ -1368,7 +1371,8 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 	/* save virt address of first buffer */
 	va = page_address(rx_info->page) + rx_info->page_offset;
-	prefetch(va + NET_IP_ALIGN);
+
+	prefetch(va);
 
 	if (len <= rx_ring->rx_copybreak) {
 		skb = ena_alloc_skb(rx_ring, false);
@@ -1409,8 +1413,6 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_info->page,
 				rx_info->page_offset, len, ENA_PAGE_SIZE);
-		/* The offset is non zero only for the first buffer */
-		rx_info->page_offset = 0;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "rx skb updated. len %d. data_len %d\n",
@@ -1529,8 +1531,7 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	int ret;
 
 	rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-	xdp->data = page_address(rx_info->page) +
-		rx_info->page_offset + rx_ring->rx_headroom;
+	xdp->data = page_address(rx_info->page) + rx_info->page_offset;
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_hard_start = page_address(rx_info->page);
 	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
@@ -1597,8 +1598,9 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		if (unlikely(ena_rx_ctx.descs == 0))
 			break;
 
+		/* First descriptor might have an offset set by the device */
 		rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-		rx_info->page_offset = ena_rx_ctx.pkt_offset;
+		rx_info->page_offset += ena_rx_ctx.pkt_offset;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "rx_poll: q %d got packet from ena. descs #: %d l3 proto %d l4 proto %d hash: %x\n",
-- 
2.27.0



