Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861C7D272F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfJJKaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:30:19 -0400
Received: from www.linuxtv.org ([130.149.80.248]:49284 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfJJKaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 06:30:19 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iIVi4-0008EQ-3h; Thu, 10 Oct 2019 10:30:16 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 10 Oct 2019 10:22:06 +0000
Subject: [git:media_tree/master] media: usbvision: Fix invalid accesses after device disconnect
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+7fa38a608b1075dfd634@syzkaller.appspotmail.com,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iIVi4-0008EQ-3h@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: usbvision: Fix invalid accesses after device disconnect
Author:  Alan Stern <stern@rowland.harvard.edu>
Date:    Mon Oct 7 12:09:04 2019 -0300

The syzbot fuzzer found two invalid-access bugs in the usbvision
driver.  These bugs occur when userspace keeps the device file open
after the device has been disconnected and usbvision_disconnect() has
set usbvision->dev to NULL:

	When the device file is closed, usbvision_radio_close() tries
	to issue a usb_set_interface() call, passing the NULL pointer
	as its first argument.

	If userspace performs a querycap ioctl call, vidioc_querycap()
	calls usb_make_path() with the same NULL pointer.

This patch fixes the problems by making the appropriate tests
beforehand.  Note that vidioc_querycap() is protected by
usbvision->v4l2_lock, acquired in a higher layer of the V4L2
subsystem.

Reported-and-tested-by: syzbot+7fa38a608b1075dfd634@syzkaller.appspotmail.com

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/usb/usbvision/usbvision-video.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index cdc66adda755..62dec73aec6e 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -453,6 +453,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
+	if (!usbvision->dev)
+		return -ENODEV;
+
 	strscpy(vc->driver, "USBVision", sizeof(vc->driver));
 	strscpy(vc->card,
 		usbvision_device_data[usbvision->dev_model].model_string,
@@ -1099,8 +1102,9 @@ static int usbvision_radio_close(struct file *file)
 	mutex_lock(&usbvision->v4l2_lock);
 	/* Set packet size to 0 */
 	usbvision->iface_alt = 0;
-	usb_set_interface(usbvision->dev, usbvision->iface,
-				    usbvision->iface_alt);
+	if (usbvision->dev)
+		usb_set_interface(usbvision->dev, usbvision->iface,
+				  usbvision->iface_alt);
 
 	usbvision_audio_off(usbvision);
 	usbvision->radio = 0;
