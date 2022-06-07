Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEA3540759
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347934AbiFGRrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348796AbiFGRqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0F110F37E;
        Tue,  7 Jun 2022 10:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D24F8B8232B;
        Tue,  7 Jun 2022 17:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F5BC385A5;
        Tue,  7 Jun 2022 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623313;
        bh=5qujHslJKa+cLXDBzqLqbZbG/+Kawd142fQS2AP1TFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sh9LyvAwi89YJ+rmBqL+R/6N8CBVtRqWpMZLVSrJCCiZA+iIiCk/Lnk0xI/Xix76d
         ItMS1bPo1IRPqrPbGzeOhTpx0hYAwFt2k3be5SlIoVSZtCGDqslyi7Rctw/b6bOMiK
         ReY0fPCeJKdPidl81oJC8HRnlMK1qaFrVjzqH0PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 335/452] dmaengine: stm32-mdma: rework interrupt handler
Date:   Tue,  7 Jun 2022 19:03:12 +0200
Message-Id: <20220607164918.541734040@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit 1d3dd68749b9f4a4da272f39608d03b4bae0b69f ]

To avoid multiple entries in MDMA interrupt handler for each flag&interrupt
enable, manage all flags set at once.

Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Link: https://lore.kernel.org/r/20201120143320.30367-5-amelie.delaunay@st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 64 +++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index cd394624085a..4ec6f5b69f56 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1345,7 +1345,7 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 {
 	struct stm32_mdma_device *dmadev = devid;
 	struct stm32_mdma_chan *chan = devid;
-	u32 reg, id, ien, status, flag;
+	u32 reg, id, ccr, ien, status;
 
 	/* Find out which channel generates the interrupt */
 	status = readl_relaxed(dmadev->base + STM32_MDMA_GISR0);
@@ -1357,67 +1357,71 @@ static irqreturn_t stm32_mdma_irq_handler(int irq, void *devid)
 
 	chan = &dmadev->chan[id];
 	if (!chan) {
-		dev_dbg(mdma2dev(dmadev), "MDMA channel not initialized\n");
-		goto exit;
+		dev_warn(mdma2dev(dmadev), "MDMA channel not initialized\n");
+		return IRQ_NONE;
 	}
 
 	/* Handle interrupt for the channel */
 	spin_lock(&chan->vchan.lock);
-	status = stm32_mdma_read(dmadev, STM32_MDMA_CISR(chan->id));
-	ien = stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id));
-	ien &= STM32_MDMA_CCR_IRQ_MASK;
-	ien >>= 1;
+	status = stm32_mdma_read(dmadev, STM32_MDMA_CISR(id));
+	/* Mask Channel ReQuest Active bit which can be set in case of MEM2MEM */
+	status &= ~STM32_MDMA_CISR_CRQA;
+	ccr = stm32_mdma_read(dmadev, STM32_MDMA_CCR(id));
+	ien = (ccr & STM32_MDMA_CCR_IRQ_MASK) >> 1;
 
 	if (!(status & ien)) {
 		spin_unlock(&chan->vchan.lock);
-		dev_dbg(chan2dev(chan),
-			"spurious it (status=0x%04x, ien=0x%04x)\n",
-			status, ien);
+		dev_warn(chan2dev(chan),
+			 "spurious it (status=0x%04x, ien=0x%04x)\n",
+			 status, ien);
 		return IRQ_NONE;
 	}
 
-	flag = __ffs(status & ien);
-	reg = STM32_MDMA_CIFCR(chan->id);
+	reg = STM32_MDMA_CIFCR(id);
 
-	switch (1 << flag) {
-	case STM32_MDMA_CISR_TEIF:
-		id = chan->id;
-		status = readl_relaxed(dmadev->base + STM32_MDMA_CESR(id));
-		dev_err(chan2dev(chan), "Transfer Err: stat=0x%08x\n", status);
+	if (status & STM32_MDMA_CISR_TEIF) {
+		dev_err(chan2dev(chan), "Transfer Err: stat=0x%08x\n",
+			readl_relaxed(dmadev->base + STM32_MDMA_CESR(id)));
 		stm32_mdma_set_bits(dmadev, reg, STM32_MDMA_CIFCR_CTEIF);
-		break;
+		status &= ~STM32_MDMA_CISR_TEIF;
+	}
 
-	case STM32_MDMA_CISR_CTCIF:
+	if (status & STM32_MDMA_CISR_CTCIF) {
 		stm32_mdma_set_bits(dmadev, reg, STM32_MDMA_CIFCR_CCTCIF);
+		status &= ~STM32_MDMA_CISR_CTCIF;
 		stm32_mdma_xfer_end(chan);
-		break;
+	}
 
-	case STM32_MDMA_CISR_BRTIF:
+	if (status & STM32_MDMA_CISR_BRTIF) {
 		stm32_mdma_set_bits(dmadev, reg, STM32_MDMA_CIFCR_CBRTIF);
-		break;
+		status &= ~STM32_MDMA_CISR_BRTIF;
+	}
 
-	case STM32_MDMA_CISR_BTIF:
+	if (status & STM32_MDMA_CISR_BTIF) {
 		stm32_mdma_set_bits(dmadev, reg, STM32_MDMA_CIFCR_CBTIF);
+		status &= ~STM32_MDMA_CISR_BTIF;
 		chan->curr_hwdesc++;
 		if (chan->desc && chan->desc->cyclic) {
 			if (chan->curr_hwdesc == chan->desc->count)
 				chan->curr_hwdesc = 0;
 			vchan_cyclic_callback(&chan->desc->vdesc);
 		}
-		break;
+	}
 
-	case STM32_MDMA_CISR_TCIF:
+	if (status & STM32_MDMA_CISR_TCIF) {
 		stm32_mdma_set_bits(dmadev, reg, STM32_MDMA_CIFCR_CLTCIF);
-		break;
+		status &= ~STM32_MDMA_CISR_TCIF;
+	}
 
-	default:
-		dev_err(chan2dev(chan), "it %d unhandled (status=0x%04x)\n",
-			1 << flag, status);
+	if (status) {
+		stm32_mdma_set_bits(dmadev, reg, status);
+		dev_err(chan2dev(chan), "DMA error: status=0x%08x\n", status);
+		if (!(ccr & STM32_MDMA_CCR_EN))
+			dev_err(chan2dev(chan), "chan disabled by HW\n");
 	}
 
 	spin_unlock(&chan->vchan.lock);
 
-exit:
 	return IRQ_HANDLED;
 }
 
-- 
2.35.1



