Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D28364B62
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbhDSUo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242292AbhDSUo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C69D8613AB;
        Mon, 19 Apr 2021 20:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865035;
        bh=OfTZhQVCkfP1iUoe6FXBgYEwvVROmP5JhRAWr8lWs4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQ02tuhpd+QiZksGD5hKEoCq+zA20FnMq129QqfN1jBqm5YgehhSbFgPBAe414voB
         iQGC6TuDUsHaMHHaodyrO1wTikQafriPKciAQsEPUkah6P2bqu2djH3S5vVyDVBD9Q
         tYjfVhBFcikhj54kOI2Ps5MmRukoQcDXAnm8Qae9F+Wn/w9qelvo3LzKHtLqhPHInS
         SlzQUitRfzFQmgpgLWvJLywLST6lhcijYAnDpd1WM9KjRMiCyHsgWteZcX8JYU6Vx8
         M+01MbSkrVYlCSJxEgHwwEcKapS206a0aG4E5JP0mgpQ/ryYyvQQe/pN8GIntdplwr
         dtK1UZM1ECdqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 08/23] dmaengine: xilinx: dpdma: Fix race condition in done IRQ
Date:   Mon, 19 Apr 2021 16:43:27 -0400
Message-Id: <20210419204343.6134-8-sashal@kernel.org>
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

