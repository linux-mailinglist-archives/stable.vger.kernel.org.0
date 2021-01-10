Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD61B2F08E5
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbhAJRyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 12:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJRyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 12:54:52 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF72C061786
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 09:54:12 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id c14so11740921qtn.5
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 09:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=PMmvRaQ36fTjEgj6kVCX++Tln5tlagkABbPEgCbdZho=;
        b=cJsZKMaB3JE5+MUy0LLtyp7E/B0xRpdgO1gMH+09nzW6KLmnjz+a+TzXB1D+eMJHJe
         k5+pmAs8RQXMZXqr3wvSI98Cg97ua5OjRHWp5jQ7io1yhha42XGV5f5eq4eDSvLT4voh
         uGbOMwTz4kGj/4zfEsv3XbvmaY/gULHWe2vZzVM9WfbGiuMiNI2WkdUFKUfPHwhWgf75
         0RQlkUzyhr0UrdFJY/Db3sA64xrWooDXuW7OMdVRDoS6PfuQ8BiUS+yeAdKhSiE5fs9V
         MJsF8Gj4AgYR6D/4PbjYoVbNuIfWD4x62+398Uh4URilIe4aPWLEPrHqwNtCFhx2ZIcy
         tIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=PMmvRaQ36fTjEgj6kVCX++Tln5tlagkABbPEgCbdZho=;
        b=rtLRAZxjKihQUTmkgrnHxee+rV/Ilkv5QuSbsvlmj80FpNuCljxCb25Gv9lnpgHLAy
         h7R2fPuBKIvS0ot2iO+fYbxU/iUBF9re9/YHU8fO7lax/giwzR45wkOUijvO8zz+Ii5g
         HMEDfNXE2eFKoUxoA7FozcdRMR5niOnzATWBTWeiJDbJmufolFaoYKu1aYFm4RNPlsEq
         jxOgIwISgCfinTjg/0CN+rzWjm4WZxPwA4uUJ55UyznLNxnZ688Qsm3N0bTbeOQXymXa
         vHtIp0N2PE+W9LJGL3OmCLSEkqDgrT1dXsyFIL2DcB3dAPdgb/wtkqcx6KS/fX5VZaEW
         nKSw==
X-Gm-Message-State: AOAM533HC1y+9sLnsy9P3pc04oEeNCRyuw3Q3ADkFPKqtJCW9sSIDSjv
        BLkVwXCj9Q+dKaKL64lFMfgQ2Ktjqz9AZKU=
X-Google-Smtp-Source: ABdhPJxxFxEdB7Ve+ZXR4qEY23p/VHRY1z0BnWOv1bfqqOQkaaJYI3FMOfKYAElPSQl2BD0CJTyX3bDHWiyrCp8=
Sender: "saravanak via sendgmr" <saravanak@saravanak.san.corp.google.com>
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7220:84ff:fe09:fedc])
 (user=saravanak job=sendgmr) by 2002:a0c:f812:: with SMTP id
 r18mr12545001qvn.39.1610301251482; Sun, 10 Jan 2021 09:54:11 -0800 (PST)
Date:   Sun, 10 Jan 2021 09:54:07 -0800
Message-Id: <20210110175408.1465657-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v4] driver core: Fix device link device name collision
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
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
v1:
- Fixed the collision in the device link device name.
v1 -> v2:
- Tried to fixed collision in the supplier: and consumer: symlinks
v2 -> v3:
- Fixed the truncation of the symlink names caused by v2.
v3 -> v4:
- Did all the above fixes for the symlink removal path.

 Documentation/ABI/testing/sysfs-class-devlink |  4 +--
 .../ABI/testing/sysfs-devices-consumer        |  5 ++--
 .../ABI/testing/sysfs-devices-supplier        |  5 ++--
 drivers/base/core.c                           | 27 ++++++++++---------
 include/linux/device.h                        | 12 +++++++++
 5 files changed, 35 insertions(+), 18 deletions(-)

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
index 25e08e5f40bd..47a6faf1605a 100644
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
@@ -483,7 +485,7 @@ static int devlink_add_symlinks(struct device *dev,
 	goto out;
 
 err_sup_dev:
-	snprintf(buf, len, "consumer:%s", dev_name(con));
+	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
 	sysfs_remove_link(&sup->kobj, buf);
 err_con_dev:
 	sysfs_remove_link(&link->link_dev.kobj, "consumer");
@@ -506,7 +508,9 @@ static void devlink_remove_symlinks(struct device *dev,
 	sysfs_remove_link(&link->link_dev.kobj, "consumer");
 	sysfs_remove_link(&link->link_dev.kobj, "supplier");
 
-	len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
+	len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
+		  strlen(dev_bus_name(con)) + strlen(dev_name(con)));
+	len += strlen(":");
 	len += strlen("supplier:") + 1;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf) {
@@ -514,9 +518,9 @@ static void devlink_remove_symlinks(struct device *dev,
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
@@ -737,8 +741,9 @@ struct device_link *device_link_add(struct device *consumer,
 
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
@@ -1808,9 +1813,7 @@ const char *dev_driver_string(const struct device *dev)
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
2.30.0.284.gd98b1dd5eaa7-goog

