Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9173844189E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhKAJti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhKAJrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5BD6140A;
        Mon,  1 Nov 2021 09:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759043;
        bh=ODKWOjMO3/2OwXh7SeUSEoDQ7wL65y486lmsntO7kcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WclD6BI2JYTuGdZdTHYW5AhgGZunssyI2YxwxEzlZPddRGcK2t9FaHfe5xhnsWWX2
         i4cIg+Fj2SNcmSNqBxVFxNEXQSk1DNzorFYOFuDGfzSPdR4xYmhXE/3MzLtSH1SNt1
         k5THlC/HbKoFE1iEdrQ1enpG6QnCzTT7Ne6Ugn7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 090/125] net: ethernet: microchip: lan743x: Fix skb allocation failure
Date:   Mon,  1 Nov 2021 10:17:43 +0100
Message-Id: <20211101082550.147475732@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

commit e8684db191e4164f3f5f3ad7dec04a6734c25f1c upstream.

The driver allocates skb during ndo_open with GFP_ATOMIC which has high chance of failure when there are multiple instances.
GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt context.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1944,7 +1944,8 @@ static void lan743x_rx_update_tail(struc
 				  index);
 }
 
-static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
+static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
+					gfp_t gfp)
 {
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
@@ -1958,7 +1959,7 @@ static int lan743x_rx_init_ring_element(
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	skb = __netdev_alloc_skb(netdev, buffer_length, GFP_ATOMIC | GFP_DMA);
+	skb = __netdev_alloc_skb(netdev, buffer_length, gfp);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, buffer_length, DMA_FROM_DEVICE);
@@ -2120,7 +2121,8 @@ static int lan743x_rx_process_buffer(str
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head,
+					 GFP_ATOMIC | GFP_DMA)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2335,13 +2337,16 @@ static int lan743x_rx_ring_init(struct l
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index);
+		ret = lan743x_rx_init_ring_element(rx, index, GFP_KERNEL);
 		if (ret)
 			goto cleanup;
 	}
 	return 0;
 
 cleanup:
+	netif_warn(rx->adapter, ifup, rx->adapter->netdev,
+		   "Error allocating memory for LAN743x\n");
+
 	lan743x_rx_ring_cleanup(rx);
 	return ret;
 }


