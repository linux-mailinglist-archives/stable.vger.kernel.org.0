Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675003AF2E0
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhFUR53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232693AbhFURzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E4761206;
        Mon, 21 Jun 2021 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297987;
        bh=B7X9n0KxSfKATjIy3luIVXkiz2zILgPhXb7wwnPFLKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7gUSvXu4jP28jc4P5sugh6knMM9Z1emNFJHYgvVJ37H/s8V7k9ZFWyBnzQ+wz9lx
         O7DJNnEkQONdVwRgxyTTJ7YzVgD/aedkq9UYMbnBv8L5UP/Jp5xlX28qWKjx6JTCA2
         AkyYfQxPLtPRrC1Eg3TXBvi5JT5gJ4QX0+2TNr7ClSgViRTOGdvkuAgSCUrjed4WLF
         hqgDXHaJjKwx7Jy7OvwVxyzlHHfStfsxht2MCCkdjAOorcfo/zK0KGTC6gmW0iU2Ly
         qTTmMzVofBlljtp/zs3BHRKL+S5b0JUrJMCYo40IF4uBrpM0Tk+NP2e/ksSw8UNWFs
         rluTP8nmWKJHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jianqiang Chen <jianqiang.chen@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 04/35] dmaengine: xilinx: dpdma: Limit descriptor IDs to 16 bits
Date:   Mon, 21 Jun 2021 13:52:29 -0400
Message-Id: <20210621175300.735437-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 9f007e7b6643799e2a6538a5fe04f51c371c6657 ]

While the descriptor ID is stored in a 32-bit field in the hardware
descriptor, only 16 bits are used by the hardware and are reported
through the XILINX_DPDMA_CH_DESC_ID register. Failure to handle the
wrap-around results in a descriptor ID mismatch after 65536 frames. Fix
it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Jianqiang Chen <jianqiang.chen@xilinx.com>
Reviewed-by: Jianqiang Chen <jianqiang.chen@xilinx.com>
Link: https://lore.kernel.org/r/20210520152420.23986-5-laurent.pinchart@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dpdma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dpdma.c b/drivers/dma/xilinx/xilinx_dpdma.c
index 70b29bd079c9..249ce3988a59 100644
--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -113,6 +113,7 @@
 #define XILINX_DPDMA_CH_VDO				0x020
 #define XILINX_DPDMA_CH_PYLD_SZ				0x024
 #define XILINX_DPDMA_CH_DESC_ID				0x028
+#define XILINX_DPDMA_CH_DESC_ID_MASK			GENMASK(15, 0)
 
 /* DPDMA descriptor fields */
 #define XILINX_DPDMA_DESC_CONTROL_PREEMBLE		0xa5
@@ -866,7 +867,8 @@ static void xilinx_dpdma_chan_queue_transfer(struct xilinx_dpdma_chan *chan)
 	 * will be used, but it should be enough.
 	 */
 	list_for_each_entry(sw_desc, &desc->descriptors, node)
-		sw_desc->hw.desc_id = desc->vdesc.tx.cookie;
+		sw_desc->hw.desc_id = desc->vdesc.tx.cookie
+				    & XILINX_DPDMA_CH_DESC_ID_MASK;
 
 	sw_desc = list_first_entry(&desc->descriptors,
 				   struct xilinx_dpdma_sw_desc, node);
@@ -1086,7 +1088,8 @@ static void xilinx_dpdma_chan_vsync_irq(struct  xilinx_dpdma_chan *chan)
 	if (!chan->running || !pending)
 		goto out;
 
-	desc_id = dpdma_read(chan->reg, XILINX_DPDMA_CH_DESC_ID);
+	desc_id = dpdma_read(chan->reg, XILINX_DPDMA_CH_DESC_ID)
+		& XILINX_DPDMA_CH_DESC_ID_MASK;
 
 	/* If the retrigger raced with vsync, retry at the next frame. */
 	sw_desc = list_first_entry(&pending->descriptors,
-- 
2.30.2

