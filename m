Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92D03C7FC1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 10:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbhGNIJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 04:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238385AbhGNIJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 04:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58FA3613AF;
        Wed, 14 Jul 2021 08:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626250008;
        bh=Ya3u94eMIcTHm5PPl4FfDKsZbgE5F56Nv1jfp2qsi8Y=;
        h=From:To:Cc:Subject:Date:From;
        b=DXxuwXaLwhI9n2rtysmsiXshuTT4jZIfwP4LrA8Ah/69Pg8rJrWjavP4kfhSitSjV
         RwBrWYuFqveLqZQ3dL49cWAfoX8Q9wVcpifnpnhN1lf6+yPStO6CfSONrSpRpbg2bI
         4r5TvL3Ys2wrVVg3WbxJZjN4bMtidPRa5jBwpbNwtWHEDan78BlHil4rrffWNwzZWt
         PhJZwdhW8wG2EhN84fi82OMR9PfwxVlnbYuDmYU37SdVhZTYOcVUsBSscWjyDJqldW
         nkuXzshcT6Np4Te4lpzrtBpl0GWHc5gaxfP8YKrXwrWwM3UxsRxDRbwW9Pmg14o6yK
         9iyVHMskpfQOw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m3ZuX-0007LK-KG; Wed, 14 Jul 2021 10:06:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH] serial: 8250: fix handle_irq locking
Date:   Wed, 14 Jul 2021 10:04:27 +0200
Message-Id: <20210714080427.28164-1-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 8250 handle_irq callback is not just called from the interrupt
handler but also from a timer callback when polling (e.g. for ports
without an interrupt line). Consequently the callback must explicitly
disable interrupts to avoid a potential deadlock with another interrupt
in polled mode.

Add back an irqrestore-version of the sysrq port-unlock helper and use
it in the 8250 callbacks that need it.

Fixes: 75f4e830fa9c ("serial: do not restore interrupt state in sysrq helper")
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable@vger.kernel.org	# 5.13
Cc: Joel Stanley <joel@jms.id.au>
Cc: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/8250/8250_aspeed_vuart.c |  5 +++--
 drivers/tty/serial/8250/8250_fsl.c          |  5 +++--
 drivers/tty/serial/8250/8250_port.c         |  5 +++--
 include/linux/serial_core.h                 | 24 +++++++++++++++++++++
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index 4caab8714e2c..2350fb3bb5e4 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -329,6 +329,7 @@ static int aspeed_vuart_handle_irq(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned int iir, lsr;
+	unsigned long flags;
 	unsigned int space, count;
 
 	iir = serial_port_in(port, UART_IIR);
@@ -336,7 +337,7 @@ static int aspeed_vuart_handle_irq(struct uart_port *port)
 	if (iir & UART_IIR_NO_INT)
 		return 0;
 
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 
 	lsr = serial_port_in(port, UART_LSR);
 
@@ -370,7 +371,7 @@ static int aspeed_vuart_handle_irq(struct uart_port *port)
 	if (lsr & UART_LSR_THRE)
 		serial8250_tx_chars(up);
 
-	uart_unlock_and_check_sysrq(port);
+	uart_unlock_and_check_sysrq_irqrestore(port, flags);
 
 	return 1;
 }
diff --git a/drivers/tty/serial/8250/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
index 4e75d2e4f87c..fc65a2293ce9 100644
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
@@ -82,7 +83,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 
 	up->lsr_saved_flags = orig_lsr;
 
-	uart_unlock_and_check_sysrq(&up->port);
+	uart_unlock_and_check_sysrq_irqrestore(&up->port, flags);
 
 	return 1;
 }
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 2164290cbd31..d65778c4e4ca 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1893,11 +1893,12 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 	unsigned char status;
 	struct uart_8250_port *up = up_to_u8250p(port);
 	bool skip_rx = false;
+	unsigned long flags;
 
 	if (iir & UART_IIR_NO_INT)
 		return 0;
 
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 
 	status = serial_port_in(port, UART_LSR);
 
@@ -1923,7 +1924,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 		(up->ier & UART_IER_THRI))
 		serial8250_tx_chars(up);
 
-	uart_unlock_and_check_sysrq(port);
+	uart_unlock_and_check_sysrq_irqrestore(port, flags);
 
 	return 1;
 }
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 52d7fb92a69d..c58cc142d23f 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -518,6 +518,25 @@ static inline void uart_unlock_and_check_sysrq(struct uart_port *port)
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
@@ -531,6 +550,11 @@ static inline void uart_unlock_and_check_sysrq(struct uart_port *port)
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
-- 
2.31.1

