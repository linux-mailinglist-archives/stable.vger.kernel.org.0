Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41FB50797
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfFXKIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbfFXKIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:16 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D3E82063F;
        Mon, 24 Jun 2019 10:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370894;
        bh=hmuKHWT6v4vc5lkvUgMLOlwIAVQJrNlVbbSNKOPQL28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11i2B5vaWigpOvmkZTK+e8Xxm2HgTGerHaq661YVnKPv0eat4i4IgBwpKQCJJNFCy
         f8egwjgsYO6QJxZSELNAs3KrLz62nMNDOL83NXRHwUitecWSiHYwwutPCc2At2VsvI
         wtdRpw2/DvUwLcZ7hGLWkb4gftugEzo839bAiSCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 033/121] dmaengine: jz4780: Fix transfers being ACKed too soon
Date:   Mon, 24 Jun 2019 17:56:05 +0800
Message-Id: <20190624092322.524417776@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4e4106f5e942bff65548e82fc330d40385c89220 ]

When a multi-descriptor DMA transfer is in progress, the "IRQ pending"
flag will apparently be set for that channel as soon as the last
descriptor loads, way before the IRQ actually happens. This behaviour
has been observed on the JZ4725B, but maybe other SoCs are affected.

In the case where another DMA transfer is running into completion on a
separate channel, the IRQ handler would then run the completion handler
for our previous channel even if the transfer didn't actually finish.

Fix this by checking in the completion handler that we're indeed done;
if not the interrupted DMA transfer will simply be resumed.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-jz4780.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dma-jz4780.c b/drivers/dma/dma-jz4780.c
index 9ce0a386225b..f49534019d37 100644
--- a/drivers/dma/dma-jz4780.c
+++ b/drivers/dma/dma-jz4780.c
@@ -666,10 +666,11 @@ static enum dma_status jz4780_dma_tx_status(struct dma_chan *chan,
 	return status;
 }
 
-static void jz4780_dma_chan_irq(struct jz4780_dma_dev *jzdma,
-	struct jz4780_dma_chan *jzchan)
+static bool jz4780_dma_chan_irq(struct jz4780_dma_dev *jzdma,
+				struct jz4780_dma_chan *jzchan)
 {
 	uint32_t dcs;
+	bool ack = true;
 
 	spin_lock(&jzchan->vchan.lock);
 
@@ -692,12 +693,20 @@ static void jz4780_dma_chan_irq(struct jz4780_dma_dev *jzdma,
 		if ((dcs & (JZ_DMA_DCS_AR | JZ_DMA_DCS_HLT)) == 0) {
 			if (jzchan->desc->type == DMA_CYCLIC) {
 				vchan_cyclic_callback(&jzchan->desc->vdesc);
-			} else {
+
+				jz4780_dma_begin(jzchan);
+			} else if (dcs & JZ_DMA_DCS_TT) {
 				vchan_cookie_complete(&jzchan->desc->vdesc);
 				jzchan->desc = NULL;
-			}
 
-			jz4780_dma_begin(jzchan);
+				jz4780_dma_begin(jzchan);
+			} else {
+				/* False positive - continue the transfer */
+				ack = false;
+				jz4780_dma_chn_writel(jzdma, jzchan->id,
+						      JZ_DMA_REG_DCS,
+						      JZ_DMA_DCS_CTE);
+			}
 		}
 	} else {
 		dev_err(&jzchan->vchan.chan.dev->device,
@@ -705,21 +714,22 @@ static void jz4780_dma_chan_irq(struct jz4780_dma_dev *jzdma,
 	}
 
 	spin_unlock(&jzchan->vchan.lock);
+
+	return ack;
 }
 
 static irqreturn_t jz4780_dma_irq_handler(int irq, void *data)
 {
 	struct jz4780_dma_dev *jzdma = data;
+	unsigned int nb_channels = jzdma->soc_data->nb_channels;
 	uint32_t pending, dmac;
 	int i;
 
 	pending = jz4780_dma_ctrl_readl(jzdma, JZ_DMA_REG_DIRQP);
 
-	for (i = 0; i < jzdma->soc_data->nb_channels; i++) {
-		if (!(pending & (1<<i)))
-			continue;
-
-		jz4780_dma_chan_irq(jzdma, &jzdma->chan[i]);
+	for_each_set_bit(i, (unsigned long *)&pending, nb_channels) {
+		if (jz4780_dma_chan_irq(jzdma, &jzdma->chan[i]))
+			pending &= ~BIT(i);
 	}
 
 	/* Clear halt and address error status of all channels. */
@@ -728,7 +738,7 @@ static irqreturn_t jz4780_dma_irq_handler(int irq, void *data)
 	jz4780_dma_ctrl_writel(jzdma, JZ_DMA_REG_DMAC, dmac);
 
 	/* Clear interrupt pending status. */
-	jz4780_dma_ctrl_writel(jzdma, JZ_DMA_REG_DIRQP, 0);
+	jz4780_dma_ctrl_writel(jzdma, JZ_DMA_REG_DIRQP, pending);
 
 	return IRQ_HANDLED;
 }
-- 
2.20.1



