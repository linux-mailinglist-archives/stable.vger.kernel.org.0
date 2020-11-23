Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2910D2C09D6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgKWNNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731747AbgKWMpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66A8A20857;
        Mon, 23 Nov 2020 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135540;
        bh=rG0LxXNPM1cFIYQnqk4kaHxLz5JcdwvHuRZIbsYjYAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuEToCVaITjJi/g8H0ooOzi6+IkXx2YThmQf0nBetiDagydm6aKuzqYAUlMr51s3M
         W1TinSVd8xHbrTVXWGY5HA6Qj9e7KnYVbCG0sy4/zTPqIpALtWo6E5RNFwbKipe0y+
         jtL7gowjPQSUVhnK/7tChY8TCNPiagBUcpnrPdRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Murrian <matthew.murrian@goctsi.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 104/252] dmaengine: xilinx_dma: Fix usage of xilinx_aximcdma_tx_segment
Date:   Mon, 23 Nov 2020 13:20:54 +0100
Message-Id: <20201123121840.603004702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Murrian <matthew.murrian@goctsi.com>

[ Upstream commit c8ae7932997d0cc92d016829138074c7520248e5 ]

Several code sections incorrectly use struct xilinx_axidma_tx_segment
instead of struct xilinx_aximcdma_tx_segment when operating as
Multichannel DMA. As their structures are similar, this just works.

Fixes: 6ccd692bfb7f ("dmaengine: xilinx_dma: Add Xilinx AXI MCDMA Engine driver support")
Signed-off-by: Matthew Murrian <matthew.murrian@goctsi.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1604473206-32573-3-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 5429497d3560b..f0662f6672ff9 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -948,8 +948,10 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
 {
 	struct xilinx_cdma_tx_segment *cdma_seg;
 	struct xilinx_axidma_tx_segment *axidma_seg;
+	struct xilinx_aximcdma_tx_segment *aximcdma_seg;
 	struct xilinx_cdma_desc_hw *cdma_hw;
 	struct xilinx_axidma_desc_hw *axidma_hw;
+	struct xilinx_aximcdma_desc_hw *aximcdma_hw;
 	struct list_head *entry;
 	u32 residue = 0;
 
@@ -961,13 +963,23 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
 			cdma_hw = &cdma_seg->hw;
 			residue += (cdma_hw->control - cdma_hw->status) &
 				   chan->xdev->max_buffer_len;
-		} else {
+		} else if (chan->xdev->dma_config->dmatype ==
+			   XDMA_TYPE_AXIDMA) {
 			axidma_seg = list_entry(entry,
 						struct xilinx_axidma_tx_segment,
 						node);
 			axidma_hw = &axidma_seg->hw;
 			residue += (axidma_hw->control - axidma_hw->status) &
 				   chan->xdev->max_buffer_len;
+		} else {
+			aximcdma_seg =
+				list_entry(entry,
+					   struct xilinx_aximcdma_tx_segment,
+					   node);
+			aximcdma_hw = &aximcdma_seg->hw;
+			residue +=
+				(aximcdma_hw->control - aximcdma_hw->status) &
+				chan->xdev->max_buffer_len;
 		}
 	}
 
@@ -1135,7 +1147,7 @@ static int xilinx_dma_alloc_chan_resources(struct dma_chan *dchan)
 			upper_32_bits(chan->seg_p + sizeof(*chan->seg_mv) *
 				((i + 1) % XILINX_DMA_NUM_DESCS));
 			chan->seg_mv[i].phys = chan->seg_p +
-				sizeof(*chan->seg_v) * i;
+				sizeof(*chan->seg_mv) * i;
 			list_add_tail(&chan->seg_mv[i].node,
 				      &chan->free_seg_list);
 		}
@@ -1560,7 +1572,7 @@ static void xilinx_dma_start_transfer(struct xilinx_dma_chan *chan)
 static void xilinx_mcdma_start_transfer(struct xilinx_dma_chan *chan)
 {
 	struct xilinx_dma_tx_descriptor *head_desc, *tail_desc;
-	struct xilinx_axidma_tx_segment *tail_segment;
+	struct xilinx_aximcdma_tx_segment *tail_segment;
 	u32 reg;
 
 	/*
@@ -1582,7 +1594,7 @@ static void xilinx_mcdma_start_transfer(struct xilinx_dma_chan *chan)
 	tail_desc = list_last_entry(&chan->pending_list,
 				    struct xilinx_dma_tx_descriptor, node);
 	tail_segment = list_last_entry(&tail_desc->segments,
-				       struct xilinx_axidma_tx_segment, node);
+				       struct xilinx_aximcdma_tx_segment, node);
 
 	reg = dma_ctrl_read(chan, XILINX_MCDMA_CHAN_CR_OFFSET(chan->tdest));
 
@@ -1864,6 +1876,7 @@ static void append_desc_queue(struct xilinx_dma_chan *chan,
 	struct xilinx_vdma_tx_segment *tail_segment;
 	struct xilinx_dma_tx_descriptor *tail_desc;
 	struct xilinx_axidma_tx_segment *axidma_tail_segment;
+	struct xilinx_aximcdma_tx_segment *aximcdma_tail_segment;
 	struct xilinx_cdma_tx_segment *cdma_tail_segment;
 
 	if (list_empty(&chan->pending_list))
@@ -1885,11 +1898,17 @@ static void append_desc_queue(struct xilinx_dma_chan *chan,
 						struct xilinx_cdma_tx_segment,
 						node);
 		cdma_tail_segment->hw.next_desc = (u32)desc->async_tx.phys;
-	} else {
+	} else if (chan->xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA) {
 		axidma_tail_segment = list_last_entry(&tail_desc->segments,
 					       struct xilinx_axidma_tx_segment,
 					       node);
 		axidma_tail_segment->hw.next_desc = (u32)desc->async_tx.phys;
+	} else {
+		aximcdma_tail_segment =
+			list_last_entry(&tail_desc->segments,
+					struct xilinx_aximcdma_tx_segment,
+					node);
+		aximcdma_tail_segment->hw.next_desc = (u32)desc->async_tx.phys;
 	}
 
 	/*
-- 
2.27.0



