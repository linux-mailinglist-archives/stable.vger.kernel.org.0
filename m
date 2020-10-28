Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900029D6B6
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbgJ1WRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731707AbgJ1WRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82E7524706;
        Wed, 28 Oct 2020 12:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603887581;
        bh=lFAa4bk6HE3bRBo1v0aDytoIMsW2IVc1YYOWWdGEKpw=;
        h=Subject:To:From:Date:From;
        b=uDMwkTI/MwNl6fBPvNHFwAfOBt+wm636JyoaNe70M+Ez1cnK58VfzS8M8r8P8D/GE
         jBN3J7WpGucduNi7+U20J0ARsBV8ub+AdchCGyNS6teCMXuoqcNFZYmXqUBiIJIwXA
         LdEPEliz8uF6ykZpuQXUfPF58Sf9dQAyYL+0vFDU=
Subject: patch "usb: cdc-acm: fix cooldown mechanism" added to usb-linus
To:     jbrunet@baylibre.com, gregkh@linuxfoundation.org, oneukum@suse.com,
        pascal.vizeli@nabucasa.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:20:33 +0100
Message-ID: <160388763368212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdc-acm: fix cooldown mechanism

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 38203b8385bf6283537162bde7d499f830964711 Mon Sep 17 00:00:00 2001
From: Jerome Brunet <jbrunet@baylibre.com>
Date: Mon, 19 Oct 2020 19:07:02 +0200
Subject: usb: cdc-acm: fix cooldown mechanism

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
---
 drivers/usb/class/cdc-acm.c | 12 +++++-------
 drivers/usb/class/cdc-acm.h |  3 +--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 30ef946a8e1a..1e7568867910 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -508,6 +508,7 @@ static void acm_read_bulk_callback(struct urb *urb)
 			"%s - cooling babbling device\n", __func__);
 		usb_mark_last_busy(acm->dev);
 		set_bit(rb->index, &acm->urbs_in_error_delay);
+		set_bit(ACM_ERROR_DELAY, &acm->flags);
 		cooldown = true;
 		break;
 	default:
@@ -533,7 +534,7 @@ static void acm_read_bulk_callback(struct urb *urb)
 
 	if (stopped || stalled || cooldown) {
 		if (stalled)
-			schedule_work(&acm->work);
+			schedule_delayed_work(&acm->dwork, 0);
 		else if (cooldown)
 			schedule_delayed_work(&acm->dwork, HZ / 2);
 		return;
@@ -563,13 +564,13 @@ static void acm_write_bulk(struct urb *urb)
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
@@ -585,7 +586,7 @@ static void acm_softint(struct work_struct *work)
 	if (test_and_clear_bit(ACM_ERROR_DELAY, &acm->flags)) {
 		for (i = 0; i < acm->rx_buflimit; i++)
 			if (test_and_clear_bit(i, &acm->urbs_in_error_delay))
-					acm_submit_read_urb(acm, i, GFP_NOIO);
+				acm_submit_read_urb(acm, i, GFP_KERNEL);
 	}
 
 	if (test_and_clear_bit(EVENT_TTY_WAKEUP, &acm->flags))
@@ -1351,7 +1352,6 @@ static int acm_probe(struct usb_interface *intf,
 	acm->ctrlsize = ctrlsize;
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
-	INIT_WORK(&acm->work, acm_softint);
 	INIT_DELAYED_WORK(&acm->dwork, acm_softint);
 	init_waitqueue_head(&acm->wioctl);
 	spin_lock_init(&acm->write_lock);
@@ -1561,7 +1561,6 @@ static void acm_disconnect(struct usb_interface *intf)
 	}
 
 	acm_kill_urbs(acm);
-	cancel_work_sync(&acm->work);
 	cancel_delayed_work_sync(&acm->dwork);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
@@ -1604,7 +1603,6 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 		return 0;
 
 	acm_kill_urbs(acm);
-	cancel_work_sync(&acm->work);
 	cancel_delayed_work_sync(&acm->dwork);
 	acm->urbs_in_error_delay = 0;
 
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index 9dce179d031b..8aef5eb769a0 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -112,8 +112,7 @@ struct acm {
 #		define ACM_ERROR_DELAY	3
 	unsigned long urbs_in_error_delay;		/* these need to be restarted after a delay */
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
-	struct work_struct work;			/* work queue entry for various purposes*/
-	struct delayed_work dwork;			/* for cool downs needed in error recovery */
+	struct delayed_work dwork;		        /* work queue entry for various purposes */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
 	unsigned int ctrlout;				/* output control lines (DTR, RTS) */
 	struct async_icount iocount;			/* counters for control line changes */
-- 
2.29.1


