Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B23F74DF
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKKNaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfKKNaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:30:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C3B92196E;
        Mon, 11 Nov 2019 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573479010;
        bh=6sclHmDGSQX+Wr1BcGArkl85LKftmhcRE7D1/+VeOtM=;
        h=Subject:To:From:Date:From;
        b=t5yr8WviscqiXKaNUEFDVEW7IaKCXFYnhK6t8jT5mHsFZXHkj8FuJVHzwUPqGeVnW
         5Z4Dg+lTs41N/uTd/+fBOVBXsIpkb88sBYrWOTPwoAeqjtByEa5m54yyQGi9B6Wwbg
         w9jfz/ACayGbJLMnZVYCOuKAitlGmkuTJhHKo/jA=
Subject: patch "USB: chaoskey: fix error case of a timeout" added to usb-testing
To:     oneukum@suse.com, gregkh@linuxfoundation.org, oneukum@suse.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 14:30:00 +0100
Message-ID: <157347900011770@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: chaoskey: fix error case of a timeout

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 92aa5986f4f7b5a8bf282ca0f50967f4326559f5 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 7 Nov 2019 15:28:55 +0100
Subject: USB: chaoskey: fix error case of a timeout

In case of a timeout or if a signal aborts a read
communication with the device needs to be ended
lest we overwrite an active URB the next time we
do IO to the device, as the URB may still be active.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191107142856.16774-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/chaoskey.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index 34e6cd6f40d3..87067c3d6109 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -384,13 +384,17 @@ static int _chaoskey_fill(struct chaoskey *dev)
 		!dev->reading,
 		(started ? NAK_TIMEOUT : ALEA_FIRST_TIMEOUT) );
 
-	if (result < 0)
+	if (result < 0) {
+		usb_kill_urb(dev->urb);
 		goto out;
+	}
 
-	if (result == 0)
+	if (result == 0) {
 		result = -ETIMEDOUT;
-	else
+		usb_kill_urb(dev->urb);
+	} else {
 		result = dev->valid;
+	}
 out:
 	/* Let the device go back to sleep eventually */
 	usb_autopm_put_interface(dev->interface);
@@ -526,7 +530,21 @@ static int chaoskey_suspend(struct usb_interface *interface,
 
 static int chaoskey_resume(struct usb_interface *interface)
 {
+	struct chaoskey *dev;
+	struct usb_device *udev = interface_to_usbdev(interface);
+
 	usb_dbg(interface, "resume");
+	dev = usb_get_intfdata(interface);
+
+	/*
+	 * We may have lost power.
+	 * In that case the device that needs a long time
+	 * for the first requests needs an extended timeout
+	 * again
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == ALEA_VENDOR_ID)
+		dev->reads_started = false;
+
 	return 0;
 }
 #else
-- 
2.24.0


