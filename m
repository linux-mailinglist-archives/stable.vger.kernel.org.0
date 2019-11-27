Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA2A10BED5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbfK0Uom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbfK0Uol (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E168D2158A;
        Wed, 27 Nov 2019 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887481;
        bh=Cj5k5l1hgsvz/6ZMIJzgQ2nDSVd4HdUBgRCfi+Rzyps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZyop+3Ae0T1+kJPrJ0nGDL2vl69Yii8yN9oc9lhdU04oRWKPtzqQG4+M+rtIYHoX
         tX9aykC+Ejuv04pmxE0P2yRCujNm/RSLRcU9e23yFg6zlsoVnutIqtTkAgIXxeq9Nd
         2ZFpIhvmHRgiI4dTfnw5nwMy6kW/ZVKGw5b+nDIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c86454eb3af9e8a4da20@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 128/151] media: uvcvideo: Fix error path in control parsing failure
Date:   Wed, 27 Nov 2019 21:31:51 +0100
Message-Id: <20191127203045.936828249@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
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
 drivers/media/usb/uvc/uvc_driver.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2021,6 +2021,21 @@ static int uvc_probe(struct usb_interfac
 			le16_to_cpu(udev->descriptor.idVendor),
 			le16_to_cpu(udev->descriptor.idProduct));
 
+	/* Initialize the media device. */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->mdev.dev = &intf->dev;
+	strscpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
+	if (udev->serial)
+		strscpy(dev->mdev.serial, udev->serial,
+			sizeof(dev->mdev.serial));
+	usb_make_path(udev, dev->mdev.bus_info, sizeof(dev->mdev.bus_info));
+	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	dev->mdev.driver_version = LINUX_VERSION_CODE;
+	media_device_init(&dev->mdev);
+
+	dev->vdev.mdev = &dev->mdev;
+#endif
+
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
 		uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC "
@@ -2041,20 +2056,7 @@ static int uvc_probe(struct usb_interfac
 			"linux-uvc-devel mailing list.\n");
 	}
 
-	/* Initialize the media device and register the V4L2 device. */
-#ifdef CONFIG_MEDIA_CONTROLLER
-	dev->mdev.dev = &intf->dev;
-	strlcpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
-	if (udev->serial)
-		strlcpy(dev->mdev.serial, udev->serial,
-			sizeof(dev->mdev.serial));
-	strcpy(dev->mdev.bus_info, udev->devpath);
-	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	dev->mdev.driver_version = LINUX_VERSION_CODE;
-	media_device_init(&dev->mdev);
-
-	dev->vdev.mdev = &dev->mdev;
-#endif
+	/* Register the V4L2 device. */
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
 		goto error;
 


