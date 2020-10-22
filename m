Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9721F296078
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 15:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900519AbgJVNzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 09:55:47 -0400
Received: from aibo.runbox.com ([91.220.196.211]:54282 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442869AbgJVNzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 09:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=RLOsQAWw+vGlqNwVSZlDdr2JvP1N7nTxGdiLPOxd2ig=; b=mndfz1QUR5OU9krOjL1SwlCZmm
        Ovvlf5HCkf39Cd0aXktZJRlYPatwQULtaM8xc0CQtmnW8q3Io1Tym60/A2Jz2fjdth/Nlu6gPVibt
        WxQ+CI3qjniHav7Y9LpJ6bo0IGRN2roRURDYChNi7dxy5NP89Jod+Fj61yjqy+Td0i1v5AtG8AeRS
        GBnwUv7D1BTeIcKoQn1GJPg/ZDehQNSOIV2R5bEmcTW2RkMJBjMUE/U3D2teLNB7eorO3IVq5Yw/O
        Bm8alus2125OOoh9Ojl+GTSJyq3smYtty+XST4zZoCKhzgaefuRogPpBTxTj5jQev48+ovw9FZknb
        ah4FoncQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kVb4C-0001ZH-JV; Thu, 22 Oct 2020 15:55:44 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kVb42-0008Qw-OZ; Thu, 22 Oct 2020 15:55:35 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     Bastien Nocera <hadess@hadess.net>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "M . Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 1/2] usbcore: Check both id_table and match() when both available
Date:   Thu, 22 Oct 2020 09:55:20 -0400
Message-Id: <20201022135521.375211-2-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201022135521.375211-1-m.v.b@runbox.com>
References: <4cc0e162-c607-3fdf-30c9-1b3a77f6cf20@runbox.com>
 <20201022135521.375211-1-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

From: Bastien Nocera <hadess@hadess.net>

When a USB device driver has both an id_table and a match() function, make
sure to check both to find a match, first matching the id_table, then
checking the match() function.

This makes it possible to have module autoloading done through the
id_table when devices are plugged in, before checking for further
device eligibility in the match() function.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Co-developed-by: M. Vefa Bicakci <m.v.b@runbox.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
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
2.26.2

