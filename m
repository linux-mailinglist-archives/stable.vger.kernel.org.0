Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FEED272E
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfJJKaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:30:19 -0400
Received: from www.linuxtv.org ([130.149.80.248]:49162 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfJJKaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 06:30:19 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iIVi4-0008E5-1H; Thu, 10 Oct 2019 10:30:16 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 10 Oct 2019 10:22:38 +0000
Subject: [git:media_tree/master] media: usbvision: Fix races among open, close, and disconnect
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iIVi4-0008E5-1H@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: usbvision: Fix races among open, close, and disconnect
Author:  Alan Stern <stern@rowland.harvard.edu>
Date:    Mon Oct 7 12:09:53 2019 -0300

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
CC: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/usb/usbvision/usbvision-video.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 62dec73aec6e..93d36aab824f 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -314,6 +314,10 @@ static int usbvision_v4l2_open(struct file *file)
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
 
+	if (usbvision->remove_pending) {
+		err_code = -ENODEV;
+		goto unlock;
+	}
 	if (usbvision->user) {
 		err_code = -EBUSY;
 	} else {
@@ -377,6 +381,7 @@ unlock:
 static int usbvision_v4l2_close(struct file *file)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
+	int r;
 
 	PDEBUG(DBG_IO, "close");
 
@@ -391,9 +396,10 @@ static int usbvision_v4l2_close(struct file *file)
 	usbvision_scratch_free(usbvision);
 
 	usbvision->user--;
+	r = usbvision->remove_pending;
 	mutex_unlock(&usbvision->v4l2_lock);
 
-	if (usbvision->remove_pending) {
+	if (r) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
 		return 0;
@@ -1064,6 +1070,11 @@ static int usbvision_radio_open(struct file *file)
 
 	if (mutex_lock_interruptible(&usbvision->v4l2_lock))
 		return -ERESTARTSYS;
+
+	if (usbvision->remove_pending) {
+		err_code = -ENODEV;
+		goto out;
+	}
 	err_code = v4l2_fh_open(file);
 	if (err_code)
 		goto out;
@@ -1096,6 +1107,7 @@ out:
 static int usbvision_radio_close(struct file *file)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
+	int r;
 
 	PDEBUG(DBG_IO, "");
 
@@ -1109,9 +1121,10 @@ static int usbvision_radio_close(struct file *file)
 	usbvision_audio_off(usbvision);
 	usbvision->radio = 0;
 	usbvision->user--;
+	r = usbvision->remove_pending;
 	mutex_unlock(&usbvision->v4l2_lock);
 
-	if (usbvision->remove_pending) {
+	if (r) {
 		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		v4l2_fh_release(file);
 		usbvision_release(usbvision);
@@ -1543,6 +1556,7 @@ err_usb:
 static void usbvision_disconnect(struct usb_interface *intf)
 {
 	struct usb_usbvision *usbvision = to_usbvision(usb_get_intfdata(intf));
+	int u;
 
 	PDEBUG(DBG_PROBE, "");
 
@@ -1559,13 +1573,14 @@ static void usbvision_disconnect(struct usb_interface *intf)
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
