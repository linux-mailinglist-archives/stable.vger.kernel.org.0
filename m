Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3806113A63B
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbgANKKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbgANKKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:10:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8DF20678;
        Tue, 14 Jan 2020 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996617;
        bh=+B9vjfKRifOYrJv2rNTi+ClHryp0A5p2lCBhAplKizI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMwpCbt2SwKL6B8jW14bDWjLWvjRsp0SAUCHwXttyTqU0Z1uSk7TQ23RtGodszmTD
         j5RUkpnvic7DQlPTGzPC38QHO2oE41SnCdT5erEI+HL9MNXSKUAnkvtQ36+5JHEBtF
         5ZTrhD22UyPazA5WsscW9dwtWT4tnpqVQir/rMaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 26/39] tty: link tty and port before configuring it as console
Date:   Tue, 14 Jan 2020 11:02:00 +0100
Message-Id: <20200114094344.699176547@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191212131602.29504-1-sudipm.mukherjee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |    1 +
 drivers/tty/tty_port.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2810,6 +2810,7 @@ int uart_add_one_port(struct uart_driver
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
 
+	tty_port_link_device(port, drv->tty_driver, uport->line);
 	uart_configure_port(drv, state, uport);
 
 	port->console = uart_console(uport);
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -88,7 +88,8 @@ void tty_port_link_device(struct tty_por
 {
 	if (WARN_ON(index >= driver->num))
 		return;
-	driver->ports[index] = port;
+	if (!driver->ports[index])
+		driver->ports[index] = port;
 }
 EXPORT_SYMBOL_GPL(tty_port_link_device);
 


