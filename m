Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FECB924A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbfITOZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36752 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388356AbfITOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:14 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqR-0004xe-PR; Fri, 20 Sep 2019 15:25:11 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007uC-2S; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.752564858@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 070/132] USB: cdc-acm: fix unthrottle races
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

commit 764478f41130f1b8d8057575b89e69980a0f600d upstream.

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

Also note that the first race was fixed by 36e59e0d70d6 ("cdc-acm: fix
race between callback and unthrottle") back in 2015, but the bug was
reintroduced a year later.

Fixes: 1aba579f3cf5 ("cdc-acm: handle read pipe errors")
Fixes: 088c64f81284 ("USB: cdc-acm: re-write read processing")
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -420,12 +420,12 @@ static void acm_read_bulk_callback(struc
 	struct acm *acm = rb->instance;
 	unsigned long flags;
 	int status = urb->status;
+	bool stopped = false;
+	bool stalled = false;
 
 	dev_vdbg(&acm->data->dev, "%s - urb %d, len %d\n", __func__,
 					rb->index, urb->actual_length);
 
-	set_bit(rb->index, &acm->read_urbs_free);
-
 	if (!acm->dev) {
 		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
 		return;
@@ -438,15 +438,16 @@ static void acm_read_bulk_callback(struc
 		break;
 	case -EPIPE:
 		set_bit(EVENT_RX_STALL, &acm->flags);
-		schedule_work(&acm->work);
-		return;
+		stalled = true;
+		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&acm->data->dev,
 			"%s - urb shutting down with status: %d\n",
 			__func__, status);
-		return;
+		stopped = true;
+		break;
 	default:
 		dev_dbg(&acm->data->dev,
 			"%s - nonzero urb status received: %d\n",
@@ -455,10 +456,24 @@ static void acm_read_bulk_callback(struc
 	}
 
 	/*
-	 * Unthrottle may run on another CPU which needs to see events
-	 * in the same order. Submission has an implict barrier
+	 * Make sure URB processing is done before marking as free to avoid
+	 * racing with unthrottle() on another CPU. Matches the barriers
+	 * implied by the test_and_clear_bit() in acm_submit_read_urb().
 	 */
 	smp_mb__before_atomic();
+	set_bit(rb->index, &acm->read_urbs_free);
+	/*
+	 * Make sure URB is marked as free before checking the throttled flag
+	 * to avoid racing with unthrottle() on another CPU. Matches the
+	 * smp_mb() in unthrottle().
+	 */
+	smp_mb__after_atomic();
+
+	if (stopped || stalled) {
+		if (stalled)
+			schedule_work(&acm->work);
+		return;
+	}
 
 	/* throttle device if requested by tty */
 	spin_lock_irqsave(&acm->read_lock, flags);
@@ -807,6 +822,9 @@ static void acm_tty_unthrottle(struct tt
 	acm->throttle_req = 0;
 	spin_unlock_irq(&acm->read_lock);
 
+	/* Matches the smp_mb__after_atomic() in acm_read_bulk_callback(). */
+	smp_mb();
+
 	if (was_throttled)
 		acm_submit_read_urbs(acm, GFP_KERNEL);
 }

