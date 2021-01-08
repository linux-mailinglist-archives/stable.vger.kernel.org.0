Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8702EEADD
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbhAHBZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbhAHBZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:25:12 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3388DC0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:24:32 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h75so13375271ybg.18
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=KOAVDThdKzrh65X/GbWaYtQc60+9XyXrjP6Yz10hBpg=;
        b=RBGLN+zZzbIyfD+Sx/8r3MreHegdReAedekFKpvtaPNNaqDbxkXYUj2VDgIfMU2A+a
         0gSrIzpImGQ7lN+roVMUsqqZ/U6UKXglPQAKcLOxtuXz5XCZrSBzdnRyeyAZ6P7rAP2+
         p20EzqAtITf3uOy8l+7o8K8aplevxQgr8mcMGEN/YLXWuDLt8A/lOi6vRoJ24r/ltKVD
         kyQB7m52qcSKNuifYv9rjJ5XWDxv3vyUrdczvAB0Al217clWckEOomaFHNDcQuiAkhs2
         wb9lWUU5U2EJa53S5Bd1MeIOxKCQDs1WnLO2WDPO0iabFn/+7S/upoYubbaTArj+IHqn
         XzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=KOAVDThdKzrh65X/GbWaYtQc60+9XyXrjP6Yz10hBpg=;
        b=ZxTWouiY4uKch9U+N+XQ8rPnQtit4NgPLzM3rg/aRdRSJ5Qqg/lQf0/LvXE4akrKzl
         Y4qqhnjKaP/vdIEIoc6GZuzOkLwtr2B+y6p2toQS0nudvNiYkErUfJ6Wux6toSgy+klj
         3YuwgljzBZ3D9D1IqeCykiKkzmucvA+H9BXV0+cydQIyXiuIh+BgxURfK9rlErIR1Gju
         HKyU+nxRm3IIwsk8ZJU1w3V7BPTaVlLF7Wf6JWbvv4kRLM4eczDMfnoJjd7dpYu61r1r
         yNZ0DxHKB4X3fehLUvNMsnO6Dj3aQ/NmFCtA+2WuKpPXJSFrCJsrctUkAOsaWn4BaCnL
         REEg==
X-Gm-Message-State: AOAM532+uLkNy/We2pJ+KNJ2JZ01yUfS9NqXhlZZddd9WRvAFuS6iPT2
        QRyPLcLCIwxRqOXDQVidt7FJH/I4Wfn1IxI=
X-Google-Smtp-Source: ABdhPJzcbE9RQxvMxNJh1QmFnA8FU8pPSupKeop38Z4gjuGWxWAa4dIAdZFbvDm5UgGdd3I+qjJIZj+dv7KoTlU=
Sender: "saravanak via sendgmr" <saravanak@saravanak.san.corp.google.com>
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7220:84ff:fe09:fedc])
 (user=saravanak job=sendgmr) by 2002:a25:c095:: with SMTP id
 c143mr2229233ybf.119.1610069071305; Thu, 07 Jan 2021 17:24:31 -0800 (PST)
Date:   Thu,  7 Jan 2021 17:24:26 -0800
Message-Id: <20210108012427.766318-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v3] driver core: Fix device link device name collision
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The device link device's name was of the form:
<supplier-dev-name>--<consumer-dev-name>

This can cause name collision as reported here [1] as device names are
not globally unique. Since device names have to be unique within the
bus/class, add the bus/class name as a prefix to the device names used to
construct the device link device name.

So the devuce link device's name will be of the form:
<supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>

[1] - https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/

Cc: stable@vger.kernel.org
Fixes: 287905e68dd2 ("driver core: Expose device link details in sysfs")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 Documentation/ABI/testing/sysfs-class-devlink   |  4 ++--
 .../ABI/testing/sysfs-devices-consumer          |  5 +++--
 .../ABI/testing/sysfs-devices-supplier          |  5 +++--
 drivers/base/core.c                             | 17 +++++++++--------
 include/linux/device.h                          | 12 ++++++++++++
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-devlink b/Documentation/ABI/testing/sysfs-class-devlink
index b662f747c83e..8a21ce515f61 100644
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
diff --git a/Documentation/ABI/testing/sysfs-devices-consumer b/Documentation/ABI/testing/sysfs-devices-consumer
index 1f06d74d1c3c..0809fda092e6 100644
--- a/Documentation/ABI/testing/sysfs-devices-consumer
+++ b/Documentation/ABI/testing/sysfs-devices-consumer
@@ -4,5 +4,6 @@ Contact:	Saravana Kannan <saravanak@google.com>
 Description:
 		The /sys/devices/.../consumer:<consumer> are symlinks to device
 		links where this device is the supplier. <consumer> denotes the
-		name of the consumer in that device link. There can be zero or
-		more of these symlinks for a given device.
+		name of the consumer in that device link and is of the form
+		bus:device name. There can be zero or more of these symlinks
+		for a given device.
diff --git a/Documentation/ABI/testing/sysfs-devices-supplier b/Documentation/ABI/testing/sysfs-devices-supplier
index a919e0db5e90..207f5972e98d 100644
--- a/Documentation/ABI/testing/sysfs-devices-supplier
+++ b/Documentation/ABI/testing/sysfs-devices-supplier
@@ -4,5 +4,6 @@ Contact:	Saravana Kannan <saravanak@google.com>
 Description:
 		The /sys/devices/.../supplier:<supplier> are symlinks to device
 		links where this device is the consumer. <supplier> denotes the
-		name of the supplier in that device link. There can be zero or
-		more of these symlinks for a given device.
+		name of the supplier in that device link and is of the form
+		bus:device name. There can be zero or more of these symlinks
+		for a given device.
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 25e08e5f40bd..4140a69dfe18 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -456,7 +456,9 @@ static int devlink_add_symlinks(struct device *dev,
 	struct device *con = link->consumer;
 	char *buf;
 
-	len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
+	len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
+		  strlen(dev_bus_name(con)) + strlen(dev_name(con)));
+	len += strlen(":");
 	len += strlen("supplier:") + 1;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
@@ -470,12 +472,12 @@ static int devlink_add_symlinks(struct device *dev,
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
@@ -737,8 +739,9 @@ struct device_link *device_link_add(struct device *consumer,
 
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
@@ -1808,9 +1811,7 @@ const char *dev_driver_string(const struct device *dev)
 	 * never change once they are set, so they don't need special care.
 	 */
 	drv = READ_ONCE(dev->driver);
-	return drv ? drv->name :
-			(dev->bus ? dev->bus->name :
-			(dev->class ? dev->class->name : ""));
+	return drv ? drv->name : dev_bus_name(dev);
 }
 EXPORT_SYMBOL(dev_driver_string);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 89bb8b84173e..1779f90eeb4c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -609,6 +609,18 @@ static inline const char *dev_name(const struct device *dev)
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
-- 
2.29.2.729.g45daf8777d-goog

