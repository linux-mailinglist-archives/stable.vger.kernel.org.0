Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CFF26DE4
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfEVTpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732432AbfEVT17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:27:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7582B20879;
        Wed, 22 May 2019 19:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553279;
        bh=dg3D/9j+Nm9mDkaTgCRhMm7k1CVoFCTi2y+KqxZ7CUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQoPGJHJ15gv9vZRSTQGCowY172/jiqTxGl74vTJjHb1BUHkeMvyGHNSMLr/avIbz
         mNIgz95JD0dH3aA+28ciw1se7XW2KWYQhdYov0GzK0xJ20+FGVCANl7/7CguP9SlqB
         i1diYM5jtLfo/1cJTUM9DqNJ+wy1SaqsZ86O5CXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 053/244] USB: serial: fix initial-termios handling
Date:   Wed, 22 May 2019 15:23:19 -0400
Message-Id: <20190522192630.24917-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 579bebe5dd522580019e7b10b07daaf500f9fb1e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/usb-serial.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index f7aaa7f079e1a..c709b6281df65 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -164,9 +164,9 @@ void usb_serial_put(struct usb_serial *serial)
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
@@ -178,6 +178,7 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	int idx = tty->index;
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
+	bool init_termios;
 	int retval = -ENODEV;
 
 	port = usb_serial_port_get_by_minor(idx);
@@ -192,14 +193,16 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (retval)
 		goto error_get_interface;
 
+	init_termios = (driver->termios[idx] == NULL);
+
 	retval = tty_standard_install(driver, tty);
 	if (retval)
 		goto error_init_termios;
 
 	mutex_unlock(&serial->disc_mutex);
 
-	/* allow the driver to update the settings */
-	if (serial->type->init_termios)
+	/* allow the driver to update the initial settings */
+	if (init_termios && serial->type->init_termios)
 		serial->type->init_termios(tty);
 
 	tty->driver_data = port;
-- 
2.20.1

