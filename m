Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF3C7F347
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406378AbfHBJzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406601AbfHBJzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A39A20880;
        Fri,  2 Aug 2019 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739743;
        bh=ZjDcXP0Wz/sTUK16guHwPbb1e26Bau2spHDEwnTu/GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uud4LiqyW3lpuIIm19xp4WAt8qy7R4X9W1/DVB7AkfiBXYo91QPHxCIKt9IeL35s1
         shV2EVteZ5FK+qwN3gb8NgzP5nHBBVOd5ICsbxuWfluUxY1XeIKCAbDew5ZxzdvulN
         UcHwJNoeF7pCU1kAPBM9MO3D/zuy2EDmi5OLtz+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        syzbot+a4387f5b6b799f6becbf@syzkaller.appspotmail.com
Subject: [PATCH 4.19 16/32] media: radio-raremono: change devm_k*alloc to k*alloc
Date:   Fri,  2 Aug 2019 11:39:50 +0200
Message-Id: <20190802092106.776576552@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

commit c666355e60ddb4748ead3bdd983e3f7f2224aaf0 upstream.

Change devm_k*alloc to k*alloc to manually allocate memory

The manual allocation and freeing of memory is necessary because when
the USB radio is disconnected, the memory associated with devm_k*alloc
is freed. Meaning if we still have unresolved references to the radio
device, then we get use-after-free errors.

This patch fixes this by manually allocating memory, and freeing it in
the v4l2.release callback that gets called when the last radio device
exits.

Reported-and-tested-by: syzbot+a4387f5b6b799f6becbf@syzkaller.appspotmail.com

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: cleaned up two small checkpatch.pl warnings]
[hverkuil-cisco@xs4all.nl: prefix subject with driver name]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/radio/radio-raremono.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -271,6 +271,14 @@ static int vidioc_g_frequency(struct fil
 	return 0;
 }
 
+static void raremono_device_release(struct v4l2_device *v4l2_dev)
+{
+	struct raremono_device *radio = to_raremono_dev(v4l2_dev);
+
+	kfree(radio->buffer);
+	kfree(radio);
+}
+
 /* File system interface */
 static const struct v4l2_file_operations usb_raremono_fops = {
 	.owner		= THIS_MODULE,
@@ -295,12 +303,14 @@ static int usb_raremono_probe(struct usb
 	struct raremono_device *radio;
 	int retval = 0;
 
-	radio = devm_kzalloc(&intf->dev, sizeof(struct raremono_device), GFP_KERNEL);
-	if (radio)
-		radio->buffer = devm_kmalloc(&intf->dev, BUFFER_LENGTH, GFP_KERNEL);
-
-	if (!radio || !radio->buffer)
+	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
+	if (!radio)
+		return -ENOMEM;
+	radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
+	if (!radio->buffer) {
+		kfree(radio);
 		return -ENOMEM;
+	}
 
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
@@ -324,7 +334,8 @@ static int usb_raremono_probe(struct usb
 	if (retval != 3 ||
 	    (get_unaligned_be16(&radio->buffer[1]) & 0xfff) == 0x0242) {
 		dev_info(&intf->dev, "this is not Thanko's Raremono.\n");
-		return -ENODEV;
+		retval = -ENODEV;
+		goto free_mem;
 	}
 
 	dev_info(&intf->dev, "Thanko's Raremono connected: (%04X:%04X)\n",
@@ -333,7 +344,7 @@ static int usb_raremono_probe(struct usb
 	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&intf->dev, "couldn't register v4l2_device\n");
-		return retval;
+		goto free_mem;
 	}
 
 	mutex_init(&radio->lock);
@@ -345,6 +356,7 @@ static int usb_raremono_probe(struct usb
 	radio->vdev.ioctl_ops = &usb_raremono_ioctl_ops;
 	radio->vdev.lock = &radio->lock;
 	radio->vdev.release = video_device_release_empty;
+	radio->v4l2_dev.release = raremono_device_release;
 
 	usb_set_intfdata(intf, &radio->v4l2_dev);
 
@@ -360,6 +372,10 @@ static int usb_raremono_probe(struct usb
 	}
 	dev_err(&intf->dev, "could not register video device\n");
 	v4l2_device_unregister(&radio->v4l2_dev);
+
+free_mem:
+	kfree(radio->buffer);
+	kfree(radio);
 	return retval;
 }
 


