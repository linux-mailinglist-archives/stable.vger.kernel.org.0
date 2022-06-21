Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD8552D68
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 10:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344495AbiFUIvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 04:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiFUIvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 04:51:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172B226574
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 01:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EBE7CE0FF6
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A42C3411C;
        Tue, 21 Jun 2022 08:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655801503;
        bh=35MGarj0sEwvTwBXRRNtTkN+f78YZVvQ8f0f78w1yVQ=;
        h=Subject:To:From:Date:From;
        b=BHLUs7QzPTZ3I4xKF6KmpBhedUeA8wilC9nxsdLuOLUB/Y8cpw/W8ALK27GgcrGif
         6Lm+J4OoZ9NEcH1S60kpcGhfdKj9rCXWtR+pyQ8XK783lMfDOIzvPBp6fSTDmdMuKD
         PPryOgVMXnmlnYJ9xxIqAMdqt404r/kYvRBuRB1Y=
Subject: patch "usb: gadget: Fix non-unique driver names in raw-gadget driver" added to usb-linus
To:     stern@rowland.harvard.edu, andreyknvl@gmail.com,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Jun 2022 10:51:32 +0200
Message-ID: <165580149211221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: Fix non-unique driver names in raw-gadget driver

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f2d8c2606825317b77db1f9ba0fc26ef26160b30 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 13 Jun 2022 10:17:03 -0400
Subject: usb: gadget: Fix non-unique driver names in raw-gadget driver

In a report for a separate bug (which has already been fixed by commit
5f0b5f4d50fa "usb: gadget: fix race when gadget driver register via
ioctl") in the raw-gadget driver, the syzbot console log included
error messages caused by attempted registration of a new driver with
the same name as an existing driver:

> kobject_add_internal failed for raw-gadget with -EEXIST, don't try to register things with the same name in the same directory.
> UDC core: USB Raw Gadget: driver registration failed: -17
> misc raw-gadget: fail, usb_gadget_register_driver returned -17

These errors arise because raw_gadget.c registers a separate UDC
driver for each of the UDC instances it creates, but these drivers all
have the same name: "raw-gadget".  Until recently this wasn't a
problem, but when the "gadget" bus was added and UDC drivers were
registered on this bus, it became possible for name conflicts to cause
the registrations to fail.  The reason is simply that the bus code in
the driver core uses the driver name as a sysfs directory name (e.g.,
/sys/bus/gadget/drivers/raw-gadget/), and you can't create two
directories with the same pathname.

To fix this problem, the driver names used by raw-gadget are made
distinct by appending a unique ID number: "raw-gadget.N", with a
different value of N for each driver instance.  And to avoid the
proliferation of error handling code in the raw_ioctl_init() routine,
the error return paths are refactored into the common pattern (goto
statements leading to cleanup code at the end of the routine).

Link: https://lore.kernel.org/all/0000000000008c664105dffae2eb@google.com/
Fixes: fc274c1e9973 "USB: gadget: Add a new bus for gadgets"
CC: Andrey Konovalov <andreyknvl@gmail.com>
CC: <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+02b16343704b3af1667e@syzkaller.appspotmail.com
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YqdG32w+3h8c1s7z@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 62 +++++++++++++++++++-------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index 241740024c50..5c8481cef35f 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -36,6 +37,9 @@ MODULE_LICENSE("GPL");
 
 /*----------------------------------------------------------------------*/
 
+static DEFINE_IDA(driver_id_numbers);
+#define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+
 #define RAW_EVENT_QUEUE_SIZE	16
 
 struct raw_event_queue {
@@ -161,6 +165,9 @@ struct raw_dev {
 	/* Reference to misc device: */
 	struct device			*dev;
 
+	/* Make driver names unique */
+	int				driver_id_number;
+
 	/* Protected by lock: */
 	enum dev_state			state;
 	bool				gadget_registered;
@@ -189,6 +196,7 @@ static struct raw_dev *dev_new(void)
 	spin_lock_init(&dev->lock);
 	init_completion(&dev->ep0_done);
 	raw_event_queue_init(&dev->queue);
+	dev->driver_id_number = -1;
 	return dev;
 }
 
@@ -199,6 +207,9 @@ static void dev_free(struct kref *kref)
 
 	kfree(dev->udc_name);
 	kfree(dev->driver.udc_name);
+	kfree(dev->driver.driver.name);
+	if (dev->driver_id_number >= 0)
+		ida_free(&driver_id_numbers, dev->driver_id_number);
 	if (dev->req) {
 		if (dev->ep0_urb_queued)
 			usb_ep_dequeue(dev->gadget->ep0, dev->req);
@@ -422,6 +433,7 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 	struct usb_raw_init arg;
 	char *udc_driver_name;
 	char *udc_device_name;
+	char *driver_driver_name;
 	unsigned long flags;
 
 	if (copy_from_user(&arg, (void __user *)value, sizeof(arg)))
@@ -440,36 +452,44 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 		return -EINVAL;
 	}
 
+	ret = ida_alloc(&driver_id_numbers, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	dev->driver_id_number = ret;
+
+	driver_driver_name = kmalloc(DRIVER_DRIVER_NAME_LENGTH_MAX, GFP_KERNEL);
+	if (!driver_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_id_number;
+	}
+	snprintf(driver_driver_name, DRIVER_DRIVER_NAME_LENGTH_MAX,
+				DRIVER_NAME ".%d", dev->driver_id_number);
+
 	udc_driver_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
-	if (!udc_driver_name)
-		return -ENOMEM;
+	if (!udc_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_driver_name;
+	}
 	ret = strscpy(udc_driver_name, &arg.driver_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_driver_name;
 	ret = 0;
 
 	udc_device_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!udc_device_name) {
-		kfree(udc_driver_name);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free_udc_driver_name;
 	}
 	ret = strscpy(udc_device_name, &arg.device_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_device_name;
 	ret = 0;
 
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->state != STATE_DEV_OPENED) {
 		dev_dbg(dev->dev, "fail, device is not opened\n");
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -484,14 +504,24 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 	dev->driver.suspend = gadget_suspend;
 	dev->driver.resume = gadget_resume;
 	dev->driver.reset = gadget_reset;
-	dev->driver.driver.name = DRIVER_NAME;
+	dev->driver.driver.name = driver_driver_name;
 	dev->driver.udc_name = udc_device_name;
 	dev->driver.match_existing_only = 1;
 
 	dev->state = STATE_DEV_INITIALIZED;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ret;
 
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
+out_free_udc_device_name:
+	kfree(udc_device_name);
+out_free_udc_driver_name:
+	kfree(udc_driver_name);
+out_free_driver_driver_name:
+	kfree(driver_driver_name);
+out_free_driver_id_number:
+	ida_free(&driver_id_numbers, dev->driver_id_number);
 	return ret;
 }
 
-- 
2.36.1


