Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FADD2E404C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437931AbgL1OVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502508AbgL1OVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FA3E20731;
        Mon, 28 Dec 2020 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165239;
        bh=Zj+Zd86GV95pGjDAemC8MKnFyKsb4rqcwYgrClBk42E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/mNncMC/z2hS1kySSjz/bFbLzNJZCsXpfcvdE3fZJlFxUnWNfbN6fqatfT+bHF1L
         OrybbGDpB3qcxQkjJTB7y6m8VwIz8RVb8oBXEc14gxqGJ4MdG87v9VjCfuFsYeGycd
         znpn5s9RG+P6A/Z4WBnivTx/7Z58gxpUOiYC40m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <thesven73@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 461/717] lan743x: fix rx_napi_poll/interrupt ping-pong
Date:   Mon, 28 Dec 2020 13:47:39 +0100
Message-Id: <20201228125043.056134880@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 57030a0b620f735bf557696e5ceb9f32c2b3bb8f ]

Even if there is more rx data waiting on the chip, the rx napi poll fn
will never run more than once - it will always read a few buffers, then
bail out and re-arm interrupts. Which results in ping-pong between napi
and interrupt.

This defeats the purpose of napi, and is bad for performance.

Fix by making the rx napi poll behave identically to other ethernet
drivers:
1. initialize rx napi polling with an arbitrary budget (64).
2. in the polling fn, return full weight if rx queue is not depleted,
   this tells the napi core to "keep polling".
3. update the rx tail ("ring the doorbell") once for every 8 processed
   rx ring buffers.

Thanks to Jakub Kicinski, Eric Dumazet and Andrew Lunn for their expert
opinions and suggestions.

Tested with 20 seconds of full bandwidth receive (iperf3):
        rx irqs      softirqs(NET_RX)
        -----------------------------
before  23827        33620
after   129          4081

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Link: https://lore.kernel.org/r/20201215161954.5950-1-TheSven73@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 43 ++++++++++---------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index b319c22c211cd..8947c3a628109 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1962,6 +1962,14 @@ static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
 				  length, GFP_ATOMIC | GFP_DMA);
 }
 
+static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
+{
+	/* update the tail once per 8 descriptors */
+	if ((index & 7) == 7)
+		lan743x_csr_write(rx->adapter, RX_TAIL(rx->channel_number),
+				  index);
+}
+
 static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 					struct sk_buff *skb)
 {
@@ -1992,6 +2000,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
 			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_));
 	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
+	lan743x_rx_update_tail(rx, index);
 
 	return 0;
 }
@@ -2010,6 +2019,7 @@ static void lan743x_rx_reuse_ring_element(struct lan743x_rx *rx, int index)
 	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
 			    ((buffer_info->buffer_length) &
 			    RX_DESC_DATA0_BUF_LENGTH_MASK_));
+	lan743x_rx_update_tail(rx, index);
 }
 
 static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
@@ -2220,6 +2230,7 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 {
 	struct lan743x_rx *rx = container_of(napi, struct lan743x_rx, napi);
 	struct lan743x_adapter *adapter = rx->adapter;
+	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
 	u32 rx_tail_flags = 0;
 	int count;
 
@@ -2228,27 +2239,19 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 		lan743x_csr_write(adapter, DMAC_INT_STS,
 				  DMAC_INT_BIT_RXFRM_(rx->channel_number));
 	}
-	count = 0;
-	while (count < weight) {
-		int rx_process_result = lan743x_rx_process_packet(rx);
-
-		if (rx_process_result == RX_PROCESS_RESULT_PACKET_RECEIVED) {
-			count++;
-		} else if (rx_process_result ==
-			RX_PROCESS_RESULT_NOTHING_TO_DO) {
+	for (count = 0; count < weight; count++) {
+		result = lan743x_rx_process_packet(rx);
+		if (result == RX_PROCESS_RESULT_NOTHING_TO_DO)
 			break;
-		} else if (rx_process_result ==
-			RX_PROCESS_RESULT_PACKET_DROPPED) {
-			continue;
-		}
 	}
 	rx->frame_count += count;
-	if (count == weight)
-		goto done;
+	if (count == weight || result == RX_PROCESS_RESULT_PACKET_RECEIVED)
+		return weight;
 
 	if (!napi_complete_done(napi, count))
-		goto done;
+		return count;
 
+	/* re-arm interrupts, must write to rx tail on some chip variants */
 	if (rx->vector_flags & LAN743X_VECTOR_FLAG_VECTOR_ENABLE_AUTO_SET)
 		rx_tail_flags |= RX_TAIL_SET_TOP_INT_VEC_EN_;
 	if (rx->vector_flags & LAN743X_VECTOR_FLAG_SOURCE_ENABLE_AUTO_SET) {
@@ -2258,10 +2261,10 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 				  INT_BIT_DMA_RX_(rx->channel_number));
 	}
 
-	/* update RX_TAIL */
-	lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
-			  rx_tail_flags | rx->last_tail);
-done:
+	if (rx_tail_flags)
+		lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
+				  rx_tail_flags | rx->last_tail);
+
 	return count;
 }
 
@@ -2405,7 +2408,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
 
 	netif_napi_add(adapter->netdev,
 		       &rx->napi, lan743x_rx_napi_poll,
-		       rx->ring_size - 1);
+		       NAPI_POLL_WEIGHT);
 
 	lan743x_csr_write(adapter, DMAC_CMD,
 			  DMAC_CMD_RX_SWR_(rx->channel_number));
-- 
2.27.0



