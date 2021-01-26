Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE0A304A6F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbhAZFEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731223AbhAYSxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F4422EBD;
        Mon, 25 Jan 2021 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600767;
        bh=OBGowy0TXtuzqEdXpY7QgoEODeWbFWhU9U8P/xcunmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6xqoURBVOE0hhk2VROlnDq3yvgJpja8/FVVtK20kHcLIYleG6wgWcUQknlWzY0aH
         xgh2Oei9Z9un8U4X3PHkUIyTeoq+08RH0sNFyLXN8q2O6wH8Pi/d3BB9OlPfEjmQcJ
         2Qavmv24wyJlaUZQLQuAo+tv20rpvSnKlqD4/E9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Saravana Kannan <saravanak@google.com>
Subject: [PATCH 5.10 143/199] driver core: Fix device link device name collision
Date:   Mon, 25 Jan 2021 19:39:25 +0100
Message-Id: <20210125183222.248980345@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit e020ff611ba9be54e959e6b548038f8a020da1c9 upstream.

The device link device's name was of the form:
<supplier-dev-name>--<consumer-dev-name>

This can cause name collision as reported here [1] as device names are
not globally unique. Since device names have to be unique within the
bus/class, add the bus/class name as a prefix to the device names used to
construct the device link device name.

So the devuce link device's name will be of the form:
<supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>

[1] - https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/

Fixes: 287905e68dd2 ("driver core: Expose device link details in sysfs")
Cc: stable@vger.kernel.org
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210110175408.1465657-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/ABI/testing/sysfs-class-devlink    |    4 +--
 Documentation/ABI/testing/sysfs-devices-consumer |    5 ++--
 Documentation/ABI/testing/sysfs-devices-supplier |    5 ++--
 drivers/base/core.c                              |   27 ++++++++++++-----------
 include/linux/device.h                           |   12 ++++++++++
 5 files changed, 35 insertions(+), 18 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-devlink
+++ b/Documentation/ABI/testing/sysfs-class-devlink
@@ -5,8 +5,8 @@ Description:
 		Provide a place in sysfs for the device link objects in the
 		kernel at any given time.  The name of a device link directory,
 		denoted as ... above, is of the form <supplier>--<consumer>
-		where <supplier> is the supplier device name and <consumer> is
-		the consumer device name.
+		where <supplier> is the supplier bus:device name and <consumer>
+		is the consumer bus:device name.
 
 What:		/sys/class/devlink/.../auto_remove_on
 Date:		May 2020
--- a/Documentation/ABI/testing/sysfs-devices-consumer
+++ b/Documentation/ABI/testing/sysfs-devices-consumer
@@ -4,5 +4,6 @@ Contact:	Saravana Kannan <saravanak@goog
 Description:
 		The /sys/devices/.../consumer:<consumer> are symlinks to device
 		links where this device is the supplier. <consumer> denotes the
-		name of the consumer in that device link. There can be zero or
-		more of these symlinks for a given device.
+		name of the consumer in that device link and is of the form
+		bus:device name. There can be zero or more of these symlinks
+		for a given device.
--- a/Documentation/ABI/testing/sysfs-devices-supplier
+++ b/Documentation/ABI/testing/sysfs-devices-supplier
@@ -4,5 +4,6 @@ Contact:	Saravana Kannan <saravanak@goog
 Description:
 		The /sys/devices/.../supplier:<supplier> are symlinks to device
 		links where this device is the consumer. <supplier> denotes the
-		name of the supplier in that device link. There can be zero or
-		more of these symlinks for a given device.
+		name of the supplier in that device link and is of the form
+		bus:device name. There can be zero or more of these symlinks
+		for a given device.
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -363,7 +363,9 @@ static int devlink_add_symlinks(struct d
 	struct device *con = link->consumer;
 	char *buf;
 
-	len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
+	len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
+		  strlen(dev_bus_name(con)) + strlen(dev_name(con)));
+	len += strlen(":");
 	len += strlen("supplier:") + 1;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
@@ -377,12 +379,12 @@ static int devlink_add_symlinks(struct d
 	if (ret)
 		goto err_con;
 
-	snprintf(buf, len, "consumer:%s", dev_name(con));
+	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
 	ret = sysfs_create_link(&sup->kobj, &link->link_dev.kobj, buf);
 	if (ret)
 		goto err_con_dev;
 
-	snprintf(buf, len, "supplier:%s", dev_name(sup));
+	snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
 	ret = sysfs_create_link(&con->kobj, &link->link_dev.kobj, buf);
 	if (ret)
 		goto err_sup_dev;
@@ -390,7 +392,7 @@ static int devlink_add_symlinks(struct d
 	goto out;
 
 err_sup_dev:
-	snprintf(buf, len, "consumer:%s", dev_name(con));
+	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
 	sysfs_remove_link(&sup->kobj, buf);
 err_con_dev:
 	sysfs_remove_link(&link->link_dev.kobj, "consumer");
@@ -413,7 +415,9 @@ static void devlink_remove_symlinks(stru
 	sysfs_remove_link(&link->link_dev.kobj, "consumer");
 	sysfs_remove_link(&link->link_dev.kobj, "supplier");
 
-	len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
+	len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
+		  strlen(dev_bus_name(con)) + strlen(dev_name(con)));
+	len += strlen(":");
 	len += strlen("supplier:") + 1;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf) {
@@ -421,9 +425,9 @@ static void devlink_remove_symlinks(stru
 		return;
 	}
 
-	snprintf(buf, len, "supplier:%s", dev_name(sup));
+	snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
 	sysfs_remove_link(&con->kobj, buf);
-	snprintf(buf, len, "consumer:%s", dev_name(con));
+	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
 	sysfs_remove_link(&sup->kobj, buf);
 	kfree(buf);
 }
@@ -633,8 +637,9 @@ struct device_link *device_link_add(stru
 
 	link->link_dev.class = &devlink_class;
 	device_set_pm_not_required(&link->link_dev);
-	dev_set_name(&link->link_dev, "%s--%s",
-		     dev_name(supplier), dev_name(consumer));
+	dev_set_name(&link->link_dev, "%s:%s--%s:%s",
+		     dev_bus_name(supplier), dev_name(supplier),
+		     dev_bus_name(consumer), dev_name(consumer));
 	if (device_register(&link->link_dev)) {
 		put_device(consumer);
 		put_device(supplier);
@@ -1652,9 +1657,7 @@ const char *dev_driver_string(const stru
 	 * never change once they are set, so they don't need special care.
 	 */
 	drv = READ_ONCE(dev->driver);
-	return drv ? drv->name :
-			(dev->bus ? dev->bus->name :
-			(dev->class ? dev->class->name : ""));
+	return drv ? drv->name : dev_bus_name(dev);
 }
 EXPORT_SYMBOL(dev_driver_string);
 
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -615,6 +615,18 @@ static inline const char *dev_name(const
 	return kobject_name(&dev->kobj);
 }
 
+/**
+ * dev_bus_name - Return a device's bus/class name, if at all possible
+ * @dev: struct device to get the bus/class name of
+ *
+ * Will return the name of the bus/class the device is attached to.  If it is
+ * not attached to a bus/class, an empty string will be returned.
+ */
+static inline const char *dev_bus_name(const struct device *dev)
+{
+	return dev->bus ? dev->bus->name : (dev->class ? dev->class->name : "");
+}
+
 __printf(2, 3) int dev_set_name(struct device *dev, const char *name, ...);
 
 #ifdef CONFIG_NUMA


