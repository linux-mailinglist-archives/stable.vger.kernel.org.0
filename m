Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D455274068
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgIVLHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:07:40 -0400
Received: from aibo.runbox.com ([91.220.196.211]:40240 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgIVLHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 07:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=1K5YriAZ+QeTiFeBXlTzxJqiLhAXdhR8YIm2hSleeAY=; b=DPOZ/vBvVeE5VkFqICVEVzL/1f
        DQes4jcQp2KInC8Ztk26cjPIhAFpKkdJvHyVb7Dh+/4obzamxrZfkheHkAxs7YCbfQ7eKh2uDGtkv
        s2+TePfYfqeiYwPD+45fZrQSNEqsIh0PTWJOunXMxo22+9hS4iRdiRqRz4wbEcWNnQV+3VVBrJfGO
        EVnSdItwxWWuFneoSuCK7iYEK9PBVX/SNFX3+xA3+I14ZtWNfEGLgQia+1cFdfPnHvf6mJ9rKfEzR
        22a4K/5ojfbKmg0AGPCkDhgU+yqeb8M1UW0BHH2ptPxXiMS4O0uwP1DXV5jZaCdKNgGhn9HLK5F4f
        Gx8VJ7Zw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kKg93-00053W-Dk; Tue, 22 Sep 2020 13:07:37 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kKg92-00062a-VZ; Tue, 22 Sep 2020 13:07:37 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
Subject: [PATCH v3 4/4] usbcore/driver: Accommodate usbip
Date:   Tue, 22 Sep 2020 14:07:03 +0300
Message-Id: <20200922110703.720960-5-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922110703.720960-1-m.v.b@runbox.com>
References: <20200922110703.720960-1-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---
v3: New patch in this patch set.
    For reviewers' awareness, another option for usb_device_match would
    be as follows. This allows the driver's match() function to act
    as a fallback in case the driver has an id_table, but the id_table
    does not include the device.

	if (!udrv->id_table && !udrv->match) {
		/* Allow usbip and similar drivers to bind to
		 * arbitrary devices; let their probe functions
		 * decide.
		 */
		return 1;
	}

	if (udrv->id_table &&
	    usb_device_match_id(udev, udrv->id_table) != NULL)
		return 1;

	if (udrv->match && udrv->match(udev))
		return 1;

	return 0;
---
 drivers/usb/core/driver.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 7d90cbe063ec..98b7449c11f3 100644
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
2.26.2

