Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED92810BB8E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbfK0VNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732608AbfK0VNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81EA215F1;
        Wed, 27 Nov 2019 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889218;
        bh=XlAJfjFYmMEYcBNDrUXkP9rhkEu3DX4g5RnRmGamycI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGR3HL3uiB3m3ImNGJp7Y4GpkMlMAsRm44Aa3NfpS5Y0vpifHWPuB8QBs7Hcwtvmo
         3dWDC9b+0gF7MeWr9RWm+3kq0jVBbadfEq32IL86d3d24HyHnfHt3MhvIAvhfNSBjW
         0OARy9hECo+RuV9rE6F9kozaBbnSZJlERDonG4cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        syzbot+7fa38a608b1075dfd634@syzkaller.appspotmail.com
Subject: [PATCH 5.4 33/66] media: usbvision: Fix invalid accesses after device disconnect
Date:   Wed, 27 Nov 2019 21:32:28 +0100
Message-Id: <20191127202710.996633518@linuxfoundation.org>
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
CC: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/usbvision/usbvision-video.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -453,6 +453,9 @@ static int vidioc_querycap(struct file *
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
+	if (!usbvision->dev)
+		return -ENODEV;
+
 	strscpy(vc->driver, "USBVision", sizeof(vc->driver));
 	strscpy(vc->card,
 		usbvision_device_data[usbvision->dev_model].model_string,
@@ -1099,8 +1102,9 @@ static int usbvision_radio_close(struct
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


