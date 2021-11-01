Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8531A4417EA
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhKAJln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233417AbhKAJjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF90A60C4B;
        Mon,  1 Nov 2021 09:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758835;
        bh=DKMxY+pOUw9cIc0L4Z0dcz+lKWbz5kA8gNQc06e8AE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvmKEdWdFmxej5/4yp6BmkTH5lrq+hZ9pliIMT1fQX9W/l0yRLZ8LfC5YJX1ohJgs
         JlJG7Ke7+dJZrsbbPXAXEh+TXak7DsSdamOHBskgryfzBTB56W+HhqwaLlQC3nAyC+
         dIoLOy+VEX/5wIpqHAaAUxwvRPneOUiRHNw+4lkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Denisov <rtgbnm@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 71/77] lan743x: fix endianness when accessing descriptors
Date:   Mon,  1 Nov 2021 10:17:59 +0100
Message-Id: <20211101082526.417805427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Denisov <rtgbnm@gmail.com>

[ Upstream commit 462512824f902a24de794290dd622e664587da1d ]

TX/RX descriptor ring fields are always little-endian, but conversion
wasn't performed for big-endian CPUs, so the driver failed to work.

This patch makes the driver work on big-endian CPUs. It was tested and
confirmed to work on NXP P1010 processor (PowerPC).

Signed-off-by: Alexey Denisov <rtgbnm@gmail.com>
Link: https://lore.kernel.org/r/20210128044859.280219-1-rtgbnm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 66 +++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h | 20 +++---
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 3355e0a5b272..e14dfaafe439 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1280,7 +1280,7 @@ static void lan743x_tx_release_desc(struct lan743x_tx *tx,
 	if (!(buffer_info->flags & TX_BUFFER_INFO_FLAG_ACTIVE))
 		goto done;
 
-	descriptor_type = (descriptor->data0) &
+	descriptor_type = le32_to_cpu(descriptor->data0) &
 			  TX_DESC_DATA0_DTYPE_MASK_;
 	if (descriptor_type == TX_DESC_DATA0_DTYPE_DATA_)
 		goto clean_up_data_descriptor;
@@ -1340,7 +1340,7 @@ static int lan743x_tx_next_index(struct lan743x_tx *tx, int index)
 
 static void lan743x_tx_release_completed_descriptors(struct lan743x_tx *tx)
 {
-	while ((*tx->head_cpu_ptr) != (tx->last_head)) {
+	while (le32_to_cpu(*tx->head_cpu_ptr) != (tx->last_head)) {
 		lan743x_tx_release_desc(tx, tx->last_head, false);
 		tx->last_head = lan743x_tx_next_index(tx, tx->last_head);
 	}
@@ -1426,10 +1426,10 @@ static int lan743x_tx_frame_start(struct lan743x_tx *tx,
 	if (dma_mapping_error(dev, dma_ptr))
 		return -ENOMEM;
 
-	tx_descriptor->data1 = DMA_ADDR_LOW32(dma_ptr);
-	tx_descriptor->data2 = DMA_ADDR_HIGH32(dma_ptr);
-	tx_descriptor->data3 = (frame_length << 16) &
-		TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_;
+	tx_descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(dma_ptr));
+	tx_descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(dma_ptr));
+	tx_descriptor->data3 = cpu_to_le32((frame_length << 16) &
+		TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_);
 
 	buffer_info->skb = NULL;
 	buffer_info->dma_ptr = dma_ptr;
@@ -1470,7 +1470,7 @@ static void lan743x_tx_frame_add_lso(struct lan743x_tx *tx,
 		tx->frame_data0 |= TX_DESC_DATA0_IOC_;
 	}
 	tx_descriptor = &tx->ring_cpu_ptr[tx->frame_tail];
-	tx_descriptor->data0 = tx->frame_data0;
+	tx_descriptor->data0 = cpu_to_le32(tx->frame_data0);
 
 	/* move to next descriptor */
 	tx->frame_tail = lan743x_tx_next_index(tx, tx->frame_tail);
@@ -1514,7 +1514,7 @@ static int lan743x_tx_frame_add_fragment(struct lan743x_tx *tx,
 
 	/* wrap up previous descriptor */
 	tx_descriptor = &tx->ring_cpu_ptr[tx->frame_tail];
-	tx_descriptor->data0 = tx->frame_data0;
+	tx_descriptor->data0 = cpu_to_le32(tx->frame_data0);
 
 	/* move to next descriptor */
 	tx->frame_tail = lan743x_tx_next_index(tx, tx->frame_tail);
@@ -1540,10 +1540,10 @@ static int lan743x_tx_frame_add_fragment(struct lan743x_tx *tx,
 		return -ENOMEM;
 	}
 
-	tx_descriptor->data1 = DMA_ADDR_LOW32(dma_ptr);
-	tx_descriptor->data2 = DMA_ADDR_HIGH32(dma_ptr);
-	tx_descriptor->data3 = (frame_length << 16) &
-			       TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_;
+	tx_descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(dma_ptr));
+	tx_descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(dma_ptr));
+	tx_descriptor->data3 = cpu_to_le32((frame_length << 16) &
+			       TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_);
 
 	buffer_info->skb = NULL;
 	buffer_info->dma_ptr = dma_ptr;
@@ -1587,7 +1587,7 @@ static void lan743x_tx_frame_end(struct lan743x_tx *tx,
 	if (ignore_sync)
 		buffer_info->flags |= TX_BUFFER_INFO_FLAG_IGNORE_SYNC;
 
-	tx_descriptor->data0 = tx->frame_data0;
+	tx_descriptor->data0 = cpu_to_le32(tx->frame_data0);
 	tx->frame_tail = lan743x_tx_next_index(tx, tx->frame_tail);
 	tx->last_tail = tx->frame_tail;
 
@@ -2004,11 +2004,11 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 	}
 
 	buffer_info->buffer_length = length;
-	descriptor->data1 = DMA_ADDR_LOW32(buffer_info->dma_ptr);
-	descriptor->data2 = DMA_ADDR_HIGH32(buffer_info->dma_ptr);
+	descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(buffer_info->dma_ptr));
+	descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(buffer_info->dma_ptr));
 	descriptor->data3 = 0;
-	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
-			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_));
+	descriptor->data0 = cpu_to_le32((RX_DESC_DATA0_OWN_ |
+			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_)));
 	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
 	lan743x_rx_update_tail(rx, index);
 
@@ -2023,12 +2023,12 @@ static void lan743x_rx_reuse_ring_element(struct lan743x_rx *rx, int index)
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
 
-	descriptor->data1 = DMA_ADDR_LOW32(buffer_info->dma_ptr);
-	descriptor->data2 = DMA_ADDR_HIGH32(buffer_info->dma_ptr);
+	descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(buffer_info->dma_ptr));
+	descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(buffer_info->dma_ptr));
 	descriptor->data3 = 0;
-	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
+	descriptor->data0 = cpu_to_le32((RX_DESC_DATA0_OWN_ |
 			    ((buffer_info->buffer_length) &
-			    RX_DESC_DATA0_BUF_LENGTH_MASK_));
+			    RX_DESC_DATA0_BUF_LENGTH_MASK_)));
 	lan743x_rx_update_tail(rx, index);
 }
 
@@ -2062,7 +2062,7 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 {
 	struct skb_shared_hwtstamps *hwtstamps = NULL;
 	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
-	int current_head_index = *rx->head_cpu_ptr;
+	int current_head_index = le32_to_cpu(*rx->head_cpu_ptr);
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
 	int extension_index = -1;
@@ -2077,14 +2077,14 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 
 	if (rx->last_head != current_head_index) {
 		descriptor = &rx->ring_cpu_ptr[rx->last_head];
-		if (descriptor->data0 & RX_DESC_DATA0_OWN_)
+		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
 			goto done;
 
-		if (!(descriptor->data0 & RX_DESC_DATA0_FS_))
+		if (!(le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_))
 			goto done;
 
 		first_index = rx->last_head;
-		if (descriptor->data0 & RX_DESC_DATA0_LS_) {
+		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
 			last_index = rx->last_head;
 		} else {
 			int index;
@@ -2092,10 +2092,10 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			index = lan743x_rx_next_index(rx, first_index);
 			while (index != current_head_index) {
 				descriptor = &rx->ring_cpu_ptr[index];
-				if (descriptor->data0 & RX_DESC_DATA0_OWN_)
+				if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
 					goto done;
 
-				if (descriptor->data0 & RX_DESC_DATA0_LS_) {
+				if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
 					last_index = index;
 					break;
 				}
@@ -2104,17 +2104,17 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 		}
 		if (last_index >= 0) {
 			descriptor = &rx->ring_cpu_ptr[last_index];
-			if (descriptor->data0 & RX_DESC_DATA0_EXT_) {
+			if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT_) {
 				/* extension is expected to follow */
 				int index = lan743x_rx_next_index(rx,
 								  last_index);
 				if (index != current_head_index) {
 					descriptor = &rx->ring_cpu_ptr[index];
-					if (descriptor->data0 &
+					if (le32_to_cpu(descriptor->data0) &
 					    RX_DESC_DATA0_OWN_) {
 						goto done;
 					}
-					if (descriptor->data0 &
+					if (le32_to_cpu(descriptor->data0) &
 					    RX_DESC_DATA0_EXT_) {
 						extension_index = index;
 					} else {
@@ -2166,7 +2166,7 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			}
 			buffer_info->skb = NULL;
 			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
-					(descriptor->data0);
+					(le32_to_cpu(descriptor->data0));
 			skb_put(skb, packet_length - 4);
 			skb->protocol = eth_type_trans(skb,
 						       rx->adapter->netdev);
@@ -2204,8 +2204,8 @@ process_extension:
 			descriptor = &rx->ring_cpu_ptr[extension_index];
 			buffer_info = &rx->buffer_info[extension_index];
 
-			ts_sec = descriptor->data1;
-			ts_nsec = (descriptor->data2 &
+			ts_sec = le32_to_cpu(descriptor->data1);
+			ts_nsec = (le32_to_cpu(descriptor->data2) &
 				  RX_DESC_DATA2_TS_NS_MASK_);
 			lan743x_rx_reuse_ring_element(rx, extension_index);
 			real_last_index = extension_index;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index a536f4a4994d..751f2bc9ce84 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -660,7 +660,7 @@ struct lan743x_tx {
 
 	struct lan743x_tx_buffer_info *buffer_info;
 
-	u32		*head_cpu_ptr;
+	__le32		*head_cpu_ptr;
 	dma_addr_t	head_dma_ptr;
 	int		last_head;
 	int		last_tail;
@@ -690,7 +690,7 @@ struct lan743x_rx {
 
 	struct lan743x_rx_buffer_info *buffer_info;
 
-	u32		*head_cpu_ptr;
+	__le32		*head_cpu_ptr;
 	dma_addr_t	head_dma_ptr;
 	u32		last_head;
 	u32		last_tail;
@@ -775,10 +775,10 @@ struct lan743x_adapter {
 #define TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_	(0x3FFF0000)
 
 struct lan743x_tx_descriptor {
-	u32     data0;
-	u32     data1;
-	u32     data2;
-	u32     data3;
+	__le32     data0;
+	__le32     data1;
+	__le32     data2;
+	__le32     data3;
 } __aligned(DEFAULT_DMA_DESCRIPTOR_SPACING);
 
 #define TX_BUFFER_INFO_FLAG_ACTIVE		BIT(0)
@@ -813,10 +813,10 @@ struct lan743x_tx_buffer_info {
 #define RX_HEAD_PADDING		NET_IP_ALIGN
 
 struct lan743x_rx_descriptor {
-	u32     data0;
-	u32     data1;
-	u32     data2;
-	u32     data3;
+	__le32     data0;
+	__le32     data1;
+	__le32     data2;
+	__le32     data3;
 } __aligned(DEFAULT_DMA_DESCRIPTOR_SPACING);
 
 #define RX_BUFFER_INFO_FLAG_ACTIVE      BIT(0)
-- 
2.33.0



