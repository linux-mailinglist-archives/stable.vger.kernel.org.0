Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFB53961C3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhEaOp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233652AbhEaOnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F9E161C72;
        Mon, 31 May 2021 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469276;
        bh=CKHgblGGySsSRCukiqodNq/GwCeFxKa9pKvXZLtX0z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXSmcqkiHPdYc3eOoXgZRsVPgR7kP49mF6y/9mvY33WbCrTDkVLfk0lWlyE8gDhXu
         jbA9glHe0hDCRG5NgBhXCIvEOJRUcvTnQ76DolWztWHK0OTgFjp+PFHI6jAB3B+Uc0
         /brSkQDhx4vsWPvTvfSdtV7MtGkvHJLSyNOYDj44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.12 102/296] thermal/drivers/intel: Initialize RW trip to THERMAL_TEMP_INVALID
Date:   Mon, 31 May 2021 15:12:37 +0200
Message-Id: <20210531130707.359084386@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit eb8500b874cf295971a6a2a04e14eb0854197a3c upstream.

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
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210430122343.1789899-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c |    4 ++++
 drivers/thermal/intel/x86_pkg_temp_thermal.c                 |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -237,6 +237,8 @@ struct int34x_thermal_zone *int340x_ther
 	if (ACPI_FAILURE(status))
 		trip_cnt = 0;
 	else {
+		int i;
+
 		int34x_thermal_zone->aux_trips =
 			kcalloc(trip_cnt,
 				sizeof(*int34x_thermal_zone->aux_trips),
@@ -247,6 +249,8 @@ struct int34x_thermal_zone *int340x_ther
 		}
 		trip_mask = BIT(trip_cnt) - 1;
 		int34x_thermal_zone->aux_trip_nr = trip_cnt;
+		for (i = 0; i < trip_cnt; ++i)
+			int34x_thermal_zone->aux_trips[i] = THERMAL_TEMP_INVALID;
 	}
 
 	trip_cnt = int340x_thermal_read_trips(int34x_thermal_zone);
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -166,7 +166,7 @@ static int sys_get_trip_temp(struct ther
 	if (thres_reg_value)
 		*temp = zonedev->tj_max - thres_reg_value * 1000;
 	else
-		*temp = 0;
+		*temp = THERMAL_TEMP_INVALID;
 	pr_debug("sys_get_trip_temp %d\n", *temp);
 
 	return 0;


