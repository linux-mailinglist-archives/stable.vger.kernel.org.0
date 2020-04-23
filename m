Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D871B67BC
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgDWXJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50890 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728650AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004z3-Du; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvi-00E72t-4y; Fri, 24 Apr 2020 00:06:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:07:38 +0100
Message-ID: <lsq.1587683028.752435307@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 231/245] ptp: use is_visible method to hide unused
 attributes
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit af59e717d5ff9c8dbf9bcc581c0dfb3b2a9c9030 upstream.

Instead of creating selected attributes after the device is created (and
after userspace potentially seen uevent), lets use attribute group
is_visible() method to control which attributes are shown. This will allow
us to create all attributes (except "pins" group, which will be taken care
of later) before userspace gets notified about new ptp class device.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ptp/ptp_sysfs.c | 125 ++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 70 deletions(-)

--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -46,27 +46,6 @@ PTP_SHOW_INT(n_periodic_outputs, n_per_o
 PTP_SHOW_INT(n_programmable_pins, n_pins);
 PTP_SHOW_INT(pps_available, pps);
 
-static struct attribute *ptp_attrs[] = {
-	&dev_attr_clock_name.attr,
-	&dev_attr_max_adjustment.attr,
-	&dev_attr_n_alarms.attr,
-	&dev_attr_n_external_timestamps.attr,
-	&dev_attr_n_periodic_outputs.attr,
-	&dev_attr_n_programmable_pins.attr,
-	&dev_attr_pps_available.attr,
-	NULL,
-};
-
-static const struct attribute_group ptp_group = {
-	.attrs = ptp_attrs,
-};
-
-const struct attribute_group *ptp_groups[] = {
-	&ptp_group,
-	NULL,
-};
-
-
 static ssize_t extts_enable_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
@@ -91,6 +70,7 @@ static ssize_t extts_enable_store(struct
 out:
 	return err;
 }
+static DEVICE_ATTR(extts_enable, 0220, NULL, extts_enable_store);
 
 static ssize_t extts_fifo_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
@@ -124,6 +104,7 @@ out:
 	mutex_unlock(&ptp->tsevq_mux);
 	return cnt;
 }
+static DEVICE_ATTR(fifo, 0444, extts_fifo_show, NULL);
 
 static ssize_t period_store(struct device *dev,
 			    struct device_attribute *attr,
@@ -151,6 +132,7 @@ static ssize_t period_store(struct devic
 out:
 	return err;
 }
+static DEVICE_ATTR(period, 0220, NULL, period_store);
 
 static ssize_t pps_enable_store(struct device *dev,
 				struct device_attribute *attr,
@@ -177,6 +159,57 @@ static ssize_t pps_enable_store(struct d
 out:
 	return err;
 }
+static DEVICE_ATTR(pps_enable, 0220, NULL, pps_enable_store);
+
+static struct attribute *ptp_attrs[] = {
+	&dev_attr_clock_name.attr,
+
+	&dev_attr_max_adjustment.attr,
+	&dev_attr_n_alarms.attr,
+	&dev_attr_n_external_timestamps.attr,
+	&dev_attr_n_periodic_outputs.attr,
+	&dev_attr_n_programmable_pins.attr,
+	&dev_attr_pps_available.attr,
+
+	&dev_attr_extts_enable.attr,
+	&dev_attr_fifo.attr,
+	&dev_attr_period.attr,
+	&dev_attr_pps_enable.attr,
+	NULL
+};
+
+static umode_t ptp_is_attribute_visible(struct kobject *kobj,
+					struct attribute *attr, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *info = ptp->info;
+	umode_t mode = attr->mode;
+
+	if (attr == &dev_attr_extts_enable.attr ||
+	    attr == &dev_attr_fifo.attr) {
+		if (!info->n_ext_ts)
+			mode = 0;
+	} else if (attr == &dev_attr_period.attr) {
+		if (!info->n_per_out)
+			mode = 0;
+	} else if (attr == &dev_attr_pps_enable.attr) {
+		if (!info->pps)
+			mode = 0;
+	}
+
+	return mode;
+}
+
+static const struct attribute_group ptp_group = {
+	.is_visible	= ptp_is_attribute_visible,
+	.attrs		= ptp_attrs,
+};
+
+const struct attribute_group *ptp_groups[] = {
+	&ptp_group,
+	NULL
+};
 
 static int ptp_pin_name2index(struct ptp_clock *ptp, const char *name)
 {
@@ -235,26 +268,11 @@ static ssize_t ptp_pin_store(struct devi
 	return count;
 }
 
-static DEVICE_ATTR(extts_enable, 0220, NULL, extts_enable_store);
-static DEVICE_ATTR(fifo,         0444, extts_fifo_show, NULL);
-static DEVICE_ATTR(period,       0220, NULL, period_store);
-static DEVICE_ATTR(pps_enable,   0220, NULL, pps_enable_store);
-
 int ptp_cleanup_sysfs(struct ptp_clock *ptp)
 {
 	struct device *dev = ptp->dev;
 	struct ptp_clock_info *info = ptp->info;
 
-	if (info->n_ext_ts) {
-		device_remove_file(dev, &dev_attr_extts_enable);
-		device_remove_file(dev, &dev_attr_fifo);
-	}
-	if (info->n_per_out)
-		device_remove_file(dev, &dev_attr_period);
-
-	if (info->pps)
-		device_remove_file(dev, &dev_attr_pps_enable);
-
 	if (info->n_pins) {
 		sysfs_remove_group(&dev->kobj, &ptp->pin_attr_group);
 		kfree(ptp->pin_attr);
@@ -307,46 +325,13 @@ no_dev_attr:
 
 int ptp_populate_sysfs(struct ptp_clock *ptp)
 {
-	struct device *dev = ptp->dev;
 	struct ptp_clock_info *info = ptp->info;
 	int err;
 
-	if (info->n_ext_ts) {
-		err = device_create_file(dev, &dev_attr_extts_enable);
-		if (err)
-			goto out1;
-		err = device_create_file(dev, &dev_attr_fifo);
-		if (err)
-			goto out2;
-	}
-	if (info->n_per_out) {
-		err = device_create_file(dev, &dev_attr_period);
-		if (err)
-			goto out3;
-	}
-	if (info->pps) {
-		err = device_create_file(dev, &dev_attr_pps_enable);
-		if (err)
-			goto out4;
-	}
 	if (info->n_pins) {
 		err = ptp_populate_pins(ptp);
 		if (err)
-			goto out5;
+			return err;
 	}
 	return 0;
-out5:
-	if (info->pps)
-		device_remove_file(dev, &dev_attr_pps_enable);
-out4:
-	if (info->n_per_out)
-		device_remove_file(dev, &dev_attr_period);
-out3:
-	if (info->n_ext_ts)
-		device_remove_file(dev, &dev_attr_fifo);
-out2:
-	if (info->n_ext_ts)
-		device_remove_file(dev, &dev_attr_extts_enable);
-out1:
-	return err;
 }

