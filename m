Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0074320C1FF
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 16:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgF0ORK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 10:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgF0ORK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jun 2020 10:17:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFBB421655;
        Sat, 27 Jun 2020 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593267429;
        bh=xsdJCskCvRzrVMuiEnkXXtfiHNLHi74fkwe/7GCxlbE=;
        h=Subject:To:From:Date:From;
        b=RIsekqCiS5w0Jse7HrBbbsJJgNe/6qw+lTG/mqfTRBE8Qf7/+fyQ+BN2OIJKyWCrm
         bcPoQicma03znkLJqfNY7JU3fXz6ZMHmmZGoK9fbSbbu4O0sj4jc9sYfXoLAEYGhsB
         tiSRIlK85hoU3JaNx1luUOVFELK8raNxqnaArRfk=
Subject: patch "serial: core: fix sysrq overhead regression" added to tty-linus
To:     johan@kernel.org, 0x7f454c46@gmail.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Jun 2020 16:16:52 +0200
Message-ID: <159326741213315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: core: fix sysrq overhead regression

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 08d5470308ac3598e7709d08b8979ce6e9de8da2 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 10 Jun 2020 17:22:31 +0200
Subject: serial: core: fix sysrq overhead regression

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
 drivers/tty/serial/serial_core.c |  99 +----------------------------
 include/linux/serial_core.h      | 103 +++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 102 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index fcdb6bfbe2cf..abb102e71b14 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -41,8 +41,6 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
-#define SYSRQ_TIMEOUT	(HZ * 5)
-
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -3163,7 +3161,7 @@ static DECLARE_WORK(sysrq_enable_work, uart_sysrq_on);
  *	Returns false if @ch is out of enabling sequence and should be
  *	handled some other way, true if @ch was consumed.
  */
-static bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch)
+bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch)
 {
 	int sysrq_toggle_seq_len = strlen(sysrq_toggle_seq);
 
@@ -3186,102 +3184,9 @@ static bool uart_try_toggle_sysrq(struct uart_port *port, unsigned int ch)
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
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index ef4921ddbe97..03fa7b967103 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -462,11 +462,104 @@ extern void uart_handle_cts_change(struct uart_port *uport,
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
-- 
2.27.0


