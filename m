Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512975598D5
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 13:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiFXLpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 07:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiFXLph (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 07:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688577B36F
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 04:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054B26221A
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 11:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CB5C34114;
        Fri, 24 Jun 2022 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656071135;
        bh=spcntuk7ANnhjUuATtTFNMFGv8cNofKJGyvrnbMb/0g=;
        h=Subject:To:From:Date:From;
        b=y8p90Xv2+vBbOwO+E5NjZ76o7yu9LGdmB+ifs4Ec9tIf5uA5NgBd+qPuoxWjOIEsl
         GbMMU1RwWmyZS+s7hi0q/ORlnX6TM6W/u9bugE8XIDUepAzhn++O+WSQZ19KbD16oT
         XNnSKXj7ADXRd+nlsBjIsGjf6WdHiuftTrzXYFnw=
Subject: patch "USB: gadget: Fix double-free bug in raw_gadget driver" added to usb-linus
To:     stern@rowland.harvard.edu, andreyknvl@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Jun 2022 13:45:32 +0200
Message-ID: <1656071132251173@kroah.com>
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

    USB: gadget: Fix double-free bug in raw_gadget driver

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 90bc2af24638659da56397ff835f3c95a948f991 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 22 Jun 2022 10:46:31 -0400
Subject: USB: gadget: Fix double-free bug in raw_gadget driver

Re-reading a recently merged fix to the raw_gadget driver showed that
it inadvertently introduced a double-free bug in a failure pathway.
If raw_ioctl_init() encounters an error after the driver ID number has
been allocated, it deallocates the ID number before returning.  But
when dev_free() runs later on, it will then try to deallocate the ID
number a second time.

Closely related to this issue is another error in the recent fix: The
ID number is stored in the raw_dev structure before the code checks to
see whether the structure has already been initialized, in which case
the new ID number would overwrite the earlier value.

The solution to both bugs is to keep the new ID number in a local
variable, and store it in the raw_dev structure only after the check
for prior initialization.  No errors can occur after that point, so
the double-free will never happen.

Fixes: f2d8c2606825 ("usb: gadget: Fix non-unique driver names in raw-gadget driver")
CC: Andrey Konovalov <andreyknvl@gmail.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YrMrRw5AyIZghN0v@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index 5c8481cef35f..2acece16b890 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -430,6 +430,7 @@ static int raw_release(struct inode *inode, struct file *fd)
 static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 {
 	int ret = 0;
+	int driver_id_number;
 	struct usb_raw_init arg;
 	char *udc_driver_name;
 	char *udc_device_name;
@@ -452,10 +453,9 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 		return -EINVAL;
 	}
 
-	ret = ida_alloc(&driver_id_numbers, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-	dev->driver_id_number = ret;
+	driver_id_number = ida_alloc(&driver_id_numbers, GFP_KERNEL);
+	if (driver_id_number < 0)
+		return driver_id_number;
 
 	driver_driver_name = kmalloc(DRIVER_DRIVER_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!driver_driver_name) {
@@ -463,7 +463,7 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 		goto out_free_driver_id_number;
 	}
 	snprintf(driver_driver_name, DRIVER_DRIVER_NAME_LENGTH_MAX,
-				DRIVER_NAME ".%d", dev->driver_id_number);
+				DRIVER_NAME ".%d", driver_id_number);
 
 	udc_driver_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!udc_driver_name) {
@@ -507,6 +507,7 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 	dev->driver.driver.name = driver_driver_name;
 	dev->driver.udc_name = udc_device_name;
 	dev->driver.match_existing_only = 1;
+	dev->driver_id_number = driver_id_number;
 
 	dev->state = STATE_DEV_INITIALIZED;
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -521,7 +522,7 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 out_free_driver_driver_name:
 	kfree(driver_driver_name);
 out_free_driver_id_number:
-	ida_free(&driver_id_numbers, dev->driver_id_number);
+	ida_free(&driver_id_numbers, driver_id_number);
 	return ret;
 }
 
-- 
2.36.1


