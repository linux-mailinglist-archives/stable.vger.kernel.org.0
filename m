Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B17B69CC9C
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjBTNmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjBTNmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:42:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1331D90B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18BFE60EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C35C433EF;
        Mon, 20 Feb 2023 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900513;
        bh=D57bgoOsk0RB7x5cJOrYZuqGu7jrLOW9ZDrWiP3l5dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DY8C/Fe009xwJNzjJ9EMA91knxmxuCBYO/i9qoVL0ZCK9LjiEIrRSwM9uyHITcGKn
         0qowSss+sYiWH+TPyAdia6YosEGswcrsj4g9319pp1cgZX52UnnxfXasHTOmXGTZSi
         HN0IuK93nvbOMN4phb/QNFAQ28I++5KMWCmqLHHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/89] thermal: intel: int340x: Protect trip temperature from concurrent updates
Date:   Mon, 20 Feb 2023 14:35:24 +0100
Message-Id: <20230220133554.047294527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 6757a7abe47bcb12cb2d45661067e182424b0ee3 ]

Trip temperatures are read using ACPI methods and stored in the memory
during zone initializtion and when the firmware sends a notification for
change. This trip temperature is returned when the thermal core calls via
callback get_trip_temp().

But it is possible that while updating the memory copy of the trips when
the firmware sends a notification for change, thermal core is reading the
trip temperature via the callback get_trip_temp(). This may return invalid
trip temperature.

To address this add a mutex to protect the invalid temperature reads in
the callback get_trip_temp() and int340x_thermal_read_trips().

Fixes: 5fbf7f27fa3d ("Thermal/int340x: Add common thermal zone handler")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.0+ <stable@vger.kernel.org> # 5.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../int340x_thermal/int340x_thermal_zone.c     | 18 +++++++++++++++---
 .../int340x_thermal/int340x_thermal_zone.h     |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/int340x_thermal/int340x_thermal_zone.c
index 9ec27ac1856b..d3829308560c 100644
--- a/drivers/thermal/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/int340x_thermal/int340x_thermal_zone.c
@@ -52,11 +52,13 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
 					 int trip, int *temp)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
 
 	if (d->override_ops && d->override_ops->get_trip_temp)
 		return d->override_ops->get_trip_temp(zone, trip, temp);
 
+	mutex_lock(&d->trip_mutex);
+
 	if (trip < d->aux_trip_nr)
 		*temp = d->aux_trips[trip];
 	else if (trip == d->crt_trip_id)
@@ -74,10 +76,12 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
 			}
 		}
 		if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&d->trip_mutex);
+
+	return ret;
 }
 
 static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
@@ -182,6 +186,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 	int trip_cnt = int34x_zone->aux_trip_nr;
 	int i;
 
+	mutex_lock(&int34x_zone->trip_mutex);
+
 	int34x_zone->crt_trip_id = -1;
 	if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
 					     &int34x_zone->crt_temp))
@@ -209,6 +215,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 		int34x_zone->act_trips[i].valid = true;
 	}
 
+	mutex_unlock(&int34x_zone->trip_mutex);
+
 	return trip_cnt;
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
@@ -232,6 +240,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	if (!int34x_thermal_zone)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&int34x_thermal_zone->trip_mutex);
+
 	int34x_thermal_zone->adev = adev;
 	int34x_thermal_zone->override_ops = override_ops;
 
@@ -274,6 +284,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
 err_trip_alloc:
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 	return ERR_PTR(ret);
 }
@@ -285,6 +296,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
 	thermal_zone_device_unregister(int34x_thermal_zone->zone);
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
diff --git a/drivers/thermal/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/int340x_thermal/int340x_thermal_zone.h
index 5f3ba4775c5c..e74648e330c7 100644
--- a/drivers/thermal/int340x_thermal/int340x_thermal_zone.h
+++ b/drivers/thermal/int340x_thermal/int340x_thermal_zone.h
@@ -41,6 +41,7 @@ struct int34x_thermal_zone {
 	struct thermal_zone_device_ops *override_ops;
 	void *priv_data;
 	struct acpi_lpat_conversion_table *lpat_table;
+	struct mutex trip_mutex;
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
-- 
2.39.0



