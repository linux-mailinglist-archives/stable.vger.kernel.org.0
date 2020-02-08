Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7498156701
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgBHSik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:38:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33582 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbgBHS3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-0003bi-1x; Sat, 08 Feb 2020 18:29:33 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-000CKO-1B; Sat, 08 Feb 2020 18:29:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>
Date:   Sat, 08 Feb 2020 18:19:24 +0000
Message-ID: <lsq.1581185940.212487391@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 025/148] media: usbvision: Fix invalid accesses after
 device disconnect
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

commit c7a191464078262bf799136317c95824e26a222b upstream.

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/usbvision/usbvision-video.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -482,6 +482,9 @@ static int vidioc_querycap(struct file *
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
+	if (!usbvision->dev)
+		return -ENODEV;
+
 	strlcpy(vc->driver, "USBVision", sizeof(vc->driver));
 	strlcpy(vc->card,
 		usbvision_device_data[usbvision->dev_model].model_string,
@@ -1169,8 +1172,9 @@ static int usbvision_radio_close(struct
 	mutex_lock(&usbvision->v4l2_lock);
 	/* Set packet size to 0 */
 	usbvision->iface_alt = 0;
-	err_code = usb_set_interface(usbvision->dev, usbvision->iface,
-				    usbvision->iface_alt);
+	if (usbvision->dev)
+		err_code = usb_set_interface(usbvision->dev, usbvision->iface,
+					     usbvision->iface_alt);
 
 	usbvision_audio_off(usbvision);
 	usbvision->radio = 0;

