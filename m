Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029594F3CC
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 07:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfFVFMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 01:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfFVFMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 01:12:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AC3208C3;
        Sat, 22 Jun 2019 05:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561180361;
        bh=T6sS5l2kr2RdmwVVZ7Jb3UzYYRpv9ONwaGaIX01hNlI=;
        h=Subject:To:From:Date:From;
        b=XA803AYijVcQGN3Lf2l7BfI7F+cNNpLgPWvLMAPcpxRFFgSJQB5pYpMmwhgTrhoiN
         CHi0S1WVgm0M1aHgK1Yw++W5X0Oiqj+JMOukPFoAGLw5XH3FkCikNRQqdo6jYhJ6jl
         H4MTsREpdcbbbN6COMTxE2DsOtwUn2OSyrwSaQxU=
Subject: patch "Revert "serial: 8250: Don't service RX FIFO if interrupts are" added to tty-next
To:     o.barta89@gmail.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Jun 2019 07:12:30 +0200
Message-ID: <1561180350487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: 8250: Don't service RX FIFO if interrupts are

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 3f2640ed7be838c3f05c0d2b0f7c7508e7431e48 Mon Sep 17 00:00:00 2001
From: Oliver Barta <o.barta89@gmail.com>
Date: Wed, 19 Jun 2019 10:16:39 +0200
Subject: Revert "serial: 8250: Don't service RX FIFO if interrupts are
 disabled"

This reverts commit 2e9fe539108320820016f78ca7704a7342788380.

Reading LSR unconditionally but processing the error flags only if
UART_IIR_RDI bit was set before in IIR may lead to a loss of transmission
error information on UARTs where the transmission error flags are cleared
by a read of LSR. Information are lost in case an error is detected right
before the read of LSR while processing e.g. an UART_IIR_THRI interrupt.

Signed-off-by: Oliver Barta <o.barta89@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 2e9fe5391083 ("serial: 8250: Don't service RX FIFO if interrupts are disabled")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index a6fabc7e3b13..c1cec808571b 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1867,8 +1867,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 	status = serial_port_in(port, UART_LSR);
 
-	if (status & (UART_LSR_DR | UART_LSR_BI) &&
-	    iir & UART_IIR_RDI) {
+	if (status & (UART_LSR_DR | UART_LSR_BI)) {
 		if (!up->dma || handle_rx_dma(up, iir))
 			status = serial8250_rx_chars(up, status);
 	}
-- 
2.22.0


