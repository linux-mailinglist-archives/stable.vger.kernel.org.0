Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10F827C51F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgI2LbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgI2L3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C28BF23A61;
        Tue, 29 Sep 2020 11:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378636;
        bh=elcW+3rFUndpO2AS3fsDWk3P0VNT7odMINnacH0N4jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntWMR0H03C5rZ7DGVoxkQeoxeIG1nCkBQ9IftXhJEmhw2dUESrarK2qFsx1aNH79F
         Sk6nYmfTJ+rQvLXrnpE3y+79jc/0ctWAJtziPtHSlCfpca5KWBRWQ3BXW4hErtGSBQ
         tcmXG/ZouddPnCXMG/3WtMPyX3p+ruAuDaQPFKcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/245] dmaengine: stm32-mdma: use vchan_terminate_vdesc() in .terminate_all
Date:   Tue, 29 Sep 2020 12:58:56 +0200
Message-Id: <20200929105951.128539030@linuxfoundation.org>
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

[ Upstream commit dfc708812a2acfc0ca56f56233b3c3e7b0d4ffe7 ]

To avoid race with vchan_complete, use the race free way to terminate
running transfer.

Move vdesc->node list_del in stm32_mdma_start_transfer instead of in
stm32_mdma_xfer_end to avoid another race in vchan_dma_desc_free_list.

Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Link: https://lore.kernel.org/r/20200127085334.13163-7-amelie.delaunay@st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index 8c3c3e5b812a8..9c6867916e890 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1137,6 +1137,8 @@ static void stm32_mdma_start_transfer(struct stm32_mdma_chan *chan)
 		return;
 	}
 
+	list_del(&vdesc->node);
+
 	chan->desc = to_stm32_mdma_desc(vdesc);
 	hwdesc = chan->desc->node[0].hwdesc;
 	chan->curr_hwdesc = 0;
@@ -1252,8 +1254,10 @@ static int stm32_mdma_terminate_all(struct dma_chan *c)
 	LIST_HEAD(head);
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);
-	if (chan->busy) {
-		stm32_mdma_stop(chan);
+	if (chan->desc) {
+		vchan_terminate_vdesc(&chan->desc->vdesc);
+		if (chan->busy)
+			stm32_mdma_stop(chan);
 		chan->desc = NULL;
 	}
 	vchan_get_all_descriptors(&chan->vchan, &head);
@@ -1341,7 +1345,6 @@ static enum dma_status stm32_mdma_tx_status(struct dma_chan *c,
 
 static void stm32_mdma_xfer_end(struct stm32_mdma_chan *chan)
 {
-	list_del(&chan->desc->vdesc.node);
 	vchan_cookie_complete(&chan->desc->vdesc);
 	chan->desc = NULL;
 	chan->busy = false;
-- 
2.25.1



