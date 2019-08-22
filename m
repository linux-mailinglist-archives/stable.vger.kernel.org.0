Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229AD99C7C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392799AbfHVRei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404366AbfHVRZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:18 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B9D23400;
        Thu, 22 Aug 2019 17:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494717;
        bh=s0ApEAcmL3TT3fBlquZB8oeVyf6DwCkBqIEm+2y66aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vY9oS3IKk4jCw4J4vGHtvdIO0UbTwxRVZCd8CgD27YdDGvlLWipRfoXQFs27PCUuM
         MQcgZ8d3AejDYHcUUdPP0UdVWH9Lp2Q4RvGAgF/8KLk4j4GFx1hzm3QI/N7i+OQ5+j
         J2XyK5cpzYrJ1+jLS5SXk0Y8+8IwbgJOq6quk63U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+30cf45ebfe0b0c4847a1@syzkaller.appspotmail.com
Subject: [PATCH 4.14 46/71] USB: core: Fix races in character device registration and deregistraion
Date:   Thu, 22 Aug 2019 10:19:21 -0700
Message-Id: <20190822171729.863177187@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 303911cfc5b95d33687d9046133ff184cf5043ff upstream.

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
 drivers/usb/core/file.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -193,9 +193,10 @@ int usb_register_dev(struct usb_interfac
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
@@ -203,12 +204,11 @@ int usb_register_dev(struct usb_interfac
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
@@ -234,12 +234,12 @@ void usb_deregister_dev(struct usb_inter
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


