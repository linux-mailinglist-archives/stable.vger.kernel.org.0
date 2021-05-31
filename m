Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A30396020
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhEaOXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232842AbhEaORd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A968619B2;
        Mon, 31 May 2021 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468616;
        bh=RzFbbpwa7Yp8R+q5O798s43vbcoxm8pztewk0n6GN6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/WjIszXHjFuWJgwusOirBnREICJweMOjQ99V7vx4Fc6WDMcvGIV9uyGTwLp5H1cA
         J8gRym7ZMNb/sjWWceCtCyuJf4lSNK6y4V0mY9hJbkknzu5Kxz/eniTYoCkZ6eiHEz
         NCdv4GzPirJ2tD+Xazad6V88XG2G47Q7Uk0q239Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 060/177] thermal/drivers/intel: Initialize RW trip to THERMAL_TEMP_INVALID
Date:   Mon, 31 May 2021 15:13:37 +0200
Message-Id: <20210531130649.984180458@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
@@ -230,6 +230,8 @@ struct int34x_thermal_zone *int340x_ther
 	if (ACPI_FAILURE(status))
 		trip_cnt = 0;
 	else {
+		int i;
+
 		int34x_thermal_zone->aux_trips =
 			kcalloc(trip_cnt,
 				sizeof(*int34x_thermal_zone->aux_trips),
@@ -240,6 +242,8 @@ struct int34x_thermal_zone *int340x_ther
 		}
 		trip_mask = BIT(trip_cnt) - 1;
 		int34x_thermal_zone->aux_trip_nr = trip_cnt;
+		for (i = 0; i < trip_cnt; ++i)
+			int34x_thermal_zone->aux_trips[i] = THERMAL_TEMP_INVALID;
 	}
 
 	trip_cnt = int340x_thermal_read_trips(int34x_thermal_zone);
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -164,7 +164,7 @@ static int sys_get_trip_temp(struct ther
 	if (thres_reg_value)
 		*temp = zonedev->tj_max - thres_reg_value * 1000;
 	else
-		*temp = 0;
+		*temp = THERMAL_TEMP_INVALID;
 	pr_debug("sys_get_trip_temp %d\n", *temp);
 
 	return 0;


