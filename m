Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3023699DEA
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391646AbfHVRWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391527AbfHVRWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:49 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE24023406;
        Thu, 22 Aug 2019 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494568;
        bh=p81gYO1OegpMvTe0u5jGw4T/neWGhQp383tbYVrdTTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7MCdEf9mHCtc/MGWL2MReR9OJkMedgAxPr7JCVKPhWcw0nCLu9+7E4uqkCfQpWdr
         2RAT6H9jAef0q8TB5iPGCRb00esVdwz2hLLGwa8+zXq3HtBrmSUk1AS/8gyo13PQKw
         QhX0dl5o4ms1/YvVnyl+n7VhPfhD1WGVvs/3qaTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+30cf45ebfe0b0c4847a1@syzkaller.appspotmail.com
Subject: [PATCH 4.4 57/78] USB: core: Fix races in character device registration and deregistraion
Date:   Thu, 22 Aug 2019 10:19:01 -0700
Message-Id: <20190822171833.689551533@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
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
@@ -191,9 +191,10 @@ int usb_register_dev(struct usb_interfac
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
@@ -206,12 +207,11 @@ int usb_register_dev(struct usb_interfac
 				      MKDEV(USB_MAJOR, minor), class_driver,
 				      "%s", temp);
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
@@ -237,12 +237,12 @@ void usb_deregister_dev(struct usb_inter
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


