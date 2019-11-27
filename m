Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B159310BBD4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfK0VOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:14:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733087AbfK0VOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:14:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7582A2154A;
        Wed, 27 Nov 2019 21:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889258;
        bh=FG/Jm42DCBugQbP6zVmTLHDstw7KCJCFRfGe7IJlsZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLuQIqv4crKH6DeIrmSBLmo/IiVunbKCGQDyuMI/+v72tPM6/izClqdj61TXhJv4v
         K88PskVbgJuux2ZEfkiFKWgq6XQnHTDyZF/Um199vRohOfj7k5svU/BM4Iu3ltbFJw
         oqTKrTC9/fgcB/eHUtAClxKqddO7cRP3jNe/O2Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c86454eb3af9e8a4da20@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 47/66] media: uvcvideo: Fix error path in control parsing failure
Date:   Wed, 27 Nov 2019 21:32:42 +0100
Message-Id: <20191127202727.633594453@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 8c279e9394cade640ed86ec6c6645a0e7df5e0b6 upstream.

When parsing the UVC control descriptors fails, the error path tries to
cleanup a media device that hasn't been initialised, potentially
resulting in a crash. Fix this by initialising the media device before
the error handling path can be reached.

Fixes: 5a254d751e52 ("[media] uvcvideo: Register a v4l2_device")
Reported-by: syzbot+c86454eb3af9e8a4da20@syzkaller.appspotmail.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/uvc/uvc_driver.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2151,6 +2151,20 @@ static int uvc_probe(struct usb_interfac
 			   sizeof(dev->name) - len);
 	}
 
+	/* Initialize the media device. */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->mdev.dev = &intf->dev;
+	strscpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
+	if (udev->serial)
+		strscpy(dev->mdev.serial, udev->serial,
+			sizeof(dev->mdev.serial));
+	usb_make_path(udev, dev->mdev.bus_info, sizeof(dev->mdev.bus_info));
+	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	media_device_init(&dev->mdev);
+
+	dev->vdev.mdev = &dev->mdev;
+#endif
+
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
 		uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC "
@@ -2171,19 +2185,7 @@ static int uvc_probe(struct usb_interfac
 			"linux-uvc-devel mailing list.\n");
 	}
 
-	/* Initialize the media device and register the V4L2 device. */
-#ifdef CONFIG_MEDIA_CONTROLLER
-	dev->mdev.dev = &intf->dev;
-	strscpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
-	if (udev->serial)
-		strscpy(dev->mdev.serial, udev->serial,
-			sizeof(dev->mdev.serial));
-	usb_make_path(udev, dev->mdev.bus_info, sizeof(dev->mdev.bus_info));
-	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	media_device_init(&dev->mdev);
-
-	dev->vdev.mdev = &dev->mdev;
-#endif
+	/* Register the V4L2 device. */
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
 		goto error;
 


