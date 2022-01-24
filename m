Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66F2497FD8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiAXMsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242338AbiAXMsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:48:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D190C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C035F60FE0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D5EC340E4;
        Mon, 24 Jan 2022 12:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643028493;
        bh=WT1P5XFFt46cM5lbAghsq+eU9oiV8Fk698AxvAo5lh8=;
        h=Subject:To:Cc:From:Date:From;
        b=Li0iQds0IF/8ikriYXqMLS/yUWoiV35Th+fdv+jHFUWOkg0hQIH1plVgFV3CUSZJ5
         h9YGWkAoEx3o4phH+KPwMvPTObj/O8o+z/unfG4ecpzphq+kDapxVHTKGbvjaS2K5z
         Gmr+ATpt/hGTIvZO9e4wlxvtDF9iqf17nGrzmdk4=
Subject: FAILED: patch "[PATCH] net: axienet: add missing memory barriers" failed to apply to 4.9-stable tree
To:     robert.hancock@calian.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:47:58 +0100
Message-ID: <16430284784761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 95978df6fa328df619c15312e65ece469c2be2d2 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 18 Jan 2022 15:41:27 -0600
Subject: [PATCH] net: axienet: add missing memory barriers

This driver was missing some required memory barriers:

Use dma_rmb to ensure we see all updates to the descriptor after we see
that an entry has been completed.

Use wmb and rmb to avoid stale descriptor status between the TX path and
TX complete IRQ path.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 53ff38cbc37b..fb486a457c76 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -632,6 +632,8 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
@@ -645,8 +647,10 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
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
@@ -704,6 +708,9 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
 		return NETDEV_TX_BUSY;
@@ -843,6 +850,8 @@ static void axienet_recv(struct net_device *ndev)
 
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
 				 DMA_FROM_DEVICE);

