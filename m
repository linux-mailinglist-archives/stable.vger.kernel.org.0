Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB8B38A18D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhETJcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhETJaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E24613B9;
        Thu, 20 May 2021 09:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502850;
        bh=rToa/W+40TfTQNkL81gd2N0p+SZiNa+CC09YxZAKv1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNnwx4v8dHoQM9kmZGfdS7Y4+pxA/ptVs3UoGN27l6pW7AAKCbfDGpvocE3QqQrxI
         6o8LpZ0nT2SqYa28RJ2SPkH/u/2yfJPI8m48Rxx49DsIRqcQ49TXW3JmwgtGpUgSeE
         JfZbDZqEWkYSA+uGE98yF3rmDjFEmQ7DV81BQ0WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yannick Vignon <yannick.vignon@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/47] net: stmmac: Do not enable RX FIFO overflow interrupts
Date:   Thu, 20 May 2021 11:22:39 +0200
Message-Id: <20210520092054.871219094@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

[ Upstream commit 8a7cb245cf28cb3e541e0d6c8624b95d079e155b ]

The RX FIFO overflows when the system is not able to process all received
packets and they start accumulating (first in the DMA queue in memory,
then in the FIFO). An interrupt is then raised for each overflowing packet
and handled in stmmac_interrupt(). This is counter-productive, since it
brings the system (or more likely, one CPU core) to its knees to process
the FIFO overflow interrupts.

stmmac_interrupt() handles overflow interrupts by writing the rx tail ptr
into the corresponding hardware register (according to the MAC spec, this
has the effect of restarting the MAC DMA). However, without freeing any rx
descriptors, the DMA stops right away, and another overflow interrupt is
raised as the FIFO overflows again. Since the DMA is already restarted at
the end of stmmac_rx_refill() after freeing descriptors, disabling FIFO
overflow interrupts and the corresponding handling code has no side effect,
and eliminates the interrupt storm when the RX FIFO overflows.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Link: https://lore.kernel.org/r/20210506143312.20784-1-yannick.vignon@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  7 +------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 62aa0e95beb7..a7249e4071f1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -222,7 +222,7 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
 	unsigned int rqs = fifosz / 256 - 1;
-	u32 mtl_rx_op, mtl_rx_int;
+	u32 mtl_rx_op;
 
 	mtl_rx_op = readl(ioaddr + MTL_CHAN_RX_OP_MODE(channel));
 
@@ -283,11 +283,6 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 	}
 
 	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(channel));
-
-	/* Enable MTL RX overflow */
-	mtl_rx_int = readl(ioaddr + MTL_CHAN_INT_CTRL(channel));
-	writel(mtl_rx_int | MTL_RX_OVERFLOW_INT_EN,
-	       ioaddr + MTL_CHAN_INT_CTRL(channel));
 }
 
 static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5b9478dffe10..4374ce4671ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4138,7 +4138,6 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	/* To handle GMAC own interrupts */
 	if ((priv->plat->has_gmac) || xmac) {
 		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
-		int mtl_status;
 
 		if (unlikely(status)) {
 			/* For LPI we need to save the tx status */
@@ -4149,17 +4148,8 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 		}
 
 		for (queue = 0; queue < queues_count; queue++) {
-			struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-			mtl_status = stmmac_host_mtl_irq_status(priv, priv->hw,
-								queue);
-			if (mtl_status != -EINVAL)
-				status |= mtl_status;
-
-			if (status & CORE_IRQ_MTL_RX_OVERFLOW)
-				stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
-						       rx_q->rx_tail_addr,
-						       queue);
+			status = stmmac_host_mtl_irq_status(priv, priv->hw,
+							    queue);
 		}
 
 		/* PCS link status */
-- 
2.30.2



