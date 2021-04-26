Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD9E36AE5E
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhDZHoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233669AbhDZHnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:43:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A639C613BC;
        Mon, 26 Apr 2021 07:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422777;
        bh=Pcw49y1E0fdtvfEUzDApg+mSF6Eqc3PK/dvzuvX2dm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=He0sKvZ6521PZrdY4gN6JpmeWX6WTryrkb8ozcBkREae4Zk8cHlasux4UpwR406bj
         iSA7i/PZzvWxlHm27YPsmuqtKA+IWABfYDYrO3TPLMGB46YuYgDizxkn+HF8v6Y3yO
         bQ5wsgJ3LoRtLkNFHHSwabRNDfyyRlwQLHfsvZyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/36] dmaengine: xilinx: dpdma: Fix descriptor issuing on video group
Date:   Mon, 26 Apr 2021 09:30:05 +0200
Message-Id: <20210426072819.580107876@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 1cbd44666216278bbb6a55bcb6b9283702171c77 ]

When multiple channels are part of a video group, the transfer is
triggered only when all channels in the group are ready. The logic to do
so is incorrect, as it causes the descriptors for all channels but the
last one in a group to not being pushed to the hardware. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20210307040629.29308-2-laurent.pinchart@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dpdma.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dpdma.c b/drivers/dma/xilinx/xilinx_dpdma.c
index 55df63dead8d..d504112c609e 100644
--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -839,6 +839,7 @@ static void xilinx_dpdma_chan_queue_transfer(struct xilinx_dpdma_chan *chan)
 	struct xilinx_dpdma_tx_desc *desc;
 	struct virt_dma_desc *vdesc;
 	u32 reg, channels;
+	bool first_frame;
 
 	lockdep_assert_held(&chan->lock);
 
@@ -852,14 +853,6 @@ static void xilinx_dpdma_chan_queue_transfer(struct xilinx_dpdma_chan *chan)
 		chan->running = true;
 	}
 
-	if (chan->video_group)
-		channels = xilinx_dpdma_chan_video_group_ready(chan);
-	else
-		channels = BIT(chan->id);
-
-	if (!channels)
-		return;
-
 	vdesc = vchan_next_desc(&chan->vchan);
 	if (!vdesc)
 		return;
@@ -884,13 +877,26 @@ static void xilinx_dpdma_chan_queue_transfer(struct xilinx_dpdma_chan *chan)
 			    FIELD_PREP(XILINX_DPDMA_CH_DESC_START_ADDRE_MASK,
 				       upper_32_bits(sw_desc->dma_addr)));
 
-	if (chan->first_frame)
+	first_frame = chan->first_frame;
+	chan->first_frame = false;
+
+	if (chan->video_group) {
+		channels = xilinx_dpdma_chan_video_group_ready(chan);
+		/*
+		 * Trigger the transfer only when all channels in the group are
+		 * ready.
+		 */
+		if (!channels)
+			return;
+	} else {
+		channels = BIT(chan->id);
+	}
+
+	if (first_frame)
 		reg = XILINX_DPDMA_GBL_TRIG_MASK(channels);
 	else
 		reg = XILINX_DPDMA_GBL_RETRIG_MASK(channels);
 
-	chan->first_frame = false;
-
 	dpdma_write(xdev->reg, XILINX_DPDMA_GBL, reg);
 }
 
-- 
2.30.2



