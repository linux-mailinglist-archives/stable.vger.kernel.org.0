Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2306F226834
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbgGTQOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388323AbgGTQOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7A920684;
        Mon, 20 Jul 2020 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261691;
        bh=zuW6AQG4hO/PzRjlLdbSaVt01/DW89kAI3BXdaI4o6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwwS89o1WCQQEy+bDzoRpC+Kvz1Wspk1Zn9yLjHu60Oesob8NhtHfH4zWXgv6QsEG
         2yfi6V+S0JC5xgNF0Mvoc38EsgZGRsgrc+SPvq1Kka6nRNxq6XpCDL703MKPsS5eqK
         Mnb52xfkOPRri1BelFzzjDI9RWJwjnTlkYoRttNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 177/244] serial: core: fix sysrq overhead regression
Date:   Mon, 20 Jul 2020 17:37:28 +0200
Message-Id: <20200720152834.258518246@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 08d5470308ac3598e7709d08b8979ce6e9de8da2 upstream.

Commit 8e20fc391711 ("serial_core: Move sysrq functions from header
file") converted the inline sysrq helpers to exported functions which
are now called for every received character, interrupt and break signal
also on systems without CONFIG_MAGIC_SYSRQ_SERIAL instead of being
optimised away by the compiler.

Inlining these helpers again also avoids the function call overhead when
CONFIG_MAGIC_SYSRQ_SERIAL is enabled (e.g. when the port is not used as
a console).

Fixes: 8e20fc391711 ("serial_core: Move sysrq functions from header file")
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://lore.kernel.org/r/20200610152232.16925-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |   99 -------------------------------------
 include/linux/serial_core.h      |  103 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 102 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -41,8 +41,6 @@ static struct lock_class_key port_lock_k
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
-#define SYSRQ_TIMEOUT	(HZ * 5)
-
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -3175,7 +3173,7 @@ static DECLARE_WORK(sysrq_enable_work, u
  *	Returns false if @ch is out of enabling sequence and should be
  *	handled some other way, true if @ch was consumed.
  */
-static bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch)
+bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch)
 {
 	int sysrq_toggle_seq_len = strlen(sysrq_toggle_seq);
 
@@ -3198,102 +3196,9 @@ static bool uart_try_toggle_sysrq(struct
 	port->sysrq = 0;
 	return true;
 }
-#else
-static inline bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch)
-{
-	return false;
-}
+EXPORT_SYMBOL_GPL(uart_try_toggle_sysrq);
 #endif
 
-int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
-{
-	if (!IS_ENABLED(CONFIG_MAGIC_SYSRQ_SERIAL))
-		return 0;
-
-	if (!port->has_sysrq || !port->sysrq)
-		return 0;
-
-	if (ch && time_before(jiffies, port->sysrq)) {
-		if (sysrq_mask()) {
-			handle_sysrq(ch);
-			port->sysrq = 0;
-			return 1;
-		}
-		if (uart_try_toggle_sysrq(port, ch))
-			return 1;
-	}
-	port->sysrq = 0;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(uart_handle_sysrq_char);
-
-int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch)
-{
-	if (!IS_ENABLED(CONFIG_MAGIC_SYSRQ_SERIAL))
-		return 0;
-
-	if (!port->has_sysrq || !port->sysrq)
-		return 0;
-
-	if (ch && time_before(jiffies, port->sysrq)) {
-		if (sysrq_mask()) {
-			port->sysrq_ch = ch;
-			port->sysrq = 0;
-			return 1;
-		}
-		if (uart_try_toggle_sysrq(port, ch))
-			return 1;
-	}
-	port->sysrq = 0;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(uart_prepare_sysrq_char);
-
-void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long irqflags)
-{
-	int sysrq_ch;
-
-	if (!port->has_sysrq) {
-		spin_unlock_irqrestore(&port->lock, irqflags);
-		return;
-	}
-
-	sysrq_ch = port->sysrq_ch;
-	port->sysrq_ch = 0;
-
-	spin_unlock_irqrestore(&port->lock, irqflags);
-
-	if (sysrq_ch)
-		handle_sysrq(sysrq_ch);
-}
-EXPORT_SYMBOL_GPL(uart_unlock_and_check_sysrq);
-
-/*
- * We do the SysRQ and SAK checking like this...
- */
-int uart_handle_break(struct uart_port *port)
-{
-	struct uart_state *state = port->state;
-
-	if (port->handle_break)
-		port->handle_break(port);
-
-	if (port->has_sysrq && uart_console(port)) {
-		if (!port->sysrq) {
-			port->sysrq = jiffies + SYSRQ_TIMEOUT;
-			return 1;
-		}
-		port->sysrq = 0;
-	}
-
-	if (port->flags & UPF_SAK)
-		do_SAK(state->port.tty);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(uart_handle_break);
-
 EXPORT_SYMBOL(uart_write_wakeup);
 EXPORT_SYMBOL(uart_register_driver);
 EXPORT_SYMBOL(uart_unregister_driver);
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -460,11 +460,104 @@ extern void uart_handle_cts_change(struc
 extern void uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag);
 
-extern int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch);
-extern int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch);
-extern void uart_unlock_and_check_sysrq(struct uart_port *port,
-					unsigned long irqflags);
-extern int uart_handle_break(struct uart_port *port);
+#ifdef CONFIG_MAGIC_SYSRQ_SERIAL
+#define SYSRQ_TIMEOUT	(HZ * 5)
+
+bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch);
+
+static inline int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
+{
+	if (!port->has_sysrq || !port->sysrq)
+		return 0;
+
+	if (ch && time_before(jiffies, port->sysrq)) {
+		if (sysrq_mask()) {
+			handle_sysrq(ch);
+			port->sysrq = 0;
+			return 1;
+		}
+		if (uart_try_toggle_sysrq(port, ch))
+			return 1;
+	}
+	port->sysrq = 0;
+
+	return 0;
+}
+
+static inline int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch)
+{
+	if (!port->has_sysrq || !port->sysrq)
+		return 0;
+
+	if (ch && time_before(jiffies, port->sysrq)) {
+		if (sysrq_mask()) {
+			port->sysrq_ch = ch;
+			port->sysrq = 0;
+			return 1;
+		}
+		if (uart_try_toggle_sysrq(port, ch))
+			return 1;
+	}
+	port->sysrq = 0;
+
+	return 0;
+}
+
+static inline void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long irqflags)
+{
+	int sysrq_ch;
+
+	if (!port->has_sysrq) {
+		spin_unlock_irqrestore(&port->lock, irqflags);
+		return;
+	}
+
+	sysrq_ch = port->sysrq_ch;
+	port->sysrq_ch = 0;
+
+	spin_unlock_irqrestore(&port->lock, irqflags);
+
+	if (sysrq_ch)
+		handle_sysrq(sysrq_ch);
+}
+#else	/* CONFIG_MAGIC_SYSRQ_SERIAL */
+static inline int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
+{
+	return 0;
+}
+static inline int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch)
+{
+	return 0;
+}
+static inline void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long irqflags)
+{
+	spin_unlock_irqrestore(&port->lock, irqflags);
+}
+#endif	/* CONFIG_MAGIC_SYSRQ_SERIAL */
+
+/*
+ * We do the SysRQ and SAK checking like this...
+ */
+static inline int uart_handle_break(struct uart_port *port)
+{
+	struct uart_state *state = port->state;
+
+	if (port->handle_break)
+		port->handle_break(port);
+
+#ifdef CONFIG_MAGIC_SYSRQ_SERIAL
+	if (port->has_sysrq && uart_console(port)) {
+		if (!port->sysrq) {
+			port->sysrq = jiffies + SYSRQ_TIMEOUT;
+			return 1;
+		}
+		port->sysrq = 0;
+	}
+#endif
+	if (port->flags & UPF_SAK)
+		do_SAK(state->port.tty);
+	return 0;
+}
 
 /*
  *	UART_ENABLE_MS - determine if port should enable modem status irqs


