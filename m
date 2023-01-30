Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E59168103F
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbjA3OCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbjA3OBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24E227987
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 826ACB81178
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD48DC433D2;
        Mon, 30 Jan 2023 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087270;
        bh=+UCMugQgBL6AvBb/1w2McZlh1/XB+vbYdHDXmC+la9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00sDb7XsB7oI1ZHRFPivaPW3tu00psN+VntmEOspgV5FPrDjnQ0n20mqwfuBKAdQf
         Q552MGkUNn34IoKDIkxfeTFkny9IwpOymCq+TyK9MfBSxkXkURtmWPsaKi6IVTJr7V
         uydZmREi9T210coXUj7wYksrI9v+zRx5WXHhOsGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/313] thermal: Validate new state in cur_state_store()
Date:   Mon, 30 Jan 2023 14:49:30 +0100
Message-Id: <20230130134342.948036597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit c408b3d1d9bbc7de5fb0304fea424ef2539da616 ]

In cur_state_store(), the new state of the cooling device is received
from user-space and is not validated by the thermal core but the same is
left for the individual drivers to take care of. Apart from duplicating
the code it leaves possibility for introducing bugs where a driver may
not do it right.

Lets make the thermal core check the new state itself and store the max
value in the cooling device structure.

Link: https://lore.kernel.org/all/Y0ltRJRjO7AkawvE@kili/
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 6c54b7bc8a31 ("thermal: core: call put_device() only after device_register() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_fair_share.c |  6 +-----
 drivers/thermal/thermal_core.c   | 15 +++++++--------
 drivers/thermal/thermal_sysfs.c  | 11 +++++------
 include/linux/thermal.h          |  1 +
 4 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/thermal/gov_fair_share.c b/drivers/thermal/gov_fair_share.c
index a4ee4661e9cc..1cfeac16e7ac 100644
--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -49,11 +49,7 @@ static int get_trip_level(struct thermal_zone_device *tz)
 static long get_target_state(struct thermal_zone_device *tz,
 		struct thermal_cooling_device *cdev, int percentage, int level)
 {
-	unsigned long max_state;
-
-	cdev->ops->get_max_state(cdev, &max_state);
-
-	return (long)(percentage * level * max_state) / (100 * tz->num_trips);
+	return (long)(percentage * level * cdev->max_state) / (100 * tz->num_trips);
 }
 
 /**
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 615fdda3a5de..328da2f1d339 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -603,8 +603,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
-	unsigned long max_state;
-	int result, ret;
+	int result;
 
 	if (trip >= tz->num_trips || trip < 0)
 		return -EINVAL;
@@ -621,15 +620,11 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	if (tz != pos1 || cdev != pos2)
 		return -EINVAL;
 
-	ret = cdev->ops->get_max_state(cdev, &max_state);
-	if (ret)
-		return ret;
-
 	/* lower default 0, upper default max_state */
 	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
-	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
+	upper = upper == THERMAL_NO_LIMIT ? cdev->max_state : upper;
 
-	if (lower > upper || upper > max_state)
+	if (lower > upper || upper > cdev->max_state)
 		return -EINVAL;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -896,6 +891,10 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->updated = false;
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
+
+	if (cdev->ops->get_max_state(cdev, &cdev->max_state))
+		goto out_kfree_type;
+
 	thermal_cooling_device_setup_sysfs(cdev);
 	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	if (ret) {
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index ec495c7dff03..bd7596125461 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -589,13 +589,8 @@ static ssize_t max_state_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct thermal_cooling_device *cdev = to_cooling_device(dev);
-	unsigned long state;
-	int ret;
 
-	ret = cdev->ops->get_max_state(cdev, &state);
-	if (ret)
-		return ret;
-	return sprintf(buf, "%ld\n", state);
+	return sprintf(buf, "%ld\n", cdev->max_state);
 }
 
 static ssize_t cur_state_show(struct device *dev, struct device_attribute *attr,
@@ -625,6 +620,10 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
 	if ((long)state < 0)
 		return -EINVAL;
 
+	/* Requested state should be less than max_state + 1 */
+	if (state > cdev->max_state)
+		return -EINVAL;
+
 	mutex_lock(&cdev->lock);
 
 	result = cdev->ops->set_cur_state(cdev, state);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 9ecc128944a1..5e093602e8fc 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -100,6 +100,7 @@ struct thermal_cooling_device_ops {
 struct thermal_cooling_device {
 	int id;
 	char *type;
+	unsigned long max_state;
 	struct device device;
 	struct device_node *np;
 	void *devdata;
-- 
2.39.0



