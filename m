Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F9A6D495C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjDCOhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjDCOha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE6817652
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 951CEB81CA5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A76DC433EF;
        Mon,  3 Apr 2023 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532620;
        bh=Xi4epnogONCAT5ET1vpW3LUGs7hLcXX/JzAAj0WSQEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp7E90gATlDF3IxkLGuC931uefgrSg1edWhx0+SsbTq0n7Y3tVnUYEa11zwgXeTrH
         9rA91UsJIcP5NV+HBk3/HFCsQ+jTPN9ekdKlV1oa1XltXSaDtGBCuT3DCcmnJXPkOJ
         Y250l4xYFjTeb7XQ2W4sGfsr6aZuBVKRqYmqYbgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/181] tty: serial: fsl_lpuart: switch to new dmaengine_terminate_* API
Date:   Mon,  3 Apr 2023 16:07:38 +0200
Message-Id: <20230403140415.899806993@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 8682ab0eea89c300ebb120c02ead3999ca5560a8 ]

Convert dmaengine_terminate_all() calls to synchronous and asynchronous
versions where appropriate.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221123023619.30173-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1be6f2b15f90 ("tty: serial: fsl_lpuart: fix race on RX DMA shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index c51883f34ac2b..86e96696ab26d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -582,7 +582,7 @@ static void lpuart_flush_buffer(struct uart_port *port)
 				sport->dma_tx_nents, DMA_TO_DEVICE);
 			sport->dma_tx_in_progress = false;
 		}
-		dmaengine_terminate_all(chan);
+		dmaengine_terminate_async(chan);
 	}
 
 	if (lpuart_is_32(sport)) {
@@ -1333,7 +1333,7 @@ static void lpuart_dma_rx_free(struct uart_port *port)
 					struct lpuart_port, port);
 	struct dma_chan *chan = sport->dma_rx_chan;
 
-	dmaengine_terminate_all(chan);
+	dmaengine_terminate_sync(chan);
 	dma_unmap_sg(chan->device->dev, &sport->rx_sgl, 1, DMA_FROM_DEVICE);
 	kfree(sport->rx_ring.buf);
 	sport->rx_ring.tail = 0;
@@ -1766,7 +1766,7 @@ static void lpuart_dma_shutdown(struct lpuart_port *sport)
 		if (wait_event_interruptible_timeout(sport->dma_wait,
 			!sport->dma_tx_in_progress, msecs_to_jiffies(300)) <= 0) {
 			sport->dma_tx_in_progress = false;
-			dmaengine_terminate_all(sport->dma_tx_chan);
+			dmaengine_terminate_sync(sport->dma_tx_chan);
 		}
 		sport->lpuart_dma_tx_use = false;
 	}
@@ -2867,7 +2867,7 @@ static int __maybe_unused lpuart_suspend(struct device *dev)
 
 	if (sport->lpuart_dma_tx_use) {
 		sport->dma_tx_in_progress = false;
-		dmaengine_terminate_all(sport->dma_tx_chan);
+		dmaengine_terminate_sync(sport->dma_tx_chan);
 	}
 
 	if (sport->port.suspended && !irq_wake)
-- 
2.39.2



