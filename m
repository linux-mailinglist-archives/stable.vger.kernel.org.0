Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203B229DE85
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbgJ1WSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731744AbgJ1WRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EDA3246F9;
        Wed, 28 Oct 2020 12:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603887862;
        bh=eqTzOwsSTjUCEzPAIgDqLnvGOc6Hu0/7BxiQ2N6/JzE=;
        h=Subject:To:From:Date:From;
        b=AU1Ak3uCHox1QJGMbMpZEqQV2GyAMUv2hglOQz1L4GpjQ67FUtCCQoALir7ttyk4m
         ZiX6Vcaw7vlReo8sp36Pvn+aoSeT/EO3egsTPhVkUYaEs2t4pqiiVe7cuSfor38MSe
         CFARAOjVmuUuBrHaiqv46ecxhtMXh91zaN7T2OQA=
Subject: patch "usbcore: Check both id_table and match() when both available" added to usb-linus
To:     hadess@hadess.net, gregkh@linuxfoundation.org, m.v.b@runbox.com,
        pany@fedoraproject.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:25:13 +0100
Message-ID: <160388791323815@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbcore: Check both id_table and match() when both available

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0942d59b0af46511d59dbf5bd69ec4a64d1a854c Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Thu, 22 Oct 2020 09:55:20 -0400
Subject: usbcore: Check both id_table and match() when both available

From: Bastien Nocera <hadess@hadess.net>

When a USB device driver has both an id_table and a match() function, make
sure to check both to find a match, first matching the id_table, then
checking the match() function.

This makes it possible to have module autoloading done through the
id_table when devices are plugged in, before checking for further
device eligibility in the match() function.

Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Co-developed-by: M. Vefa Bicakci <m.v.b@runbox.com>
Tested-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Tested-by: Pan (Pany) YUAN <pany@fedoraproject.org>
Link: https://lore.kernel.org/r/20201022135521.375211-2-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/driver.c  | 30 +++++++++++++++++++++---------
 drivers/usb/core/generic.c |  4 +---
 drivers/usb/core/usb.h     |  2 ++
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 98b7449c11f3..4dfa44d6cc3c 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -839,6 +839,22 @@ const struct usb_device_id *usb_device_match_id(struct usb_device *udev,
 	return NULL;
 }
 
+bool usb_driver_applicable(struct usb_device *udev,
+			   struct usb_device_driver *udrv)
+{
+	if (udrv->id_table && udrv->match)
+		return usb_device_match_id(udev, udrv->id_table) != NULL &&
+		       udrv->match(udev);
+
+	if (udrv->id_table)
+		return usb_device_match_id(udev, udrv->id_table) != NULL;
+
+	if (udrv->match)
+		return udrv->match(udev);
+
+	return false;
+}
+
 static int usb_device_match(struct device *dev, struct device_driver *drv)
 {
 	/* devices and interfaces are handled separately */
@@ -853,17 +869,14 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
 		udev = to_usb_device(dev);
 		udrv = to_usb_device_driver(drv);
 
-		if (udrv->id_table)
-			return usb_device_match_id(udev, udrv->id_table) != NULL;
-
-		if (udrv->match)
-			return udrv->match(udev);
-
 		/* If the device driver under consideration does not have a
 		 * id_table or a match function, then let the driver's probe
 		 * function decide.
 		 */
-		return 1;
+		if (!udrv->id_table && !udrv->match)
+			return 1;
+
+		return usb_driver_applicable(udev, udrv);
 
 	} else if (is_usb_interface(dev)) {
 		struct usb_interface *intf;
@@ -941,8 +954,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
 		return 0;
 
 	udev = to_usb_device(dev);
-	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
-	    (!new_udriver->match || new_udriver->match(udev) == 0))
+	if (!usb_driver_applicable(udev, new_udriver))
 		return 0;
 
 	ret = device_reprobe(dev);
diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index 22c887f5c497..26f9fb9f67ca 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -205,9 +205,7 @@ static int __check_for_non_generic_match(struct device_driver *drv, void *data)
 	udrv = to_usb_device_driver(drv);
 	if (udrv == &usb_generic_driver)
 		return 0;
-	if (usb_device_match_id(udev, udrv->id_table) != NULL)
-		return 1;
-	return (udrv->match && udrv->match(udev));
+	return usb_driver_applicable(udev, udrv);
 }
 
 static bool usb_generic_driver_match(struct usb_device *udev)
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index c893f54a3420..82538daac8b8 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -74,6 +74,8 @@ extern int usb_match_device(struct usb_device *dev,
 			    const struct usb_device_id *id);
 extern const struct usb_device_id *usb_device_match_id(struct usb_device *udev,
 				const struct usb_device_id *id);
+extern bool usb_driver_applicable(struct usb_device *udev,
+				  struct usb_device_driver *udrv);
 extern void usb_forced_unbind_intf(struct usb_interface *intf);
 extern void usb_unbind_and_rebind_marked_interfaces(struct usb_device *udev);
 
-- 
2.29.1


