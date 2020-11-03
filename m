Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD8D2A547C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388391AbgKCVLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388901AbgKCVLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:11:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C276321534;
        Tue,  3 Nov 2020 21:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437903;
        bh=fAaW3avXwQ+Rk7uagl3fc9OAa0r+ewi18Y4dyTyU3aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqNcFZhpXlOCKjV4vf9K3IhaRzCtxIsbo8PzcDaXmXoPvNisKe05krfUZwG8dpdFS
         MAwZUOegO+tHcqqTzti/7UeM/09jhwN2+sFNtAbMmSLtH2rkCHYjZQQ7Xpas0JTkeU
         CfFYOkBDaeMzar8+LvS2AC0g86VSYfZlIxL4PIbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Pascal Vizeli <pascal.vizeli@nabucasa.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 4.14 081/125] usb: cdc-acm: fix cooldown mechanism
Date:   Tue,  3 Nov 2020 21:37:38 +0100
Message-Id: <20201103203208.665896615@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

commit 38203b8385bf6283537162bde7d499f830964711 upstream.

Commit a4e7279cd1d1 ("cdc-acm: introduce a cool down") is causing
regression if there is some USB error, such as -EPROTO.

This has been reported on some samples of the Odroid-N2 using the Combee II
Zibgee USB dongle.

> struct acm *acm = container_of(work, struct acm, work)

is incorrect in case of a delayed work and causes warnings, usually from
the workqueue:

> WARNING: CPU: 0 PID: 0 at kernel/workqueue.c:1474 __queue_work+0x480/0x528.

When this happens, USB eventually stops working completely after a while.
Also the ACM_ERROR_DELAY bit is never set, so the cooldown mechanism
previously introduced cannot be triggered and acm_submit_read_urb() is
never called.

This changes makes the cdc-acm driver use a single delayed work, fixing the
pointer arithmetic in acm_softint() and set the ACM_ERROR_DELAY when the
cooldown mechanism appear to be needed.

Fixes: a4e7279cd1d1 ("cdc-acm: introduce a cool down")
Cc: Oliver Neukum <oneukum@suse.com>
Reported-by: Pascal Vizeli <pascal.vizeli@nabucasa.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201019170702.150534-1-jbrunet@baylibre.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   12 +++++-------
 drivers/usb/class/cdc-acm.h |    3 +--
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -520,6 +520,7 @@ static void acm_read_bulk_callback(struc
 			"%s - cooling babbling device\n", __func__);
 		usb_mark_last_busy(acm->dev);
 		set_bit(rb->index, &acm->urbs_in_error_delay);
+		set_bit(ACM_ERROR_DELAY, &acm->flags);
 		cooldown = true;
 		break;
 	default:
@@ -545,7 +546,7 @@ static void acm_read_bulk_callback(struc
 
 	if (stopped || stalled || cooldown) {
 		if (stalled)
-			schedule_work(&acm->work);
+			schedule_delayed_work(&acm->dwork, 0);
 		else if (cooldown)
 			schedule_delayed_work(&acm->dwork, HZ / 2);
 		return;
@@ -580,13 +581,13 @@ static void acm_write_bulk(struct urb *u
 	acm_write_done(acm, wb);
 	spin_unlock_irqrestore(&acm->write_lock, flags);
 	set_bit(EVENT_TTY_WAKEUP, &acm->flags);
-	schedule_work(&acm->work);
+	schedule_delayed_work(&acm->dwork, 0);
 }
 
 static void acm_softint(struct work_struct *work)
 {
 	int i;
-	struct acm *acm = container_of(work, struct acm, work);
+	struct acm *acm = container_of(work, struct acm, dwork.work);
 
 	if (test_bit(EVENT_RX_STALL, &acm->flags)) {
 		smp_mb(); /* against acm_suspend() */
@@ -602,7 +603,7 @@ static void acm_softint(struct work_stru
 	if (test_and_clear_bit(ACM_ERROR_DELAY, &acm->flags)) {
 		for (i = 0; i < acm->rx_buflimit; i++)
 			if (test_and_clear_bit(i, &acm->urbs_in_error_delay))
-					acm_submit_read_urb(acm, i, GFP_NOIO);
+				acm_submit_read_urb(acm, i, GFP_KERNEL);
 	}
 
 	if (test_and_clear_bit(EVENT_TTY_WAKEUP, &acm->flags))
@@ -1405,7 +1406,6 @@ made_compressed_probe:
 	acm->ctrlsize = ctrlsize;
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
-	INIT_WORK(&acm->work, acm_softint);
 	INIT_DELAYED_WORK(&acm->dwork, acm_softint);
 	init_waitqueue_head(&acm->wioctl);
 	spin_lock_init(&acm->write_lock);
@@ -1619,7 +1619,6 @@ static void acm_disconnect(struct usb_in
 	}
 
 	acm_kill_urbs(acm);
-	cancel_work_sync(&acm->work);
 	cancel_delayed_work_sync(&acm->dwork);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
@@ -1662,7 +1661,6 @@ static int acm_suspend(struct usb_interf
 		return 0;
 
 	acm_kill_urbs(acm);
-	cancel_work_sync(&acm->work);
 	cancel_delayed_work_sync(&acm->dwork);
 	acm->urbs_in_error_delay = 0;
 
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -111,8 +111,7 @@ struct acm {
 #		define ACM_ERROR_DELAY	3
 	unsigned long urbs_in_error_delay;		/* these need to be restarted after a delay */
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
-	struct work_struct work;			/* work queue entry for various purposes*/
-	struct delayed_work dwork;			/* for cool downs needed in error recovery */
+	struct delayed_work dwork;		        /* work queue entry for various purposes */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
 	unsigned int ctrlout;				/* output control lines (DTR, RTS) */
 	struct async_icount iocount;			/* counters for control line changes */


