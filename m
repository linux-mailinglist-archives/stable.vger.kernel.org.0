Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B860364BB3
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbhDSUp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240226AbhDSUpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BEA5613C0;
        Mon, 19 Apr 2021 20:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865070;
        bh=OfTZhQVCkfP1iUoe6FXBgYEwvVROmP5JhRAWr8lWs4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRAlI7/bXqzbqYQAaSFbve3Bgq7ZESFYNXukA1SGUP+mfk/rHENVbD9euzJUmk0yE
         93oTXAUB7KVdc7JpOBA0lnYQ1SzTP9soz+8TEpM8CLIUZxfwNRkVD822RS1vHXS+5O
         VKBOvQ7hu2rzlk9cwV/5Gmynv72lxePLTNFDivmbd6Gr8xd7/aIvlh9VDJZj4HjiQ+
         ilQK1osJ8CYMRcl2KfhI0VMxGGFlJawvJZkW5PlIV5ZZt5n6epduyWaFITcWVRxAkw
         eBCHsGshDWMwUs6ySKGNEFakWWuUMZCnXL1Zl25jKReOMvGTXXPL0nDfkPepmNlEMu
         oUnrZoCZtJodA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 07/21] dmaengine: xilinx: dpdma: Fix race condition in done IRQ
Date:   Mon, 19 Apr 2021 16:44:05 -0400
Message-Id: <20210419204420.6375-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204420.6375-1-sashal@kernel.org>
References: <20210419204420.6375-1-sashal@kernel.org>
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

