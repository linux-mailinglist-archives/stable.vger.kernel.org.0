Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4344F31A9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbiDEIgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbiDEITd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ADC75C12;
        Tue,  5 Apr 2022 01:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08B2EB81A32;
        Tue,  5 Apr 2022 08:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B3FC385A0;
        Tue,  5 Apr 2022 08:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146190;
        bh=/AS13XfuaTsFOWDXBRJbBDUfvHmVSfY8gACGMKNwWq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2whj19hc9S6O0hcm+vajMToJGrOO1r9ygrbM075XNZb4crLMU6oWmOmSFaxkktN1U
         +mkFezlR56kP9s55+ChsJYcbdHWetRPXGG7TreABV8BR7UpZev+V656z7HUuVUaNCt
         36EbNE4vmeTuYLkfmft2AVZ4O+YlNUQcrytR+rVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0636/1126] net: axienet: fix RX ring refill allocation failure handling
Date:   Tue,  5 Apr 2022 09:23:03 +0200
Message-Id: <20220405070426.305243557@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 7a7d340ba4d9351e4c8847b898a2b996727a922a ]

If a memory allocation error occurred during an attempt to refill a slot
in the RX ring after the packet was received, the hardware tail pointer
would still have been updated to point to or past the slot which remained
marked as previously completed. This would likely result in the DMA engine
raising an error when it eventually tried to use that slot again.

If a slot cannot be refilled, then just stop processing and do not move
the tail pointer past it. On the next attempt, we should skip receiving
the packet from the empty slot and just try to refill it again.

This failure mode has not actually been observed, but was found as part
of other driver updates.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 72 +++++++++++--------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 377c94ec2486..90d96eb79984 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -857,46 +857,53 @@ static void axienet_recv(struct net_device *ndev)
 	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
 		dma_addr_t phys;
 
-		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-
 		/* Ensure we see complete descriptor update */
 		dma_rmb();
-		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
-				 DMA_FROM_DEVICE);
 
 		skb = cur_p->skb;
 		cur_p->skb = NULL;
-		length = cur_p->app4 & 0x0000FFFF;
-
-		skb_put(skb, length);
-		skb->protocol = eth_type_trans(skb, ndev);
-		/*skb_checksum_none_assert(skb);*/
-		skb->ip_summed = CHECKSUM_NONE;
-
-		/* if we're doing Rx csum offload, set it up */
-		if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
-			csumstatus = (cur_p->app2 &
-				      XAE_FULL_CSUM_STATUS_MASK) >> 3;
-			if ((csumstatus == XAE_IP_TCP_CSUM_VALIDATED) ||
-			    (csumstatus == XAE_IP_UDP_CSUM_VALIDATED)) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* skb could be NULL if a previous pass already received the
+		 * packet for this slot in the ring, but failed to refill it
+		 * with a newly allocated buffer. In this case, don't try to
+		 * receive it again.
+		 */
+		if (likely(skb)) {
+			length = cur_p->app4 & 0x0000FFFF;
+
+			phys = desc_get_phys_addr(lp, cur_p);
+			dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
+					 DMA_FROM_DEVICE);
+
+			skb_put(skb, length);
+			skb->protocol = eth_type_trans(skb, ndev);
+			/*skb_checksum_none_assert(skb);*/
+			skb->ip_summed = CHECKSUM_NONE;
+
+			/* if we're doing Rx csum offload, set it up */
+			if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
+				csumstatus = (cur_p->app2 &
+					      XAE_FULL_CSUM_STATUS_MASK) >> 3;
+				if (csumstatus == XAE_IP_TCP_CSUM_VALIDATED ||
+				    csumstatus == XAE_IP_UDP_CSUM_VALIDATED) {
+					skb->ip_summed = CHECKSUM_UNNECESSARY;
+				}
+			} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
+				   skb->protocol == htons(ETH_P_IP) &&
+				   skb->len > 64) {
+				skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
+				skb->ip_summed = CHECKSUM_COMPLETE;
 			}
-		} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
-			   skb->protocol == htons(ETH_P_IP) &&
-			   skb->len > 64) {
-			skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
-			skb->ip_summed = CHECKSUM_COMPLETE;
-		}
 
-		netif_rx(skb);
+			netif_rx(skb);
 
-		size += length;
-		packets++;
+			size += length;
+			packets++;
+		}
 
 		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
 		if (!new_skb)
-			return;
+			break;
 
 		phys = dma_map_single(ndev->dev.parent, new_skb->data,
 				      lp->max_frm_size,
@@ -905,7 +912,7 @@ static void axienet_recv(struct net_device *ndev)
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
-			return;
+			break;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
 
@@ -913,6 +920,11 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p->status = 0;
 		cur_p->skb = new_skb;
 
+		/* Only update tail_p to mark this slot as usable after it has
+		 * been successfully refilled.
+		 */
+		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
+
 		if (++lp->rx_bd_ci >= lp->rx_bd_num)
 			lp->rx_bd_ci = 0;
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-- 
2.34.1



