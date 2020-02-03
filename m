Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BF3150B60
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgBCQ1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgBCQ1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:01 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A228320CC7;
        Mon,  3 Feb 2020 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747220;
        bh=SraDaiKjXTsk/4sOJ4vcPAWKIECzSdo8NkqNCuGszHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+2USTzCveCkGggW9iTsglLB1K0qjiVVSYOB8GUmssoeM/igzTlPdihrsarj/KyTO
         Foofdyy41GqWusrbVUqojKMzqTCKAB7MvR0Wb2I6V45lR5/hfeM2PF+slwB5DAoZBO
         7EHfG4iFYbD4PHi5TOC5JDOhu8Y6v04F8eO3KrT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 62/68] net/sonic: Add mutual exclusion for accessing shared state
Date:   Mon,  3 Feb 2020 16:19:58 +0000
Message-Id: <20200203161915.090504993@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 865ad2f2201dc18685ba2686f13217f8b3a9c52c ]

The netif_stop_queue() call in sonic_send_packet() races with the
netif_wake_queue() call in sonic_interrupt(). This causes issues
like "NETDEV WATCHDOG: eth0 (macsonic): transmit queue 0 timed out".
Fix this by disabling interrupts when accessing tx_skb[] and next_tx.
Update a comment to clarify the synchronization properties.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.c | 49 ++++++++++++++++++++--------
 drivers/net/ethernet/natsemi/sonic.h |  1 +
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index a051dddcbd768..7aa7f8050d44e 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -50,6 +50,8 @@ static int sonic_open(struct net_device *dev)
 	if (sonic_debug > 2)
 		printk("sonic_open: initializing sonic driver.\n");
 
+	spin_lock_init(&lp->lock);
+
 	for (i = 0; i < SONIC_NUM_RRS; i++) {
 		struct sk_buff *skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 		if (skb == NULL) {
@@ -194,8 +196,6 @@ static void sonic_tx_timeout(struct net_device *dev)
  *   wake the tx queue
  * Concurrently with all of this, the SONIC is potentially writing to
  * the status flags of the TDs.
- * Until some mutual exclusion is added, this code will not work with SMP. However,
- * MIPS Jazz machines and m68k Macs were all uni-processor machines.
  */
 
 static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
@@ -203,7 +203,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	struct sonic_local *lp = netdev_priv(dev);
 	dma_addr_t laddr;
 	int length;
-	int entry = lp->next_tx;
+	int entry;
+	unsigned long flags;
 
 	if (sonic_debug > 2)
 		printk("sonic_send_packet: skb=%p, dev=%p\n", skb, dev);
@@ -226,6 +227,10 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
+	spin_lock_irqsave(&lp->lock, flags);
+
+	entry = lp->next_tx;
+
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
 	sonic_tda_put(dev, entry, SONIC_TD_FRAG_COUNT, 1);   /* single fragment */
 	sonic_tda_put(dev, entry, SONIC_TD_PKTSIZE, length); /* length of packet */
@@ -235,10 +240,6 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	sonic_tda_put(dev, entry, SONIC_TD_LINK,
 		sonic_tda_get(dev, entry, SONIC_TD_LINK) | SONIC_EOL);
 
-	/*
-	 * Must set tx_skb[entry] only after clearing status, and
-	 * before clearing EOL and before stopping queue
-	 */
 	wmb();
 	lp->tx_len[entry] = length;
 	lp->tx_laddr[entry] = laddr;
@@ -263,6 +264,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
 
+	spin_unlock_irqrestore(&lp->lock, flags);
+
 	return NETDEV_TX_OK;
 }
 
@@ -275,9 +278,21 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
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
@@ -292,11 +307,12 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
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
@@ -398,7 +414,12 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
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
 
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 07091dd27e5df..1fd61d7f79bcb 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -320,6 +320,7 @@ struct sonic_local {
 	unsigned int next_tx;          /* next free TD */
 	struct device *device;         /* generic device */
 	struct net_device_stats stats;
+	spinlock_t lock;
 };
 
 #define TX_TIMEOUT (3 * HZ)
-- 
2.20.1



