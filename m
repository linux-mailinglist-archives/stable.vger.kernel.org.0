Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CED82633C5
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgIIRJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 13:09:51 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:42534 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730224AbgIIPgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 11:36:01 -0400
Received: by mail-ej1-f66.google.com with SMTP id q13so4179483ejo.9;
        Wed, 09 Sep 2020 08:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qP6O2ucn5KuDRC7RB2WRLd9myNrDAnc1ixV/2OFvSfA=;
        b=Cg4PLTB08yBHJQsQW/PfsBFiRrKA45GKvH1wRkcrGVceSxcdFgJBavweZraWzLk/bF
         3PFxarALEuOZO9itpNOZEKOaK3XpquI4u6IywkKlb4vchMx1KazWyEhs24vyBGKNwHeV
         Gz5GTzI8N5coJMPg3lJZYPq5pC+a/rp0B0rKUHd4R6O+VviycAHYr6C8zk9VOXJEG8vk
         /GRaXZ8817J7CqF6LOhipPvSon0aJkdkV+O483k7P8xxk9h2rK3Oso9DykYDOF7PQ8bK
         3r4ddQP7ji6BbQ+5NA5u9t5a4LAtapmcBiRcfu7h0kxNIL8x9o6n5HbdyVUR5Rlpwk2q
         w3Sg==
X-Gm-Message-State: AOAM531Cvey5IbHb30HMnaeR7AuEenfpHRmL17e7s7UKBQL3Qbmred6Q
        E6I7eYzIzCVzUJx2JCC+2sdJLepcs68=
X-Google-Smtp-Source: ABdhPJxkx0pKWo4zITjkUOd3XsCXmG/5wXI1KoHYWOKbmq1Yq+MSaAZNQZh7k9wsK9NWreIyeaSFVA==
X-Received: by 2002:a19:4186:: with SMTP id o128mr1899570lfa.148.1599661891771;
        Wed, 09 Sep 2020 07:31:31 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id 206sm612714lfd.72.2020.09.09.07.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 07:31:29 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kG18B-00041D-1O; Wed, 09 Sep 2020 16:31:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] serial: core: fix console port-lock regression
Date:   Wed,  9 Sep 2020 16:31:01 +0200
Message-Id: <20200909143101.15389-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909143101.15389-1-johan@kernel.org>
References: <20200909143101.15389-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
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
2.26.2

