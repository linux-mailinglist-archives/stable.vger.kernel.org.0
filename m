Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797C6278B46
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgIYOxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgIYOxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:53:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 873C72074B;
        Fri, 25 Sep 2020 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601045590;
        bh=hp6WgApzzVex7it5jBkeHFtfi4BhISKiXpB7llqSigg=;
        h=Subject:To:From:Date:From;
        b=eMaxJTEbdPJy25W96M/bdHVJKbfn6S9exXtf+N/k9/n+yF1LpPvlpCPvAwolij6Z+
         AJmXYD49n43Sm++mwODrcbNQbCegJ5E/eX3+ej2kBApsfNFGXgxAy8qUpjkM8vx/Gc
         WbuwapUJJON1OCZhSVvvwg6R6f1TOn1RlmZiaQp4=
Subject: patch "usbcore/driver: Accommodate usbip" added to usb-linus
To:     m.v.b@runbox.com, andreyknvl@google.com,
        gregkh@linuxfoundation.org, hadess@hadess.net, shuah@kernel.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller@googlegroups.com,
        valentina.manea.m@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 16:53:19 +0200
Message-ID: <160104559930123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbcore/driver: Accommodate usbip

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3fce39601a1a34d940cf62858ee01ed9dac5d459 Mon Sep 17 00:00:00 2001
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
Date: Tue, 22 Sep 2020 14:07:03 +0300
Subject: usbcore/driver: Accommodate usbip

Commit 88b7381a939d ("USB: Select better matching USB drivers when
available") inadvertently broke usbip functionality. The commit in
question allows USB device drivers to be explicitly matched with
USB devices via the use of driver-provided identifier tables and
match functions, which is useful for a specialised device driver
to be chosen for a device that can also be handled by another,
more generic, device driver.

Prior, the USB device section of usb_device_match() had an
unconditional "return 1" statement, which allowed user-space to bind
USB devices to the usbip_host device driver, if desired. However,
the aforementioned commit changed the default/fallback return
value to zero. This breaks device drivers such as usbip_host, so
this commit restores the legacy behaviour, but only if a device
driver does not have an id_table and a match() function.

In addition, if usb_device_match is called for a device driver
and device pair where the device does not match the id_table of the
device driver in question, then the device driver will be disqualified
for the device. This allows avoiding the default case of "return 1",
which prevents undesirable probe() calls to a driver even though
its id_table did not match the device.

Finally, this commit changes the specialised-driver-to-generic-driver
transition code so that when a device driver returns -ENODEV, a more
generic device driver is only considered if the current device driver
does not have an id_table and a match() function. This ensures that
"generic" drivers such as usbip_host will not be considered specialised
device drivers and will not cause the device to be locked in to the
generic device driver, when a more specialised device driver could be
tried.

All of these changes restore usbip functionality without regressions,
ensure that the specialised/generic device driver selection logic works
as expected with the usb and apple-mfi-fastcharge drivers, and do not
negatively affect the use of devices provided by dummy_hcd.

Fixes: 88b7381a939d ("USB: Select better matching USB drivers when available")
Cc: <stable@vger.kernel.org> # 5.8
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <syzkaller@googlegroups.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Link: https://lore.kernel.org/r/20200922110703.720960-5-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/driver.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index b00b7fb1aad1..b351962279e4 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -269,8 +269,30 @@ static int usb_probe_device(struct device *dev)
 	if (error)
 		return error;
 
+	/* Probe the USB device with the driver in hand, but only
+	 * defer to a generic driver in case the current USB
+	 * device driver has an id_table or a match function; i.e.,
+	 * when the device driver was explicitly matched against
+	 * a device.
+	 *
+	 * If the device driver does not have either of these,
+	 * then we assume that it can bind to any device and is
+	 * not truly a more specialized/non-generic driver, so a
+	 * return value of -ENODEV should not force the device
+	 * to be handled by the generic USB driver, as there
+	 * can still be another, more specialized, device driver.
+	 *
+	 * This accommodates the usbip driver.
+	 *
+	 * TODO: What if, in the future, there are multiple
+	 * specialized USB device drivers for a particular device?
+	 * In such cases, there is a need to try all matching
+	 * specialised device drivers prior to setting the
+	 * use_generic_driver bit.
+	 */
 	error = udriver->probe(udev);
-	if (error == -ENODEV && udriver != &usb_generic_driver) {
+	if (error == -ENODEV && udriver != &usb_generic_driver &&
+	    (udriver->id_table || udriver->match)) {
 		udev->use_generic_driver = 1;
 		return -EPROBE_DEFER;
 	}
@@ -831,14 +853,17 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
 		udev = to_usb_device(dev);
 		udrv = to_usb_device_driver(drv);
 
-		if (udrv->id_table &&
-		    usb_device_match_id(udev, udrv->id_table) != NULL) {
-			return 1;
-		}
+		if (udrv->id_table)
+			return usb_device_match_id(udev, udrv->id_table) != NULL;
 
 		if (udrv->match)
 			return udrv->match(udev);
-		return 0;
+
+		/* If the device driver under consideration does not have a
+		 * id_table or a match function, then let the driver's probe
+		 * function decide.
+		 */
+		return 1;
 
 	} else if (is_usb_interface(dev)) {
 		struct usb_interface *intf;
-- 
2.28.0


