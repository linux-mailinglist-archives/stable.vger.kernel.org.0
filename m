Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8C2468DE
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfFNU2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfFNU2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:48 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB6962184C;
        Fri, 14 Jun 2019 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544128;
        bh=9lGgRzI3zEztZ1I/AYHiU7Qsz3qwOIwZ3463BMGqp94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcuXPMSYH1jGR84d/g6k2ejCuxcjW/HN4SWq3FJkMWGDw2dt8hmGFDWiNKhcWATAs
         +P1+rbXik5H/aAgJfm8gM+250P++cztQ4kzCKLoYjpY3cJ2upcqcCGXMI1/deFEa9H
         dxLTyvLJEFx/VPlaCdyMkxh5j7SGkDHlFcwD9Zgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 03/59] dmaengine: jz4780: Fix transfers being ACKed too soon
Date:   Fri, 14 Jun 2019 16:27:47 -0400
Message-Id: <20190614202843.26941-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

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

