Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7505F150BD0
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgBCQal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgBCQak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:40 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83FC220838;
        Mon,  3 Feb 2020 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747440;
        bh=DEA7i2iLMYI9451c3fc7Eoi7txpoaaTpVg2P1e3zJPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EucaWatugxe8WC2gWkziXwNwVp5VokSib7SG5fBbmf5iXpyPtHSNw81kB7t7EmKCt
         j9YVFe/cnNfvx76z1jW+oLmBHtn0Ud9hZ7jnMSoxo/ZLnnro2TYR9Q6RjTxml00JkR
         h5SC7JlU3RFrzOojlnZlHIdzj/vdGjHmX/QN0+oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 85/89] net/sonic: Fix receive buffer handling
Date:   Mon,  3 Feb 2020 16:20:10 +0000
Message-Id: <20200203161927.096706108@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 9e311820f67e740f4fb8dcb82b4c4b5b05bdd1a5 ]

The SONIC can sometimes advance its rx buffer pointer (RRP register)
without advancing its rx descriptor pointer (CRDA register). As a result
the index of the current rx descriptor may not equal that of the current
rx buffer. The driver mistakenly assumes that they are always equal.
This assumption leads to incorrect packet lengths and possible packet
duplication. Avoid this by calling a new function to locate the buffer
corresponding to a given descriptor.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.c | 35 ++++++++++++++++++++++++----
 drivers/net/ethernet/natsemi/sonic.h |  5 ++--
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 7aa7f8050d44e..b6599aa22504f 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -423,6 +423,21 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/* Return the array index corresponding to a given Receive Buffer pointer. */
+static int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
+			   unsigned int last)
+{
+	unsigned int i = last;
+
+	do {
+		i = (i + 1) & SONIC_RRS_MASK;
+		if (addr == lp->rx_laddr[i])
+			return i;
+	} while (i != last);
+
+	return -ENOENT;
+}
+
 /*
  * We have a good packet(s), pass it/them up the network stack.
  */
@@ -442,6 +457,16 @@ static void sonic_rx(struct net_device *dev)
 
 		status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 		if (status & SONIC_RCR_PRX) {
+			u32 addr = (sonic_rda_get(dev, entry,
+						  SONIC_RD_PKTPTR_H) << 16) |
+				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
+			int i = index_from_addr(lp, addr, entry);
+
+			if (i < 0) {
+				WARN_ONCE(1, "failed to find buffer!\n");
+				break;
+			}
+
 			/* Malloc up new buffer. */
 			new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 			if (new_skb == NULL) {
@@ -463,7 +488,7 @@ static void sonic_rx(struct net_device *dev)
 
 			/* now we have a new skb to replace it, pass the used one up the stack */
 			dma_unmap_single(lp->device, lp->rx_laddr[entry], SONIC_RBSIZE, DMA_FROM_DEVICE);
-			used_skb = lp->rx_skb[entry];
+			used_skb = lp->rx_skb[i];
 			pkt_len = sonic_rda_get(dev, entry, SONIC_RD_PKTLEN);
 			skb_trim(used_skb, pkt_len);
 			used_skb->protocol = eth_type_trans(used_skb, dev);
@@ -472,13 +497,13 @@ static void sonic_rx(struct net_device *dev)
 			lp->stats.rx_bytes += pkt_len;
 
 			/* and insert the new skb */
-			lp->rx_laddr[entry] = new_laddr;
-			lp->rx_skb[entry] = new_skb;
+			lp->rx_laddr[i] = new_laddr;
+			lp->rx_skb[i] = new_skb;
 
 			bufadr_l = (unsigned long)new_laddr & 0xffff;
 			bufadr_h = (unsigned long)new_laddr >> 16;
-			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_L, bufadr_l);
-			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, bufadr_h);
+			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
+			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
 		} else {
 			/* This should only happen, if we enable accepting broken packets. */
 			lp->stats.rx_errors++;
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 7057760cb55c6..83905eee6960c 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -274,8 +274,9 @@
 #define SONIC_NUM_RDS   SONIC_NUM_RRS /* number of receive descriptors */
 #define SONIC_NUM_TDS   16            /* number of transmit descriptors */
 
-#define SONIC_RDS_MASK  (SONIC_NUM_RDS-1)
-#define SONIC_TDS_MASK  (SONIC_NUM_TDS-1)
+#define SONIC_RRS_MASK  (SONIC_NUM_RRS - 1)
+#define SONIC_RDS_MASK  (SONIC_NUM_RDS - 1)
+#define SONIC_TDS_MASK  (SONIC_NUM_TDS - 1)
 
 #define SONIC_RBSIZE	1520          /* size of one resource buffer */
 
-- 
2.20.1



