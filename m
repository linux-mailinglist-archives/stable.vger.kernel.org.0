Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620C52982E5
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 18:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417814AbgJYRrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 13:47:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42674 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417720AbgJYRql (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 13:46:41 -0400
Received: by mail-lf1-f65.google.com with SMTP id a7so8895825lfk.9;
        Sun, 25 Oct 2020 10:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1H5cIB/bnI7O4kZIMRYu9JZwd7Rp7lhti4RdlQxKvBk=;
        b=bJ+al9spyiNr2zb8hBJZTWn8VhdKdLmJMnyrIBq69dAoaY8bCUdVBZpPlMSNqN/vUh
         nuy3ae9xU/Gl1dqxVbGxTmplLQO0L6UeJk5l7mfu7JEBswLHNo5ZJboHN3nAc8GPwI0G
         OZ0nA1oYAOGQEktsm+qRCSNpUsyqpWHp0NyhasUAMK7zd/37jrHs25EGWdrfE6ZO7ikq
         eDV1UebtLT8qWeuGh2o2JJJbkxSNoi4LGW9FkWijngIVMEDLrHlyX2M0mOUOONijtpax
         tr+lRwcRiTNTMCoVIsqyIp76B3JGpe0fprQBpb5jyt2nIilBXkJchGW/xKxEuZ/Rdrho
         rfjQ==
X-Gm-Message-State: AOAM531ErzRTtEd40LZbHU91s2/Sab5pgfFgOv0wrgkkic4X/bQ9EVXt
        x/DwN+15hmOQ7HPQyzBqb/29K3aqcoyODw==
X-Google-Smtp-Source: ABdhPJyMguwhTZ7jhhrj2tg6SKza40nPfJA+ZqzBJMbkx9j5BAM6dr2ysJbUAYTZFW+3YmxXZmukPw==
X-Received: by 2002:a19:840d:: with SMTP id g13mr3443725lfd.225.1603647998179;
        Sun, 25 Oct 2020 10:46:38 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id k16sm873420ljc.39.2020.10.25.10.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 10:46:36 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWk6I-0007HZ-Us; Sun, 25 Oct 2020 18:46:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 06/14] USB: serial: keyspan_pda: fix write unthrottling
Date:   Sun, 25 Oct 2020 18:45:52 +0100
Message-Id: <20201025174600.27896-7-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025174600.27896-1-johan@kernel.org>
References: <20201025174600.27896-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver did not update its view of the available device buffer space
until write() was called in task context. This meant that write_room()
would return 0 even after the device had sent a write-unthrottle
notification, something which could lead to blocked writers not being
woken up (e.g. when using OPOST).

Note that we must also request an unthrottle notification is case a
write() request fills the device buffer exactly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
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
2.26.2

