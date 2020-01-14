Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36C713A545
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgANKGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:06:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgANKGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:06:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B18C924683;
        Tue, 14 Jan 2020 10:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996367;
        bh=hEYvx7c/QpZ6TklmjJfBcVF6hImmEbnkxqlMHgEV5RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JpQjQdzzgIFP9zIZsJNSPavb1othtNW7HpTdrWheLO4QyQ4YEAvl/g48DV6m4ogW
         qEAHmdn0DEi0rlbzNsfopPNVOz1ld0bg+T/bIvom80i+uxINDyl3LDp6hLFs/d4KZa
         7bGjgFBlqCbqs1IYMBSWklxJunr2oYaySNH0q1/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.4 72/78] HID: hiddev: fix mess in hiddev_open()
Date:   Tue, 14 Jan 2020 11:01:46 +0100
Message-Id: <20200114094403.046774857@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 18a1b06e5b91d47dc86c0a66a762646ea7c5d141 upstream.

The open method of hiddev handler fails to bring the device out of
autosuspend state as was promised in 0361a28d3f9a, as it actually has 2
blocks that try to start the transport (call hid_hw_open()) with both
being guarded by the "open" counter, so the 2nd block is never executed as
the first block increments the counter so it is never at 0 when we check
it for the second block.

Additionally hiddev_open() was leaving counter incremented on errors,
causing the device to never be reopened properly if there was ever an
error.

Let's fix all of this by factoring out code that creates client structure
and powers up the device into a separate function that is being called
from usbhid_open() with the "existancelock" being held.

Fixes: 0361a28d3f9a ("HID: autosuspend support for USB HID")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/usbhid/hiddev.c |   97 +++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -241,12 +241,51 @@ static int hiddev_release(struct inode *
 	return 0;
 }
 
+static int __hiddev_open(struct hiddev *hiddev, struct file *file)
+{
+	struct hiddev_list *list;
+	int error;
+
+	lockdep_assert_held(&hiddev->existancelock);
+
+	list = vzalloc(sizeof(*list));
+	if (!list)
+		return -ENOMEM;
+
+	mutex_init(&list->thread_lock);
+	list->hiddev = hiddev;
+
+	if (!hiddev->open++) {
+		error = hid_hw_power(hiddev->hid, PM_HINT_FULLON);
+		if (error < 0)
+			goto err_drop_count;
+
+		error = hid_hw_open(hiddev->hid);
+		if (error < 0)
+			goto err_normal_power;
+	}
+
+	spin_lock_irq(&hiddev->list_lock);
+	list_add_tail(&list->node, &hiddev->list);
+	spin_unlock_irq(&hiddev->list_lock);
+
+	file->private_data = list;
+
+	return 0;
+
+err_normal_power:
+	hid_hw_power(hiddev->hid, PM_HINT_NORMAL);
+err_drop_count:
+	hiddev->open--;
+	vfree(list);
+	return error;
+}
+
 /*
  * open file op
  */
 static int hiddev_open(struct inode *inode, struct file *file)
 {
-	struct hiddev_list *list;
 	struct usb_interface *intf;
 	struct hid_device *hid;
 	struct hiddev *hiddev;
@@ -255,66 +294,14 @@ static int hiddev_open(struct inode *ino
 	intf = usbhid_find_interface(iminor(inode));
 	if (!intf)
 		return -ENODEV;
+
 	hid = usb_get_intfdata(intf);
 	hiddev = hid->hiddev;
 
-	if (!(list = vzalloc(sizeof(struct hiddev_list))))
-		return -ENOMEM;
-	mutex_init(&list->thread_lock);
-	list->hiddev = hiddev;
-	file->private_data = list;
-
-	/*
-	 * no need for locking because the USB major number
-	 * is shared which usbcore guards against disconnect
-	 */
-	if (list->hiddev->exist) {
-		if (!list->hiddev->open++) {
-			res = hid_hw_open(hiddev->hid);
-			if (res < 0)
-				goto bail;
-		}
-	} else {
-		res = -ENODEV;
-		goto bail;
-	}
-
-	spin_lock_irq(&list->hiddev->list_lock);
-	list_add_tail(&list->node, &hiddev->list);
-	spin_unlock_irq(&list->hiddev->list_lock);
-
 	mutex_lock(&hiddev->existancelock);
-	/*
-	 * recheck exist with existance lock held to
-	 * avoid opening a disconnected device
-	 */
-	if (!list->hiddev->exist) {
-		res = -ENODEV;
-		goto bail_unlock;
-	}
-	if (!list->hiddev->open++)
-		if (list->hiddev->exist) {
-			struct hid_device *hid = hiddev->hid;
-			res = hid_hw_power(hid, PM_HINT_FULLON);
-			if (res < 0)
-				goto bail_unlock;
-			res = hid_hw_open(hid);
-			if (res < 0)
-				goto bail_normal_power;
-		}
-	mutex_unlock(&hiddev->existancelock);
-	return 0;
-bail_normal_power:
-	hid_hw_power(hid, PM_HINT_NORMAL);
-bail_unlock:
+	res = hiddev->exist ? __hiddev_open(hiddev, file) : -ENODEV;
 	mutex_unlock(&hiddev->existancelock);
 
-	spin_lock_irq(&list->hiddev->list_lock);
-	list_del(&list->node);
-	spin_unlock_irq(&list->hiddev->list_lock);
-bail:
-	file->private_data = NULL;
-	vfree(list);
 	return res;
 }
 


