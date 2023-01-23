Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADC367830A
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjAWR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjAWR0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:26:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A156E2367C;
        Mon, 23 Jan 2023 09:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674494764; x=1706030764;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RP+wYCAJL0M0LJuF5F7wBJukpGj1LEvq6KdJ4YEAF1E=;
  b=ZwBBW6DepfSC4fkCo5HCfQpYH9DuJk0x5mkJbSz9WsWERG+7tmhHlIqq
   a1XEP4VVy1OYW+tKJQak79OlTlLQ6aVj1m6v61zIKHn2RNovpGRQ2/ef9
   MdwxcxjhOXb6U+GeQL0ukFX81kewobAZUXtxFmsVdSgYJDeavc2JMk6Y/
   XQ6Gc9xKC5Hb/LprV84lz3jXkvjlBTKXRqZzsl7s9MxUYZg/icS7BAEkR
   fXY9mPPBAxKKh6hD5Ky9rzkBJt+V6V+iRyi4fOjir95KmbTfeJTtg4B90
   lq0Q0kWZsrmd9aCD14A7H2RTA6nmeprNCt9gnDDCSMbeH5UNTfMFjimKw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="305757323"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="305757323"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 09:21:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="730355012"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="730355012"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jan 2023 09:21:11 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] thermal: int340x: Protect trip temperature from dynamic update
Date:   Mon, 23 Jan 2023 09:21:10 -0800
Message-Id: <20230123172110.376549-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # 5.0+
---
v2:
- rebased on linux-next
- Add ret variable and remove return as suugested by Rafael

 .../int340x_thermal/int340x_thermal_zone.c     | 18 +++++++++++++++---
 .../int340x_thermal/int340x_thermal_zone.h     |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 228f44260b27..5fda1e67b793 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -41,7 +41,9 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
 					 int trip, int *temp)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
+
+	mutex_lock(&d->trip_mutex);
 
 	if (trip < d->aux_trip_nr)
 		*temp = d->aux_trips[trip];
@@ -60,10 +62,12 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
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
@@ -165,6 +169,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 	int trip_cnt = int34x_zone->aux_trip_nr;
 	int i;
 
+	mutex_lock(&int34x_zone->trip_mutex);
+
 	int34x_zone->crt_trip_id = -1;
 	if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
 					     &int34x_zone->crt_temp))
@@ -192,6 +198,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 		int34x_zone->act_trips[i].valid = true;
 	}
 
+	mutex_unlock(&int34x_zone->trip_mutex);
+
 	return trip_cnt;
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
@@ -215,6 +223,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	if (!int34x_thermal_zone)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&int34x_thermal_zone->trip_mutex);
+
 	int34x_thermal_zone->adev = adev;
 
 	int34x_thermal_zone->ops = kmemdup(&int340x_thermal_zone_ops,
@@ -277,6 +287,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 err_trip_alloc:
 	kfree(int34x_thermal_zone->ops);
 err_ops_alloc:
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 	return ERR_PTR(ret);
 }
@@ -289,6 +300,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
 	kfree(int34x_thermal_zone->ops);
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
index e28ab1ba5e06..6610a9cc441b 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
@@ -32,6 +32,7 @@ struct int34x_thermal_zone {
 	struct thermal_zone_device_ops *ops;
 	void *priv_data;
 	struct acpi_lpat_conversion_table *lpat_table;
+	struct mutex trip_mutex;
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
-- 
2.31.1

