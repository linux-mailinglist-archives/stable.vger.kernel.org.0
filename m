Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC0C27CCD4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgI2MjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbgI2LQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF110208FE;
        Tue, 29 Sep 2020 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378190;
        bh=9vYwt60WtS5kvhi3kyOZocDe+6ndIZqBUPH8QXk1Qus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYNrz7sVFA9QBRXNGkEnnCEstiUU9MWBbjS/2+juKXxk9sSOy4vvdMM0U3Sw44rca
         nr+1UHCTVL6wla5UVdvRE3SxMTngieuKfUH072Y22l26CuAytw48nPf4hUqGlWkavf
         s/YI3lWuLap6sxhw4VHD399TDCaezojKA0AxmtN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/166] serial: 8250_port: Dont service RX FIFO if throttled
Date:   Tue, 29 Sep 2020 12:59:58 +0200
Message-Id: <20200929105939.509218637@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit f19c3f6c8109b8bab000afd35580929958e087a9 ]

When port's throttle callback is called, it should stop pushing any more
data into TTY buffer to avoid buffer overflow. This means driver has to
stop HW from receiving more data and assert the HW flow control. For
UARTs with auto HW flow control (such as 8250_omap) manual assertion of
flow control line is not possible and only way is to allow RX FIFO to
fill up, thus trigger auto HW flow control logic.

Therefore make sure that 8250 generic IRQ handler does not drain data
when port is stopped (i.e UART_LSR_DR is unset in read_status_mask). Not
servicing, RX FIFO would trigger auto HW flow control when FIFO
occupancy reaches preset threshold, thus halting RX.
Since, error conditions in UART_LSR register are cleared just by reading
the register, data has to be drained in case there are FIFO errors, else
error information will lost.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20200319103230.16867-2-vigneshr@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 07d5925791e1c..9880a50d664fc 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1865,6 +1865,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 	unsigned char status;
 	unsigned long flags;
 	struct uart_8250_port *up = up_to_u8250p(port);
+	bool skip_rx = false;
 
 	if (iir & UART_IIR_NO_INT)
 		return 0;
@@ -1873,7 +1874,20 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 	status = serial_port_in(port, UART_LSR);
 
-	if (status & (UART_LSR_DR | UART_LSR_BI)) {
+	/*
+	 * If port is stopped and there are no error conditions in the
+	 * FIFO, then don't drain the FIFO, as this may lead to TTY buffer
+	 * overflow. Not servicing, RX FIFO would trigger auto HW flow
+	 * control when FIFO occupancy reaches preset threshold, thus
+	 * halting RX. This only works when auto HW flow control is
+	 * available.
+	 */
+	if (!(status & (UART_LSR_FIFOE | UART_LSR_BRK_ERROR_BITS)) &&
+	    (port->status & (UPSTAT_AUTOCTS | UPSTAT_AUTORTS)) &&
+	    !(port->read_status_mask & UART_LSR_DR))
+		skip_rx = true;
+
+	if (status & (UART_LSR_DR | UART_LSR_BI) && !skip_rx) {
 		if (!up->dma || handle_rx_dma(up, iir))
 			status = serial8250_rx_chars(up, status);
 	}
-- 
2.25.1



