Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EB20E78D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgF2V6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgF2Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E9B24745;
        Mon, 29 Jun 2020 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444064;
        bh=24oy7kmAFgmeG35RsEfqYo+QUXhKwm3aNJvZm5JWm2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOTejcIgE8ubgu2ZhIKELOyjJ50+oFYSvaSCOH0iN24FnmalFvW1Exv1jeF1pOubn
         xKTf84Em70YhtuKufoih+z18qah9SHv4tmo+clJhoOwS+4dJ9rVA8PwWtgLThq7zZp
         MMJVvpZM14jytWXDFJvumQbRCm92jPUIIIH7j63Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 172/265] net: macb: free resources on failure path of at91ether_open()
Date:   Mon, 29 Jun 2020 11:16:45 -0400
Message-Id: <20200629151818.2493727-173-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 33fdef24c9ac20c68b71b363e423fbf9ad2bfc1e ]

DMA buffers were not freed on failure path of at91ether_open().
Along with changes for freeing the DMA buffers the enable/disable
interrupt instructions were moved to at91ether_start()/at91ether_stop()
functions and the operations on at91ether_stop() were done in
their reverse order (compared with how is done in at91ether_start()):
before this patch the operation order on interface open path
was as follows:
1/ alloc DMA buffers
2/ enable tx, rx
3/ enable interrupts
and the order on interface close path was as follows:
1/ disable tx, rx
2/ disable interrupts
3/ free dma buffers.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 116 ++++++++++++++---------
 1 file changed, 73 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5705359a36124..52582e8ed90e5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3762,15 +3762,9 @@ static int macb_init(struct platform_device *pdev)
 
 static struct sifive_fu540_macb_mgmt *mgmt;
 
-/* Initialize and start the Receiver and Transmit subsystems */
-static int at91ether_start(struct net_device *dev)
+static int at91ether_alloc_coherent(struct macb *lp)
 {
-	struct macb *lp = netdev_priv(dev);
 	struct macb_queue *q = &lp->queues[0];
-	struct macb_dma_desc *desc;
-	dma_addr_t addr;
-	u32 ctl;
-	int i;
 
 	q->rx_ring = dma_alloc_coherent(&lp->pdev->dev,
 					 (AT91ETHER_MAX_RX_DESCR *
@@ -3792,6 +3786,43 @@ static int at91ether_start(struct net_device *dev)
 		return -ENOMEM;
 	}
 
+	return 0;
+}
+
+static void at91ether_free_coherent(struct macb *lp)
+{
+	struct macb_queue *q = &lp->queues[0];
+
+	if (q->rx_ring) {
+		dma_free_coherent(&lp->pdev->dev,
+				  AT91ETHER_MAX_RX_DESCR *
+				  macb_dma_desc_get_size(lp),
+				  q->rx_ring, q->rx_ring_dma);
+		q->rx_ring = NULL;
+	}
+
+	if (q->rx_buffers) {
+		dma_free_coherent(&lp->pdev->dev,
+				  AT91ETHER_MAX_RX_DESCR *
+				  AT91ETHER_MAX_RBUFF_SZ,
+				  q->rx_buffers, q->rx_buffers_dma);
+		q->rx_buffers = NULL;
+	}
+}
+
+/* Initialize and start the Receiver and Transmit subsystems */
+static int at91ether_start(struct macb *lp)
+{
+	struct macb_queue *q = &lp->queues[0];
+	struct macb_dma_desc *desc;
+	dma_addr_t addr;
+	u32 ctl;
+	int i, ret;
+
+	ret = at91ether_alloc_coherent(lp);
+	if (ret)
+		return ret;
+
 	addr = q->rx_buffers_dma;
 	for (i = 0; i < AT91ETHER_MAX_RX_DESCR; i++) {
 		desc = macb_rx_desc(q, i);
@@ -3813,9 +3844,39 @@ static int at91ether_start(struct net_device *dev)
 	ctl = macb_readl(lp, NCR);
 	macb_writel(lp, NCR, ctl | MACB_BIT(RE) | MACB_BIT(TE));
 
+	/* Enable MAC interrupts */
+	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
+			     MACB_BIT(RXUBR)	|
+			     MACB_BIT(ISR_TUND)	|
+			     MACB_BIT(ISR_RLE)	|
+			     MACB_BIT(TCOMP)	|
+			     MACB_BIT(ISR_ROVR)	|
+			     MACB_BIT(HRESP));
+
 	return 0;
 }
 
+static void at91ether_stop(struct macb *lp)
+{
+	u32 ctl;
+
+	/* Disable MAC interrupts */
+	macb_writel(lp, IDR, MACB_BIT(RCOMP)	|
+			     MACB_BIT(RXUBR)	|
+			     MACB_BIT(ISR_TUND)	|
+			     MACB_BIT(ISR_RLE)	|
+			     MACB_BIT(TCOMP)	|
+			     MACB_BIT(ISR_ROVR) |
+			     MACB_BIT(HRESP));
+
+	/* Disable Receiver and Transmitter */
+	ctl = macb_readl(lp, NCR);
+	macb_writel(lp, NCR, ctl & ~(MACB_BIT(TE) | MACB_BIT(RE)));
+
+	/* Free resources. */
+	at91ether_free_coherent(lp);
+}
+
 /* Open the ethernet interface */
 static int at91ether_open(struct net_device *dev)
 {
@@ -3835,27 +3896,20 @@ static int at91ether_open(struct net_device *dev)
 
 	macb_set_hwaddr(lp);
 
-	ret = at91ether_start(dev);
+	ret = at91ether_start(lp);
 	if (ret)
 		goto pm_exit;
 
-	/* Enable MAC interrupts */
-	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
-			     MACB_BIT(RXUBR)	|
-			     MACB_BIT(ISR_TUND)	|
-			     MACB_BIT(ISR_RLE)	|
-			     MACB_BIT(TCOMP)	|
-			     MACB_BIT(ISR_ROVR)	|
-			     MACB_BIT(HRESP));
-
 	ret = macb_phylink_connect(lp);
 	if (ret)
-		goto pm_exit;
+		goto stop;
 
 	netif_start_queue(dev);
 
 	return 0;
 
+stop:
+	at91ether_stop(lp);
 pm_exit:
 	pm_runtime_put_sync(&lp->pdev->dev);
 	return ret;
@@ -3865,37 +3919,13 @@ pm_exit:
 static int at91ether_close(struct net_device *dev)
 {
 	struct macb *lp = netdev_priv(dev);
-	struct macb_queue *q = &lp->queues[0];
-	u32 ctl;
-
-	/* Disable Receiver and Transmitter */
-	ctl = macb_readl(lp, NCR);
-	macb_writel(lp, NCR, ctl & ~(MACB_BIT(TE) | MACB_BIT(RE)));
-
-	/* Disable MAC interrupts */
-	macb_writel(lp, IDR, MACB_BIT(RCOMP)	|
-			     MACB_BIT(RXUBR)	|
-			     MACB_BIT(ISR_TUND)	|
-			     MACB_BIT(ISR_RLE)	|
-			     MACB_BIT(TCOMP)	|
-			     MACB_BIT(ISR_ROVR) |
-			     MACB_BIT(HRESP));
 
 	netif_stop_queue(dev);
 
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 
-	dma_free_coherent(&lp->pdev->dev,
-			  AT91ETHER_MAX_RX_DESCR *
-			  macb_dma_desc_get_size(lp),
-			  q->rx_ring, q->rx_ring_dma);
-	q->rx_ring = NULL;
-
-	dma_free_coherent(&lp->pdev->dev,
-			  AT91ETHER_MAX_RX_DESCR * AT91ETHER_MAX_RBUFF_SZ,
-			  q->rx_buffers, q->rx_buffers_dma);
-	q->rx_buffers = NULL;
+	at91ether_stop(lp);
 
 	return pm_runtime_put(&lp->pdev->dev);
 }
-- 
2.25.1

