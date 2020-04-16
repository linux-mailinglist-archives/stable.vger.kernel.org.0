Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB841AC1F3
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894708AbgDPNBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894703AbgDPNBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:01:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A928214AF;
        Thu, 16 Apr 2020 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587042074;
        bh=RJOTq2qwvd5cU9v3dsnLMOTnpT+S6X+GucaI6JHfoVo=;
        h=Subject:To:From:Date:From;
        b=B1bTovnQYebh37LvEKyqitX9M218OYhHfVBnnDAKeK3yzERxvnbst7ELTx4blH0QX
         tOqQOTcscNkXtv5oFBVz3uLoBQItwvQcgnNS+o4bf/D4dEFt8BR0CAaCYTX6ro+mkj
         qfFlv6oUcVgNlbO2kfe8USf2xO8VqanlykHEe5aQ=
Subject: patch "cdc-acm: introduce a cool down" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        jonas.karlsson@actia.se, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 15:01:02 +0200
Message-ID: <158704206265137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    cdc-acm: introduce a cool down

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a4e7279cd1d19f48f0af2a10ed020febaa9ac092 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 15 Apr 2020 17:13:58 +0200
Subject: cdc-acm: introduce a cool down

Immediate submission in case of a babbling device can lead
to a busy loop. Introducing a delayed work.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Jonas Karlsson <jonas.karlsson@actia.se>
Link: https://lore.kernel.org/r/20200415151358.32664-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 30 ++++++++++++++++++++++++++++--
 drivers/usb/class/cdc-acm.h |  5 ++++-
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 4ef68e6671aa..ded8d93834ca 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -412,9 +412,12 @@ static void acm_ctrl_irq(struct urb *urb)
 
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
-	if (retval && retval != -EPERM)
+	if (retval && retval != -EPERM && retval != -ENODEV)
 		dev_err(&acm->control->dev,
 			"%s - usb_submit_urb failed: %d\n", __func__, retval);
+	else
+		dev_vdbg(&acm->control->dev,
+			"control resubmission terminated %d\n", retval);
 }
 
 static int acm_submit_read_urb(struct acm *acm, int index, gfp_t mem_flags)
@@ -430,6 +433,8 @@ static int acm_submit_read_urb(struct acm *acm, int index, gfp_t mem_flags)
 			dev_err(&acm->data->dev,
 				"urb %d failed submission with %d\n",
 				index, res);
+		} else {
+			dev_vdbg(&acm->data->dev, "intended failure %d\n", res);
 		}
 		set_bit(index, &acm->read_urbs_free);
 		return res;
@@ -471,6 +476,7 @@ static void acm_read_bulk_callback(struct urb *urb)
 	int status = urb->status;
 	bool stopped = false;
 	bool stalled = false;
+	bool cooldown = false;
 
 	dev_vdbg(&acm->data->dev, "got urb %d, len %d, status %d\n",
 		rb->index, urb->actual_length, status);
@@ -497,6 +503,14 @@ static void acm_read_bulk_callback(struct urb *urb)
 			__func__, status);
 		stopped = true;
 		break;
+	case -EOVERFLOW:
+	case -EPROTO:
+		dev_dbg(&acm->data->dev,
+			"%s - cooling babbling device\n", __func__);
+		usb_mark_last_busy(acm->dev);
+		set_bit(rb->index, &acm->urbs_in_error_delay);
+		cooldown = true;
+		break;
 	default:
 		dev_dbg(&acm->data->dev,
 			"%s - nonzero urb status received: %d\n",
@@ -518,9 +532,11 @@ static void acm_read_bulk_callback(struct urb *urb)
 	 */
 	smp_mb__after_atomic();
 
-	if (stopped || stalled) {
+	if (stopped || stalled || cooldown) {
 		if (stalled)
 			schedule_work(&acm->work);
+		else if (cooldown)
+			schedule_delayed_work(&acm->dwork, HZ / 2);
 		return;
 	}
 
@@ -567,6 +583,12 @@ static void acm_softint(struct work_struct *work)
 		}
 	}
 
+	if (test_and_clear_bit(ACM_ERROR_DELAY, &acm->flags)) {
+		for (i = 0; i < ACM_NR; i++) 
+			if (test_and_clear_bit(i, &acm->urbs_in_error_delay))
+					acm_submit_read_urb(acm, i, GFP_NOIO);
+	}
+
 	if (test_and_clear_bit(EVENT_TTY_WAKEUP, &acm->flags))
 		tty_port_tty_wakeup(&acm->port);
 }
@@ -1333,6 +1355,7 @@ static int acm_probe(struct usb_interface *intf,
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
 	INIT_WORK(&acm->work, acm_softint);
+	INIT_DELAYED_WORK(&acm->dwork, acm_softint);
 	init_waitqueue_head(&acm->wioctl);
 	spin_lock_init(&acm->write_lock);
 	spin_lock_init(&acm->read_lock);
@@ -1542,6 +1565,7 @@ static void acm_disconnect(struct usb_interface *intf)
 
 	acm_kill_urbs(acm);
 	cancel_work_sync(&acm->work);
+	cancel_delayed_work_sync(&acm->dwork);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
 
@@ -1584,6 +1608,8 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 
 	acm_kill_urbs(acm);
 	cancel_work_sync(&acm->work);
+	cancel_delayed_work_sync(&acm->dwork);
+	acm->urbs_in_error_delay = 0;
 
 	return 0;
 }
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index ca1c026382c2..cd5e9d8ab237 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -109,8 +109,11 @@ struct acm {
 #		define EVENT_TTY_WAKEUP	0
 #		define EVENT_RX_STALL	1
 #		define ACM_THROTTLED	2
+#		define ACM_ERROR_DELAY	3
+	unsigned long urbs_in_error_delay;		/* these need to be restarted after a delay */
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
-	struct work_struct work;			/* work queue entry for line discipline waking up */
+	struct work_struct work;			/* work queue entry for various purposes*/
+	struct delayed_work dwork;			/* for cool downs needed in error recovery */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
 	unsigned int ctrlout;				/* output control lines (DTR, RTS) */
 	struct async_icount iocount;			/* counters for control line changes */
-- 
2.26.1


