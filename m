Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5924321DD
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 17:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhJRPIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 11:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhJRPH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 11:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE5926103D;
        Mon, 18 Oct 2021 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634569545;
        bh=/udOtEARZBzPd+aHly2KG1IuxaLECN5jd/2lVDZ2XfE=;
        h=Subject:To:From:Date:From;
        b=ljdbBR0+60QxbGTrQ4APccbW2dNp2G7kZYDQVKhljLTJIWq56/4YPPyoYEyC2+2jb
         cv+13veZ0bLmqyYzhq7PuSr2KB6hEdimP2APaoFUOPLJSHPki8jU3jcNO9QBAy1pbq
         kpfLvgp+Yj+SyoQYZ/cG77z5VvqFsT/8AYKMbzRI=
Subject: patch "usb-storage: Add compatibility quirk flags for iODD 2531/2541" added to usb-testing
To:     braewoods+lkml@braewoods.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 17:05:43 +0200
Message-ID: <16345695432324@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add compatibility quirk flags for iODD 2531/2541

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 05c8f1b67e67dcd786ae3fe44492bbc617b4bd12 Mon Sep 17 00:00:00 2001
From: James Buren <braewoods+lkml@braewoods.net>
Date: Wed, 13 Oct 2021 20:55:04 -0500
Subject: usb-storage: Add compatibility quirk flags for iODD 2531/2541

These drive enclosures have firmware bugs that make it impossible to mount
a new virtual ISO image after Linux ejects the old one if the device is
locked by Linux. Windows bypasses this problem by the fact that they do
not lock the device. Add a quirk to disable device locking for these
drive enclosures.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: James Buren <braewoods+lkml@braewoods.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211014015504.2695089-1-braewoods+lkml@braewoods.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index c6b3fcf90180..29191d33c0e3 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -406,6 +406,16 @@ UNUSUAL_DEV(  0x04b8, 0x0602, 0x0110, 0x0110,
 		"785EPX Storage",
 		USB_SC_SCSI, USB_PR_BULK, NULL, US_FL_SINGLE_LUN),
 
+/*
+ * Reported by James Buren <braewoods+lkml@braewoods.net>
+ * Virtual ISOs cannot be remounted if ejected while the device is locked
+ * Disable locking to mimic Windows behavior that bypasses the issue
+ */
+UNUSUAL_DEV(  0x04c5, 0x2028, 0x0001, 0x0001,
+		"iODD",
+		"2531/2541",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE),
+
 /*
  * Not sure who reported this originally but
  * Pavel Machek <pavel@ucw.cz> reported that the extra US_FL_SINGLE_LUN
-- 
2.33.1


