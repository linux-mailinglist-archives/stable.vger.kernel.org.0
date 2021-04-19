Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0023364B5E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242296AbhDSUoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242263AbhDSUoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 706E7613B0;
        Mon, 19 Apr 2021 20:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865034;
        bh=Pcw49y1E0fdtvfEUzDApg+mSF6Eqc3PK/dvzuvX2dm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejgs4JOdjCYpJjOsZFJrH8Z9EqT0L097caFmLNcbY94W/BYGZTeCtwc7e0Kcj1F5+
         JP0n5zgPXIaJpwMvRC2RG4evpjZRpWFx6WUTQyjQZvbYJWybSNtDJGOfvkhxfjRY1/
         ucT3k9f9Dy5LSj9rVeh0jd3R/QdcKp20W2j8AlHOpznOmXdIRI4WD4WMsxJGEZO+JV
         +AlCG1UPvBBtTdgtTZMui77o2RyOl0q/GRraUWHy0wBSgtxeYDuFCNYtbX32t8Wd9x
         c4s65qeoSolCtOkB5Fmh6/ZiWcDwI0nqjDm6XxXcWvpwesS6E8xj891FI+KAi32aqT
         BveTRwVfUpBqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 07/23] dmaengine: xilinx: dpdma: Fix descriptor issuing on video group
Date:   Mon, 19 Apr 2021 16:43:26 -0400
Message-Id: <20210419204343.6134-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

