Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814781E7740
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 09:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgE2HmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 03:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgE2HmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 03:42:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD43220723;
        Fri, 29 May 2020 07:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590738131;
        bh=8u6wnbEgstM19gdCJf6kFdzo46HNCAQB7KTwud9Ud6A=;
        h=Subject:To:From:Date:From;
        b=GeXnCo9mE6gc8nbF+X0dcZpA2M97FBNO8ZN//dvhnu/LRX2D0FZ1L31c1+8WDDd/G
         z0Jvq+44quDmJ0+dx+e4ME0cGbCepwLyCHiI+OCBkOYbo1o/IyX6JObr6cFEEACVlT
         1RrSQ/NpPYKHD1OJy3oQ+zvmqR15zayJupumv+rU=
Subject: patch "USB: serial: ch341: add basis for quirk detection" added to usb-next
To:     public@hansmi.ch, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 29 May 2020 09:42:01 +0200
Message-ID: <159073812113557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ch341: add basis for quirk detection

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c404bf4aa9236cb4d1068e499ae42acf48a6ff97 Mon Sep 17 00:00:00 2001
From: Michael Hanselmann <public@hansmi.ch>
Date: Tue, 31 Mar 2020 23:37:18 +0000
Subject: USB: serial: ch341: add basis for quirk detection

A subset of CH341 devices does not support all features, namely the
prescaler is limited to a reduced precision and there is no support for
sending a RS232 break condition. This patch adds a detection function
which will be extended to set quirk flags as they're implemented.

The author's affected device has an imprint of "340" on the
turquoise-colored plug, but not all such devices appear to be affected.

Signed-off-by: Michael Hanselmann <public@hansmi.ch>
Link: https://lore.kernel.org/r/1e1ae0da6082bb528a44ef323d4e1d3733d38858.1585697281.git.public@hansmi.ch
[ johan: use long type for quirks; rephrase and use port device for
	 messages; handle short reads; set quirk flags directly in
	 helper function ]
Cc: stable <stable@vger.kernel.org>	# 5.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 53 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index c5ecdcd51ffc..f2b93f4554a7 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -87,6 +87,7 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+	unsigned long quirks;
 };
 
 static void ch341_set_termios(struct tty_struct *tty,
@@ -308,6 +309,53 @@ out:	kfree(buffer);
 	return r;
 }
 
+static int ch341_detect_quirks(struct usb_serial_port *port)
+{
+	struct ch341_private *priv = usb_get_serial_port_data(port);
+	struct usb_device *udev = port->serial->dev;
+	const unsigned int size = 2;
+	unsigned long quirks = 0;
+	char *buffer;
+	int r;
+
+	buffer = kmalloc(size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	/*
+	 * A subset of CH34x devices does not support all features. The
+	 * prescaler is limited and there is no support for sending a RS232
+	 * break condition. A read failure when trying to set up the latter is
+	 * used to detect these devices.
+	 */
+	r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), CH341_REQ_READ_REG,
+			    USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			    CH341_REG_BREAK, 0, buffer, size, DEFAULT_TIMEOUT);
+	if (r == -EPIPE) {
+		dev_dbg(&port->dev, "break control not supported\n");
+		r = 0;
+		goto out;
+	}
+
+	if (r != size) {
+		if (r >= 0)
+			r = -EIO;
+		dev_err(&port->dev, "failed to read break control: %d\n", r);
+		goto out;
+	}
+
+	r = 0;
+out:
+	kfree(buffer);
+
+	if (quirks) {
+		dev_dbg(&port->dev, "enabling quirk flags: 0x%02lx\n", quirks);
+		priv->quirks |= quirks;
+	}
+
+	return r;
+}
+
 static int ch341_port_probe(struct usb_serial_port *port)
 {
 	struct ch341_private *priv;
@@ -330,6 +378,11 @@ static int ch341_port_probe(struct usb_serial_port *port)
 		goto error;
 
 	usb_set_serial_port_data(port, priv);
+
+	r = ch341_detect_quirks(port);
+	if (r < 0)
+		goto error;
+
 	return 0;
 
 error:	kfree(priv);
-- 
2.26.2


