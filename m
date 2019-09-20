Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76701B91BC
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388392AbfITOZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36748 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388355AbfITOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:14 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqR-0004xX-Hp; Fri, 20 Sep 2019 15:25:11 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007uM-6e; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.778189460@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 072/132] USB: serial: fix unthrottle races
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/generic.c | 39 +++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -350,6 +350,7 @@ void usb_serial_generic_read_bulk_callba
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
+	bool stopped = false;
 	int status = urb->status;
 	int i;
 
@@ -357,33 +358,51 @@ void usb_serial_generic_read_bulk_callba
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
@@ -458,6 +477,12 @@ void usb_serial_generic_unthrottle(struc
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

