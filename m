Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917203DB2AD
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 07:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbhG3FQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 01:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237337AbhG3FP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 01:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7EBE60F6B;
        Fri, 30 Jul 2021 05:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627622124;
        bh=SZgPYAVk+Jn1ph5fyQURoEM4zoEZDM4DR0ObZtVKyRE=;
        h=Subject:To:From:Date:From;
        b=Y3vjM/bcUQuj+k8SwA/s/puitryDwDY0MJQNprAzmZl24UOPasSzRGYsW8D2G3w6f
         5hNReBUtr/W5ptvtMfTu03Y66XRETHGW545jflH9p3gW4VGoI0XsryPsmxFMKtrc4i
         VU3o+gX91di6CHv3vzyO902UZHXkjzJVCpFLB9UY=
Subject: patch "serial: 8250_mtk: fix uart corruption issue when rx power off" added to tty-linus
To:     zhiyong.tao@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 30 Jul 2021 07:15:21 +0200
Message-ID: <1627622121107151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_mtk: fix uart corruption issue when rx power off

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7c4a509d3815a260c423c0633bd73695250ac26d Mon Sep 17 00:00:00 2001
From: Zhiyong Tao <zhiyong.tao@mediatek.com>
Date: Thu, 29 Jul 2021 16:46:40 +0800
Subject: serial: 8250_mtk: fix uart corruption issue when rx power off

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
 drivers/tty/serial/8250/8250_mtk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index f7d3023f860f..fb65dc601b23 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -93,10 +93,13 @@ static void mtk8250_dma_rx_complete(void *param)
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
@@ -120,6 +123,8 @@ static void mtk8250_dma_rx_complete(void *param)
 	tty_flip_buffer_push(tty_port);
 
 	mtk8250_rx_dma(up);
+
+	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
 static void mtk8250_rx_dma(struct uart_8250_port *up)
-- 
2.32.0


