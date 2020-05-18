Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251181D8674
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgERRqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730036AbgERRqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9684E20715;
        Mon, 18 May 2020 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823967;
        bh=p/rp1dB4ad8U9VjmrjkExsxu3NWli1WNbE7dlplUZGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9HmidIcdqEi5SHfzfeX3s+Qg7m0oodkrcc9Ibb8dEOpMsLTSFWYP4coBUhAMm836
         Xou+M1wtT9PRYhJ5LwbcV3Rrl9xvx+zt2FknNdsNh8uVg5I3ntCvyXGO7h7IYuh6UK
         AsThB2b/jB/qthN7KNN8Avy8+dkk00fcBJZicwpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Kosina <jkosina@suse.cz>,
        syzbot+7bf5a7b0f0a1f9446f4c@syzkaller.appspotmail.com
Subject: [PATCH 4.14 018/114] HID: usbhid: Fix race between usbhid_close() and usbhid_stop()
Date:   Mon, 18 May 2020 19:35:50 +0200
Message-Id: <20200518173506.983367509@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 0ed08faded1da03eb3def61502b27f81aef2e615 upstream.

The syzbot fuzzer discovered a bad race between in the usbhid driver
between usbhid_stop() and usbhid_close().  In particular,
usbhid_stop() does:

	usb_free_urb(usbhid->urbin);
	...
	usbhid->urbin = NULL; /* don't mess up next start */

and usbhid_close() does:

	usb_kill_urb(usbhid->urbin);

with no mutual exclusion.  If the two routines happen to run
concurrently so that usb_kill_urb() is called in between the
usb_free_urb() and the NULL assignment, it will access the
deallocated urb structure -- a use-after-free bug.

This patch adds a mutex to the usbhid private structure and uses it to
enforce mutual exclusion of the usbhid_start(), usbhid_stop(),
usbhid_open() and usbhid_close() callbacks.

Reported-and-tested-by: syzbot+7bf5a7b0f0a1f9446f4c@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/usbhid/hid-core.c |   37 +++++++++++++++++++++++++++++--------
 drivers/hid/usbhid/usbhid.h   |    1 +
 2 files changed, 30 insertions(+), 8 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -680,16 +680,21 @@ static int usbhid_open(struct hid_device
 	struct usbhid_device *usbhid = hid->driver_data;
 	int res;
 
+	mutex_lock(&usbhid->mutex);
+
 	set_bit(HID_OPENED, &usbhid->iofl);
 
-	if (hid->quirks & HID_QUIRK_ALWAYS_POLL)
-		return 0;
+	if (hid->quirks & HID_QUIRK_ALWAYS_POLL) {
+		res = 0;
+		goto Done;
+	}
 
 	res = usb_autopm_get_interface(usbhid->intf);
 	/* the device must be awake to reliably request remote wakeup */
 	if (res < 0) {
 		clear_bit(HID_OPENED, &usbhid->iofl);
-		return -EIO;
+		res = -EIO;
+		goto Done;
 	}
 
 	usbhid->intf->needs_remote_wakeup = 1;
@@ -723,6 +728,9 @@ static int usbhid_open(struct hid_device
 		msleep(50);
 
 	clear_bit(HID_RESUME_RUNNING, &usbhid->iofl);
+
+ Done:
+	mutex_unlock(&usbhid->mutex);
 	return res;
 }
 
@@ -730,6 +738,8 @@ static void usbhid_close(struct hid_devi
 {
 	struct usbhid_device *usbhid = hid->driver_data;
 
+	mutex_lock(&usbhid->mutex);
+
 	/*
 	 * Make sure we don't restart data acquisition due to
 	 * a resumption we no longer care about by avoiding racing
@@ -741,12 +751,13 @@ static void usbhid_close(struct hid_devi
 		clear_bit(HID_IN_POLLING, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->lock);
 
-	if (hid->quirks & HID_QUIRK_ALWAYS_POLL)
-		return;
+	if (!(hid->quirks & HID_QUIRK_ALWAYS_POLL)) {
+		hid_cancel_delayed_stuff(usbhid);
+		usb_kill_urb(usbhid->urbin);
+		usbhid->intf->needs_remote_wakeup = 0;
+	}
 
-	hid_cancel_delayed_stuff(usbhid);
-	usb_kill_urb(usbhid->urbin);
-	usbhid->intf->needs_remote_wakeup = 0;
+	mutex_unlock(&usbhid->mutex);
 }
 
 /*
@@ -1056,6 +1067,8 @@ static int usbhid_start(struct hid_devic
 	unsigned int n, insize = 0;
 	int ret;
 
+	mutex_lock(&usbhid->mutex);
+
 	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
 
 	usbhid->bufsize = HID_MIN_BUFFER_SIZE;
@@ -1170,6 +1183,8 @@ static int usbhid_start(struct hid_devic
 		usbhid_set_leds(hid);
 		device_set_wakeup_enable(&dev->dev, 1);
 	}
+
+	mutex_unlock(&usbhid->mutex);
 	return 0;
 
 fail:
@@ -1180,6 +1195,7 @@ fail:
 	usbhid->urbout = NULL;
 	usbhid->urbctrl = NULL;
 	hid_free_buffers(dev, hid);
+	mutex_unlock(&usbhid->mutex);
 	return ret;
 }
 
@@ -1195,6 +1211,8 @@ static void usbhid_stop(struct hid_devic
 		usbhid->intf->needs_remote_wakeup = 0;
 	}
 
+	mutex_lock(&usbhid->mutex);
+
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
@@ -1215,6 +1233,8 @@ static void usbhid_stop(struct hid_devic
 	usbhid->urbout = NULL;
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
+
+	mutex_unlock(&usbhid->mutex);
 }
 
 static int usbhid_power(struct hid_device *hid, int lvl)
@@ -1375,6 +1395,7 @@ static int usbhid_probe(struct usb_inter
 	INIT_WORK(&usbhid->reset_work, hid_reset);
 	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
 	spin_lock_init(&usbhid->lock);
+	mutex_init(&usbhid->mutex);
 
 	ret = hid_add_device(hid);
 	if (ret) {
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -93,6 +93,7 @@ struct usbhid_device {
 	dma_addr_t outbuf_dma;                                          /* Output buffer dma */
 	unsigned long last_out;							/* record of last output for timeouts */
 
+	struct mutex mutex;						/* start/stop/open/close */
 	spinlock_t lock;						/* fifo spinlock */
 	unsigned long iofl;                                             /* I/O flags (CTRL_RUNNING, OUT_RUNNING) */
 	struct timer_list io_retry;                                     /* Retry timer */


