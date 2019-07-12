Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FB166E0E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbfGLMcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfGLMcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 389C321019;
        Fri, 12 Jul 2019 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934773;
        bh=nkZ6Tz3khAsmsQ82x8OX7tgmPnhebC4vG3Vhlk1ApSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6fc5PN8GA1ib/l3X3u8M/DeS+Q+oZJ677XIHpmbz7LoDP13qPjlzb6FmarB/5iEG
         WShvcQefqmD8FDQomBM/P2XELxKjuYbzIXoa97hTcdJOH8C/0cKNg7+j5yNQohwi3B
         Qin3bbRTO/vFXhcrvE4UdnJ0IMX2ntzx7i8G0IdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Barta <o.barta89@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.2 26/61] Revert "serial: 8250: Dont service RX FIFO if interrupts are disabled"
Date:   Fri, 12 Jul 2019 14:19:39 +0200
Message-Id: <20190712121622.030062321@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
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
@@ -1869,8 +1869,7 @@ int serial8250_handle_irq(struct uart_po
 
 	status = serial_port_in(port, UART_LSR);
 
-	if (status & (UART_LSR_DR | UART_LSR_BI) &&
-	    iir & UART_IIR_RDI) {
+	if (status & (UART_LSR_DR | UART_LSR_BI)) {
 		if (!up->dma || handle_rx_dma(up, iir))
 			status = serial8250_rx_chars(up, status);
 	}


