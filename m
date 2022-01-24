Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F82499AFE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359136AbiAXVsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457543AbiAXVlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 135F761521;
        Mon, 24 Jan 2022 21:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FE8C340E4;
        Mon, 24 Jan 2022 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060508;
        bh=DKaIZ44jXhAHBBxgsqnKrT5Vc0etjfMDYpjpcuu0RIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ql+Go9qqWBq3vYFCFyXv76g828PV4MfEnkDRF/d40rXvgyEQk+YLUw773IL3PtaxP
         wTS1jTmQp24Zg3QsNln2zjyVk2imGvkzgGq/30w4p0ltFDe3LtBh7FUbV2Ui+EH5+O
         WAdL/JD852UzPybkVxomo62TZG+n+AG7rjPOxHtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 0970/1039] net: axienet: add missing memory barriers
Date:   Mon, 24 Jan 2022 19:45:59 +0100
Message-Id: <20220124184157.899224815@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 95978df6fa328df619c15312e65ece469c2be2d2 upstream.

This driver was missing some required memory barriers:

Use dma_rmb to ensure we see all updates to the descriptor after we see
that an entry has been completed.

Use wmb and rmb to avoid stale descriptor status between the TX path and
TX complete IRQ path.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -632,6 +632,8 @@ static int axienet_free_tx_chain(struct
 		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
@@ -645,8 +647,10 @@ static int axienet_free_tx_chain(struct
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app4 = 0;
-		cur_p->status = 0;
 		cur_p->skb = NULL;
+		/* ensure our transmit path and device don't prematurely see status cleared */
+		wmb();
+		cur_p->status = 0;
 
 		if (sizep)
 			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
@@ -704,6 +708,9 @@ static inline int axienet_check_tx_bd_sp
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
 		return NETDEV_TX_BUSY;
@@ -843,6 +850,8 @@ static void axienet_recv(struct net_devi
 
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
 				 DMA_FROM_DEVICE);


