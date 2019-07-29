Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B234797FE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388784AbfG2Tlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388871AbfG2Tlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:41:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992BB2171F;
        Mon, 29 Jul 2019 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429310;
        bh=AiRkER81Co8UQt0zlgmDGoi46MpkJjkhNRC9uvNMC1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WieRXmL/cLsesget8O9C244HIjG890q/MZInTuQivsmF+AOGF7w0qC8CO0gefsau1
         llxSZ+HftV1TQqfkBgFnL1Fo4izbO/nBHfXO6QwTeTCfVB8q/a34q4APTetcaLyxTv
         xsnsvYGf+B6Wx/QX40gpnF13ui8/5rjkTgrWDEX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/113] serial: sh-sci: Fix TX DMA buffer flushing and workqueue races
Date:   Mon, 29 Jul 2019 21:22:24 +0200
Message-Id: <20190729190709.142567610@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8493eab02608b0e82f67b892aa72882e510c31d0 ]

When uart_flush_buffer() is called, the .flush_buffer() callback zeroes
the tx_dma_len field.  This may race with the work queue function
handling transmit DMA requests:

  1. If the buffer is flushed before the first DMA API call,
     dmaengine_prep_slave_single() may be called with a zero length,
     causing the DMA request to never complete, leading to messages
     like:

        rcar-dmac e7300000.dma-controller: Channel Address Error happen

     and, with debug enabled:

	sh-sci e6e88000.serial: sci_dma_tx_work_fn: ffff800639b55000: 0...0, cookie 126

     and DMA timeouts.

  2. If the buffer is flushed after the first DMA API call, but before
     the second, dma_sync_single_for_device() may be called with a zero
     length, causing the transmit data not to be flushed to RAM, and
     leading to stale data being output.

Fix this by:
  1. Letting sci_dma_tx_work_fn() return immediately if the transmit
     buffer is empty,
  2. Extending the critical section to cover all DMA preparational work,
     so tx_dma_len stays consistent for all of it,
  3. Using local copies of circ_buf.head and circ_buf.tail, to make sure
     they match the actual operation above.

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Suggested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Link: https://lore.kernel.org/r/20190624123540.20629-2-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 71f12601e693..5550289e6678 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1376,6 +1376,7 @@ static void work_fn_tx(struct work_struct *work)
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned long flags;
 	dma_addr_t buf;
+	int head, tail;
 
 	/*
 	 * DMA is idle now.
@@ -1385,16 +1386,23 @@ static void work_fn_tx(struct work_struct *work)
 	 * consistent xmit buffer state.
 	 */
 	spin_lock_irq(&port->lock);
-	buf = s->tx_dma_addr + (xmit->tail & (UART_XMIT_SIZE - 1));
+	head = xmit->head;
+	tail = xmit->tail;
+	buf = s->tx_dma_addr + (tail & (UART_XMIT_SIZE - 1));
 	s->tx_dma_len = min_t(unsigned int,
-		CIRC_CNT(xmit->head, xmit->tail, UART_XMIT_SIZE),
-		CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE));
-	spin_unlock_irq(&port->lock);
+		CIRC_CNT(head, tail, UART_XMIT_SIZE),
+		CIRC_CNT_TO_END(head, tail, UART_XMIT_SIZE));
+	if (!s->tx_dma_len) {
+		/* Transmit buffer has been flushed */
+		spin_unlock_irq(&port->lock);
+		return;
+	}
 
 	desc = dmaengine_prep_slave_single(chan, buf, s->tx_dma_len,
 					   DMA_MEM_TO_DEV,
 					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
+		spin_unlock_irq(&port->lock);
 		dev_warn(port->dev, "Failed preparing Tx DMA descriptor\n");
 		goto switch_to_pio;
 	}
@@ -1402,18 +1410,18 @@ static void work_fn_tx(struct work_struct *work)
 	dma_sync_single_for_device(chan->device->dev, buf, s->tx_dma_len,
 				   DMA_TO_DEVICE);
 
-	spin_lock_irq(&port->lock);
 	desc->callback = sci_dma_tx_complete;
 	desc->callback_param = s;
-	spin_unlock_irq(&port->lock);
 	s->cookie_tx = dmaengine_submit(desc);
 	if (dma_submit_error(s->cookie_tx)) {
+		spin_unlock_irq(&port->lock);
 		dev_warn(port->dev, "Failed submitting Tx DMA descriptor\n");
 		goto switch_to_pio;
 	}
 
+	spin_unlock_irq(&port->lock);
 	dev_dbg(port->dev, "%s: %p: %d...%d, cookie %d\n",
-		__func__, xmit->buf, xmit->tail, xmit->head, s->cookie_tx);
+		__func__, xmit->buf, tail, head, s->cookie_tx);
 
 	dma_async_issue_pending(chan);
 	return;
-- 
2.20.1



