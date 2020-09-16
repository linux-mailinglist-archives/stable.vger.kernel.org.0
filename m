Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D7926C94B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgIPTGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbgIPRpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:45:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18CBF21D1B;
        Wed, 16 Sep 2020 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600255401;
        bh=3SAPOAjoNLFEB0aIfDZoUAk2mDeTK/e/JwN2wBGAhHY=;
        h=Subject:To:From:Date:From;
        b=Q5SM9pnqXhS+a1IhRB5EZx5Z7j2ucM5X9R78ED8164FwtICTw3znm9V6MQZDEW8XC
         U6XOalYkVcJxXWW/3jEsliPyP3YBc6Su9xuEJabJt3638JDB29cHx1GvCLkS0lb0rE
         rHDO9AzYE4L8Zww4TPLUm9+PgTgjt7Pq+4GeFKNw=
Subject: patch "serial: core: fix port-lock initialisation" added to tty-linus
To:     johan@kernel.org, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Sep 2020 13:23:55 +0200
Message-ID: <1600255435114105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: core: fix port-lock initialisation

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fe88c6489264eaea23570dfdf03e1d3f5f47f423 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Sep 2020 16:31:00 +0200
Subject: serial: core: fix port-lock initialisation

Commit f743061a85f5 ("serial: core: Initialise spin lock before use in
uart_configure_port()") tried to work around a breakage introduced by
commit a3cb39d258ef ("serial: core: Allow detach and attach serial
device for console") by adding a second initialisation of the port lock
when registering the port.

As reported by the build robots [1], this doesn't really solve the
regression introduced by the console-detach changes and also adds a
second redundant initialisation of the lock for normal ports.

Start cleaning up this mess by removing the redundant initialisation and
making sure that the port lock is again initialised once-only for ports
that aren't already in use as a console.

[1] https://lore.kernel.org/r/20200802054852.GR23458@shao2-debian

Fixes: f743061a85f5 ("serial: core: Initialise spin lock before use in uart_configure_port()")
Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Cc: stable <stable@vger.kernel.org>     # 5.7
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200909143101.15389-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f797c971cd82..53b79e1fcbc8 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2378,13 +2378,6 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		/* Power up port for set_mctrl() */
 		uart_change_pm(state, UART_PM_STATE_ON);
 
-		/*
-		 * If this driver supports console, and it hasn't been
-		 * successfully registered yet, initialise spin lock for it.
-		 */
-		if (port->cons && !(port->cons->flags & CON_ENABLED))
-			__uart_port_spin_lock_init(port);
-
 		/*
 		 * Ensure that the modem control lines are de-activated.
 		 * keep the DTR setting that is set in uart_set_options()
@@ -2900,7 +2893,12 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 		goto out;
 	}
 
-	uart_port_spin_lock_init(uport);
+	/*
+	 * If this port is in use as a console then the spinlock is already
+	 * initialised.
+	 */
+	if (!uart_console_enabled(uport))
+		__uart_port_spin_lock_init(uport);
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
-- 
2.28.0


