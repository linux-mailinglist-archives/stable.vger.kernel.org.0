Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4190D14E1BA
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbgA3SrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731005AbgA3Sq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:46:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05A620674;
        Thu, 30 Jan 2020 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410018;
        bh=3kM9e9MQWAmuC3Po1OJvzxbXTCdlRt6TUpNoO8DV8DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ+IiOOUzNWVqFVRA0qsKVBHpsBl8ees6/b4hPjzRg0ITxCfgagz7WnoUoq7ncI0m
         7YwIB0UTy7bc/yaRc+PbNq1dIZdzychne4ag5vkftLF6xDZJg+BtR1kkQn8/7RK/CS
         Ef4w641bgOsRPWnCmUzqVy7P9lcnxmleMRfflAP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 06/55] USB: serial: ir-usb: fix IrLAP framing
Date:   Thu, 30 Jan 2020 19:38:47 +0100
Message-Id: <20200130183609.862694344@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 38c0d5bdf4973f9f5a888166e9d3e9ed0d32057a upstream.

Commit f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
switched to using the generic write implementation which may combine
multiple write requests into larger transfers. This can break the IrLAP
protocol where end-of-frame is determined using the USB short packet
mechanism, for example, if multiple frames are sent in rapid succession.

Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ir-usb.c |  113 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 91 insertions(+), 22 deletions(-)

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
@@ -77,8 +78,9 @@ static struct usb_serial_driver ir_devic
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
 
@@ -254,35 +256,102 @@ static int ir_startup(struct usb_serial
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


