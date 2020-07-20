Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEDA22673D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387598AbgGTQJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732900AbgGTQJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6A42065E;
        Mon, 20 Jul 2020 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261395;
        bh=za21BTmLuUrLxiNm+BJdCpjd7tubdIm6RmXG4QxQBx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFm0ShJ6R0Fsc6VsDFbYy09m6sDv+7eCSCQlCWvyV/CaVe/wd25bS9OdPl1qTVXGk
         VuwXL7WW/vaz4u41WS6rSR1cNLpkouPcr/H/7sSml59I8Pfx5pCU0OYPIHAPOXR7YM
         ThSyuzjjWeIR22+lVCw2ouxFu8rg6Nw4WaQliRQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Anatoly Pugachev <matorola@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 100/244] serial: core: Initialise spin lock before use in uart_configure_port()
Date:   Mon, 20 Jul 2020 17:36:11 +0200
Message-Id: <20200720152830.589414341@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f743061a85f5e9989df22ccbf07c80c98fc90e08 ]

The comment near to uart_port_spin_lock_init() says:

  Ensure that the serial console lock is initialised early.
  If this port is a console, then the spinlock is already initialised.

and there is nothing about enabled or disabled consoles. The commit
a3cb39d258ef ("serial: core: Allow detach and attach serial device
for console") made a change, which follows the comment, and also to
prevent reinitialisation of the lock in use, when user detaches and
attaches back the same console device. But this change discovers
another issue, that uart_add_one_port() tries to access a spin lock
that now may be uninitialised. This happens when a driver expects
the serial core to register a console on its behalf. In this case
we must initialise a spin lock before use.

Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Reported-by: Marc Zyngier <maz@kernel.org>
Reported-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Anatoly Pugachev <matorola@gmail.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20200706214903.56148-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 66a5e2faf57ea..ca5e6212bf1ce 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1916,6 +1916,12 @@ static inline bool uart_console_enabled(struct uart_port *port)
 	return uart_console(port) && (port->cons->flags & CON_ENABLED);
 }
 
+static void __uart_port_spin_lock_init(struct uart_port *port)
+{
+	spin_lock_init(&port->lock);
+	lockdep_set_class(&port->lock, &port_lock_key);
+}
+
 /*
  * Ensure that the serial console lock is initialised early.
  * If this port is a console, then the spinlock is already initialised.
@@ -1925,8 +1931,7 @@ static inline void uart_port_spin_lock_init(struct uart_port *port)
 	if (uart_console(port))
 		return;
 
-	spin_lock_init(&port->lock);
-	lockdep_set_class(&port->lock, &port_lock_key);
+	__uart_port_spin_lock_init(port);
 }
 
 #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
@@ -2372,6 +2377,13 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		/* Power up port for set_mctrl() */
 		uart_change_pm(state, UART_PM_STATE_ON);
 
+		/*
+		 * If this driver supports console, and it hasn't been
+		 * successfully registered yet, initialise spin lock for it.
+		 */
+		if (port->cons && !(port->cons->flags & CON_ENABLED))
+			__uart_port_spin_lock_init(port);
+
 		/*
 		 * Ensure that the modem control lines are de-activated.
 		 * keep the DTR setting that is set in uart_set_options()
-- 
2.25.1



