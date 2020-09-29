Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B58727CBD4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732965AbgI2Mav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbgI2L3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA9CD23A6C;
        Tue, 29 Sep 2020 11:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378647;
        bh=Mmmn4O9DHxEkZ0A4g/zA5vFLwhO4s+XICS06F85x+Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNqrJYDnzp9+XlNZu0PbDZ1OSic1hOq8UxKa7rbCShbKHjj+rcwtZHqDZI971Jjxm
         /fbtAu9AosJ0yur6P4PkNnt/kYmrHizMmAHVGTqhrLVWELAaOfNG6gxzfaN/z526F/
         oDdF/DM58zH/GEXozhS2FNVSJAUe7M5RQ7tyJyak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/245] dmaengine: stm32-dma: use vchan_terminate_vdesc() in .terminate_all
Date:   Tue, 29 Sep 2020 12:59:00 +0200
Message-Id: <20200929105951.319112891@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit d80cbef35bf89b763f06e03bb4ff8f933bf012c5 ]

To avoid race with vchan_complete, use the race free way to terminate
running transfer.

Move vdesc->node list_del in stm32_dma_start_transfer instead of in
stm32_mdma_chan_complete to avoid another race in vchan_dma_desc_free_list.

Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Link: https://lore.kernel.org/r/20200129153628.29329-9-amelie.delaunay@st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index 4903a408fc146..ac7af440f8658 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -494,8 +494,10 @@ static int stm32_dma_terminate_all(struct dma_chan *c)
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);
 
-	if (chan->busy) {
-		stm32_dma_stop(chan);
+	if (chan->desc) {
+		vchan_terminate_vdesc(&chan->desc->vdesc);
+		if (chan->busy)
+			stm32_dma_stop(chan);
 		chan->desc = NULL;
 	}
 
@@ -551,6 +553,8 @@ static void stm32_dma_start_transfer(struct stm32_dma_chan *chan)
 		if (!vdesc)
 			return;
 
+		list_del(&vdesc->node);
+
 		chan->desc = to_stm32_dma_desc(vdesc);
 		chan->next_sg = 0;
 	}
@@ -628,7 +632,6 @@ static void stm32_dma_handle_chan_done(struct stm32_dma_chan *chan)
 		} else {
 			chan->busy = false;
 			if (chan->next_sg == chan->desc->num_sgs) {
-				list_del(&chan->desc->vdesc.node);
 				vchan_cookie_complete(&chan->desc->vdesc);
 				chan->desc = NULL;
 			}
-- 
2.25.1



