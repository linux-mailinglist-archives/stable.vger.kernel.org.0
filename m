Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F7119138
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfEISyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfEISyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBD9204FD;
        Thu,  9 May 2019 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428055;
        bh=k/TeH7BaKVX1u50l//zvo0KDlOFkKEQ+Vt+mzlbxyaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe3xyLbj6KoVWISWpfbMGaNbYTY8RMLMZFd0ZTq3E4zlMxQGYXnTJAz2g037jfSuu
         ZKkXmaDS+AUQu3hjCgczYMqMBcFePSwZ3wWISRNPNjmON/1GURNYx8McckL3uNzcDI
         6L1zbz8ukUNeyjK3QbscXf8NTp4nnRHHVEwjze2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.1 10/30] USB: cdc-acm: fix unthrottle races
Date:   Thu,  9 May 2019 20:42:42 +0200
Message-Id: <20190509181252.882348559@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -470,12 +470,12 @@ static void acm_read_bulk_callback(struc
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
@@ -488,15 +488,16 @@ static void acm_read_bulk_callback(struc
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
@@ -505,10 +506,24 @@ static void acm_read_bulk_callback(struc
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
@@ -842,6 +857,9 @@ static void acm_tty_unthrottle(struct tt
 	acm->throttle_req = 0;
 	spin_unlock_irq(&acm->read_lock);
 
+	/* Matches the smp_mb__after_atomic() in acm_read_bulk_callback(). */
+	smp_mb();
+
 	if (was_throttled)
 		acm_submit_read_urbs(acm, GFP_KERNEL);
 }


