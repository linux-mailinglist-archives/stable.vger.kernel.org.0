Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D14D1B6806
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgDWXLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:11:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50210 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728549AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvb-0004lh-3j; Fri, 24 Apr 2020 00:06:43 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvY-00E6yS-Bp; Fri, 24 Apr 2020 00:06:40 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Finn Thain" <fthain@telegraphics.com.au>,
        "Stan Johnson" <userm57@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:07:10 +0100
Message-ID: <lsq.1587683028.72974195@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 203/245] net/sonic: Add mutual exclusion for
 accessing shared state
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

commit 865ad2f2201dc18685ba2686f13217f8b3a9c52c upstream.

The netif_stop_queue() call in sonic_send_packet() races with the
netif_wake_queue() call in sonic_interrupt(). This causes issues
like "NETDEV WATCHDOG: eth0 (macsonic): transmit queue 0 timed out".
Fix this by disabling interrupts when accessing tx_skb[] and next_tx.
Update a comment to clarify the synchronization properties.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/natsemi/sonic.c | 49 ++++++++++++++++++++--------
 drivers/net/ethernet/natsemi/sonic.h |  1 +
 2 files changed, 36 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -50,6 +50,8 @@ static int sonic_open(struct net_device
 	if (sonic_debug > 2)
 		printk("sonic_open: initializing sonic driver.\n");
 
+	spin_lock_init(&lp->lock);
+
 	for (i = 0; i < SONIC_NUM_RRS; i++) {
 		struct sk_buff *skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 		if (skb == NULL) {
@@ -194,8 +196,6 @@ static void sonic_tx_timeout(struct net_
  *   wake the tx queue
  * Concurrently with all of this, the SONIC is potentially writing to
  * the status flags of the TDs.
- * Until some mutual exclusion is added, this code will not work with SMP. However,
- * MIPS Jazz machines and m68k Macs were all uni-processor machines.
  */
 
 static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
@@ -203,7 +203,8 @@ static int sonic_send_packet(struct sk_b
 	struct sonic_local *lp = netdev_priv(dev);
 	dma_addr_t laddr;
 	int length;
-	int entry = lp->next_tx;
+	int entry;
+	unsigned long flags;
 
 	if (sonic_debug > 2)
 		printk("sonic_send_packet: skb=%p, dev=%p\n", skb, dev);
@@ -226,6 +227,10 @@ static int sonic_send_packet(struct sk_b
 		return NETDEV_TX_OK;
 	}
 
+	spin_lock_irqsave(&lp->lock, flags);
+
+	entry = lp->next_tx;
+
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
 	sonic_tda_put(dev, entry, SONIC_TD_FRAG_COUNT, 1);   /* single fragment */
 	sonic_tda_put(dev, entry, SONIC_TD_PKTSIZE, length); /* length of packet */
@@ -235,10 +240,6 @@ static int sonic_send_packet(struct sk_b
 	sonic_tda_put(dev, entry, SONIC_TD_LINK,
 		sonic_tda_get(dev, entry, SONIC_TD_LINK) | SONIC_EOL);
 
-	/*
-	 * Must set tx_skb[entry] only after clearing status, and
-	 * before clearing EOL and before stopping queue
-	 */
 	wmb();
 	lp->tx_len[entry] = length;
 	lp->tx_laddr[entry] = laddr;
@@ -263,6 +264,8 @@ static int sonic_send_packet(struct sk_b
 
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
 
+	spin_unlock_irqrestore(&lp->lock, flags);
+
 	return NETDEV_TX_OK;
 }
 
@@ -275,9 +278,21 @@ static irqreturn_t sonic_interrupt(int i
 	struct net_device *dev = dev_id;
 	struct sonic_local *lp = netdev_priv(dev);
 	int status;
+	unsigned long flags;
+
+	/* The lock has two purposes. Firstly, it synchronizes sonic_interrupt()
+	 * with sonic_send_packet() so that the two functions can share state.
+	 * Secondly, it makes sonic_interrupt() re-entrant, as that is required
+	 * by macsonic which must use two IRQs with different priority levels.
+	 */
+	spin_lock_irqsave(&lp->lock, flags);
+
+	status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
+	if (!status) {
+		spin_unlock_irqrestore(&lp->lock, flags);
 
-	if (!(status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT))
 		return IRQ_NONE;
+	}
 
 	do {
 		if (status & SONIC_INT_PKTRX) {
@@ -292,11 +307,12 @@ static irqreturn_t sonic_interrupt(int i
 			int td_status;
 			int freed_some = 0;
 
-			/* At this point, cur_tx is the index of a TD that is one of:
-			 *   unallocated/freed                          (status set   & tx_skb[entry] clear)
-			 *   allocated and sent                         (status set   & tx_skb[entry] set  )
-			 *   allocated and not yet sent                 (status clear & tx_skb[entry] set  )
-			 *   still being allocated by sonic_send_packet (status clear & tx_skb[entry] clear)
+			/* The state of a Transmit Descriptor may be inferred
+			 * from { tx_skb[entry], td_status } as follows.
+			 * { clear, clear } => the TD has never been used
+			 * { set,   clear } => the TD was handed to SONIC
+			 * { set,   set   } => the TD was handed back
+			 * { clear, set   } => the TD is available for re-use
 			 */
 
 			if (sonic_debug > 2)
@@ -398,7 +414,12 @@ static irqreturn_t sonic_interrupt(int i
 		/* load CAM done */
 		if (status & SONIC_INT_LCD)
 			SONIC_WRITE(SONIC_ISR, SONIC_INT_LCD); /* clear the interrupt */
-	} while((status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT));
+
+		status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
+	} while (status);
+
+	spin_unlock_irqrestore(&lp->lock, flags);
+
 	return IRQ_HANDLED;
 }
 
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -320,6 +320,7 @@ struct sonic_local {
 	unsigned int next_tx;          /* next free TD */
 	struct device *device;         /* generic device */
 	struct net_device_stats stats;
+	spinlock_t lock;
 };
 
 #define TX_TIMEOUT (3 * HZ)

