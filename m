Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1A126F08E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIRCoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728454AbgIRCK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBD37238A1;
        Fri, 18 Sep 2020 02:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395027;
        bh=gvderARrpRnfGtjOgHdX2IEOm/oM9jcniUBqXQ3gp7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFZTh0iArAegXnPeHscez3G05ylxcuZ0/jOvXxTfyzSRr3Y5ct/FEMyza0V+zxOZG
         q0ykKm90hXngOvPdyH0eMXzyLRbu4NMK0DQo+4GlI2hh9/1RTmVpiM9qOAruXBv6Pl
         oBRWr+pVULBOIN0xLUkortdO1Z+M5HeTm8uVc06M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 120/206] serial: 8250_port: Don't service RX FIFO if throttled
Date:   Thu, 17 Sep 2020 22:06:36 -0400
Message-Id: <20200918020802.2065198-120-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 09f0dc3b967b1..60ca19eca1f63 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1861,6 +1861,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 	unsigned char status;
 	unsigned long flags;
 	struct uart_8250_port *up = up_to_u8250p(port);
+	bool skip_rx = false;
 
 	if (iir & UART_IIR_NO_INT)
 		return 0;
@@ -1869,7 +1870,20 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
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

