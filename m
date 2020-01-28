Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5602314B61F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgA1OCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbgA1OCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E85A24685;
        Tue, 28 Jan 2020 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220151;
        bh=5RmTnKOEq7QMa7UEgFMYiT5SpDZtOasf7w/LX4MzZqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMOUnGTJKl1kSrI7CUY/z3dOO6L5epd52vDoC+nl61mlH0t3PtskuguWwcaF2kXWr
         hKUbmNsW2z0JKUtR2rrLvCSgo2r6lQqMY9dDDxv53h7OR4fcGu2WDO3QubIQITwei+
         HujfOPZoAMnd7eNUIzz9UgDLMcAaCI3HiHsh66hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 036/104] hwmon: (core) Do not use device managed functions for memory allocations
Date:   Tue, 28 Jan 2020 14:59:57 +0100
Message-Id: <20200128135822.378228012@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 3bf8bdcf3bada771eb12b57f2a30caee69e8ab8d upstream.

The hwmon core uses device managed functions, tied to the hwmon parent
device, for various internal memory allocations. This is problematic
since hwmon device lifetime does not necessarily match its parent's
device lifetime. If there is a mismatch, memory leaks will accumulate
until the parent device is released.

Fix the problem by managing all memory allocations internally. The only
exception is memory allocation for thermal device registration, which
can be tied to the hwmon device, along with thermal device registration
itself.

Fixes: d560168b5d0f ("hwmon: (core) New hwmon registration API")
Cc: stable@vger.kernel.org # v4.14.x: 47c332deb8e8: hwmon: Deal with errors from the thermal subsystem
Cc: stable@vger.kernel.org # v4.14.x: 74e3512731bd: hwmon: (core) Fix double-free in __hwmon_device_register()
Cc: stable@vger.kernel.org # v4.9.x: 3a412d5e4a1c: hwmon: (core) Simplify sysfs attribute name allocation
Cc: stable@vger.kernel.org # v4.9.x: 47c332deb8e8: hwmon: Deal with errors from the thermal subsystem
Cc: stable@vger.kernel.org # v4.9.x: 74e3512731bd: hwmon: (core) Fix double-free in __hwmon_device_register()
Cc: stable@vger.kernel.org # v4.9+
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/hwmon.c |   68 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 27 deletions(-)

--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -51,6 +51,7 @@ struct hwmon_device_attribute {
 
 #define to_hwmon_attr(d) \
 	container_of(d, struct hwmon_device_attribute, dev_attr)
+#define to_dev_attr(a) container_of(a, struct device_attribute, attr)
 
 /*
  * Thermal zone information
@@ -58,7 +59,7 @@ struct hwmon_device_attribute {
  * also provides the sensor index.
  */
 struct hwmon_thermal_data {
-	struct hwmon_device *hwdev;	/* Reference to hwmon device */
+	struct device *dev;		/* Reference to hwmon device */
 	int index;			/* sensor index */
 };
 
@@ -95,9 +96,27 @@ static const struct attribute_group *hwm
 	NULL
 };
 
+static void hwmon_free_attrs(struct attribute **attrs)
+{
+	int i;
+
+	for (i = 0; attrs[i]; i++) {
+		struct device_attribute *dattr = to_dev_attr(attrs[i]);
+		struct hwmon_device_attribute *hattr = to_hwmon_attr(dattr);
+
+		kfree(hattr);
+	}
+	kfree(attrs);
+}
+
 static void hwmon_dev_release(struct device *dev)
 {
-	kfree(to_hwmon_device(dev));
+	struct hwmon_device *hwdev = to_hwmon_device(dev);
+
+	if (hwdev->group.attrs)
+		hwmon_free_attrs(hwdev->group.attrs);
+	kfree(hwdev->groups);
+	kfree(hwdev);
 }
 
 static struct class hwmon_class = {
@@ -119,11 +138,11 @@ static DEFINE_IDA(hwmon_ida);
 static int hwmon_thermal_get_temp(void *data, int *temp)
 {
 	struct hwmon_thermal_data *tdata = data;
-	struct hwmon_device *hwdev = tdata->hwdev;
+	struct hwmon_device *hwdev = to_hwmon_device(tdata->dev);
 	int ret;
 	long t;
 
-	ret = hwdev->chip->ops->read(&hwdev->dev, hwmon_temp, hwmon_temp_input,
+	ret = hwdev->chip->ops->read(tdata->dev, hwmon_temp, hwmon_temp_input,
 				     tdata->index, &t);
 	if (ret < 0)
 		return ret;
@@ -137,8 +156,7 @@ static const struct thermal_zone_of_devi
 	.get_temp = hwmon_thermal_get_temp,
 };
 
-static int hwmon_thermal_add_sensor(struct device *dev,
-				    struct hwmon_device *hwdev, int index)
+static int hwmon_thermal_add_sensor(struct device *dev, int index)
 {
 	struct hwmon_thermal_data *tdata;
 	struct thermal_zone_device *tzd;
@@ -147,10 +165,10 @@ static int hwmon_thermal_add_sensor(stru
 	if (!tdata)
 		return -ENOMEM;
 
-	tdata->hwdev = hwdev;
+	tdata->dev = dev;
 	tdata->index = index;
 
-	tzd = devm_thermal_zone_of_sensor_register(&hwdev->dev, index, tdata,
+	tzd = devm_thermal_zone_of_sensor_register(dev, index, tdata,
 						   &hwmon_thermal_ops);
 	/*
 	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
@@ -162,8 +180,7 @@ static int hwmon_thermal_add_sensor(stru
 	return 0;
 }
 #else
-static int hwmon_thermal_add_sensor(struct device *dev,
-				    struct hwmon_device *hwdev, int index)
+static int hwmon_thermal_add_sensor(struct device *dev, int index)
 {
 	return 0;
 }
@@ -250,8 +267,7 @@ static bool is_string_attr(enum hwmon_se
 	       (type == hwmon_fan && attr == hwmon_fan_label);
 }
 
-static struct attribute *hwmon_genattr(struct device *dev,
-				       const void *drvdata,
+static struct attribute *hwmon_genattr(const void *drvdata,
 				       enum hwmon_sensor_types type,
 				       u32 attr,
 				       int index,
@@ -279,7 +295,7 @@ static struct attribute *hwmon_genattr(s
 	if ((mode & 0222) && !ops->write)
 		return ERR_PTR(-EINVAL);
 
-	hattr = devm_kzalloc(dev, sizeof(*hattr), GFP_KERNEL);
+	hattr = kzalloc(sizeof(*hattr), GFP_KERNEL);
 	if (!hattr)
 		return ERR_PTR(-ENOMEM);
 
@@ -492,8 +508,7 @@ static int hwmon_num_channel_attrs(const
 	return n;
 }
 
-static int hwmon_genattrs(struct device *dev,
-			  const void *drvdata,
+static int hwmon_genattrs(const void *drvdata,
 			  struct attribute **attrs,
 			  const struct hwmon_ops *ops,
 			  const struct hwmon_channel_info *info)
@@ -519,7 +534,7 @@ static int hwmon_genattrs(struct device
 			attr_mask &= ~BIT(attr);
 			if (attr >= template_size)
 				return -EINVAL;
-			a = hwmon_genattr(dev, drvdata, info->type, attr, i,
+			a = hwmon_genattr(drvdata, info->type, attr, i,
 					  templates[attr], ops);
 			if (IS_ERR(a)) {
 				if (PTR_ERR(a) != -ENOENT)
@@ -533,8 +548,7 @@ static int hwmon_genattrs(struct device
 }
 
 static struct attribute **
-__hwmon_create_attrs(struct device *dev, const void *drvdata,
-		     const struct hwmon_chip_info *chip)
+__hwmon_create_attrs(const void *drvdata, const struct hwmon_chip_info *chip)
 {
 	int ret, i, aindex = 0, nattrs = 0;
 	struct attribute **attrs;
@@ -545,15 +559,17 @@ __hwmon_create_attrs(struct device *dev,
 	if (nattrs == 0)
 		return ERR_PTR(-EINVAL);
 
-	attrs = devm_kcalloc(dev, nattrs + 1, sizeof(*attrs), GFP_KERNEL);
+	attrs = kcalloc(nattrs + 1, sizeof(*attrs), GFP_KERNEL);
 	if (!attrs)
 		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; chip->info[i]; i++) {
-		ret = hwmon_genattrs(dev, drvdata, &attrs[aindex], chip->ops,
+		ret = hwmon_genattrs(drvdata, &attrs[aindex], chip->ops,
 				     chip->info[i]);
-		if (ret < 0)
+		if (ret < 0) {
+			hwmon_free_attrs(attrs);
 			return ERR_PTR(ret);
+		}
 		aindex += ret;
 	}
 
@@ -595,14 +611,13 @@ __hwmon_device_register(struct device *d
 			for (i = 0; groups[i]; i++)
 				ngroups++;
 
-		hwdev->groups = devm_kcalloc(dev, ngroups, sizeof(*groups),
-					     GFP_KERNEL);
+		hwdev->groups = kcalloc(ngroups, sizeof(*groups), GFP_KERNEL);
 		if (!hwdev->groups) {
 			err = -ENOMEM;
 			goto free_hwmon;
 		}
 
-		attrs = __hwmon_create_attrs(dev, drvdata, chip);
+		attrs = __hwmon_create_attrs(drvdata, chip);
 		if (IS_ERR(attrs)) {
 			err = PTR_ERR(attrs);
 			goto free_hwmon;
@@ -647,8 +662,7 @@ __hwmon_device_register(struct device *d
 							   hwmon_temp_input, j))
 					continue;
 				if (info[i]->config[j] & HWMON_T_INPUT) {
-					err = hwmon_thermal_add_sensor(dev,
-								hwdev, j);
+					err = hwmon_thermal_add_sensor(hdev, j);
 					if (err) {
 						device_unregister(hdev);
 						/*
@@ -667,7 +681,7 @@ __hwmon_device_register(struct device *d
 	return hdev;
 
 free_hwmon:
-	kfree(hwdev);
+	hwmon_dev_release(hdev);
 ida_remove:
 	ida_simple_remove(&hwmon_ida, id);
 	return ERR_PTR(err);


