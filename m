Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163CD628031
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbiKNNDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiKNNDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4B51DDE4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D4A561175
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAEEC43470;
        Mon, 14 Nov 2022 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431022;
        bh=NppQ2jSeoicOzbkqFbrtLmKB4a1Sra+jLbaEEUTFi+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+1Zx3ofXiJdlpD5znKMIGcjr164b3Ny3clqhWkPN9yTcnzdFcVgXgeJtKWRBbK1N
         QsM/aln2kJWeJruzT3/PdidQlOhZm9rLKRccbXzavZ6dKnXD0BGZQ9E62lDDwu0iDB
         YwS5V+JCY42jDYadjMmJzZTDWmCS/qTouyhPxsX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 070/190] dmaengine: stm32-dma: fix potential race between pause and resume
Date:   Mon, 14 Nov 2022 13:44:54 +0100
Message-Id: <20221114124501.763018979@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 140fd5e74a1cc7413df88c735fff5ec64d33c1d3 ]

When disabling dma channel, a TCF flag is set and as TCIE is enabled, an
interrupt is raised.
On a busy system, the interrupt may have latency and the user can ask for
dmaengine_resume while stm32-dma driver has not yet managed the complete
pause (backup of registers to restore state in resume).
To avoid such a case, instead of waiting the interrupt to backup the
registers, do it just after disabling the channel and discard Transfer
Complete interrupt in case the channel is paused.

Fixes: 099a9a94be0e ("dmaengine: stm32-dma: add device_pause/device_resume support")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20221024083611.132588-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dma.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index adb25a11c70f..5aeaaac846df 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -663,6 +663,8 @@ static void stm32_dma_handle_chan_paused(struct stm32_dma_chan *chan)
 
 	chan->chan_reg.dma_sndtr = stm32_dma_read(dmadev, STM32_DMA_SNDTR(chan->id));
 
+	chan->status = DMA_PAUSED;
+
 	dev_dbg(chan2dev(chan), "vchan %pK: paused\n", &chan->vchan);
 }
 
@@ -775,9 +777,7 @@ static irqreturn_t stm32_dma_chan_irq(int irq, void *devid)
 	if (status & STM32_DMA_TCI) {
 		stm32_dma_irq_clear(chan, STM32_DMA_TCI);
 		if (scr & STM32_DMA_SCR_TCIE) {
-			if (chan->status == DMA_PAUSED && !(scr & STM32_DMA_SCR_EN))
-				stm32_dma_handle_chan_paused(chan);
-			else
+			if (chan->status != DMA_PAUSED)
 				stm32_dma_handle_chan_done(chan, scr);
 		}
 		status &= ~STM32_DMA_TCI;
@@ -824,13 +824,11 @@ static int stm32_dma_pause(struct dma_chan *c)
 		return -EPERM;
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);
+
 	ret = stm32_dma_disable_chan(chan);
-	/*
-	 * A transfer complete flag is set to indicate the end of transfer due to the stream
-	 * interruption, so wait for interrupt
-	 */
 	if (!ret)
-		chan->status = DMA_PAUSED;
+		stm32_dma_handle_chan_paused(chan);
+
 	spin_unlock_irqrestore(&chan->vchan.lock, flags);
 
 	return ret;
-- 
2.35.1



