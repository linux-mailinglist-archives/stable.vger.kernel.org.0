Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C854C3E7F6C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhHJRkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233409AbhHJRgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:36:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D96610EA;
        Tue, 10 Aug 2021 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616944;
        bh=xHgfxz9wQATRqOjex35VnVIrpDufuV1SvTgYhWBlqA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ou/TInDv+Rx0W2yVHFgKrMjFuhDsWgh6gHjY0XPUG2EzTDEX6HLJtBhvOF0pjFH7e
         ssFhe1DfQUWvq06oBYSaHQpVnypQj9Bq/ODnwzT7ylOh4I8sWMzWPDiO16UT1T08zq
         2XCeDkXG28N5zMRvIDtZe2mfagmvNPZT2JzMmbAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiyong Tao <zhiyong.tao@mediatek.com>
Subject: [PATCH 5.4 62/85] serial: 8250_mtk: fix uart corruption issue when rx power off
Date:   Tue, 10 Aug 2021 19:30:35 +0200
Message-Id: <20210810172950.339027962@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiyong Tao <zhiyong.tao@mediatek.com>

commit 7c4a509d3815a260c423c0633bd73695250ac26d upstream.

Fix uart corruption issue when rx power off.
Add spin lock in mtk8250_dma_rx_complete function in APDMA mode.

when uart is used as a communication port with external device(GPS).
when external device(GPS) power off, the power of rx pin is also from
1.8v to 0v. Even if there is not any data in rx. But uart rx pin can
capture the data "0".
If uart don't receive any data in specified cycle, uart will generates
BI(Break interrupt) interrupt.
If external device(GPS) power off, we found that BI interrupt appeared
continuously and very frequently.
When uart interrupt type is BI, uart IRQ handler(8250 framwork
API:serial8250_handle_irq) will push data to tty buffer.
mtk8250_dma_rx_complete is a task of mtk_uart_apdma_rx_handler.
mtk8250_dma_rx_complete priority is lower than uart irq
handler(serial8250_handle_irq).
if we are in process of mtk8250_dma_rx_complete, uart appear BI
interrupt:1)serial8250_handle_irq will priority execution.2)it may cause
write tty buffer conflict in mtk8250_dma_rx_complete.
So the spin lock protect the rx receive data process is not break.

Signed-off-by: Zhiyong Tao <zhiyong.tao@mediatek.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210729084640.17613-2-zhiyong.tao@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -92,10 +92,13 @@ static void mtk8250_dma_rx_complete(void
 	struct dma_tx_state state;
 	int copied, total, cnt;
 	unsigned char *ptr;
+	unsigned long flags;
 
 	if (data->rx_status == DMA_RX_SHUTDOWN)
 		return;
 
+	spin_lock_irqsave(&up->port.lock, flags);
+
 	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
 	total = dma->rx_size - state.residue;
 	cnt = total;
@@ -119,6 +122,8 @@ static void mtk8250_dma_rx_complete(void
 	tty_flip_buffer_push(tty_port);
 
 	mtk8250_rx_dma(up);
+
+	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 static void mtk8250_rx_dma(struct uart_8250_port *up)


