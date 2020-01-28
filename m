Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF4314B686
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA1OEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727579AbgA1OEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E417E205F4;
        Tue, 28 Jan 2020 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220292;
        bh=T8OS+M2NCWOCgXWD7w/P8+b4YP+JimAenip2OKW1nrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzDLdZ1KZEUCbUgvyuH1b1mLUGZpcJCuaCoUVCDYhGEU0IXFEo5v+Cj5OamJsML9F
         RqOPUFBEJPkqJ8huftqKhop6GPYfxlDg1kirLuvhiD2MCD3owJViSHnxBW3DcHULf4
         YPvgR9WMkO7z2SF3+QVwp8vP5aS8uW3P9mtx0XW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 094/104] net/sonic: Fix receive buffer replenishment
Date:   Tue, 28 Jan 2020 15:00:55 +0100
Message-Id: <20200128135829.992414448@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 89ba879e95582d3bba55081e45b5409e883312ca upstream.

As soon as the driver is finished with a receive buffer it allocs a new
one and overwrites the corresponding RRA entry with a new buffer pointer.

Problem is, the buffer pointer is split across two word-sized registers.
It can't be updated in one atomic store. So this operation races with the
chip while it stores received packets and advances its RRP register.
This could result in memory corruption by a DMA write.

Avoid this problem by adding buffers only at the location given by the
RWP register, in accordance with the National Semiconductor datasheet.

Re-factor this code into separate functions to calculate a RRA pointer
and to update the RWP.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |  150 ++++++++++++++++++++---------------
 drivers/net/ethernet/natsemi/sonic.h |   18 +++-
 2 files changed, 105 insertions(+), 63 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -428,6 +428,59 @@ static int index_from_addr(struct sonic_
 	return -ENOENT;
 }
 
+/* Allocate and map a new skb to be used as a receive buffer. */
+static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
+			   struct sk_buff **new_skb, dma_addr_t *new_addr)
+{
+	*new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
+	if (!*new_skb)
+		return false;
+
+	if (SONIC_BUS_SCALE(lp->dma_bitmode) == 2)
+		skb_reserve(*new_skb, 2);
+
+	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
+				   SONIC_RBSIZE, DMA_FROM_DEVICE);
+	if (!*new_addr) {
+		dev_kfree_skb(*new_skb);
+		*new_skb = NULL;
+		return false;
+	}
+
+	return true;
+}
+
+/* Place a new receive resource in the Receive Resource Area and update RWP. */
+static void sonic_update_rra(struct net_device *dev, struct sonic_local *lp,
+			     dma_addr_t old_addr, dma_addr_t new_addr)
+{
+	unsigned int entry = sonic_rr_entry(dev, SONIC_READ(SONIC_RWP));
+	unsigned int end = sonic_rr_entry(dev, SONIC_READ(SONIC_RRP));
+	u32 buf;
+
+	/* The resources in the range [RRP, RWP) belong to the SONIC. This loop
+	 * scans the other resources in the RRA, those in the range [RWP, RRP).
+	 */
+	do {
+		buf = (sonic_rra_get(dev, entry, SONIC_RR_BUFADR_H) << 16) |
+		      sonic_rra_get(dev, entry, SONIC_RR_BUFADR_L);
+
+		if (buf == old_addr)
+			break;
+
+		entry = (entry + 1) & SONIC_RRS_MASK;
+	} while (entry != end);
+
+	WARN_ONCE(buf != old_addr, "failed to find resource!\n");
+
+	sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, new_addr >> 16);
+	sonic_rra_put(dev, entry, SONIC_RR_BUFADR_L, new_addr & 0xffff);
+
+	entry = (entry + 1) & SONIC_RRS_MASK;
+
+	SONIC_WRITE(SONIC_RWP, sonic_rr_addr(dev, entry));
+}
+
 /*
  * We have a good packet(s), pass it/them up the network stack.
  */
@@ -436,18 +489,15 @@ static void sonic_rx(struct net_device *
 	struct sonic_local *lp = netdev_priv(dev);
 	int entry = lp->cur_rx;
 	int prev_entry = lp->eol_rx;
+	bool rbe = false;
 
 	while (sonic_rda_get(dev, entry, SONIC_RD_IN_USE) == 0) {
-		struct sk_buff *used_skb;
-		struct sk_buff *new_skb;
-		dma_addr_t new_laddr;
-		u16 bufadr_l;
-		u16 bufadr_h;
-		int pkt_len;
 		u16 status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 
 		/* If the RD has LPKT set, the chip has finished with the RB */
 		if ((status & SONIC_RCR_PRX) && (status & SONIC_RCR_LPKT)) {
+			struct sk_buff *new_skb;
+			dma_addr_t new_laddr;
 			u32 addr = (sonic_rda_get(dev, entry,
 						  SONIC_RD_PKTPTR_H) << 16) |
 				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
@@ -458,55 +508,35 @@ static void sonic_rx(struct net_device *
 				break;
 			}
 
-			/* Malloc up new buffer. */
-			new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
-			if (new_skb == NULL) {
+			if (sonic_alloc_rb(dev, lp, &new_skb, &new_laddr)) {
+				struct sk_buff *used_skb = lp->rx_skb[i];
+				int pkt_len;
+
+				/* Pass the used buffer up the stack */
+				dma_unmap_single(lp->device, addr, SONIC_RBSIZE,
+						 DMA_FROM_DEVICE);
+
+				pkt_len = sonic_rda_get(dev, entry,
+							SONIC_RD_PKTLEN);
+				skb_trim(used_skb, pkt_len);
+				used_skb->protocol = eth_type_trans(used_skb,
+								    dev);
+				netif_rx(used_skb);
+				lp->stats.rx_packets++;
+				lp->stats.rx_bytes += pkt_len;
+
+				lp->rx_skb[i] = new_skb;
+				lp->rx_laddr[i] = new_laddr;
+			} else {
+				/* Failed to obtain a new buffer so re-use it */
+				new_laddr = addr;
 				lp->stats.rx_dropped++;
-				break;
 			}
-			/* provide 16 byte IP header alignment unless DMA requires otherwise */
-			if(SONIC_BUS_SCALE(lp->dma_bitmode) == 2)
-				skb_reserve(new_skb, 2);
-
-			new_laddr = dma_map_single(lp->device, skb_put(new_skb, SONIC_RBSIZE),
-		                               SONIC_RBSIZE, DMA_FROM_DEVICE);
-			if (!new_laddr) {
-				dev_kfree_skb(new_skb);
-				printk(KERN_ERR "%s: Failed to map rx buffer, dropping packet.\n", dev->name);
-				lp->stats.rx_dropped++;
-				break;
-			}
-
-			/* now we have a new skb to replace it, pass the used one up the stack */
-			dma_unmap_single(lp->device, lp->rx_laddr[entry], SONIC_RBSIZE, DMA_FROM_DEVICE);
-			used_skb = lp->rx_skb[i];
-			pkt_len = sonic_rda_get(dev, entry, SONIC_RD_PKTLEN);
-			skb_trim(used_skb, pkt_len);
-			used_skb->protocol = eth_type_trans(used_skb, dev);
-			netif_rx(used_skb);
-			lp->stats.rx_packets++;
-			lp->stats.rx_bytes += pkt_len;
-
-			/* and insert the new skb */
-			lp->rx_laddr[i] = new_laddr;
-			lp->rx_skb[i] = new_skb;
-
-			bufadr_l = (unsigned long)new_laddr & 0xffff;
-			bufadr_h = (unsigned long)new_laddr >> 16;
-			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
-			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
-			/*
-			 * this was the last packet out of the current receive buffer
-			 * give the buffer back to the SONIC
+			/* If RBE is already asserted when RWP advances then
+			 * it's safe to clear RBE after processing this packet.
 			 */
-			lp->cur_rwp += SIZEOF_SONIC_RR * SONIC_BUS_SCALE(lp->dma_bitmode);
-			if (lp->cur_rwp >= lp->rra_end) lp->cur_rwp = lp->rra_laddr & 0xffff;
-			SONIC_WRITE(SONIC_RWP, lp->cur_rwp);
-			if (SONIC_READ(SONIC_ISR) & SONIC_INT_RBE) {
-				netif_dbg(lp, rx_err, dev, "%s: rx buffer exhausted\n",
-					  __func__);
-				SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE); /* clear the flag */
-			}
+			rbe = rbe || SONIC_READ(SONIC_ISR) & SONIC_INT_RBE;
+			sonic_update_rra(dev, lp, addr, new_laddr);
 		}
 		/*
 		 * give back the descriptor
@@ -528,6 +558,9 @@ static void sonic_rx(struct net_device *
 			      sonic_rda_get(dev, lp->eol_rx, SONIC_RD_LINK));
 		lp->eol_rx = prev_entry;
 	}
+
+	if (rbe)
+		SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE);
 	/*
 	 * If any worth-while packets have been received, netif_rx()
 	 * has done a mark_bh(NET_BH) for us and will work on them
@@ -642,15 +675,10 @@ static int sonic_init(struct net_device
 	}
 
 	/* initialize all RRA registers */
-	lp->rra_end = (lp->rra_laddr + SONIC_NUM_RRS * SIZEOF_SONIC_RR *
-					SONIC_BUS_SCALE(lp->dma_bitmode)) & 0xffff;
-	lp->cur_rwp = (lp->rra_laddr + (SONIC_NUM_RRS - 1) * SIZEOF_SONIC_RR *
-					SONIC_BUS_SCALE(lp->dma_bitmode)) & 0xffff;
-
-	SONIC_WRITE(SONIC_RSA, lp->rra_laddr & 0xffff);
-	SONIC_WRITE(SONIC_REA, lp->rra_end);
-	SONIC_WRITE(SONIC_RRP, lp->rra_laddr & 0xffff);
-	SONIC_WRITE(SONIC_RWP, lp->cur_rwp);
+	SONIC_WRITE(SONIC_RSA, sonic_rr_addr(dev, 0));
+	SONIC_WRITE(SONIC_REA, sonic_rr_addr(dev, SONIC_NUM_RRS));
+	SONIC_WRITE(SONIC_RRP, sonic_rr_addr(dev, 0));
+	SONIC_WRITE(SONIC_RWP, sonic_rr_addr(dev, SONIC_NUM_RRS - 1));
 	SONIC_WRITE(SONIC_URRA, lp->rra_laddr >> 16);
 	SONIC_WRITE(SONIC_EOBC, (SONIC_RBSIZE >> 1) - (lp->dma_bitmode ? 2 : 1));
 
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -314,8 +314,6 @@ struct sonic_local {
 	u32 rda_laddr;              /* logical DMA address of RDA */
 	dma_addr_t rx_laddr[SONIC_NUM_RRS]; /* logical DMA addresses of rx skbuffs */
 	dma_addr_t tx_laddr[SONIC_NUM_TDS]; /* logical DMA addresses of tx skbuffs */
-	unsigned int rra_end;
-	unsigned int cur_rwp;
 	unsigned int cur_rx;
 	unsigned int cur_tx;           /* first unacked transmit packet */
 	unsigned int eol_rx;
@@ -450,6 +448,22 @@ static inline __u16 sonic_rra_get(struct
 			     (entry * SIZEOF_SONIC_RR) + offset);
 }
 
+static inline u16 sonic_rr_addr(struct net_device *dev, int entry)
+{
+	struct sonic_local *lp = netdev_priv(dev);
+
+	return lp->rra_laddr +
+	       entry * SIZEOF_SONIC_RR * SONIC_BUS_SCALE(lp->dma_bitmode);
+}
+
+static inline u16 sonic_rr_entry(struct net_device *dev, u16 addr)
+{
+	struct sonic_local *lp = netdev_priv(dev);
+
+	return (addr - (u16)lp->rra_laddr) / (SIZEOF_SONIC_RR *
+					      SONIC_BUS_SCALE(lp->dma_bitmode));
+}
+
 static const char version[] =
     "sonic.c:v0.92 20.9.98 tsbogend@alpha.franken.de\n";
 


