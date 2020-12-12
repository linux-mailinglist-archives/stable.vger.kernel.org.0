Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0842D8589
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 11:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438508AbgLLKAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 05:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438526AbgLLKAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 05:00:21 -0500
Subject: patch "USB: serial: keyspan_pda: fix write unthrottling" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607767180;
        bh=3KYSi1VRbAaBlUAv+62iJR+Bw0gpwjpzofuQdP4FSBk=;
        h=To:From:Date:From;
        b=hTyJmI+3cYUFi7d4QEsjJx3e+BbYW6D7z8kRPEsbkjuHJqLO9MtzB/bN10qIlsHiO
         rq08ynCiLSPozMk/Exy7+BMOF3B/EJsHCa0872ZbfXUPZWJZ2yks0HTrLwIpLCesbD
         +IT8hIUaZVdTA4R0S6lhMuJPGscyMJwLuHKh9g2M=
To:     johan@kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Dec 2020 10:59:21 +0100
Message-ID: <1607767161567@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: keyspan_pda: fix write unthrottling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 320f9028c7873c3c7710e8e93e5c979f4c857490 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Sun, 25 Oct 2020 18:45:52 +0100
Subject: USB: serial: keyspan_pda: fix write unthrottling

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
---
 drivers/usb/serial/keyspan_pda.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 781b6723379f..39ed3ad32365 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -40,6 +40,8 @@
 #define DRIVER_AUTHOR "Brian Warner <warner@lothar.com>"
 #define DRIVER_DESC "USB Keyspan PDA Converter driver"
 
+#define KEYSPAN_TX_THRESHOLD	16
+
 struct keyspan_pda_private {
 	int			tx_room;
 	int			tx_throttled;
@@ -110,7 +112,7 @@ static void keyspan_pda_request_unthrottle(struct work_struct *work)
 				 7, /* request_unthrottle */
 				 USB_TYPE_VENDOR | USB_RECIP_INTERFACE
 				 | USB_DIR_OUT,
-				 16, /* value: threshold */
+				 KEYSPAN_TX_THRESHOLD,
 				 0, /* index */
 				 NULL,
 				 0,
@@ -129,6 +131,8 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 	int retval;
 	int status = urb->status;
 	struct keyspan_pda_private *priv;
+	unsigned long flags;
+
 	priv = usb_get_serial_port_data(port);
 
 	switch (status) {
@@ -171,7 +175,10 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
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
@@ -505,7 +512,8 @@ static int keyspan_pda_write(struct tty_struct *tty,
 			goto exit;
 		}
 	}
-	if (count > priv->tx_room) {
+
+	if (count >= priv->tx_room) {
 		/* we're about to completely fill the Tx buffer, so
 		   we'll be throttled afterwards. */
 		count = priv->tx_room;
@@ -560,14 +568,17 @@ static void keyspan_pda_write_bulk_callback(struct urb *urb)
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
-- 
2.29.2


