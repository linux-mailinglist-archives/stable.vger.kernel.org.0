Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF371F196
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfEOLQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbfEOLQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:16:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA1320862;
        Wed, 15 May 2019 11:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918959;
        bh=fR9Ra7go9oLoEQ2Zxycne+fGigOmcql6f5zs1nJ1g0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQweBXr8bCeDlC9dI+fRGVj8o0gfJ5YeY0Qoy2VhCs0gAAWHH+wEvGtVZsLY+WrFO
         KHmG85uRP7qI54rCgi6hak93/5wDAovD/KUlDdqFhEIaQHbmAP6QZp/6isIRPTSjeL
         xSHasJvFjJaJGpnhQuYkivAU2vrdsI0FufD8+WlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 006/115] USB: serial: fix unthrottle races
Date:   Wed, 15 May 2019 12:54:46 +0200
Message-Id: <20190515090659.694603200@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3f5edd58d040bfa4b74fb89bc02f0bc6b9cd06ab upstream.

Fix two long-standing bugs which could potentially lead to memory
corruption or leave the port throttled until it is reopened (on weakly
ordered systems), respectively, when read-URB completion races with
unthrottle().

First, the URB must not be marked as free before processing is complete
to prevent it from being submitted by unthrottle() on another CPU.

	CPU 1				CPU 2
	================		================
	complete()			unthrottle()
	  process_urb();
	  smp_mb__before_atomic();
	  set_bit(i, free);		  if (test_and_clear_bit(i, free))
	  					  submit_urb();

Second, the URB must be marked as free before checking the throttled
flag to prevent unthrottle() on another CPU from failing to observe that
the URB needs to be submitted if complete() sees that the throttled flag
is set.

	CPU 1				CPU 2
	================		================
	complete()			unthrottle()
	  set_bit(i, free);		  throttled = 0;
	  smp_mb__after_atomic();	  smp_mb();
	  if (throttled)		  if (test_and_clear_bit(i, free))
	  	  return;			  submit_urb();

Note that test_and_clear_bit() only implies barriers when the test is
successful. To handle the case where the URB is still in use an explicit
barrier needs to be added to unthrottle() for the second race condition.

Fixes: d83b405383c9 ("USB: serial: add support for multiple read urbs")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/generic.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -379,6 +379,7 @@ void usb_serial_generic_read_bulk_callba
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
+	bool stopped = false;
 	int status = urb->status;
 	int i;
 
@@ -386,33 +387,51 @@ void usb_serial_generic_read_bulk_callba
 		if (urb == port->read_urbs[i])
 			break;
 	}
-	set_bit(i, &port->read_urbs_free);
 
 	dev_dbg(&port->dev, "%s - urb %d, len %d\n", __func__, i,
 							urb->actual_length);
 	switch (status) {
 	case 0:
+		usb_serial_debug_data(&port->dev, __func__, urb->actual_length,
+							data);
+		port->serial->type->process_read_urb(urb);
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
 							__func__, status);
-		return;
+		stopped = true;
+		break;
 	case -EPIPE:
 		dev_err(&port->dev, "%s - urb stopped: %d\n",
 							__func__, status);
-		return;
+		stopped = true;
+		break;
 	default:
 		dev_dbg(&port->dev, "%s - nonzero urb status: %d\n",
 							__func__, status);
-		goto resubmit;
+		break;
 	}
 
-	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
-	port->serial->type->process_read_urb(urb);
+	/*
+	 * Make sure URB processing is done before marking as free to avoid
+	 * racing with unthrottle() on another CPU. Matches the barriers
+	 * implied by the test_and_clear_bit() in
+	 * usb_serial_generic_submit_read_urb().
+	 */
+	smp_mb__before_atomic();
+	set_bit(i, &port->read_urbs_free);
+	/*
+	 * Make sure URB is marked as free before checking the throttled flag
+	 * to avoid racing with unthrottle() on another CPU. Matches the
+	 * smp_mb() in unthrottle().
+	 */
+	smp_mb__after_atomic();
+
+	if (stopped)
+		return;
 
-resubmit:
 	/* Throttle the device if requested by tty */
 	spin_lock_irqsave(&port->lock, flags);
 	port->throttled = port->throttle_req;
@@ -487,6 +506,12 @@ void usb_serial_generic_unthrottle(struc
 	port->throttled = port->throttle_req = 0;
 	spin_unlock_irq(&port->lock);
 
+	/*
+	 * Matches the smp_mb__after_atomic() in
+	 * usb_serial_generic_read_bulk_callback().
+	 */
+	smp_mb();
+
 	if (was_throttled)
 		usb_serial_generic_submit_read_urbs(port, GFP_KERNEL);
 }


