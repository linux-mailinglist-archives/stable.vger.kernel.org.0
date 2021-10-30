Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C59F4408FA
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhJ3NL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhJ3NL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5281D60E9C;
        Sat, 30 Oct 2021 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599337;
        bh=+UolVYm4KgMsfYjulAZpdsrW+KUO57hbGqtBwVYEXVE=;
        h=Subject:To:Cc:From:Date:From;
        b=MTdXaR4rXBUTfLp0JEprwNQ56HdTaaZzeuR9xi71JZYYrkYRWVcCceGHaWGHFgrMr
         qLjeZ3Zg6FgvDCdynMN1AyVDcW/QmHHaIB4K9zPvXuAdfoyLbTefPDxQCLXgIBT6gq
         0J7XlT4YQ5uqVudMEcEvULC83nwl0fEZpETdk+h0=
Subject: FAILED: patch "[PATCH] net: ethernet: microchip: lan743x: Fix skb allocation failure" failed to apply to 5.4-stable tree
To:     yuiko.oshino@microchip.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:08:45 +0200
Message-ID: <1635599325121126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e8684db191e4164f3f5f3ad7dec04a6734c25f1c Mon Sep 17 00:00:00 2001
From: Yuiko Oshino <yuiko.oshino@microchip.com>
Date: Wed, 27 Oct 2021 14:23:02 -0400
Subject: [PATCH] net: ethernet: microchip: lan743x: Fix skb allocation failure

The driver allocates skb during ndo_open with GFP_ATOMIC which has high chance of failure when there are multiple instances.
GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt context.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index c4f32c7e0db1..4d5a5d6595b3 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1944,7 +1944,8 @@ static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 				  index);
 }
 
-static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
+static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
+					gfp_t gfp)
 {
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
@@ -1958,7 +1959,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	skb = __netdev_alloc_skb(netdev, buffer_length, GFP_ATOMIC | GFP_DMA);
+	skb = __netdev_alloc_skb(netdev, buffer_length, gfp);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, buffer_length, DMA_FROM_DEVICE);
@@ -2120,7 +2121,8 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head,
+					 GFP_ATOMIC | GFP_DMA)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2335,13 +2337,16 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
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

