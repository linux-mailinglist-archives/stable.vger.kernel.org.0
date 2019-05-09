Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95F5191FD
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEIStz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfEIStx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:49:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85AD32183E;
        Thu,  9 May 2019 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427793;
        bh=I+QDktYu+QQzHoDsXUrQ9bv4Jncxo0ot9xe/W1uWQZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyK7xR+Oh1K1gaPcOq/fVuPN+hizW2OErYLEi5rmbWQmtxjU18C3iXakgmk3aybH0
         hN4MdakQkZ6eitdkQoBhIhFrh/ZHukCUT3iWxZ8RcgzcmClGahYC39P4as1j7im8ue
         cEh57gIzJIMUWPgdxkyIQapPkWJTy69eP3TqTckY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 52/66] USB: serial: f81232: fix interrupt worker not stop
Date:   Thu,  9 May 2019 20:42:27 +0200
Message-Id: <20190509181307.088759077@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>

commit 804dbee1e49774918339c1e5a87400988c0819e8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/f81232.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -556,9 +556,12 @@ static int f81232_open(struct tty_struct
 
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
@@ -652,6 +655,40 @@ static int f81232_port_remove(struct usb
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
@@ -675,6 +712,8 @@ static struct usb_serial_driver f81232_d
 	.read_int_callback =	f81232_read_int_callback,
 	.port_probe =		f81232_port_probe,
 	.port_remove =		f81232_port_remove,
+	.suspend =		f81232_suspend,
+	.resume =		f81232_resume,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {


