Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A061177DF3
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgCCRpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:45:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729917AbgCCRpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C76792146E;
        Tue,  3 Mar 2020 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257511;
        bh=Ub3p2TSJLqskWyV5CNAcadRpsni35F9PTePT2NtfYRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YT4Y7OiRf9YpR/QMiItvB6anRNtPGamv390qZ5VLWxnogCe4a1trqN2F2zpFJbs2G
         Gmgla1yGiDICGqUfKg/U0R83AemyC7w2LdibyfKvT1KNHhfWGwRNAVdJ4OwxDpHNfn
         Wj+jmn5J8mD12abjZg+dpG1wph+emjTXNqFflf+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 023/176] net: macb: Properly handle phylink on at91rm9200
Date:   Tue,  3 Mar 2020 18:41:27 +0100
Message-Id: <20200303174307.222995318@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit ac2fcfa9fd26db67d7000677c05629c34cc94564 ]

at91ether_init was handling the phy mode and speed but since the switch to
phylink, the NCFGR register got overwritten by macb_mac_config(). The issue
is that the RM9200_RMII bit and the MACB_CLK_DIV32 field are cleared
but never restored as they conflict with the PAE, GBE and PCSSEL bits.

Add new capability to differentiate between EMAC and the other versions of
the IP and use it to set and avoid clearing the relevant bits.

Also, this fixes a NULL pointer dereference in macb_mac_link_up as the EMAC
doesn't use any rings/bufffers/queues.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb.h      |    1 
 drivers/net/ethernet/cadence/macb_main.c |   60 ++++++++++++++++---------------
 2 files changed, 33 insertions(+), 28 deletions(-)

--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -645,6 +645,7 @@
 #define MACB_CAPS_GEM_HAS_PTP			0x00000040
 #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
+#define MACB_CAPS_MACB_IS_EMAC			0x08000000
 #define MACB_CAPS_FIFO_MODE			0x10000000
 #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
 #define MACB_CAPS_SG_DISABLED			0x40000000
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -533,8 +533,21 @@ static void macb_mac_config(struct phyli
 	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
 
 	/* Clear all the bits we might set later */
-	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
-		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
+	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE));
+
+	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
+		if (state->interface == PHY_INTERFACE_MODE_RMII)
+			ctrl |= MACB_BIT(RM9200_RMII);
+	} else {
+		ctrl &= ~(GEM_BIT(GBE) | GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
+
+		/* We do not support MLO_PAUSE_RX yet */
+		if (state->pause & MLO_PAUSE_TX)
+			ctrl |= MACB_BIT(PAE);
+
+		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
+	}
 
 	if (state->speed == SPEED_1000)
 		ctrl |= GEM_BIT(GBE);
@@ -544,13 +557,6 @@ static void macb_mac_config(struct phyli
 	if (state->duplex)
 		ctrl |= MACB_BIT(FD);
 
-	/* We do not support MLO_PAUSE_RX yet */
-	if (state->pause & MLO_PAUSE_TX)
-		ctrl |= MACB_BIT(PAE);
-
-	if (state->interface == PHY_INTERFACE_MODE_SGMII)
-		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
-
 	/* Apply the new configuration, if any */
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
@@ -569,9 +575,10 @@ static void macb_mac_link_down(struct ph
 	unsigned int q;
 	u32 ctrl;
 
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
-		queue_writel(queue, IDR,
-			     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
+	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC))
+		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
+			queue_writel(queue, IDR,
+				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
 
 	/* Disable Rx and Tx */
 	ctrl = macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE));
@@ -588,17 +595,19 @@ static void macb_mac_link_up(struct phyl
 	struct macb_queue *queue;
 	unsigned int q;
 
-	macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
+	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
+		macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
 
-	/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
-	 * cleared the pipeline and control registers.
-	 */
-	bp->macbgem_ops.mog_init_rings(bp);
-	macb_init_buffers(bp);
+		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
+		 * cleared the pipeline and control registers.
+		 */
+		bp->macbgem_ops.mog_init_rings(bp);
+		macb_init_buffers(bp);
 
-	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
-		queue_writel(queue, IER,
-			     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
+		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
+			queue_writel(queue, IER,
+				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
+	}
 
 	/* Enable Rx and Tx */
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
@@ -4002,7 +4011,6 @@ static int at91ether_init(struct platfor
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct macb *bp = netdev_priv(dev);
 	int err;
-	u32 reg;
 
 	bp->queues[0].bp = bp;
 
@@ -4016,11 +4024,7 @@ static int at91ether_init(struct platfor
 
 	macb_writel(bp, NCR, 0);
 
-	reg = MACB_BF(CLK, MACB_CLK_DIV32) | MACB_BIT(BIG);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_RMII)
-		reg |= MACB_BIT(RM9200_RMII);
-
-	macb_writel(bp, NCFGR, reg);
+	macb_writel(bp, NCFGR, MACB_BF(CLK, MACB_CLK_DIV32) | MACB_BIT(BIG));
 
 	return 0;
 }
@@ -4179,7 +4183,7 @@ static const struct macb_config sama5d4_
 };
 
 static const struct macb_config emac_config = {
-	.caps = MACB_CAPS_NEEDS_RSTONUBR,
+	.caps = MACB_CAPS_NEEDS_RSTONUBR | MACB_CAPS_MACB_IS_EMAC,
 	.clk_init = at91ether_clk_init,
 	.init = at91ether_init,
 };


