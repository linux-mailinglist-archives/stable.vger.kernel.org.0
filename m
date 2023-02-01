Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A079D68117E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbjA3OOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237346AbjA3ONw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F3B471
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF5FB80E60
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AEBC433D2;
        Mon, 30 Jan 2023 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088027;
        bh=PDVTx4jceWOZnxKWvaeZ3IaN78suRgzhptgX91rKzYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDWToM+rSBcF7b/Wv/OhYgEIn3ijh+d66ksN3aGc3RSfyb9MAaMkyCh0BgdfNOaEh
         y5O2HFmQeF+QdTkvQGWaADhJknjp7uC5oaYRYT0qP3pq6OSIAaQUmFtCmiKNYiRlpX
         D1Tv/qQYvKiXLAoHRSF6L46E8HTXazX5tFf1Q/50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexandre Bailon <abailon@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linexp.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/204] thermal/core: Rename trips to num_trips
Date:   Mon, 30 Jan 2023 14:50:55 +0100
Message-Id: <20230130134320.301263762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linexp.org>

[ Upstream commit e5bfcd30f88fdb0ce830229e7ccdeddcb7a59b04 ]

In order to use thermal trips defined in the thermal structure, rename
the 'trips' field to 'num_trips' to have the 'trips' field containing the
thermal trip points.

Cc: Alexandre Bailon <abailon@baylibre.com>
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linexp.org>
Link: https://lore.kernel.org/r/20220722200007.1839356-8-daniel.lezcano@linexp.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: 6c54b7bc8a31 ("thermal: core: call put_device() only after device_register() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_fair_share.c        |  6 +++---
 drivers/thermal/gov_power_allocator.c   |  4 ++--
 drivers/thermal/tegra/tegra30-tsensor.c |  2 +-
 drivers/thermal/thermal_core.c          | 20 ++++++++++----------
 drivers/thermal/thermal_helpers.c       |  4 ++--
 drivers/thermal/thermal_netlink.c       |  2 +-
 drivers/thermal/thermal_sysfs.c         | 22 +++++++++++-----------
 include/linux/thermal.h                 |  4 ++--
 8 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/thermal/gov_fair_share.c b/drivers/thermal/gov_fair_share.c
index 1e5abf4822be..6a2abcfc648f 100644
--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -25,10 +25,10 @@ static int get_trip_level(struct thermal_zone_device *tz)
 	int trip_temp;
 	enum thermal_trip_type trip_type;
 
-	if (tz->trips == 0 || !tz->ops->get_trip_temp)
+	if (tz->num_trips == 0 || !tz->ops->get_trip_temp)
 		return 0;
 
-	for (count = 0; count < tz->trips; count++) {
+	for (count = 0; count < tz->num_trips; count++) {
 		tz->ops->get_trip_temp(tz, count, &trip_temp);
 		if (tz->temperature < trip_temp)
 			break;
@@ -53,7 +53,7 @@ static long get_target_state(struct thermal_zone_device *tz,
 
 	cdev->ops->get_max_state(cdev, &max_state);
 
-	return (long)(percentage * level * max_state) / (100 * tz->trips);
+	return (long)(percentage * level * max_state) / (100 * tz->num_trips);
 }
 
 /**
diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 13e375751d22..1d5052470967 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -527,7 +527,7 @@ static void get_governor_trips(struct thermal_zone_device *tz,
 	last_active = INVALID_TRIP;
 	last_passive = INVALID_TRIP;
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 		enum thermal_trip_type type;
 		int ret;
 
@@ -668,7 +668,7 @@ static int power_allocator_bind(struct thermal_zone_device *tz)
 
 	get_governor_trips(tz, params);
 
-	if (tz->trips > 0) {
+	if (tz->num_trips > 0) {
 		ret = tz->ops->get_trip_temp(tz,
 					params->trip_max_desired_temperature,
 					&control_temp);
diff --git a/drivers/thermal/tegra/tegra30-tsensor.c b/drivers/thermal/tegra/tegra30-tsensor.c
index 9b6b693cbcf8..05886684f429 100644
--- a/drivers/thermal/tegra/tegra30-tsensor.c
+++ b/drivers/thermal/tegra/tegra30-tsensor.c
@@ -316,7 +316,7 @@ static void tegra_tsensor_get_hw_channel_trips(struct thermal_zone_device *tzd,
 	*hot_trip  = 85000;
 	*crit_trip = 90000;
 
-	for (i = 0; i < tzd->trips; i++) {
+	for (i = 0; i < tzd->num_trips; i++) {
 		enum thermal_trip_type type;
 		int trip_temp;
 
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9ec7a8e04fa6..c6b7eaffceda 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -503,7 +503,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
 
 	tz->notify_event = event;
 
-	for (count = 0; count < tz->trips; count++)
+	for (count = 0; count < tz->num_trips; count++)
 		handle_thermal_trip(tz, count);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_update);
@@ -628,7 +628,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	unsigned long max_state;
 	int result, ret;
 
-	if (trip >= tz->trips || trip < 0)
+	if (trip >= tz->num_trips || trip < 0)
 		return -EINVAL;
 
 	list_for_each_entry(pos1, &thermal_tz_list, node) {
@@ -809,7 +809,7 @@ static void __bind(struct thermal_zone_device *tz, int mask,
 {
 	int i, ret;
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 		if (mask & (1 << i)) {
 			unsigned long upper, lower;
 
@@ -1056,7 +1056,7 @@ static void __unbind(struct thermal_zone_device *tz, int mask,
 {
 	int i;
 
-	for (i = 0; i < tz->trips; i++)
+	for (i = 0; i < tz->num_trips; i++)
 		if (mask & (1 << i))
 			thermal_zone_unbind_cooling_device(tz, i, cdev);
 }
@@ -1161,7 +1161,7 @@ static void bind_tz(struct thermal_zone_device *tz)
 /**
  * thermal_zone_device_register() - register a new thermal zone device
  * @type:	the thermal zone device type
- * @trips:	the number of trip points the thermal zone support
+ * @num_trips:	the number of trip points the thermal zone support
  * @mask:	a bit string indicating the writeablility of trip points
  * @devdata:	private device data
  * @ops:	standard thermal zone device callbacks
@@ -1183,7 +1183,7 @@ static void bind_tz(struct thermal_zone_device *tz)
  * IS_ERR*() helpers.
  */
 struct thermal_zone_device *
-thermal_zone_device_register(const char *type, int trips, int mask,
+thermal_zone_device_register(const char *type, int num_trips, int mask,
 			     void *devdata, struct thermal_zone_device_ops *ops,
 			     struct thermal_zone_params *tzp, int passive_delay,
 			     int polling_delay)
@@ -1207,7 +1207,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (trips > THERMAL_MAX_TRIPS || trips < 0 || mask >> trips) {
+	if (num_trips > THERMAL_MAX_TRIPS || num_trips < 0 || mask >> num_trips) {
 		pr_err("Incorrect number of thermal trips\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -1217,7 +1217,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (trips > 0 && (!ops->get_trip_type || !ops->get_trip_temp))
+	if (num_trips > 0 && (!ops->get_trip_type || !ops->get_trip_temp))
 		return ERR_PTR(-EINVAL);
 
 	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
@@ -1243,7 +1243,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	tz->tzp = tzp;
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
-	tz->trips = trips;
+	tz->num_trips = num_trips;
 
 	thermal_set_delay_jiffies(&tz->passive_delay_jiffies, passive_delay);
 	thermal_set_delay_jiffies(&tz->polling_delay_jiffies, polling_delay);
@@ -1266,7 +1266,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	if (result)
 		goto release_device;
 
-	for (count = 0; count < trips; count++) {
+	for (count = 0; count < num_trips; count++) {
 		if (tz->ops->get_trip_type(tz, count, &trip_type) ||
 		    tz->ops->get_trip_temp(tz, count, &trip_temp) ||
 		    !trip_temp)
diff --git a/drivers/thermal/thermal_helpers.c b/drivers/thermal/thermal_helpers.c
index 3edd047e144f..ee7027bdcafa 100644
--- a/drivers/thermal/thermal_helpers.c
+++ b/drivers/thermal/thermal_helpers.c
@@ -90,7 +90,7 @@ int thermal_zone_get_temp(struct thermal_zone_device *tz, int *temp)
 	ret = tz->ops->get_temp(tz, temp);
 
 	if (IS_ENABLED(CONFIG_THERMAL_EMULATION) && tz->emul_temperature) {
-		for (count = 0; count < tz->trips; count++) {
+		for (count = 0; count < tz->num_trips; count++) {
 			ret = tz->ops->get_trip_type(tz, count, &type);
 			if (!ret && type == THERMAL_TRIP_CRITICAL) {
 				ret = tz->ops->get_trip_temp(tz, count,
@@ -138,7 +138,7 @@ void thermal_zone_set_trips(struct thermal_zone_device *tz)
 	if (!tz->ops->set_trips || !tz->ops->get_trip_hyst)
 		goto exit;
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 		int trip_low;
 
 		tz->ops->get_trip_temp(tz, i, &trip_temp);
diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index 41c8d47805c4..c70d407c2c71 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -415,7 +415,7 @@ static int thermal_genl_cmd_tz_get_trip(struct param *p)
 
 	mutex_lock(&tz->lock);
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 
 		enum thermal_trip_type type;
 		int temp, hyst = 0;
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 1e5a78131aba..3a8d6e747c25 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -416,15 +416,15 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 	int indx;
 
 	/* This function works only for zones with at least one trip */
-	if (tz->trips <= 0)
+	if (tz->num_trips <= 0)
 		return -EINVAL;
 
-	tz->trip_type_attrs = kcalloc(tz->trips, sizeof(*tz->trip_type_attrs),
+	tz->trip_type_attrs = kcalloc(tz->num_trips, sizeof(*tz->trip_type_attrs),
 				      GFP_KERNEL);
 	if (!tz->trip_type_attrs)
 		return -ENOMEM;
 
-	tz->trip_temp_attrs = kcalloc(tz->trips, sizeof(*tz->trip_temp_attrs),
+	tz->trip_temp_attrs = kcalloc(tz->num_trips, sizeof(*tz->trip_temp_attrs),
 				      GFP_KERNEL);
 	if (!tz->trip_temp_attrs) {
 		kfree(tz->trip_type_attrs);
@@ -432,7 +432,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 	}
 
 	if (tz->ops->get_trip_hyst) {
-		tz->trip_hyst_attrs = kcalloc(tz->trips,
+		tz->trip_hyst_attrs = kcalloc(tz->num_trips,
 					      sizeof(*tz->trip_hyst_attrs),
 					      GFP_KERNEL);
 		if (!tz->trip_hyst_attrs) {
@@ -442,7 +442,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 		}
 	}
 
-	attrs = kcalloc(tz->trips * 3 + 1, sizeof(*attrs), GFP_KERNEL);
+	attrs = kcalloc(tz->num_trips * 3 + 1, sizeof(*attrs), GFP_KERNEL);
 	if (!attrs) {
 		kfree(tz->trip_type_attrs);
 		kfree(tz->trip_temp_attrs);
@@ -451,7 +451,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 		return -ENOMEM;
 	}
 
-	for (indx = 0; indx < tz->trips; indx++) {
+	for (indx = 0; indx < tz->num_trips; indx++) {
 		/* create trip type attribute */
 		snprintf(tz->trip_type_attrs[indx].name, THERMAL_NAME_LENGTH,
 			 "trip_point_%d_type", indx);
@@ -478,7 +478,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 			tz->trip_temp_attrs[indx].attr.store =
 							trip_point_temp_store;
 		}
-		attrs[indx + tz->trips] = &tz->trip_temp_attrs[indx].attr.attr;
+		attrs[indx + tz->num_trips] = &tz->trip_temp_attrs[indx].attr.attr;
 
 		/* create Optional trip hyst attribute */
 		if (!tz->ops->get_trip_hyst)
@@ -496,10 +496,10 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 			tz->trip_hyst_attrs[indx].attr.store =
 					trip_point_hyst_store;
 		}
-		attrs[indx + tz->trips * 2] =
+		attrs[indx + tz->num_trips * 2] =
 					&tz->trip_hyst_attrs[indx].attr.attr;
 	}
-	attrs[tz->trips * 3] = NULL;
+	attrs[tz->num_trips * 3] = NULL;
 
 	tz->trips_attribute_group.attrs = attrs;
 
@@ -540,7 +540,7 @@ int thermal_zone_create_device_groups(struct thermal_zone_device *tz,
 	for (i = 0; i < size - 2; i++)
 		groups[i] = thermal_zone_attribute_groups[i];
 
-	if (tz->trips) {
+	if (tz->num_trips) {
 		result = create_trip_attrs(tz, mask);
 		if (result) {
 			kfree(groups);
@@ -561,7 +561,7 @@ void thermal_zone_destroy_device_groups(struct thermal_zone_device *tz)
 	if (!tz)
 		return;
 
-	if (tz->trips)
+	if (tz->num_trips)
 		destroy_trip_attrs(tz);
 
 	kfree(tz->device.groups);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index c314893970b3..67f121914020 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -113,7 +113,7 @@ struct thermal_cooling_device {
  * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
  * @mode:		current mode of this thermal zone
  * @devdata:	private pointer for device private data
- * @trips:	number of trip points the thermal zone supports
+ * @num_trips:	number of trip points the thermal zone supports
  * @trips_disabled;	bitmap for disabled trips
  * @passive_delay_jiffies: number of jiffies to wait between polls when
  *			performing passive cooling.
@@ -153,7 +153,7 @@ struct thermal_zone_device {
 	struct thermal_attr *trip_hyst_attrs;
 	enum thermal_device_mode mode;
 	void *devdata;
-	int trips;
+	int num_trips;
 	unsigned long trips_disabled;	/* bitmap for disabled trips */
 	unsigned long passive_delay_jiffies;
 	unsigned long polling_delay_jiffies;
-- 
2.39.0



