Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B48D1C13F3
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgEANeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730558AbgEANeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1673924957;
        Fri,  1 May 2020 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340060;
        bh=pvqg+T3fegrWc6pRXGDLuGW+rkYe0Io6nNfeOYwhRiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsz7QF9V3m8/kPyk7ckZRe1qo6XDtk2pmJpejUcIN2iYG4wUA5VvfI72LYnry8BKi
         9nDzh8JDIq8BUckbexvF8inrUS/hjfOdcbzoQ8P+RhTdrm1TA+a+GVwjNZoRd+qXr5
         EexxJnOl0Uy74i+NOh5J9cZeGhVV3qriPmH8isBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jonas Karlsson <jonas.karlsson@actia.se>
Subject: [PATCH 4.14 078/117] cdc-acm: introduce a cool down
Date:   Fri,  1 May 2020 15:21:54 +0200
Message-Id: <20200501131554.172370804@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit a4e7279cd1d19f48f0af2a10ed020febaa9ac092 upstream.

Immediate submission in case of a babbling device can lead
to a busy loop. Introducing a delayed work.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Jonas Karlsson <jonas.karlsson@actia.se>
Link: https://lore.kernel.org/r/20200415151358.32664-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   30 ++++++++++++++++++++++++++++--
 drivers/usb/class/cdc-acm.h |    5 ++++-
 2 files changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -424,9 +424,12 @@ static void acm_ctrl_irq(struct urb *urb
 
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
@@ -442,6 +445,8 @@ static int acm_submit_read_urb(struct ac
 			dev_err(&acm->data->dev,
 				"urb %d failed submission with %d\n",
 				index, res);
+		} else {
+			dev_vdbg(&acm->data->dev, "intended failure %d\n", res);
 		}
 		set_bit(index, &acm->read_urbs_free);
 		return res;
@@ -484,6 +489,7 @@ static void acm_read_bulk_callback(struc
 	int status = urb->status;
 	bool stopped = false;
 	bool stalled = false;
+	bool cooldown = false;
 
 	dev_vdbg(&acm->data->dev, "got urb %d, len %d, status %d\n",
 		rb->index, urb->actual_length, status);
@@ -510,6 +516,14 @@ static void acm_read_bulk_callback(struc
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
@@ -531,9 +545,11 @@ static void acm_read_bulk_callback(struc
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
 
@@ -585,6 +601,12 @@ static void acm_softint(struct work_stru
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
@@ -1374,6 +1396,7 @@ made_compressed_probe:
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
 	INIT_WORK(&acm->work, acm_softint);
+	INIT_DELAYED_WORK(&acm->dwork, acm_softint);
 	init_waitqueue_head(&acm->wioctl);
 	spin_lock_init(&acm->write_lock);
 	spin_lock_init(&acm->read_lock);
@@ -1587,6 +1610,7 @@ static void acm_disconnect(struct usb_in
 
 	acm_kill_urbs(acm);
 	cancel_work_sync(&acm->work);
+	cancel_delayed_work_sync(&acm->dwork);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
 
@@ -1629,6 +1653,8 @@ static int acm_suspend(struct usb_interf
 
 	acm_kill_urbs(acm);
 	cancel_work_sync(&acm->work);
+	cancel_delayed_work_sync(&acm->dwork);
+	acm->urbs_in_error_delay = 0;
 
 	return 0;
 }
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -108,8 +108,11 @@ struct acm {
 	unsigned long flags;
 #		define EVENT_TTY_WAKEUP	0
 #		define EVENT_RX_STALL	1
+#		define ACM_ERROR_DELAY	3
+	unsigned long urbs_in_error_delay;		/* these need to be restarted after a delay */
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
-	struct work_struct work;			/* work queue entry for line discipline waking up */
+	struct work_struct work;			/* work queue entry for various purposes*/
+	struct delayed_work dwork;			/* for cool downs needed in error recovery */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
 	unsigned int ctrlout;				/* output control lines (DTR, RTS) */
 	struct async_icount iocount;			/* counters for control line changes */


