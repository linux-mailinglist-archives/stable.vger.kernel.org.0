Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438BA131B6
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfECQBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 12:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbfECQBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 12:01:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C82E2089E;
        Fri,  3 May 2019 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556899305;
        bh=5lC5j/lyXoOs/5seppOEsqtwyj6A+154FKUdipZ/au0=;
        h=Subject:To:From:Date:From;
        b=EfRKzFjidnfHMhlC1WrxtGCW77MThY5F/OhL0O0SOZ8teGYygKGwiQBYocMckxgh0
         Y6nm8plgbukRDb85b9sZo6FurqYPKiTXGDYHhDQXcOOTOzr05ggtDqF5tg5MiP7CxE
         id2Gvx/pHJPvxOKmVBVCrPLDE75EKvJ32CUyN8Do=
Subject: patch "USB: serial: f81232: fix interrupt worker not stop" added to usb-testing
To:     hpeter@gmail.com, hpeter+linux_kernel@gmail.com, johan@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 May 2019 18:00:56 +0200
Message-ID: <155689925611057@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: f81232: fix interrupt worker not stop

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 804dbee1e49774918339c1e5a87400988c0819e8 Mon Sep 17 00:00:00 2001
From: "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
Date: Tue, 30 Apr 2019 09:22:29 +0800
Subject: USB: serial: f81232: fix interrupt worker not stop

The F81232 will use interrupt worker to handle MSR change.
This patch will fix the issue that interrupt work should stop
in close() and suspend().

This also fixes line-status events being disabled after a suspend cycle
until the port is re-opened.

Signed-off-by: Ji-Ze Hong (Peter Hong) <hpeter+linux_kernel@gmail.com>
[ johan: amend commit message ]
Fixes: 87fe5adcd8de ("USB: f81232: implement read IIR/MSR with endpoint")
Cc: stable <stable@vger.kernel.org>	# 4.1
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/f81232.c | 39 +++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 0dcdcb4b2cde..dee6f2caf9b5 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -556,9 +556,12 @@ static int f81232_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 static void f81232_close(struct usb_serial_port *port)
 {
+	struct f81232_private *port_priv = usb_get_serial_port_data(port);
+
 	f81232_port_disable(port);
 	usb_serial_generic_close(port);
 	usb_kill_urb(port->interrupt_in_urb);
+	flush_work(&port_priv->interrupt_work);
 }
 
 static void f81232_dtr_rts(struct usb_serial_port *port, int on)
@@ -632,6 +635,40 @@ static int f81232_port_remove(struct usb_serial_port *port)
 	return 0;
 }
 
+static int f81232_suspend(struct usb_serial *serial, pm_message_t message)
+{
+	struct usb_serial_port *port = serial->port[0];
+	struct f81232_private *port_priv = usb_get_serial_port_data(port);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(port->read_urbs); ++i)
+		usb_kill_urb(port->read_urbs[i]);
+
+	usb_kill_urb(port->interrupt_in_urb);
+
+	if (port_priv)
+		flush_work(&port_priv->interrupt_work);
+
+	return 0;
+}
+
+static int f81232_resume(struct usb_serial *serial)
+{
+	struct usb_serial_port *port = serial->port[0];
+	int result;
+
+	if (tty_port_initialized(&port->port)) {
+		result = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
+		if (result) {
+			dev_err(&port->dev, "submit interrupt urb failed: %d\n",
+					result);
+			return result;
+		}
+	}
+
+	return usb_serial_generic_resume(serial);
+}
+
 static struct usb_serial_driver f81232_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -655,6 +692,8 @@ static struct usb_serial_driver f81232_device = {
 	.read_int_callback =	f81232_read_int_callback,
 	.port_probe =		f81232_port_probe,
 	.port_remove =		f81232_port_remove,
+	.suspend =		f81232_suspend,
+	.resume =		f81232_resume,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
-- 
2.21.0


