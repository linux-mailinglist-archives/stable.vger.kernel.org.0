Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6486F122C9C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 14:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfLQNMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 08:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbfLQNMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 08:12:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1723C206EC;
        Tue, 17 Dec 2019 13:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576588368;
        bh=BJrIs4Ak6SnqRiPTBFLlNNhG9jtGYflP7pWEdlRGxSE=;
        h=Subject:To:From:Date:From;
        b=sDXvajZFJrVo8q6HyUcDsiN27BIU5T6SmTnpTkw4IRhKfIO0wtUS+smCAfAGbWOOu
         VzpZgTepL/AlV+QST3AuvrkFXXwUkWAY1Rz0/wNnekocfd7IMbhXcd3dPZx1ku0x08
         3hP7EG1UzS7rXI8idsa8HsFl745NewOE6fPTAr3A=
Subject: patch "tty: link tty and port before configuring it as console" added to tty-linus
To:     sudipm.mukherjee@gmail.com, gregkh@linuxfoundation.org,
        jslaby@suse.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 14:12:46 +0100
Message-ID: <15765883664326@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: link tty and port before configuring it as console

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fb2b90014d782d80d7ebf663e50f96d8c507a73c Mon Sep 17 00:00:00 2001
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Thu, 12 Dec 2019 13:16:02 +0000
Subject: tty: link tty and port before configuring it as console

There seems to be a race condition in tty drivers and I could see on
many boot cycles a NULL pointer dereference as tty_init_dev() tries to
do 'tty->port->itty = tty' even though tty->port is NULL.
'tty->port' will be set by the driver and if the driver has not yet done
it before we open the tty device we can get to this situation. By adding
some extra debug prints, I noticed that:

6.650130: uart_add_one_port
6.663849: register_console
6.664846: tty_open
6.674391: tty_init_dev
6.675456: tty_port_link_device

uart_add_one_port() registers the console, as soon as it registers, the
userspace tries to use it and that leads to tty_open() but
uart_add_one_port() has not yet done tty_port_link_device() and so
tty->port is not yet configured when control reaches tty_init_dev().

Further look into the code and tty_port_link_device() is done by
uart_add_one_port(). After registering the console uart_add_one_port()
will call tty_port_register_device_attr_serdev() and
tty_port_link_device() is called from this.

Call add tty_port_link_device() before uart_configure_port() is done and
add a check in tty_port_link_device() so that it only links the port if
it has not been done yet.

Suggested-by: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191212131602.29504-1-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c | 1 +
 drivers/tty/tty_port.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b0a6eb106edb..7c2782785736 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2834,6 +2834,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
 
+	tty_port_link_device(port, drv->tty_driver, uport->line);
 	uart_configure_port(drv, state, uport);
 
 	port->console = uart_console(uport);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 044c3cbdcfa4..5023c85ebc6e 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -89,7 +89,8 @@ void tty_port_link_device(struct tty_port *port,
 {
 	if (WARN_ON(index >= driver->num))
 		return;
-	driver->ports[index] = port;
+	if (!driver->ports[index])
+		driver->ports[index] = port;
 }
 EXPORT_SYMBOL_GPL(tty_port_link_device);
 
-- 
2.24.1


