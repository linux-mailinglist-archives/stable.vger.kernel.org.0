Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E956818B669
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgCSN0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730818AbgCSN0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F130A20658;
        Thu, 19 Mar 2020 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624403;
        bh=wKyo751Qb290M1eueCeLhse11w1D722qA+2YbQAX6yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpwAuhT30kjYajYLYAYXNiKS1XhHZO/YWTAiMKL3AjAgmXGMDsYVouAwBHpTStR3E
         l93sdx4ll8MpxHiRVh2qkKDv4ybFBeIJ06R1Sf2MrBPqY5B/lWXYGn1dDqNLuMyM/w
         DqyLSxdAg3rwRYuwlEq2v76CrEwyOpgJdTj0f7iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <esben@geanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 32/65] net: ll_temac: Handle DMA halt condition caused by buffer underrun
Date:   Thu, 19 Mar 2020 14:04:14 +0100
Message-Id: <20200319123936.502308862@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 1d63b8d66d146deaaedbe16c80de105f685ea012 ]

The SDMA engine used by TEMAC halts operation when it has finished
processing of the last buffer descriptor in the buffer ring.
Unfortunately, no interrupt event is generated when this happens,
so we need to setup another mechanism to make sure DMA operation is
restarted when enough buffers have been added to the ring.

Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |  3 ++
 drivers/net/ethernet/xilinx/ll_temac_main.c | 58 +++++++++++++++++++--
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 99fe059e5c7f3..53fb8141f1a67 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -380,6 +380,9 @@ struct temac_local {
 	/* DMA channel control setup */
 	u32 tx_chnl_ctrl;
 	u32 rx_chnl_ctrl;
+	u8 coalesce_count_rx;
+
+	struct delayed_work restart_work;
 };
 
 /* Wrappers for temac_ior()/temac_iow() function pointers above */
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 2e3f59dae586e..eb480204cdbeb 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -51,6 +51,7 @@
 #include <linux/ip.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <linux/dma-mapping.h>
 #include <linux/processor.h>
 #include <linux/platform_data/xilinx-ll-temac.h>
@@ -866,8 +867,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 				      skb_headlen(skb), DMA_TO_DEVICE);
 	cur_p->len = cpu_to_be32(skb_headlen(skb));
-	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr)))
-		return NETDEV_TX_BUSY;
+	if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent, skb_dma_addr))) {
+		dev_kfree_skb_any(skb);
+		ndev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
 	ptr_to_txbd((void *)skb, cur_p);
 
@@ -897,7 +901,9 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			dma_unmap_single(ndev->dev.parent,
 					 be32_to_cpu(cur_p->phys),
 					 skb_headlen(skb), DMA_TO_DEVICE);
-			return NETDEV_TX_BUSY;
+			dev_kfree_skb_any(skb);
+			ndev->stats.tx_dropped++;
+			return NETDEV_TX_OK;
 		}
 		cur_p->phys = cpu_to_be32(skb_dma_addr);
 		cur_p->len = cpu_to_be32(skb_frag_size(frag));
@@ -920,6 +926,17 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+static int ll_temac_recv_buffers_available(struct temac_local *lp)
+{
+	int available;
+
+	if (!lp->rx_skb[lp->rx_bd_ci])
+		return 0;
+	available = 1 + lp->rx_bd_tail - lp->rx_bd_ci;
+	if (available <= 0)
+		available += RX_BD_NUM;
+	return available;
+}
 
 static void ll_temac_recv(struct net_device *ndev)
 {
@@ -990,6 +1007,18 @@ static void ll_temac_recv(struct net_device *ndev)
 			lp->rx_bd_ci = 0;
 	} while (rx_bd != lp->rx_bd_tail);
 
+	/* DMA operations will halt when the last buffer descriptor is
+	 * processed (ie. the one pointed to by RX_TAILDESC_PTR).
+	 * When that happens, no more interrupt events will be
+	 * generated.  No IRQ_COAL or IRQ_DLY, and not even an
+	 * IRQ_ERR.  To avoid stalling, we schedule a delayed work
+	 * when there is a potential risk of that happening.  The work
+	 * will call this function, and thus re-schedule itself until
+	 * enough buffers are available again.
+	 */
+	if (ll_temac_recv_buffers_available(lp) < lp->coalesce_count_rx)
+		schedule_delayed_work(&lp->restart_work, HZ / 1000);
+
 	/* Allocate new buffers for those buffer descriptors that were
 	 * passed to network stack.  Note that GFP_ATOMIC allocations
 	 * can fail (e.g. when a larger burst of GFP_ATOMIC
@@ -1045,6 +1074,18 @@ static void ll_temac_recv(struct net_device *ndev)
 	spin_unlock_irqrestore(&lp->rx_lock, flags);
 }
 
+/* Function scheduled to ensure a restart in case of DMA halt
+ * condition caused by running out of buffer descriptors.
+ */
+static void ll_temac_restart_work_func(struct work_struct *work)
+{
+	struct temac_local *lp = container_of(work, struct temac_local,
+					      restart_work.work);
+	struct net_device *ndev = lp->ndev;
+
+	ll_temac_recv(ndev);
+}
+
 static irqreturn_t ll_temac_tx_irq(int irq, void *_ndev)
 {
 	struct net_device *ndev = _ndev;
@@ -1137,6 +1178,8 @@ static int temac_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "temac_close()\n");
 
+	cancel_delayed_work_sync(&lp->restart_work);
+
 	free_irq(lp->tx_irq, ndev);
 	free_irq(lp->rx_irq, ndev);
 
@@ -1269,6 +1312,7 @@ static int temac_probe(struct platform_device *pdev)
 	lp->dev = &pdev->dev;
 	lp->options = XTE_OPTION_DEFAULTS;
 	spin_lock_init(&lp->rx_lock);
+	INIT_DELAYED_WORK(&lp->restart_work, ll_temac_restart_work_func);
 
 	/* Setup mutex for synchronization of indirect register access */
 	if (pdata) {
@@ -1375,6 +1419,7 @@ static int temac_probe(struct platform_device *pdev)
 		 */
 		lp->tx_chnl_ctrl = 0x10220000;
 		lp->rx_chnl_ctrl = 0xff070000;
+		lp->coalesce_count_rx = 0x07;
 
 		/* Finished with the DMA node; drop the reference */
 		of_node_put(dma_np);
@@ -1406,11 +1451,14 @@ static int temac_probe(struct platform_device *pdev)
 				(pdata->tx_irq_count << 16);
 		else
 			lp->tx_chnl_ctrl = 0x10220000;
-		if (pdata->rx_irq_timeout || pdata->rx_irq_count)
+		if (pdata->rx_irq_timeout || pdata->rx_irq_count) {
 			lp->rx_chnl_ctrl = (pdata->rx_irq_timeout << 24) |
 				(pdata->rx_irq_count << 16);
-		else
+			lp->coalesce_count_rx = pdata->rx_irq_count;
+		} else {
 			lp->rx_chnl_ctrl = 0xff070000;
+			lp->coalesce_count_rx = 0x07;
+		}
 	}
 
 	/* Error handle returned DMA RX and TX interrupts */
-- 
2.20.1



