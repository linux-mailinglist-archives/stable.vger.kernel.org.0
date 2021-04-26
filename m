Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0586136AE97
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhDZHpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbhDZHoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EBFA613D3;
        Mon, 26 Apr 2021 07:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422827;
        bh=OfTZhQVCkfP1iUoe6FXBgYEwvVROmP5JhRAWr8lWs4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mE+ELAv1IsRxgCBqv0cIov6R9HCIX4ar+emJ7RijcEm/tNgEoBs3JaSyQ4mqstZ4K
         aSoL84aW5HCvJZbvYiVZa191Inl4iIDInyIh+nQJ93XAWDEClXyc9im3VKumOyIZ5q
         K1/HWYbHv/XzhyPs2q7yownCm+/yXMw/hq7HRS7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/36] dmaengine: xilinx: dpdma: Fix race condition in done IRQ
Date:   Mon, 26 Apr 2021 09:30:06 +0200
Message-Id: <20210426072819.616178987@linuxfoundation.org>
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

[ Upstream commit 868833fbffbe51c487df4f95d4de9194264a4b30 ]

The active descriptor pointer is accessed from different contexts,
including different interrupt handlers, and its access must be protected
by the channel's lock. This wasn't done in the done IRQ handler. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20210307040629.29308-3-laurent.pinchart@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dpdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dpdma.c b/drivers/dma/xilinx/xilinx_dpdma.c
index d504112c609e..70b29bd079c9 100644
--- a/drivers/dma/xilinx/xilinx_dpdma.c
+++ b/drivers/dma/xilinx/xilinx_dpdma.c
@@ -1048,13 +1048,14 @@ static int xilinx_dpdma_chan_stop(struct xilinx_dpdma_chan *chan)
  */
 static void xilinx_dpdma_chan_done_irq(struct xilinx_dpdma_chan *chan)
 {
-	struct xilinx_dpdma_tx_desc *active = chan->desc.active;
+	struct xilinx_dpdma_tx_desc *active;
 	unsigned long flags;
 
 	spin_lock_irqsave(&chan->lock, flags);
 
 	xilinx_dpdma_debugfs_desc_done_irq(chan);
 
+	active = chan->desc.active;
 	if (active)
 		vchan_cyclic_callback(&active->vdesc);
 	else
-- 
2.30.2



