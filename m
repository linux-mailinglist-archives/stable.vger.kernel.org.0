Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019DB248397
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgHRLJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgHRLJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:09:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08AA7206B5;
        Tue, 18 Aug 2020 11:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597748969;
        bh=5DuHzFRLMxyHpU8rMEHdBw4sO9sIe8djRKDpcC5ohqc=;
        h=Subject:To:From:Date:From;
        b=xtzGCW796xZOyS++L5SEyOPjG5RyGEEK2iEpjNt0vnppjimu4XaSpGB/bYX/UmU8o
         I0U6T+D59f0tUQGx3yk2TfKAq4AqsktsNjlQsXaiMotqLODuC6rZv+ncJNeqw/V0rF
         zQ9NnQiZfMWLa22NAsr70+ZkfN1mMUa86db1674A=
Subject: patch "USB: Fix device driver race" added to usb-linus
To:     hadess@hadess.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:09:44 +0200
Message-ID: <159774898416413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Fix device driver race

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d5643d2249b279077427b2c2b2ffae9b70c95b0b Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Tue, 18 Aug 2020 13:04:45 +0200
Subject: USB: Fix device driver race

When a new device with a specialised device driver is plugged in, the
new driver will be modprobe()'d but the driver core will attach the
"generic" driver to the device.

After that, nothing will trigger a reprobe when the modprobe()'d device
driver has finished initialising, as the device has the "generic"
driver attached to it.

Trigger a reprobe ourselves when new specialised drivers get registered.

Fixes: 88b7381a939d ("USB: Select better matching USB drivers when available")
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200818110445.509668-3-hadess@hadess.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/driver.c | 40 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index f81606c6a35b..7e73e989645b 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -905,6 +905,35 @@ static int usb_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static bool is_dev_usb_generic_driver(struct device *dev)
+{
+	struct usb_device_driver *udd = dev->driver ?
+		to_usb_device_driver(dev->driver) : NULL;
+
+	return udd == &usb_generic_driver;
+}
+
+static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
+{
+	struct usb_device_driver *new_udriver = data;
+	struct usb_device *udev;
+	int ret;
+
+	if (!is_dev_usb_generic_driver(dev))
+		return 0;
+
+	udev = to_usb_device(dev);
+	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
+	    (!new_udriver->match || new_udriver->match(udev) != 0))
+		return 0;
+
+	ret = device_reprobe(dev);
+	if (ret && ret != -EPROBE_DEFER)
+		dev_err(dev, "Failed to reprobe device (error %d)\n", ret);
+
+	return 0;
+}
+
 /**
  * usb_register_device_driver - register a USB device (not interface) driver
  * @new_udriver: USB operations for the device driver
@@ -934,13 +963,20 @@ int usb_register_device_driver(struct usb_device_driver *new_udriver,
 
 	retval = driver_register(&new_udriver->drvwrap.driver);
 
-	if (!retval)
+	if (!retval) {
 		pr_info("%s: registered new device driver %s\n",
 			usbcore_name, new_udriver->name);
-	else
+		/*
+		 * Check whether any device could be better served with
+		 * this new driver
+		 */
+		bus_for_each_dev(&usb_bus_type, NULL, new_udriver,
+				 __usb_bus_reprobe_drivers);
+	} else {
 		printk(KERN_ERR "%s: error %d registering device "
 			"	driver %s\n",
 			usbcore_name, retval, new_udriver->name);
+	}
 
 	return retval;
 }
-- 
2.28.0


