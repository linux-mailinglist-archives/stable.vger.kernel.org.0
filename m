Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147E268958A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjBCKTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjBCKSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:18:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE0693AF1
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4073361CBE
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16046C433EF;
        Fri,  3 Feb 2023 10:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419500;
        bh=EULvtUtrYj0eRoPByu/EOh0KoWwVAHAyJocQpUEIg0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zR1wGBTN0pNHFhVPvjX8a26dDY2fl0fgWZHM12YtqFuK9HNrwvRu7J1IKSnilXKWL
         UF73rxt8OHYtZWIibBXgUnj/KVKdB8EEuvia2IVLiBz/A+/PiBbA88G0SFY9R95DX/
         qPSxLdxENPEGwWTMik1KtxNoxe6LXOdBxEkb1aH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vinod Koul <vkoul@kernel.org>,
        Andrea Merello <andrea.merello@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/80] dmaengine: xilinx_dma: commonize DMA copy size calculation
Date:   Fri,  3 Feb 2023 11:12:19 +0100
Message-Id: <20230203101016.254056257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Merello <andrea.merello@gmail.com>

[ Upstream commit 616f0f81d857e248a72b5af45ab185196556ae2e ]

This patch removes a bit of duplicated code by introducing a new
function that implements calculations for DMA copy size, and
prepares for changes to the copy size calculation that will
happen in following patches.

Suggested-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 596b53ccc36a ("dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 39 ++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 0ba70be4ea85..e4ea94b93400 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -428,6 +428,7 @@ struct xilinx_dma_config {
  * @rxs_clk: DMA s2mm stream clock
  * @nr_channels: Number of channels DMA device supports
  * @chan_id: DMA channel identifier
+ * @max_buffer_len: Max buffer length
  */
 struct xilinx_dma_device {
 	void __iomem *regs;
@@ -447,6 +448,7 @@ struct xilinx_dma_device {
 	struct clk *rxs_clk;
 	u32 nr_channels;
 	u32 chan_id;
+	u32 max_buffer_len;
 };
 
 /* Macros */
@@ -969,6 +971,25 @@ static int xilinx_dma_alloc_chan_resources(struct dma_chan *dchan)
 	return 0;
 }
 
+/**
+ * xilinx_dma_calc_copysize - Calculate the amount of data to copy
+ * @chan: Driver specific DMA channel
+ * @size: Total data that needs to be copied
+ * @done: Amount of data that has been already copied
+ *
+ * Return: Amount of data that has to be copied
+ */
+static int xilinx_dma_calc_copysize(struct xilinx_dma_chan *chan,
+				    int size, int done)
+{
+	size_t copy;
+
+	copy = min_t(size_t, size - done,
+		     chan->xdev->max_buffer_len);
+
+	return copy;
+}
+
 /**
  * xilinx_dma_tx_status - Get DMA transaction status
  * @dchan: DMA channel
@@ -1002,7 +1023,7 @@ static enum dma_status xilinx_dma_tx_status(struct dma_chan *dchan,
 			list_for_each_entry(segment, &desc->segments, node) {
 				hw = &segment->hw;
 				residue += (hw->control - hw->status) &
-					   XILINX_DMA_MAX_TRANS_LEN;
+					   chan->xdev->max_buffer_len;
 			}
 		}
 		spin_unlock_irqrestore(&chan->lock, flags);
@@ -1262,7 +1283,7 @@ static void xilinx_cdma_start_transfer(struct xilinx_dma_chan *chan)
 
 		/* Start the transfer */
 		dma_ctrl_write(chan, XILINX_DMA_REG_BTT,
-				hw->control & XILINX_DMA_MAX_TRANS_LEN);
+				hw->control & chan->xdev->max_buffer_len);
 	}
 
 	list_splice_tail_init(&chan->pending_list, &chan->active_list);
@@ -1365,7 +1386,7 @@ static void xilinx_dma_start_transfer(struct xilinx_dma_chan *chan)
 
 		/* Start the transfer */
 		dma_ctrl_write(chan, XILINX_DMA_REG_BTT,
-			       hw->control & XILINX_DMA_MAX_TRANS_LEN);
+			       hw->control & chan->xdev->max_buffer_len);
 	}
 
 	list_splice_tail_init(&chan->pending_list, &chan->active_list);
@@ -1729,7 +1750,7 @@ xilinx_cdma_prep_memcpy(struct dma_chan *dchan, dma_addr_t dma_dst,
 	struct xilinx_cdma_tx_segment *segment;
 	struct xilinx_cdma_desc_hw *hw;
 
-	if (!len || len > XILINX_DMA_MAX_TRANS_LEN)
+	if (!len || len > chan->xdev->max_buffer_len)
 		return NULL;
 
 	desc = xilinx_dma_alloc_tx_descriptor(chan);
@@ -1819,8 +1840,8 @@ static struct dma_async_tx_descriptor *xilinx_dma_prep_slave_sg(
 			 * Calculate the maximum number of bytes to transfer,
 			 * making sure it is less than the hw limit
 			 */
-			copy = min_t(size_t, sg_dma_len(sg) - sg_used,
-				     XILINX_DMA_MAX_TRANS_LEN);
+			copy = xilinx_dma_calc_copysize(chan, sg_dma_len(sg),
+							sg_used);
 			hw = &segment->hw;
 
 			/* Fill in the descriptor */
@@ -1924,8 +1945,8 @@ static struct dma_async_tx_descriptor *xilinx_dma_prep_dma_cyclic(
 			 * Calculate the maximum number of bytes to transfer,
 			 * making sure it is less than the hw limit
 			 */
-			copy = min_t(size_t, period_len - sg_used,
-				     XILINX_DMA_MAX_TRANS_LEN);
+			copy = xilinx_dma_calc_copysize(chan, period_len,
+							sg_used);
 			hw = &segment->hw;
 			xilinx_axidma_buf(chan, hw, buf_addr, sg_used,
 					  period_len * i);
@@ -2645,6 +2666,8 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	/* Retrieve the DMA engine properties from the device tree */
 	xdev->has_sg = of_property_read_bool(node, "xlnx,include-sg");
+	xdev->max_buffer_len = XILINX_DMA_MAX_TRANS_LEN;
+
 	if (xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA)
 		xdev->mcdma = of_property_read_bool(node, "xlnx,mcdma");
 
-- 
2.39.0



