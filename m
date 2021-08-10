Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4BB3E81BD
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhHJSBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238669AbhHJR7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD4316112D;
        Tue, 10 Aug 2021 17:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617596;
        bh=CStUyNp+qm5s8GGhGw22zcDDyNT/riOMp3pldqrNyxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDBVUaZpYiBDlklMDJucjPyS34e+kIvBKy6Sj+PCqsuHLGPFD0PLg2HksVi69jP4g
         Kl9INqefRtcvUQZDnJ/GIN9z361oAJakZtMXbbaQaLFEnrvBNgwBXaTIrCQfJbc3Za
         Amh9B0esEfSGJbG6Wa/drvwa5LCwGAqB7hpA+t/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        kernel test robot <oliver.sang@intel.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.13 127/175] serial: 8250: fix handle_irq locking
Date:   Tue, 10 Aug 2021 19:30:35 +0200
Message-Id: <20210810173005.136988577@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 853a9ae29e978d37f5dfa72622a68c9ae3d7fa89 upstream.

The 8250 handle_irq callback is not just called from the interrupt
handler but also from a timer callback when polling (e.g. for ports
without an interrupt line). Consequently the callback must explicitly
disable interrupts to avoid a potential deadlock with another interrupt
in polled mode.

Add back an irqrestore-version of the sysrq port-unlock helper and use
it in the 8250 callbacks that need it.

Fixes: 75f4e830fa9c ("serial: do not restore interrupt state in sysrq helper")
Cc: stable@vger.kernel.org	# 5.13
Cc: Joel Stanley <joel@jms.id.au>
Cc: Andrew Jeffery <andrew@aj.id.au>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210714080427.28164-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_aspeed_vuart.c |    5 +++--
 drivers/tty/serial/8250/8250_fsl.c          |    5 +++--
 drivers/tty/serial/8250/8250_port.c         |    5 +++--
 include/linux/serial_core.h                 |   24 ++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -320,6 +320,7 @@ static int aspeed_vuart_handle_irq(struc
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned int iir, lsr;
+	unsigned long flags;
 	int space, count;
 
 	iir = serial_port_in(port, UART_IIR);
@@ -327,7 +328,7 @@ static int aspeed_vuart_handle_irq(struc
 	if (iir & UART_IIR_NO_INT)
 		return 0;
 
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 
 	lsr = serial_port_in(port, UART_LSR);
 
@@ -363,7 +364,7 @@ static int aspeed_vuart_handle_irq(struc
 	if (lsr & UART_LSR_THRE)
 		serial8250_tx_chars(up);
 
-	uart_unlock_and_check_sysrq(port);
+	uart_unlock_and_check_sysrq_irqrestore(port, flags);
 
 	return 1;
 }
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -30,10 +30,11 @@ struct fsl8250_data {
 int fsl8250_handle_irq(struct uart_port *port)
 {
 	unsigned char lsr, orig_lsr;
+	unsigned long flags;
 	unsigned int iir;
 	struct uart_8250_port *up = up_to_u8250p(port);
 
-	spin_lock(&up->port.lock);
+	spin_lock_irqsave(&up->port.lock, flags);
 
 	iir = port->serial_in(port, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
@@ -82,7 +83,7 @@ int fsl8250_handle_irq(struct uart_port
 
 	up->lsr_saved_flags = orig_lsr;
 
-	uart_unlock_and_check_sysrq(&up->port);
+	uart_unlock_and_check_sysrq_irqrestore(&up->port, flags);
 
 	return 1;
 }
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1899,11 +1899,12 @@ int serial8250_handle_irq(struct uart_po
 	unsigned char status;
 	struct uart_8250_port *up = up_to_u8250p(port);
 	bool skip_rx = false;
+	unsigned long flags;
 
 	if (iir & UART_IIR_NO_INT)
 		return 0;
 
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 
 	status = serial_port_in(port, UART_LSR);
 
@@ -1929,7 +1930,7 @@ int serial8250_handle_irq(struct uart_po
 		(up->ier & UART_IER_THRI))
 		serial8250_tx_chars(up);
 
-	uart_unlock_and_check_sysrq(port);
+	uart_unlock_and_check_sysrq_irqrestore(port, flags);
 
 	return 1;
 }
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -517,6 +517,25 @@ static inline void uart_unlock_and_check
 	if (sysrq_ch)
 		handle_sysrq(sysrq_ch);
 }
+
+static inline void uart_unlock_and_check_sysrq_irqrestore(struct uart_port *port,
+		unsigned long flags)
+{
+	int sysrq_ch;
+
+	if (!port->has_sysrq) {
+		spin_unlock_irqrestore(&port->lock, flags);
+		return;
+	}
+
+	sysrq_ch = port->sysrq_ch;
+	port->sysrq_ch = 0;
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (sysrq_ch)
+		handle_sysrq(sysrq_ch);
+}
 #else	/* CONFIG_MAGIC_SYSRQ_SERIAL */
 static inline int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 {
@@ -530,6 +549,11 @@ static inline void uart_unlock_and_check
 {
 	spin_unlock(&port->lock);
 }
+static inline void uart_unlock_and_check_sysrq_irqrestore(struct uart_port *port,
+		unsigned long flags)
+{
+	spin_unlock_irqrestore(&port->lock, flags);
+}
 #endif	/* CONFIG_MAGIC_SYSRQ_SERIAL */
 
 /*


