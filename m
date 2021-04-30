Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A5536FA14
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 14:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhD3MYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 08:24:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:8762 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhD3MYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 08:24:32 -0400
IronPort-SDR: sMStc3CHza2hDduuknvnihVLueHRu9AVHQp430LuvbjZr//noETXJI2p+KgSftIVvxelJHEQSO
 2ycjWTj1k/tA==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="282607011"
X-IronPort-AV: E=Sophos;i="5.82,262,1613462400"; 
   d="scan'208";a="282607011"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 05:23:44 -0700
IronPort-SDR: W0vlkEqTU7tW+kredQ0XYgjCZzgujRu4VFGPrrknI3iUx2t/nCaFJj0vZEtMxBdLF8EvEUCilT
 gaYfSCxK01PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,262,1613462400"; 
   d="scan'208";a="466796415"
Received: from spandruv-desk.jf.intel.com ([10.54.75.21])
  by orsmga001.jf.intel.com with ESMTP; 30 Apr 2021 05:23:44 -0700
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org, amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] thermal: intel: Initialize RW trip to THERMAL_TEMP_INVALID
Date:   Fri, 30 Apr 2021 05:23:43 -0700
Message-Id: <20210430122343.1789899-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 81ad4276b505 ("Thermal: Ignore invalid trip points") all
user_space governor notifications via RW trip point is broken in intel
thermal drivers. This commits marks trip_points with value of 0 during
call to thermal_zone_device_register() as invalid. RW trip points can be
0 as user space will set the correct trip temperature later.

During driver init, x86_package_temp and all int340x drivers sets RW trip
temperature as 0. This results in all these trips marked as invalid by
the thermal core.

To fix this initialize RW trips to THERMAL_TEMP_INVALID instead of 0.

Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c | 4 ++++
 drivers/thermal/intel/x86_pkg_temp_thermal.c                 | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index d1248ba943a4..62c0aa5d0783 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -237,6 +237,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	if (ACPI_FAILURE(status))
 		trip_cnt = 0;
 	else {
+		int i;
+
 		int34x_thermal_zone->aux_trips =
 			kcalloc(trip_cnt,
 				sizeof(*int34x_thermal_zone->aux_trips),
@@ -247,6 +249,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 		}
 		trip_mask = BIT(trip_cnt) - 1;
 		int34x_thermal_zone->aux_trip_nr = trip_cnt;
+		for (i = 0; i < trip_cnt; ++i)
+			int34x_thermal_zone->aux_trips[i] = THERMAL_TEMP_INVALID;
 	}
 
 	trip_cnt = int340x_thermal_read_trips(int34x_thermal_zone);
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 295742e83960..4d8edc61a78b 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -166,7 +166,7 @@ static int sys_get_trip_temp(struct thermal_zone_device *tzd,
 	if (thres_reg_value)
 		*temp = zonedev->tj_max - thres_reg_value * 1000;
 	else
-		*temp = 0;
+		*temp = THERMAL_TEMP_INVALID;
 	pr_debug("sys_get_trip_temp %d\n", *temp);
 
 	return 0;
-- 
2.25.1

