Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4850E497FF3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242441AbiAXMtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242682AbiAXMtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:49:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88D9C06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80948B80F9B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B956C340E7;
        Mon, 24 Jan 2022 12:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643028569;
        bh=J3p8BAdM6/LHha5giYUOs1DsZC9YMvvcBBuYbBj+GUE=;
        h=Subject:To:Cc:From:Date:From;
        b=zWDNcOf9L7KBm5FH6e6yrDY6bgcsDu/0VVfdmAJHKXPF/bbDKz4ggohMjHIyhklLI
         JOiwie/BpSeCAj6Fotjv93VWPaVAMTneXMgPlIeUbFpPIIK9+raWn490NMMbvvjVHa
         fOmJJysS0nLGT9anmyiw5sZ37sXAcUJhOakBDdc8=
Subject: FAILED: patch "[PATCH] net: axienet: fix for TX busy handling" failed to apply to 5.4-stable tree
To:     robert.hancock@calian.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:49:11 +0100
Message-ID: <164302855120420@kroah.com>
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

From bb193e3db8b86a63f26889c99e14fd30c9ebd72a Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 18 Jan 2022 15:41:31 -0600
Subject: [PATCH] net: axienet: fix for TX busy handling

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

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8dc9e92e05d2..b4f42ee9b75d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -660,6 +660,32 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 	return i;
 }
 
+/**
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
 /**
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
@@ -689,33 +715,8 @@ static void axienet_start_xmit_done(struct net_device *ndev)
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
@@ -748,19 +749,14 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
@@ -821,6 +817,18 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
 

