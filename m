Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812461BCAAC
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgD1ShF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbgD1ShE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:37:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF5720730;
        Tue, 28 Apr 2020 18:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099023;
        bh=vPgXxGI66rLRdoSQpuNxxGXdIZQViP/JDAYkzmrJUQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5t7pMg/vOubNwXfrouG+CmOwrkphAfAwJYIP3bCJ5k8/0g/ePgv1zCX/iy6ErcUf
         9EIOlEe+vQmepMGI+VDRA2y3zahuToXWSXJs4ubP6sBQZ7tsZr9E5vM+c8qO67em9D
         YLK1gRayh3CEMznv80L/Z7M8Yz9LtfJ6zOffBqdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jonas Karlsson <jonas.karlsson@actia.se>
Subject: [PATCH 5.6 145/167] cdc-acm: introduce a cool down
Date:   Tue, 28 Apr 2020 20:25:21 +0200
Message-Id: <20200428182243.941621809@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -412,9 +412,12 @@ static void acm_ctrl_irq(struct urb *urb
 
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
@@ -430,6 +433,8 @@ static int acm_submit_read_urb(struct ac
 			dev_err(&acm->data->dev,
 				"urb %d failed submission with %d\n",
 				index, res);
+		} else {
+			dev_vdbg(&acm->data->dev, "intended failure %d\n", res);
 		}
 		set_bit(index, &acm->read_urbs_free);
 		return res;
@@ -471,6 +476,7 @@ static void acm_read_bulk_callback(struc
 	int status = urb->status;
 	bool stopped = false;
 	bool stalled = false;
+	bool cooldown = false;
 
 	dev_vdbg(&acm->data->dev, "got urb %d, len %d, status %d\n",
 		rb->index, urb->actual_length, status);
@@ -497,6 +503,14 @@ static void acm_read_bulk_callback(struc
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
@@ -518,9 +532,11 @@ static void acm_read_bulk_callback(struc
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
 
@@ -567,6 +583,12 @@ static void acm_softint(struct work_stru
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
@@ -1333,6 +1355,7 @@ made_compressed_probe:
 	acm->readsize = readsize;
 	acm->rx_buflimit = num_rx_buf;
 	INIT_WORK(&acm->work, acm_softint);
+	INIT_DELAYED_WORK(&acm->dwork, acm_softint);
 	init_waitqueue_head(&acm->wioctl);
 	spin_lock_init(&acm->write_lock);
 	spin_lock_init(&acm->read_lock);
@@ -1542,6 +1565,7 @@ static void acm_disconnect(struct usb_in
 
 	acm_kill_urbs(acm);
 	cancel_work_sync(&acm->work);
+	cancel_delayed_work_sync(&acm->dwork);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
 
@@ -1584,6 +1608,8 @@ static int acm_suspend(struct usb_interf
 
 	acm_kill_urbs(acm);
 	cancel_work_sync(&acm->work);
+	cancel_delayed_work_sync(&acm->dwork);
+	acm->urbs_in_error_delay = 0;
 
 	return 0;
 }
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


