Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C54D1F4431
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbgFISCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbgFIRxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A926C20734;
        Tue,  9 Jun 2020 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725228;
        bh=61wbgqZP6RiTlB2en8fs2oA+5228qjJ/z3HAiGnFn+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLpXqw6FgWG9zguQeLFPFMxGiubI9Ekaxza42YwjMI5++wa8JUAlGTkogbuNaURgq
         ZYWV37MuhKiDcLsT783n0TK6A3yyLM1FmQEEjU5NtxDge/tFCPK7TRNElmJLQbJg5A
         6K0W++e7muZ7uuPdFuDxgbHJqnB5t9BHsNR52Tp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Hanselmann <public@hansmi.ch>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.6 21/41] USB: serial: ch341: add basis for quirk detection
Date:   Tue,  9 Jun 2020 19:45:23 +0200
Message-Id: <20200609174114.150309933@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hanselmann <public@hansmi.ch>

commit c404bf4aa9236cb4d1068e499ae42acf48a6ff97 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |   53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

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
@@ -330,6 +378,11 @@ static int ch341_port_probe(struct usb_s
 		goto error;
 
 	usb_set_serial_port_data(port, priv);
+
+	r = ch341_detect_quirks(port);
+	if (r < 0)
+		goto error;
+
 	return 0;
 
 error:	kfree(priv);


