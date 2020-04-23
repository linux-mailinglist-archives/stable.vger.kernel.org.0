Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8D41B6865
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgDWXGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49674 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728407AbgDWXGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hX-E1; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6pT-Fe; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jiri Slaby" <jslaby@suse.com>
Date:   Fri, 24 Apr 2020 00:05:57 +0100
Message-ID: <lsq.1587683028.301840929@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 130/245] tty: link tty and port before configuring it
 as console
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

commit fb2b90014d782d80d7ebf663e50f96d8c507a73c upstream.

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
Link: https://lore.kernel.org/r/20191212131602.29504-1-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/serial_core.c | 1 +
 drivers/tty/tty_port.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2639,6 +2639,7 @@ int uart_add_one_port(struct uart_driver
 		lockdep_set_class(&uport->lock, &port_lock_key);
 	}
 
+	tty_port_link_device(port, drv->tty_driver, uport->line);
 	uart_configure_port(drv, state, uport);
 
 	/*
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -49,7 +49,8 @@ void tty_port_link_device(struct tty_por
 {
 	if (WARN_ON(index >= driver->num))
 		return;
-	driver->ports[index] = port;
+	if (!driver->ports[index])
+		driver->ports[index] = port;
 }
 EXPORT_SYMBOL_GPL(tty_port_link_device);
 

