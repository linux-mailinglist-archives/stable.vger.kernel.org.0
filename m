Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B895863E8
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 16:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfHHOJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 10:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfHHOJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 10:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE127214C6;
        Thu,  8 Aug 2019 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565273357;
        bh=f7+yHVk9liOcIRPQHpHOxfRkUrDPw8t6aDxDpGnHTEI=;
        h=Subject:To:From:Date:From;
        b=FA+an4lZNOzIISKowW48zflN/ECJ9B3fFy8Bj0n7aR3ger1jy/CcyVH9m9WQTbjj1
         nBRgNPCoES/zWM4laJZmMWToSuLcd8aqVf3RkETi09x75SWIswuXmApo2lAeV9o8RY
         zV2Q/7maqoxpJ3j1hVwWWfmOckQyAA3HCaONyZCw=
Subject: patch "usb: setup authorized_default attributes using usb_bus_notify" added to usb-linus
To:     tweek@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Aug 2019 16:09:14 +0200
Message-ID: <15652733546777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: setup authorized_default attributes using usb_bus_notify

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 27709ae4e2fe6cf7da2ae45e718e190c5433342b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>
Date: Tue, 6 Aug 2019 13:00:50 +0200
Subject: usb: setup authorized_default attributes using usb_bus_notify
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, the authorized_default and interface_authorized_default
attributes for HCD are set up after the uevent has been sent to userland.
This creates a race condition where userland may fail to access this
file when processing the event. Move the appending of these attributes
earlier relying on the usb_bus_notify dispatcher.

Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190806110050.38918-1-tweek@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c   | 123 ---------------------------------------
 drivers/usb/core/sysfs.c | 121 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/usb.h   |   5 ++
 3 files changed, 126 insertions(+), 123 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 9320787ac2e6..2ccbc2f83570 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -103,11 +103,6 @@ static DEFINE_SPINLOCK(hcd_urb_unlink_lock);
 /* wait queue for synchronous unlinks */
 DECLARE_WAIT_QUEUE_HEAD(usb_kill_urb_queue);
 
-static inline int is_root_hub(struct usb_device *udev)
-{
-	return (udev->parent == NULL);
-}
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -880,101 +875,6 @@ static int usb_rh_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 }
 
 
-
-/*
- * Show & store the current value of authorized_default
- */
-static ssize_t authorized_default_show(struct device *dev,
-				       struct device_attribute *attr, char *buf)
-{
-	struct usb_device *rh_usb_dev = to_usb_device(dev);
-	struct usb_bus *usb_bus = rh_usb_dev->bus;
-	struct usb_hcd *hcd;
-
-	hcd = bus_to_hcd(usb_bus);
-	return snprintf(buf, PAGE_SIZE, "%u\n", hcd->dev_policy);
-}
-
-static ssize_t authorized_default_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t size)
-{
-	ssize_t result;
-	unsigned val;
-	struct usb_device *rh_usb_dev = to_usb_device(dev);
-	struct usb_bus *usb_bus = rh_usb_dev->bus;
-	struct usb_hcd *hcd;
-
-	hcd = bus_to_hcd(usb_bus);
-	result = sscanf(buf, "%u\n", &val);
-	if (result == 1) {
-		hcd->dev_policy = val <= USB_DEVICE_AUTHORIZE_INTERNAL ?
-			val : USB_DEVICE_AUTHORIZE_ALL;
-		result = size;
-	} else {
-		result = -EINVAL;
-	}
-	return result;
-}
-static DEVICE_ATTR_RW(authorized_default);
-
-/*
- * interface_authorized_default_show - show default authorization status
- * for USB interfaces
- *
- * note: interface_authorized_default is the default value
- *       for initializing the authorized attribute of interfaces
- */
-static ssize_t interface_authorized_default_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct usb_device *usb_dev = to_usb_device(dev);
-	struct usb_hcd *hcd = bus_to_hcd(usb_dev->bus);
-
-	return sprintf(buf, "%u\n", !!HCD_INTF_AUTHORIZED(hcd));
-}
-
-/*
- * interface_authorized_default_store - store default authorization status
- * for USB interfaces
- *
- * note: interface_authorized_default is the default value
- *       for initializing the authorized attribute of interfaces
- */
-static ssize_t interface_authorized_default_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct usb_device *usb_dev = to_usb_device(dev);
-	struct usb_hcd *hcd = bus_to_hcd(usb_dev->bus);
-	int rc = count;
-	bool val;
-
-	if (strtobool(buf, &val) != 0)
-		return -EINVAL;
-
-	if (val)
-		set_bit(HCD_FLAG_INTF_AUTHORIZED, &hcd->flags);
-	else
-		clear_bit(HCD_FLAG_INTF_AUTHORIZED, &hcd->flags);
-
-	return rc;
-}
-static DEVICE_ATTR_RW(interface_authorized_default);
-
-/* Group all the USB bus attributes */
-static struct attribute *usb_bus_attrs[] = {
-		&dev_attr_authorized_default.attr,
-		&dev_attr_interface_authorized_default.attr,
-		NULL,
-};
-
-static const struct attribute_group usb_bus_attr_group = {
-	.name = NULL,	/* we want them in the same directory */
-	.attrs = usb_bus_attrs,
-};
-
-
-
 /*-------------------------------------------------------------------------*/
 
 /**
@@ -2894,32 +2794,11 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	if (retval != 0)
 		goto err_register_root_hub;
 
-	retval = sysfs_create_group(&rhdev->dev.kobj, &usb_bus_attr_group);
-	if (retval < 0) {
-		printk(KERN_ERR "Cannot register USB bus sysfs attributes: %d\n",
-		       retval);
-		goto error_create_attr_group;
-	}
 	if (hcd->uses_new_polling && HCD_POLL_RH(hcd))
 		usb_hcd_poll_rh_status(hcd);
 
 	return retval;
 
-error_create_attr_group:
-	clear_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
-	if (HC_IS_RUNNING(hcd->state))
-		hcd->state = HC_STATE_QUIESCING;
-	spin_lock_irq(&hcd_root_hub_lock);
-	hcd->rh_registered = 0;
-	spin_unlock_irq(&hcd_root_hub_lock);
-
-#ifdef CONFIG_PM
-	cancel_work_sync(&hcd->wakeup_work);
-#endif
-	cancel_work_sync(&hcd->died_work);
-	mutex_lock(&usb_bus_idr_lock);
-	usb_disconnect(&rhdev);		/* Sets rhdev to NULL */
-	mutex_unlock(&usb_bus_idr_lock);
 err_register_root_hub:
 	hcd->rh_pollable = 0;
 	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
@@ -2963,8 +2842,6 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	dev_info(hcd->self.controller, "remove, state %x\n", hcd->state);
 
 	usb_get_dev(rhdev);
-	sysfs_remove_group(&rhdev->dev.kobj, &usb_bus_attr_group);
-
 	clear_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
 	if (HC_IS_RUNNING (hcd->state))
 		hcd->state = HC_STATE_QUIESCING;
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 7e88fdfe3cf5..f19694e69f5c 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/usb.h>
+#include <linux/usb/hcd.h>
 #include <linux/usb/quirks.h>
 #include <linux/of.h>
 #include "usb.h"
@@ -922,6 +923,116 @@ static struct bin_attribute dev_bin_attr_descriptors = {
 	.size = 18 + 65535,	/* dev descr + max-size raw descriptor */
 };
 
+/*
+ * Show & store the current value of authorized_default
+ */
+static ssize_t authorized_default_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct usb_device *rh_usb_dev = to_usb_device(dev);
+	struct usb_bus *usb_bus = rh_usb_dev->bus;
+	struct usb_hcd *hcd;
+
+	hcd = bus_to_hcd(usb_bus);
+	return snprintf(buf, PAGE_SIZE, "%u\n", hcd->dev_policy);
+}
+
+static ssize_t authorized_default_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t size)
+{
+	ssize_t result;
+	unsigned int val;
+	struct usb_device *rh_usb_dev = to_usb_device(dev);
+	struct usb_bus *usb_bus = rh_usb_dev->bus;
+	struct usb_hcd *hcd;
+
+	hcd = bus_to_hcd(usb_bus);
+	result = sscanf(buf, "%u\n", &val);
+	if (result == 1) {
+		hcd->dev_policy = val <= USB_DEVICE_AUTHORIZE_INTERNAL ?
+			val : USB_DEVICE_AUTHORIZE_ALL;
+		result = size;
+	} else {
+		result = -EINVAL;
+	}
+	return result;
+}
+static DEVICE_ATTR_RW(authorized_default);
+
+/*
+ * interface_authorized_default_show - show default authorization status
+ * for USB interfaces
+ *
+ * note: interface_authorized_default is the default value
+ *       for initializing the authorized attribute of interfaces
+ */
+static ssize_t interface_authorized_default_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct usb_device *usb_dev = to_usb_device(dev);
+	struct usb_hcd *hcd = bus_to_hcd(usb_dev->bus);
+
+	return sprintf(buf, "%u\n", !!HCD_INTF_AUTHORIZED(hcd));
+}
+
+/*
+ * interface_authorized_default_store - store default authorization status
+ * for USB interfaces
+ *
+ * note: interface_authorized_default is the default value
+ *       for initializing the authorized attribute of interfaces
+ */
+static ssize_t interface_authorized_default_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct usb_device *usb_dev = to_usb_device(dev);
+	struct usb_hcd *hcd = bus_to_hcd(usb_dev->bus);
+	int rc = count;
+	bool val;
+
+	if (strtobool(buf, &val) != 0)
+		return -EINVAL;
+
+	if (val)
+		set_bit(HCD_FLAG_INTF_AUTHORIZED, &hcd->flags);
+	else
+		clear_bit(HCD_FLAG_INTF_AUTHORIZED, &hcd->flags);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(interface_authorized_default);
+
+/* Group all the USB bus attributes */
+static struct attribute *usb_bus_attrs[] = {
+		&dev_attr_authorized_default.attr,
+		&dev_attr_interface_authorized_default.attr,
+		NULL,
+};
+
+static const struct attribute_group usb_bus_attr_group = {
+	.name = NULL,	/* we want them in the same directory */
+	.attrs = usb_bus_attrs,
+};
+
+
+static int add_default_authorized_attributes(struct device *dev)
+{
+	int rc = 0;
+
+	if (is_usb_device(dev))
+		rc = sysfs_create_group(&dev->kobj, &usb_bus_attr_group);
+
+	return rc;
+}
+
+static void remove_default_authorized_attributes(struct device *dev)
+{
+	if (is_usb_device(dev)) {
+		sysfs_remove_group(&dev->kobj, &usb_bus_attr_group);
+	}
+}
+
 int usb_create_sysfs_dev_files(struct usb_device *udev)
 {
 	struct device *dev = &udev->dev;
@@ -938,7 +1049,14 @@ int usb_create_sysfs_dev_files(struct usb_device *udev)
 	retval = add_power_attributes(dev);
 	if (retval)
 		goto error;
+
+	if (is_root_hub(udev)) {
+		retval = add_default_authorized_attributes(dev);
+		if (retval)
+			goto error;
+	}
 	return retval;
+
 error:
 	usb_remove_sysfs_dev_files(udev);
 	return retval;
@@ -948,6 +1066,9 @@ void usb_remove_sysfs_dev_files(struct usb_device *udev)
 {
 	struct device *dev = &udev->dev;
 
+	if (is_root_hub(udev))
+		remove_default_authorized_attributes(dev);
+
 	remove_power_attributes(dev);
 	remove_persist_attributes(dev);
 	device_remove_bin_file(dev, &dev_bin_attr_descriptors);
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index bd8d01f85a13..0c9fde5ad052 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -153,6 +153,11 @@ static inline int is_usb_port(const struct device *dev)
 	return dev->type == &usb_port_device_type;
 }
 
+static inline int is_root_hub(struct usb_device *udev)
+{
+	return (udev->parent == NULL);
+}
+
 /* Do the same for device drivers and interface drivers. */
 
 static inline int is_usb_device_driver(struct device_driver *drv)
-- 
2.22.0


