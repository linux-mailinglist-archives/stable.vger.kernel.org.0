Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5B26C688
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 19:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgIPRxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 13:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgIPRwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:52:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB8521D43;
        Wed, 16 Sep 2020 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600255404;
        bh=lqzdIOQ2v5uAaJ5UDf7Rkv6xvR9w50zt6VNuSmWbeD0=;
        h=Subject:To:From:Date:From;
        b=tMqy+fB5WUjofla58yU2ip14yDHBdK1kGt1tjcWXaE5IC1BayfYMFsxTZwE9WJ3M5
         cZYqbfB2x0RrmBq7NGWhuHxWOiW72XvtnFywIlKy/ToHA5RMhMex58zxPQpkns3oPQ
         0QwMDcSXXC7jFGo9BVL+77as/mPF7PYFkww2SRHM=
Subject: patch "serial: core: fix console port-lock regression" added to tty-linus
To:     johan@kernel.org, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Sep 2020 13:23:56 +0200
Message-ID: <1600255436723@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: core: fix console port-lock regression

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e0830dbf71f191851ed3772d2760f007b7c5bc3a Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Sep 2020 16:31:01 +0200
Subject: serial: core: fix console port-lock regression

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
 drivers/tty/serial/serial_core.c | 32 +++++++++++++++-----------------
 include/linux/serial_core.h      |  1 +
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 53b79e1fcbc8..124524ecfe26 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1916,24 +1916,12 @@ static inline bool uart_console_enabled(struct uart_port *port)
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
@@ -2086,7 +2074,15 @@ uart_set_options(struct uart_port *port, struct console *co,
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
 
@@ -2794,10 +2790,12 @@ static ssize_t console_store(struct device *dev,
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
@@ -2898,7 +2896,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 * initialised.
 	 */
 	if (!uart_console_enabled(uport))
-		__uart_port_spin_lock_init(uport);
+		uart_port_spin_lock_init(uport);
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 01fc4d9c9c54..8a99279a579b 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -248,6 +248,7 @@ struct uart_port {
 
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		suspended;
+	unsigned char		console_reinit;
 	const char		*name;			/* port name */
 	struct attribute_group	*attr_group;		/* port specific attributes */
 	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
-- 
2.28.0


