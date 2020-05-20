Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF411DB686
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgETOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:25:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33050 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00037O-13; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DTk-5i; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Wed, 20 May 2020 15:14:32 +0100
Message-ID: <lsq.1589984008.116452665@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 64/99] USB: serial: ir-usb: fix IrLAP framing
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 38c0d5bdf4973f9f5a888166e9d3e9ed0d32057a upstream.

Commit f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
switched to using the generic write implementation which may combine
multiple write requests into larger transfers. This can break the IrLAP
protocol where end-of-frame is determined using the USB short packet
mechanism, for example, if multiple frames are sent in rapid succession.

Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ir-usb.c | 113 +++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 22 deletions(-)

--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -49,9 +49,10 @@ static int buffer_size;
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
@@ -81,8 +82,9 @@ static struct usb_serial_driver ir_devic
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
 
@@ -258,35 +260,102 @@ static int ir_startup(struct usb_serial
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

