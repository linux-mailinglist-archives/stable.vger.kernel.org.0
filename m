Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CEF2E66A7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbgL1NSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgL1NSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:18:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2DF3206ED;
        Mon, 28 Dec 2020 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161502;
        bh=5s+ayH5xSO+3HI4I6eAAxZcKK4J4aqp9MoUjWQlXeIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiUP2C+q6T4XDWCgh7NS5hhNLNkwZbwuVmJ5QbQEmeuGqPkzFwtkFaedJ2H9MjEv/
         aM0k6VSHrKYXjqnB5+wUqfnO+k9EuWfTuw3I9q3xUocKzh1J1JkROpO/l5Ke7rtzFx
         2vM+vTk5j+7WNKAaaInGiuNM66YjmvCHZwdEvilU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 205/242] USB: serial: keyspan_pda: fix write unthrottling
Date:   Mon, 28 Dec 2020 13:50:10 +0100
Message-Id: <20201228124914.769521607@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 320f9028c7873c3c7710e8e93e5c979f4c857490 upstream.

The driver did not update its view of the available device buffer space
until write() was called in task context. This meant that write_room()
would return 0 even after the device had sent a write-unthrottle
notification, something which could lead to blocked writers not being
woken up (e.g. when using OPOST).

Note that we must also request an unthrottle notification is case a
write() request fills the device buffer exactly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -44,6 +44,8 @@
 #define DRIVER_AUTHOR "Brian Warner <warner@lothar.com>"
 #define DRIVER_DESC "USB Keyspan PDA Converter driver"
 
+#define KEYSPAN_TX_THRESHOLD	16
+
 struct keyspan_pda_private {
 	int			tx_room;
 	int			tx_throttled;
@@ -114,7 +116,7 @@ static void keyspan_pda_request_unthrott
 				 7, /* request_unthrottle */
 				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE
 				 | USB_DIR_OUT,
-				 16, /* value: threshold */
+				 KEYSPAN_TX_THRESHOLD,
 				 0, /* index */
 				 NULL,
 				 0,
@@ -133,6 +135,8 @@ static void keyspan_pda_rx_interrupt(str
 	int retval;
 	int status = urb->status;
 	struct keyspan_pda_private *priv;
+	unsigned long flags;
+
 	priv = usb_get_serial_port_data(port);
 
 	switch (status) {
@@ -175,7 +179,10 @@ static void keyspan_pda_rx_interrupt(str
 		case 1: /* modemline change */
 			break;
 		case 2: /* tx unthrottle interrupt */
+			spin_lock_irqsave(&port->lock, flags);
 			priv->tx_throttled = 0;
+			priv->tx_room = max(priv->tx_room, KEYSPAN_TX_THRESHOLD);
+			spin_unlock_irqrestore(&port->lock, flags);
 			/* queue up a wakeup at scheduler time */
 			usb_serial_port_softint(port);
 			break;
@@ -509,7 +516,8 @@ static int keyspan_pda_write(struct tty_
 			goto exit;
 		}
 	}
-	if (count > priv->tx_room) {
+
+	if (count >= priv->tx_room) {
 		/* we're about to completely fill the Tx buffer, so
 		   we'll be throttled afterwards. */
 		count = priv->tx_room;
@@ -564,14 +572,17 @@ static void keyspan_pda_write_bulk_callb
 static int keyspan_pda_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct keyspan_pda_private *priv;
-	priv = usb_get_serial_port_data(port);
-	/* used by n_tty.c for processing of tabs and such. Giving it our
-	   conservative guess is probably good enough, but needs testing by
-	   running a console through the device. */
-	return priv->tx_room;
-}
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	int room = 0;
+
+	spin_lock_irqsave(&port->lock, flags);
+	if (test_bit(0, &port->write_urbs_free) && !priv->tx_throttled)
+		room = priv->tx_room;
+	spin_unlock_irqrestore(&port->lock, flags);
 
+	return room;
+}
 
 static int keyspan_pda_chars_in_buffer(struct tty_struct *tty)
 {


