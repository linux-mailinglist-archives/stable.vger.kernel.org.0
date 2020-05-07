Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4421C8E77
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEGO1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgEGO1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798162083B;
        Thu,  7 May 2020 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861653;
        bh=nldiJ+MHYYN+kjgAX5mo6jUIk7pC/Xc/j4g2G7Uco6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0s4o+5EI+KKTv1EgVraZSnAfNcypP9onwpJf01GmePNVCzCRa9kHDOdp2JmKvYAR
         QtzvVzwnfVW3XUo6M556Gizb5EI8oMj9cvYjDBNL59gnAAmOwQK3XM/R7wVj+WZJUZ
         eA8cU4ZevAU/7OzP0/EfaWKkx4XzjRT8pJYN7l+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian von Ohr <vonohr@smaract.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 05/50] dmaengine: xilinx_dma: Add missing check for empty list
Date:   Thu,  7 May 2020 10:26:41 -0400
Message-Id: <20200507142726.25751-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian von Ohr <vonohr@smaract.com>

[ Upstream commit b269426011bcfd97b7c3101abfe1a99147b6f40b ]

The DMA transfer might finish just after checking the state with
dma_cookie_status, but before the lock is acquired. Not checking
for an empty list in xilinx_dma_tx_status may result in reading
random data or data corruption when desc is written to. This can
be reliably triggered by using dma_sync_wait to wait for DMA
completion.

Signed-off-by: Sebastian von Ohr <vonohr@smaract.com>
Tested-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/20200303130518.333-1-vonohr@smaract.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index a9c5d5cc9f2bd..5d5f1d0ce16cb 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1229,16 +1229,16 @@ static enum dma_status xilinx_dma_tx_status(struct dma_chan *dchan,
 		return ret;
 
 	spin_lock_irqsave(&chan->lock, flags);
-
-	desc = list_last_entry(&chan->active_list,
-			       struct xilinx_dma_tx_descriptor, node);
-	/*
-	 * VDMA and simple mode do not support residue reporting, so the
-	 * residue field will always be 0.
-	 */
-	if (chan->has_sg && chan->xdev->dma_config->dmatype != XDMA_TYPE_VDMA)
-		residue = xilinx_dma_get_residue(chan, desc);
-
+	if (!list_empty(&chan->active_list)) {
+		desc = list_last_entry(&chan->active_list,
+				       struct xilinx_dma_tx_descriptor, node);
+		/*
+		 * VDMA and simple mode do not support residue reporting, so the
+		 * residue field will always be 0.
+		 */
+		if (chan->has_sg && chan->xdev->dma_config->dmatype != XDMA_TYPE_VDMA)
+			residue = xilinx_dma_get_residue(chan, desc);
+	}
 	spin_unlock_irqrestore(&chan->lock, flags);
 
 	dma_set_residue(txstate, residue);
-- 
2.20.1

