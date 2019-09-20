Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87174B9264
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbfITOZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36446 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388268AbfITOZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqN-0004y7-6H; Fri, 20 Sep 2019 15:25:07 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007yS-9c; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Luke Nowakowski-Krijger" <lnowakow@eng.ucsd.edu>,
        "Hans Verkuil" <hverkuil-cisco@xs4all.nl>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.791343078@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 115/132] media: radio-raremono: change devm_k*alloc
 to k*alloc
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/radio/radio-raremono.c | 30 +++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -283,6 +283,14 @@ static int vidioc_g_frequency(struct fil
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
@@ -307,12 +315,14 @@ static int usb_raremono_probe(struct usb
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
@@ -336,7 +346,8 @@ static int usb_raremono_probe(struct usb
 	if (retval != 3 ||
 	    (get_unaligned_be16(&radio->buffer[1]) & 0xfff) == 0x0242) {
 		dev_info(&intf->dev, "this is not Thanko's Raremono.\n");
-		return -ENODEV;
+		retval = -ENODEV;
+		goto free_mem;
 	}
 
 	dev_info(&intf->dev, "Thanko's Raremono connected: (%04X:%04X)\n",
@@ -345,7 +356,7 @@ static int usb_raremono_probe(struct usb
 	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&intf->dev, "couldn't register v4l2_device\n");
-		return retval;
+		goto free_mem;
 	}
 
 	mutex_init(&radio->lock);
@@ -357,6 +368,7 @@ static int usb_raremono_probe(struct usb
 	radio->vdev.ioctl_ops = &usb_raremono_ioctl_ops;
 	radio->vdev.lock = &radio->lock;
 	radio->vdev.release = video_device_release_empty;
+	radio->v4l2_dev.release = raremono_device_release;
 
 	usb_set_intfdata(intf, &radio->v4l2_dev);
 
@@ -373,6 +385,10 @@ static int usb_raremono_probe(struct usb
 	}
 	dev_err(&intf->dev, "could not register video device\n");
 	v4l2_device_unregister(&radio->v4l2_dev);
+
+free_mem:
+	kfree(radio->buffer);
+	kfree(radio);
 	return retval;
 }
 

