Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFAF8A89D
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 22:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfHLUsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 16:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfHLUsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 16:48:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A384B20684;
        Mon, 12 Aug 2019 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565642900;
        bh=IQ6m/2x6AYyn+rloEAo8VT1suRYXCgWQUr4Fwc1Af/M=;
        h=Subject:To:From:Date:From;
        b=vGqef24pvTL7QF8R+KPnJZFb1PSWWi4cW2JWuSJLXbwXG5q7aO6pIOW713g25AvEl
         YRts35DpEklR5sEgw1KtbYmGkjcy5OhcAtpl66DN7wtVKGisvVmH/q1Rq4MnZ7oiB0
         EBOff/SRFRjyKI/EcsFLTGT5ZqHSzrFLnZa9ljbM=
Subject: patch "USB: core: Fix races in character device registration and" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 12 Aug 2019 22:48:17 +0200
Message-ID: <1565642897141251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: core: Fix races in character device registration and

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 303911cfc5b95d33687d9046133ff184cf5043ff Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 12 Aug 2019 16:11:07 -0400
Subject: USB: core: Fix races in character device registration and
 deregistraion

The syzbot fuzzer has found two (!) races in the USB character device
registration and deregistration routines.  This patch fixes the races.

The first race results from the fact that usb_deregister_dev() sets
usb_minors[intf->minor] to NULL before calling device_destroy() on the
class device.  This leaves a window during which another thread can
allocate the same minor number but will encounter a duplicate name
error when it tries to register its own class device.  A typical error
message in the system log would look like:

    sysfs: cannot create duplicate filename '/class/usbmisc/ldusb0'

The patch fixes this race by destroying the class device first.

The second race is in usb_register_dev().  When that routine runs, it
first allocates a minor number, then drops minor_rwsem, and then
creates the class device.  If the device creation fails, the minor
number is deallocated and the whole routine returns an error.  But
during the time while minor_rwsem was dropped, there is a window in
which the minor number is allocated and so another thread can
successfully open the device file.  Typically this results in
use-after-free errors or invalid accesses when the other thread closes
its open file reference, because the kernel then tries to release
resources that were already deallocated when usb_register_dev()
failed.  The patch fixes this race by keeping minor_rwsem locked
throughout the entire routine.

Reported-and-tested-by: syzbot+30cf45ebfe0b0c4847a1@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1908121607590.1659-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 65de6f73b672..558890ada0e5 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -193,9 +193,10 @@ int usb_register_dev(struct usb_interface *intf,
 		intf->minor = minor;
 		break;
 	}
-	up_write(&minor_rwsem);
-	if (intf->minor < 0)
+	if (intf->minor < 0) {
+		up_write(&minor_rwsem);
 		return -EXFULL;
+	}
 
 	/* create a usb class device for this usb interface */
 	snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
@@ -203,12 +204,11 @@ int usb_register_dev(struct usb_interface *intf,
 				      MKDEV(USB_MAJOR, minor), class_driver,
 				      "%s", kbasename(name));
 	if (IS_ERR(intf->usb_dev)) {
-		down_write(&minor_rwsem);
 		usb_minors[minor] = NULL;
 		intf->minor = -1;
-		up_write(&minor_rwsem);
 		retval = PTR_ERR(intf->usb_dev);
 	}
+	up_write(&minor_rwsem);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(usb_register_dev);
@@ -234,12 +234,12 @@ void usb_deregister_dev(struct usb_interface *intf,
 		return;
 
 	dev_dbg(&intf->dev, "removing %d minor\n", intf->minor);
+	device_destroy(usb_class->class, MKDEV(USB_MAJOR, intf->minor));
 
 	down_write(&minor_rwsem);
 	usb_minors[intf->minor] = NULL;
 	up_write(&minor_rwsem);
 
-	device_destroy(usb_class->class, MKDEV(USB_MAJOR, intf->minor));
 	intf->usb_dev = NULL;
 	intf->minor = -1;
 	destroy_usb_class();
-- 
2.22.0


