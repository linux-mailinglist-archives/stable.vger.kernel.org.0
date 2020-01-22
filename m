Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E7614524F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 11:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgAVKPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 05:15:54 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39418 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbgAVKPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 05:15:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id o11so5836781ljc.6;
        Wed, 22 Jan 2020 02:15:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Em19EzjWfRgzXWLNmqkC5wijvfl7V9/+QdnPlZcD7+s=;
        b=Nm88Q1RzKjoLlZK4dZeMXSD7e7C3ULGZ0y8aFGZpWUDC8HVWYoH4JtNpyOQfwI1o6o
         6Q7LPtR7teI3mgI5dN8UqkXnnPsomvFXA4EX1K+Ue87x1Oy9ZtJZDnmb2DuBZ0OWEAiK
         rwlCvbNF+8r1lEvi6MfLvPMxLXAqGa+VQEHLcHReZHdOEcLukcuslCLUtSKwrlnwJVNY
         5o561flgRZiFC2cUREvsfdlJp3VwrYN17wTuqa45v4tXliR4FsPfYTVfb1sg6eAnKIys
         hpnKIviGGJcxJJEfoVGng78Vtz1Y8HKzkRqlHzQluDJsr++GI2bFON0ibJ8kDUo3zcil
         TQMg==
X-Gm-Message-State: APjAAAW/MotwdIKRCMzRZ/c811kkRjecyjJmb2Z0i2pqqzUPupMFyR21
        saDDbaIXGaxwK3FEuY+Cf5ifi7Yi
X-Google-Smtp-Source: APXvYqzyu1e0zzpVNUaebmYd/1OK53ZCTp1+35cmK3LfXrtiKhKPmg/RpfKEymswco7AM07cL8sskQ==
X-Received: by 2002:a2e:8745:: with SMTP id q5mr17803846ljj.208.1579688151805;
        Wed, 22 Jan 2020 02:15:51 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 2sm20088114ljq.38.2020.01.22.02.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:15:50 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iuD34-0007bf-Ca; Wed, 22 Jan 2020 11:15:46 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 3/5] USB: serial: ir-usb: fix IrLAP framing
Date:   Wed, 22 Jan 2020 11:15:28 +0100
Message-Id: <20200122101530.29176-4-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122101530.29176-1-johan@kernel.org>
References: <20200122101530.29176-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
switched to using the generic write implementation which may combine
multiple write requests into larger transfers. This can break the IrLAP
protocol where end-of-frame is determined using the USB short packet
mechanism, for example, if multiple frames are sent in rapid succession.

Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ir-usb.c | 113 +++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 26eab1307165..627bea7e6cfb 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -45,9 +45,10 @@ static int buffer_size;
 static int xbof = -1;
 
 static int  ir_startup (struct usb_serial *serial);
-static int  ir_open(struct tty_struct *tty, struct usb_serial_port *port);
-static int ir_prepare_write_buffer(struct usb_serial_port *port,
-						void *dest, size_t size);
+static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
+		const unsigned char *buf, int count);
+static int ir_write_room(struct tty_struct *tty);
+static void ir_write_bulk_callback(struct urb *urb);
 static void ir_process_read_urb(struct urb *urb);
 static void ir_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
@@ -77,8 +78,9 @@ static struct usb_serial_driver ir_device = {
 	.num_ports		= 1,
 	.set_termios		= ir_set_termios,
 	.attach			= ir_startup,
-	.open			= ir_open,
-	.prepare_write_buffer	= ir_prepare_write_buffer,
+	.write			= ir_write,
+	.write_room		= ir_write_room,
+	.write_bulk_callback	= ir_write_bulk_callback,
 	.process_read_urb	= ir_process_read_urb,
 };
 
@@ -254,35 +256,102 @@ static int ir_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static int ir_open(struct tty_struct *tty, struct usb_serial_port *port)
+static int ir_write(struct tty_struct *tty, struct usb_serial_port *port,
+		const unsigned char *buf, int count)
 {
-	int i;
+	struct urb *urb = NULL;
+	unsigned long flags;
+	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(port->write_urbs); ++i)
-		port->write_urbs[i]->transfer_flags = URB_ZERO_PACKET;
+	if (port->bulk_out_size == 0)
+		return -EINVAL;
 
-	/* Start reading from the device */
-	return usb_serial_generic_open(tty, port);
-}
+	if (count == 0)
+		return 0;
 
-static int ir_prepare_write_buffer(struct usb_serial_port *port,
-						void *dest, size_t size)
-{
-	unsigned char *buf = dest;
-	int count;
+	count = min(count, port->bulk_out_size - 1);
+
+	spin_lock_irqsave(&port->lock, flags);
+	if (__test_and_clear_bit(0, &port->write_urbs_free)) {
+		urb = port->write_urbs[0];
+		port->tx_bytes += count;
+	}
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	if (!urb)
+		return 0;
 
 	/*
 	 * The first byte of the packet we send to the device contains an
-	 * inbound header which indicates an additional number of BOFs and
+	 * outbound header which indicates an additional number of BOFs and
 	 * a baud rate change.
 	 *
 	 * See section 5.4.2.2 of the USB IrDA spec.
 	 */
-	*buf = ir_xbof | ir_baud;
+	*(u8 *)urb->transfer_buffer = ir_xbof | ir_baud;
+
+	memcpy(urb->transfer_buffer + 1, buf, count);
+
+	urb->transfer_buffer_length = count + 1;
+	urb->transfer_flags = URB_ZERO_PACKET;
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret) {
+		dev_err(&port->dev, "failed to submit write urb: %d\n", ret);
+
+		spin_lock_irqsave(&port->lock, flags);
+		__set_bit(0, &port->write_urbs_free);
+		port->tx_bytes -= count;
+		spin_unlock_irqrestore(&port->lock, flags);
+
+		return ret;
+	}
+
+	return count;
+}
+
+static void ir_write_bulk_callback(struct urb *urb)
+{
+	struct usb_serial_port *port = urb->context;
+	int status = urb->status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	__set_bit(0, &port->write_urbs_free);
+	port->tx_bytes -= urb->transfer_buffer_length - 1;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	switch (status) {
+	case 0:
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		dev_dbg(&port->dev, "write urb stopped: %d\n", status);
+		return;
+	case -EPIPE:
+		dev_err(&port->dev, "write urb stopped: %d\n", status);
+		return;
+	default:
+		dev_err(&port->dev, "nonzero write-urb status: %d\n", status);
+		break;
+	}
+
+	usb_serial_port_softint(port);
+}
+
+static int ir_write_room(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	int count = 0;
+
+	if (port->bulk_out_size == 0)
+		return 0;
+
+	if (test_bit(0, &port->write_urbs_free))
+		count = port->bulk_out_size - 1;
 
-	count = kfifo_out_locked(&port->write_fifo, buf + 1, size - 1,
-								&port->lock);
-	return count + 1;
+	return count;
 }
 
 static void ir_process_read_urb(struct urb *urb)
-- 
2.24.1

