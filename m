Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04D2B9239
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390640AbfITOa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:30:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36942 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388413AbfITOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-0004y7-Ft; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007u2-V8; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ladislav Michl" <ladis@linux-mips.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.515677026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 068/132] cdc-acm: handle read pipe errors
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

From: Ladislav Michl <ladis@linux-mips.org>

commit 1aba579f3cf51fd0fe0b4d46cc13823fd1200acb upstream.

Read urbs are submitted back only on success, causing read pipe
running out of urbs after few errors. No more characters can
be read from tty device then until it is reopened and no errors
are reported.
Fix that by always submitting urbs back and clearing stall on
-EPIPE.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 60 ++++++++++++++++++++++++++++++-------
 drivers/usb/class/cdc-acm.h |  3 ++
 2 files changed, 53 insertions(+), 10 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -424,29 +424,41 @@ static void acm_read_bulk_callback(struc
 	dev_vdbg(&acm->data->dev, "%s - urb %d, len %d\n", __func__,
 					rb->index, urb->actual_length);
 
+	set_bit(rb->index, &acm->read_urbs_free);
+
 	if (!acm->dev) {
-		set_bit(rb->index, &acm->read_urbs_free);
 		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
 		return;
 	}
 
-	if (urb->status) {
-		set_bit(rb->index, &acm->read_urbs_free);
-		dev_dbg(&acm->data->dev, "%s - non-zero urb status: %d\n",
-							__func__, status);
-		if ((urb->status != -ENOENT) || (urb->actual_length == 0))
-			return;
+	switch (status) {
+	case 0:
+		usb_mark_last_busy(acm->dev);
+		acm_process_read_urb(acm, urb);
+		break;
+	case -EPIPE:
+		set_bit(EVENT_RX_STALL, &acm->flags);
+		schedule_work(&acm->work);
+		return;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		dev_dbg(&acm->data->dev,
+			"%s - urb shutting down with status: %d\n",
+			__func__, status);
+		return;
+	default:
+		dev_dbg(&acm->data->dev,
+			"%s - nonzero urb status received: %d\n",
+			__func__, status);
+		break;
 	}
 
-	usb_mark_last_busy(acm->dev);
-
-	acm_process_read_urb(acm, urb);
 	/*
 	 * Unthrottle may run on another CPU which needs to see events
 	 * in the same order. Submission has an implict barrier
 	 */
 	smp_mb__before_atomic();
-	set_bit(rb->index, &acm->read_urbs_free);
 
 	/* throttle device if requested by tty */
 	spin_lock_irqsave(&acm->read_lock, flags);
@@ -476,16 +488,32 @@ static void acm_write_bulk(struct urb *u
 	spin_lock_irqsave(&acm->write_lock, flags);
 	acm_write_done(acm, wb);
 	spin_unlock_irqrestore(&acm->write_lock, flags);
+	set_bit(EVENT_TTY_WAKEUP, &acm->flags);
 	schedule_work(&acm->work);
 }
 
 static void acm_softint(struct work_struct *work)
 {
+	int i;
 	struct acm *acm = container_of(work, struct acm, work);
 
 	dev_vdbg(&acm->data->dev, "%s\n", __func__);
 
-	tty_port_tty_wakeup(&acm->port);
+	if (test_bit(EVENT_RX_STALL, &acm->flags)) {
+		if (!(usb_autopm_get_interface(acm->data))) {
+			for (i = 0; i < acm->rx_buflimit; i++)
+				usb_kill_urb(acm->read_urbs[i]);
+			usb_clear_halt(acm->dev, acm->in);
+			acm_submit_read_urbs(acm, GFP_KERNEL);
+			usb_autopm_put_interface(acm->data);
+		}
+		clear_bit(EVENT_RX_STALL, &acm->flags);
+	}
+
+	if (test_bit(EVENT_TTY_WAKEUP, &acm->flags)) {
+		tty_port_tty_wakeup(&acm->port);
+		clear_bit(EVENT_TTY_WAKEUP, &acm->flags);
+	}
 }
 
 /*
@@ -1680,6 +1708,15 @@ static int acm_reset_resume(struct usb_i
 
 #endif /* CONFIG_PM */
 
+static int acm_pre_reset(struct usb_interface *intf)
+{
+	struct acm *acm = usb_get_intfdata(intf);
+
+	clear_bit(EVENT_RX_STALL, &acm->flags);
+
+	return 0;
+}
+
 #define NOKIA_PCSUITE_ACM_INFO(x) \
 		USB_DEVICE_AND_INTERFACE_INFO(0x0421, x, \
 		USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM, \
@@ -1955,6 +1992,7 @@ static struct usb_driver acm_driver = {
 	.resume =	acm_resume,
 	.reset_resume =	acm_reset_resume,
 #endif
+	.pre_reset =	acm_pre_reset,
 	.id_table =	acm_ids,
 #ifdef CONFIG_PM
 	.supports_autosuspend = 1,
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -102,6 +102,9 @@ struct acm {
 	spinlock_t write_lock;
 	struct mutex mutex;
 	bool disconnected;
+	unsigned long flags;
+#		define EVENT_TTY_WAKEUP	0
+#		define EVENT_RX_STALL	1
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
 	struct work_struct work;			/* work queue entry for line discipline waking up */
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */

