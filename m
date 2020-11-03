Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B72A5879
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgKCVwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731335AbgKCUrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC112242A;
        Tue,  3 Nov 2020 20:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436442;
        bh=J4WFhOze+C83DnDmzB1r7/n/MQ51u0fosTMl/mGgGHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCwpWb7Aud+XzMhF/vfSylEDNLIlZTdJFa7wZIdeBex+2m8bIKFkyPH7dWXirM4/r
         2GXlrfaIljrj+K6SkHuPxqfxUv1F+X4qw767s8joYthcih/i4pYdLi2Gs3CLCZ/+lo
         YQ2BNmcuW342ZS5dV99sIWXXpMD0KM2oxLsyOLRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>,
        "Pan (Pany) YUAN" <pany@fedoraproject.org>
Subject: [PATCH 5.9 251/391] usbcore: Check both id_table and match() when both available
Date:   Tue,  3 Nov 2020 21:35:02 +0100
Message-Id: <20201103203403.952249813@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

commit 0942d59b0af46511d59dbf5bd69ec4a64d1a854c upstream.

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
 drivers/usb/core/driver.c  |   30 +++++++++++++++++++++---------
 drivers/usb/core/generic.c |    4 +---
 drivers/usb/core/usb.h     |    2 ++
 3 files changed, 24 insertions(+), 12 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -839,6 +839,22 @@ const struct usb_device_id *usb_device_m
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
@@ -853,17 +869,14 @@ static int usb_device_match(struct devic
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
@@ -941,8 +954,7 @@ static int __usb_bus_reprobe_drivers(str
 		return 0;
 
 	udev = to_usb_device(dev);
-	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
-	    (!new_udriver->match || new_udriver->match(udev) == 0))
+	if (!usb_driver_applicable(udev, new_udriver))
 		return 0;
 
 	ret = device_reprobe(dev);
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -205,9 +205,7 @@ static int __check_usb_generic(struct de
 	udrv = to_usb_device_driver(drv);
 	if (udrv == &usb_generic_driver)
 		return 0;
-	if (usb_device_match_id(udev, udrv->id_table) != NULL)
-		return 1;
-	return (udrv->match && udrv->match(udev));
+	return usb_driver_applicable(udev, udrv);
 }
 
 static bool usb_generic_driver_match(struct usb_device *udev)
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -74,6 +74,8 @@ extern int usb_match_device(struct usb_d
 			    const struct usb_device_id *id);
 extern const struct usb_device_id *usb_device_match_id(struct usb_device *udev,
 				const struct usb_device_id *id);
+extern bool usb_driver_applicable(struct usb_device *udev,
+				  struct usb_device_driver *udrv);
 extern void usb_forced_unbind_intf(struct usb_interface *intf);
 extern void usb_unbind_and_rebind_marked_interfaces(struct usb_device *udev);
 


