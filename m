Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDD94454E2
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhKDOSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhKDORt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B925A611EF;
        Thu,  4 Nov 2021 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035311;
        bh=aJwTCCsV8Trl17W6V1f2HGrRqnHcLj2QEYuk5S0JB30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9OM43WMFnRAFghVhojgTcui0h/6SCjSR3tuiIbB/0Tb2vCJYxKCNWI77ccnSWgLN
         VPjyURwQkSbiNFZVPLIRBeoSpInPCpOAdnlekty5bzxOTU1NZF5jTLlZ+cqw6QS2f/
         Igp/eP6xSi3aAglS8x96AGTrtAPY/uXRvB+EF9H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 05/16] net: ethernet: microchip: lan743x: Fix skb allocation failure
Date:   Thu,  4 Nov 2021 15:12:44 +0100
Message-Id: <20211104141159.748367268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
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
 drivers/net/ethernet/microchip/lan743x_main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1963,13 +1963,13 @@ static int lan743x_rx_next_index(struct
 	return ((++index) % rx->ring_size);
 }
 
-static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
+static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx, gfp_t gfp)
 {
 	int length = 0;
 
 	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
 	return __netdev_alloc_skb(rx->adapter->netdev,
-				  length, GFP_ATOMIC | GFP_DMA);
+				  length, gfp);
 }
 
 static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
@@ -2141,7 +2141,8 @@ static int lan743x_rx_process_packet(str
 			struct sk_buff *new_skb = NULL;
 			int packet_length;
 
-			new_skb = lan743x_rx_allocate_skb(rx);
+			new_skb = lan743x_rx_allocate_skb(rx,
+							  GFP_ATOMIC | GFP_DMA);
 			if (!new_skb) {
 				/* failed to allocate next skb.
 				 * Memory is very low.
@@ -2377,7 +2378,8 @@ static int lan743x_rx_ring_init(struct l
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		struct sk_buff *new_skb = lan743x_rx_allocate_skb(rx);
+		struct sk_buff *new_skb = lan743x_rx_allocate_skb(rx,
+								   GFP_KERNEL);
 
 		ret = lan743x_rx_init_ring_element(rx, index, new_skb);
 		if (ret)


