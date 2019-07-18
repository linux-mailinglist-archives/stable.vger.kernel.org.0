Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB7D6C6FD
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391111AbfGRDKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391101AbfGRDKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:05 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905FA21841;
        Thu, 18 Jul 2019 03:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419404;
        bh=Ulc6IGMJovVWgezLWzctt5c4gvetb3xmZ8ycD3SVkZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwDMmQm3V5v4K2nD7To2UDHUUF8GFjVYro2bbh7tqoiItrXEKIhMuK+YAhslSYgPg
         ZYMQoLmy5DZEhvG4wPgvMDNTcXzfZSJlaRLaBD14NTxdOU0/7z7d8qskaqVCqYx2wi
         +2AAmvkEoKzfNrKp7Fwu29GonutpIWPyKWTOaf0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Barta <o.barta89@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 52/80] Revert "serial: 8250: Dont service RX FIFO if interrupts are disabled"
Date:   Thu, 18 Jul 2019 12:01:43 +0900
Message-Id: <20190718030102.627376265@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Barta <o.barta89@gmail.com>

commit 3f2640ed7be838c3f05c0d2b0f7c7508e7431e48 upstream.

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
 drivers/tty/serial/8250/8250_port.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1873,8 +1873,7 @@ int serial8250_handle_irq(struct uart_po
 
 	status = serial_port_in(port, UART_LSR);
 
-	if (status & (UART_LSR_DR | UART_LSR_BI) &&
-	    iir & UART_IIR_RDI) {
+	if (status & (UART_LSR_DR | UART_LSR_BI)) {
 		if (!up->dma || handle_rx_dma(up, iir))
 			status = serial8250_rx_chars(up, status);
 	}


