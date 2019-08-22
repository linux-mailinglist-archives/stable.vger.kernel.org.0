Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C499A46
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390672AbfHVRJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390662AbfHVRJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:06 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0262F233FD;
        Thu, 22 Aug 2019 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493746;
        bh=BceQIvYA6h6G5G9kleh1h72iqWj3mord1EgIKK2cbS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ien4CO5oIek2jrmauRld0Z72feE0zfOcP+CCXE8S1y2fsfjAsEQd6y6zwVrknDr1g
         tB7T0ZE/W3y0Sqd4d9gyVfWOXW6sHohIbgcOtsIdeR6vnehNIuiHu4SkDlgDXnLdhR
         3YAwGoXal/YwcPn1X6Ax8X3CRUmjc9hwgR4N9qTk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot+30cf45ebfe0b0c4847a1@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 095/135] USB: core: Fix races in character device registration and deregistraion
Date:   Thu, 22 Aug 2019 13:07:31 -0400
Message-Id: <20190822170811.13303-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/usb/core/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 65de6f73b6725..558890ada0e5b 100644
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
2.20.1

