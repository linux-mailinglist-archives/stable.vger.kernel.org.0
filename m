Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D641B5C83
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgDWNXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgDWNXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:23:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 741D420704;
        Thu, 23 Apr 2020 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587648224;
        bh=cjvCkM/Nc45Zm23x15GPDP+WanBipeduPoKGFz8bYYs=;
        h=Subject:To:From:Date:From;
        b=dryH8l+BNhLC6XnOyrhQrbk8ASBPfZGJn8yaWi4TJ+EFl5F82uMK2aOgeGlCn1OkP
         u3EB4mYKpYCrN9OLTLS7KfFE8AYgHRdyUrzLhzzps1OgdUrHZiqR4pbmAtcYfmwvkC
         KiFN3dpDyka/S3NeowVq/RH0N3AViJgf7RRVw7ss=
Subject: patch "USB: hub: Revert commit bd0e6c9614b9 ("usb: hub: try old enumeration" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        prime.zeng@hisilicon.com, stable@vger.kernel.org,
        williambader@hotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:23:32 +0200
Message-ID: <1587648212174235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: hub: Revert commit bd0e6c9614b9 ("usb: hub: try old enumeration

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3155f4f40811c5d7e3c686215051acf504e05565 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 22 Apr 2020 16:13:08 -0400
Subject: USB: hub: Revert commit bd0e6c9614b9 ("usb: hub: try old enumeration
 scheme first for high speed devices")

Commit bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for
high speed devices") changed the way the hub driver enumerates
high-speed devices.  Instead of using the "new" enumeration scheme
first and switching to the "old" scheme if that doesn't work, we start
with the "old" scheme.  In theory this is better because the "old"
scheme is slightly faster -- it involves resetting the device only
once instead of twice.

However, for a long time Windows used only the "new" scheme.  Zeng Tao
said that Windows 8 and later use the "old" scheme for high-speed
devices, but apparently there are some devices that don't like it.
William Bader reports that the Ricoh webcam built into his Sony Vaio
laptop not only doesn't enumerate under the "old" scheme, it gets hung
up so badly that it won't then enumerate under the "new" scheme!  Only
a cold reset will fix it.

Therefore we will revert the commit and go back to trying the "new"
scheme first for high-speed devices.

Reported-and-tested-by: William Bader <williambader@hotmail.com>
Ref: https://bugzilla.kernel.org/show_bug.cgi?id=207219
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for high speed devices")
CC: Zeng Tao <prime.zeng@hisilicon.com>
CC: <stable@vger.kernel.org>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2004221611230.11262-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +--
 drivers/usb/core/hub.c                          | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f2a93c8679e8..7bc83f3d9bdf 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5187,8 +5187,7 @@
 
 	usbcore.old_scheme_first=
 			[USB] Start with the old device initialization
-			scheme,  applies only to low and full-speed devices
-			 (default 0 = off).
+			scheme (default 0 = off).
 
 	usbcore.usbfs_memory_mb=
 			[USB] Memory limit (in MB) for buffers allocated by
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 83549f009ced..2b6565c06c23 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2728,13 +2728,11 @@ static bool use_new_scheme(struct usb_device *udev, int retry,
 {
 	int old_scheme_first_port =
 		port_dev->quirks & USB_PORT_QUIRK_OLD_SCHEME;
-	int quick_enumeration = (udev->speed == USB_SPEED_HIGH);
 
 	if (udev->speed >= USB_SPEED_SUPER)
 		return false;
 
-	return USE_NEW_SCHEME(retry, old_scheme_first_port || old_scheme_first
-			      || quick_enumeration);
+	return USE_NEW_SCHEME(retry, old_scheme_first_port || old_scheme_first);
 }
 
 /* Is a USB 3.0 port in the Inactive or Compliance Mode state?
-- 
2.26.2


