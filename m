Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72F1B92BF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391772AbfITOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36038 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388129AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0004xz-HJ; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007tY-OO; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.882376429@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 062/132] USB: serial: fix initial-termios handling
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 579bebe5dd522580019e7b10b07daaf500f9fb1e upstream.

The USB-serial driver init_termios callback is used to override the
default initial terminal settings provided by USB-serial core.

After a bug was fixed in the original implementation introduced by
commit fe1ae7fdd2ee ("tty: USB serial termios bits"), the init_termios
callback was no longer called just once on first use as intended but
rather on every (first) open.

This specifically meant that the terminal settings saved on (final)
close were ignored when reopening a port for drivers overriding the
initial settings.

Also update the outdated function header referring to the creation of
termios objects.

Fixes: 7e29bb4b779f ("usb-serial: fix termios initialization logic")
Signed-off-by: Johan Hovold <johan@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb-serial.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -167,9 +167,9 @@ void usb_serial_put(struct usb_serial *s
  * @driver: the driver (USB in our case)
  * @tty: the tty being created
  *
- * Create the termios objects for this tty.  We use the default
+ * Initialise the termios structure for this tty.  We use the default
  * USB serial settings but permit them to be overridden by
- * serial->type->init_termios.
+ * serial->type->init_termios on first open.
  *
  * This is the first place a new tty gets used.  Hence this is where we
  * acquire references to the usb_serial structure and the driver module,
@@ -181,6 +181,7 @@ static int serial_install(struct tty_dri
 	int idx = tty->index;
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
+	bool init_termios;
 	int retval = -ENODEV;
 
 	port = usb_serial_port_get_by_minor(idx);
@@ -195,14 +196,16 @@ static int serial_install(struct tty_dri
 	if (retval)
 		goto error_get_interface;
 
+	init_termios = (driver->termios[idx] == NULL);
+
 	retval = tty_port_install(&port->port, driver, tty);
 	if (retval)
 		goto error_init_termios;
 
 	mutex_unlock(&serial->disc_mutex);
 
-	/* allow the driver to update the settings */
-	if (serial->type->init_termios)
+	/* allow the driver to update the initial settings */
+	if (init_termios && serial->type->init_termios)
 		serial->type->init_termios(tty);
 
 	tty->driver_data = port;

