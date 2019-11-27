Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E4610B056
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 14:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfK0NgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 08:36:02 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:57571 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbfK0NgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 08:36:02 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4AEB3701;
        Wed, 27 Nov 2019 08:36:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 08:36:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iZcMcz
        DixH3XjV6pIUu6jVrLY4CzPGah+dvSN72yAF4=; b=qSXq6SoNCuwdnEflVlPqoz
        zOKa6oTykhoDu4uvJ68huccvtionGWOYZ0pNi2XQS3ElD1FKpfZq8IhNs4Sgj70J
        4Dc/Qzpn7tESxqVdhtzOH0iMlBlyCfVxdce8koOVB4ZacDqK9vQzlnOczCF4iEEp
        OWjAQbo7GoUnwrUEgLdO96rIrU4D6t7yYJFDTBAvR7E6jyj2Upvidrg2IuOP5G2F
        u0RRNZwUWyWvwwRalPEbdBYUJ7AUWfji4VWCQovEdEZkHVx5BbsPUsAeednnMw/D
        FKPmXFWOL8oAnAEfmxyJpz/oPTVIdbmtgw9jDlUo7whPInXdgBQx1TZV/2VbexpQ
        ==
X-ME-Sender: <xms:wHveXSW8L-pG-Ma6ptYlgHCRzy4ivfQaQG7I9Q6BUctTaZPsjySoXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeihedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:wHveXRWmwknGICI870PEzgCWU5M6Sr2MTCGdGjhmuZY4DuhALvEBhA>
    <xmx:wHveXTQw0C37XOLCqDC1__xNLE5n5rUB-JDNnY-NV19Xwr8HOfxJdg>
    <xmx:wHveXQ3v4RFS0_38uborrDpv6jvFXjizpQ4WwO6CCmpKZngzbRNfiQ>
    <xmx:wHveXTXybv1I6PfG_jcOAFyQqiT0Y7m1Nj8oF9g3kVYt4h--3ftdhw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 810F43060060;
        Wed, 27 Nov 2019 08:36:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: uvcvideo: Fix error path in control parsing failure" failed to apply to 4.4-stable tree
To:     laurent.pinchart@ideasonboard.com, mchehab+samsung@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 14:35:59 +0100
Message-ID: <157486175917263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c279e9394cade640ed86ec6c6645a0e7df5e0b6 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Mon, 29 Jul 2019 23:14:55 -0300
Subject: [PATCH] media: uvcvideo: Fix error path in control parsing failure

When parsing the UVC control descriptors fails, the error path tries to
cleanup a media device that hasn't been initialised, potentially
resulting in a crash. Fix this by initialising the media device before
the error handling path can be reached.

Fixes: 5a254d751e52 ("[media] uvcvideo: Register a v4l2_device")
Reported-by: syzbot+c86454eb3af9e8a4da20@syzkaller.appspotmail.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 66ee168ddc7e..428235ca2635 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2151,6 +2151,20 @@ static int uvc_probe(struct usb_interface *intf,
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
@@ -2171,19 +2185,7 @@ static int uvc_probe(struct usb_interface *intf,
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
 

