Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B453E272F11
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgIUQqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbgIUQqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8CE2223E;
        Mon, 21 Sep 2020 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706802;
        bh=LAIpAa3C+GIaoY8EIGRJI8TvXg5ZFTnj6W2xCYBFhgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1kcaiOMmmhPYAtzRTy0kGah4bb3P6F1jFBWqRNvhIzTDb7VYtMYGJywhSFDX2CAG
         7c19QnFDwvI97NaEtSpKIEv5lklxMypEfuObxtf1EUyj9F9W5D3FPgAXue1D1SmNzt
         rMziIPQkIUnr4Jczw6g55kg29/701NoPQ795I+dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.8 101/118] serial: core: fix console port-lock regression
Date:   Mon, 21 Sep 2020 18:28:33 +0200
Message-Id: <20200921162041.067535362@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit e0830dbf71f191851ed3772d2760f007b7c5bc3a upstream.

Fix the port-lock initialisation regression introduced by commit
a3cb39d258ef ("serial: core: Allow detach and attach serial device for
console") by making sure that the lock is again initialised during
console setup.

The console may be registered before the serial controller has been
probed in which case the port lock needs to be initialised during
console setup by a call to uart_set_options(). The console-detach
changes introduced a regression in several drivers by effectively
removing that initialisation by not initialising the lock when the port
is used as a console (which is always the case during console setup).

Add back the early lock initialisation and instead use a new
console-reinit flag to handle the case where a console is being
re-attached through sysfs.

The question whether the console-detach interface should have been added
in the first place is left for another discussion.

Note that the console-enabled check in uart_set_options() is not
redundant because of kgdboc, which can end up reinitialising an already
enabled console (see commit 42b6a1baa3ec ("serial_core: Don't
re-initialize a previously initialized spinlock.")).

Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Cc: stable <stable@vger.kernel.org>     # 5.7
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200909143101.15389-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |   32 +++++++++++++++-----------------
 include/linux/serial_core.h      |    1 +
 2 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1914,24 +1914,12 @@ static inline bool uart_console_enabled(
 	return uart_console(port) && (port->cons->flags & CON_ENABLED);
 }
 
-static void __uart_port_spin_lock_init(struct uart_port *port)
+static void uart_port_spin_lock_init(struct uart_port *port)
 {
 	spin_lock_init(&port->lock);
 	lockdep_set_class(&port->lock, &port_lock_key);
 }
 
-/*
- * Ensure that the serial console lock is initialised early.
- * If this port is a console, then the spinlock is already initialised.
- */
-static inline void uart_port_spin_lock_init(struct uart_port *port)
-{
-	if (uart_console(port))
-		return;
-
-	__uart_port_spin_lock_init(port);
-}
-
 #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
 /**
  *	uart_console_write - write a console message to a serial port
@@ -2084,7 +2072,15 @@ uart_set_options(struct uart_port *port,
 	struct ktermios termios;
 	static struct ktermios dummy;
 
-	uart_port_spin_lock_init(port);
+	/*
+	 * Ensure that the serial-console lock is initialised early.
+	 *
+	 * Note that the console-enabled check is needed because of kgdboc,
+	 * which can end up calling uart_set_options() for an already enabled
+	 * console via tty_find_polling_driver() and uart_poll_init().
+	 */
+	if (!uart_console_enabled(port) && !port->console_reinit)
+		uart_port_spin_lock_init(port);
 
 	memset(&termios, 0, sizeof(struct ktermios));
 
@@ -2791,10 +2787,12 @@ static ssize_t console_store(struct devi
 		if (oldconsole && !newconsole) {
 			ret = unregister_console(uport->cons);
 		} else if (!oldconsole && newconsole) {
-			if (uart_console(uport))
+			if (uart_console(uport)) {
+				uport->console_reinit = 1;
 				register_console(uport->cons);
-			else
+			} else {
 				ret = -ENOENT;
+			}
 		}
 	} else {
 		ret = -ENXIO;
@@ -2895,7 +2893,7 @@ int uart_add_one_port(struct uart_driver
 	 * initialised.
 	 */
 	if (!uart_console_enabled(uport))
-		__uart_port_spin_lock_init(uport);
+		uart_port_spin_lock_init(uport);
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -248,6 +248,7 @@ struct uart_port {
 
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		suspended;
+	unsigned char		console_reinit;
 	const char		*name;			/* port name */
 	struct attribute_group	*attr_group;		/* port specific attributes */
 	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */


