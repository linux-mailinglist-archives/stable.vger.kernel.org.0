Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A3499DA5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585914AbiAXWZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584523AbiAXWVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F12DC0424C9;
        Mon, 24 Jan 2022 12:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A2CB80FA1;
        Mon, 24 Jan 2022 20:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D11C340E5;
        Mon, 24 Jan 2022 20:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057391;
        bh=br/iQTyRsURcetzVqnQpSl1GiGq29hfg10350Q/e9Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D35QV/GT57oa5jGhfItNSeAitLj//R3L2ltxbXXmE2+E4mQxm67h5UZhWKycc9NEZ
         V+liwIBCPdxOAB7zc4KgEAkvMkW7TVjrElT0MvG/BeD+hNxFMevV71r7p5V+AC+Qhe
         +GJbgWnR7+kxGvePaMgfgAWxCirQk4wlmYFT98sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 798/846] net: axienet: fix for TX busy handling
Date:   Mon, 24 Jan 2022 19:45:15 +0100
Message-Id: <20220124184128.477699424@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit bb193e3db8b86a63f26889c99e14fd30c9ebd72a upstream.

Network driver documentation indicates we should be avoiding returning
NETDEV_TX_BUSY from ndo_start_xmit in normal cases, since it requires
the packets to be requeued. Instead the queue should be stopped after
a packet is added to the TX ring when there may not be enough room for an
additional one. Also, when TX ring entries are completed, we should only
wake the queue if we know there is room for another full maximally
fragmented packet.

Print a warning if there is insufficient space at the start of start_xmit,
since this should no longer happen.

Combined with increasing the default TX ring size (in a subsequent
patch), this appears to recover the TX performance lost by previous changes
to actually manage the TX ring state properly.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   86 ++++++++++++----------
 1 file changed, 47 insertions(+), 39 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -661,6 +661,32 @@ static int axienet_free_tx_chain(struct
 }
 
 /**
+ * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
+ * @lp:		Pointer to the axienet_local structure
+ * @num_frag:	The number of BDs to check for
+ *
+ * Return: 0, on success
+ *	    NETDEV_TX_BUSY, if any of the descriptors are not free
+ *
+ * This function is invoked before BDs are allocated and transmission starts.
+ * This function returns 0 if a BD or group of BDs can be allocated for
+ * transmission. If the BD or any of the BDs are not free the function
+ * returns a busy status. This is invoked from axienet_start_xmit.
+ */
+static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
+					    int num_frag)
+{
+	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
+	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
+	if (cur_p->cntrl)
+		return NETDEV_TX_BUSY;
+	return 0;
+}
+
+/**
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
  * @ndev:	Pointer to the net_device structure
@@ -689,33 +715,8 @@ static void axienet_start_xmit_done(stru
 	/* Matches barrier in axienet_start_xmit */
 	smp_mb();
 
-	netif_wake_queue(ndev);
-}
-
-/**
- * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
- * @lp:		Pointer to the axienet_local structure
- * @num_frag:	The number of BDs to check for
- *
- * Return: 0, on success
- *	    NETDEV_TX_BUSY, if any of the descriptors are not free
- *
- * This function is invoked before BDs are allocated and transmission starts.
- * This function returns 0 if a BD or group of BDs can be allocated for
- * transmission. If the BD or any of the BDs are not free the function
- * returns a busy status. This is invoked from axienet_start_xmit.
- */
-static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
-					    int num_frag)
-{
-	struct axidma_bd *cur_p;
-
-	/* Ensure we see all descriptor updates from device or TX IRQ path */
-	rmb();
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->cntrl)
-		return NETDEV_TX_BUSY;
-	return 0;
+	if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+		netif_wake_queue(ndev);
 }
 
 /**
@@ -748,19 +749,14 @@ axienet_start_xmit(struct sk_buff *skb,
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
-		if (netif_queue_stopped(ndev))
-			return NETDEV_TX_BUSY;
-
+		/* Should not happen as last start_xmit call should have
+		 * checked for sufficient space and queue should only be
+		 * woken when sufficient space is available.
+		 */
 		netif_stop_queue(ndev);
-
-		/* Matches barrier in axienet_start_xmit_done */
-		smp_mb();
-
-		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag + 1))
-			return NETDEV_TX_BUSY;
-
-		netif_wake_queue(ndev);
+		if (net_ratelimit())
+			netdev_warn(ndev, "TX ring unexpectedly full\n");
+		return NETDEV_TX_BUSY;
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -821,6 +817,18 @@ axienet_start_xmit(struct sk_buff *skb,
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
 
+	/* Stop queue if next transmit may not have space */
+	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in axienet_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 }
 


