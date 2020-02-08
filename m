Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9C8156705
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgBHSik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:38:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33584 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727613AbgBHS3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-0003bj-8R; Sat, 08 Feb 2020 18:29:33 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-000CKT-3l; Sat, 08 Feb 2020 18:29:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Date:   Sat, 08 Feb 2020 18:19:25 +0000
Message-ID: <lsq.1581185940.144154732@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 026/148] media: usbvision: Fix races among open,
 close, and disconnect
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 9e08117c9d4efc1e1bc6fce83dab856d9fd284b6 upstream.

Visual inspection of the usbvision driver shows that it suffers from
three races between its open, close, and disconnect handlers.  In
particular, the driver is careful to update its usbvision->user and
usbvision->remove_pending flags while holding the private mutex, but:

	usbvision_v4l2_close() and usbvision_radio_close() don't hold
	the mutex while they check the value of
	usbvision->remove_pending;

	usbvision_disconnect() doesn't hold the mutex while checking
	the value of usbvision->user; and

	also, usbvision_v4l2_open() and usbvision_radio_open() don't
	check whether the device has been unplugged before allowing
	the user to open the device files.

Each of these can potentially lead to usbvision_release() being called
twice and use-after-free errors.

This patch fixes the races by reading the flags while the mutex is
still held and checking for pending removes before allowing an open to
succeed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
[bwh: Backported to 3.16:
 - Add unlock label in usbvision_v4l2_open()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -348,6 +348,10 @@ static int usbvision_v4l2_open(struct fi
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
 
+	if (usbvision->remove_pending) {
+		err_code = -ENODEV;
+		goto unlock;
+	}
 	if (usbvision->user) {
 		err_code = -EBUSY;
 	} else {
@@ -389,6 +393,7 @@ static int usbvision_v4l2_open(struct fi
 		}
 	}
 
+unlock:
 	mutex_unlock(&usbvision->v4l2_lock);
 
 	PDEBUG(DBG_IO, "success");
@@ -406,6 +411,7 @@ static int usbvision_v4l2_open(struct fi
 static int usbvision_v4l2_close(struct file *file)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
+	int r;
 
 	PDEBUG(DBG_IO, "close");
 
@@ -420,9 +426,10 @@ static int usbvision_v4l2_close(struct f
 	usbvision_scratch_free(usbvision);
 
 	usbvision->user--;
+	r = usbvision->remove_pending;
 	mutex_unlock(&usbvision->v4l2_lock);
 
-	if (usbvision->remove_pending) {
+	if (r) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
 		return 0;
@@ -1136,6 +1143,11 @@ static int usbvision_radio_open(struct f
 
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
+
+	if (usbvision->remove_pending) {
+		err_code = -ENODEV;
+		goto out;
+	}
 	if (usbvision->user) {
 		dev_err(&usbvision->rdev->dev,
 			"%s: Someone tried to open an already opened USBVision Radio!\n",
@@ -1166,6 +1178,7 @@ static int usbvision_radio_close(struct
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 	int err_code = 0;
+	int r;
 
 	PDEBUG(DBG_IO, "");
 
@@ -1179,9 +1192,10 @@ static int usbvision_radio_close(struct
 	usbvision_audio_off(usbvision);
 	usbvision->radio = 0;
 	usbvision->user--;
+	r = usbvision->remove_pending;
 	mutex_unlock(&usbvision->v4l2_lock);
 
-	if (usbvision->remove_pending) {
+	if (r) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
 		return err_code;
@@ -1614,6 +1628,7 @@ err_usb:
 static void usbvision_disconnect(struct usb_interface *intf)
 {
 	struct usb_usbvision *usbvision = to_usbvision(usb_get_intfdata(intf));
+	int u;
 
 	PDEBUG(DBG_PROBE, "");
 
@@ -1630,13 +1645,14 @@ static void usbvision_disconnect(struct
 	v4l2_device_disconnect(&usbvision->v4l2_dev);
 	usbvision_i2c_unregister(usbvision);
 	usbvision->remove_pending = 1;	/* Now all ISO data will be ignored */
+	u = usbvision->user;
 
 	usb_put_dev(usbvision->dev);
 	usbvision->dev = NULL;	/* USB device is no more */
 
 	mutex_unlock(&usbvision->v4l2_lock);
 
-	if (usbvision->user) {
+	if (u) {
 		printk(KERN_INFO "%s: In use, disconnect pending\n",
 		       __func__);
 		wake_up_interruptible(&usbvision->wait_frame);

