Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13369F141
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 09:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfD3H0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 03:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3H0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 03:26:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8819F2080C;
        Tue, 30 Apr 2019 07:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556609206;
        bh=+HovBSRTWUQeTmTQuTvfzhX+RMbgbI41Ce0GP5FYWTA=;
        h=Subject:To:From:Date:From;
        b=1D23RGo2BiejltCtmeRwoUzBTPXkGjI+gExb5pxh/PrIGg7s+PhQUPq0Ki54CcdVm
         aDRAPXy+CyE/ACEHUPT/SQ3YGQSo0Xbq099nLR52R9LI4iuRY/XmWC6pWAWE6Dzt6e
         WWuLSPMgDZWiwI4AxXV/M5E/FWDp1V7fhK4vHz+8=
Subject: patch "USB: cdc-acm: fix unthrottle races" added to usb-next
To:     johan@kernel.org, gregkh@linuxfoundation.org, oneukum@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 30 Apr 2019 09:26:43 +0200
Message-ID: <1556609203223151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-acm: fix unthrottle races

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 764478f41130f1b8d8057575b89e69980a0f600d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 25 Apr 2019 18:05:39 +0200
Subject: USB: cdc-acm: fix unthrottle races

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ec666eb4b7b4..c03aa8550980 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -470,12 +470,12 @@ static void acm_read_bulk_callback(struct urb *urb)
 	struct acm *acm = rb->instance;
 	unsigned long flags;
 	int status = urb->status;
+	bool stopped = false;
+	bool stalled = false;
 
 	dev_vdbg(&acm->data->dev, "got urb %d, len %d, status %d\n",
 		rb->index, urb->actual_length, status);
 
-	set_bit(rb->index, &acm->read_urbs_free);
-
 	if (!acm->dev) {
 		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
 		return;
@@ -488,15 +488,16 @@ static void acm_read_bulk_callback(struct urb *urb)
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
@@ -505,10 +506,24 @@ static void acm_read_bulk_callback(struct urb *urb)
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
@@ -842,6 +857,9 @@ static void acm_tty_unthrottle(struct tty_struct *tty)
 	acm->throttle_req = 0;
 	spin_unlock_irq(&acm->read_lock);
 
+	/* Matches the smp_mb__after_atomic() in acm_read_bulk_callback(). */
+	smp_mb();
+
 	if (was_throttled)
 		acm_submit_read_urbs(acm, GFP_KERNEL);
 }
-- 
2.21.0


