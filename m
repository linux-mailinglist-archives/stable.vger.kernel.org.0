Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B0837C73E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhELQAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:00:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:8129 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhELP4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:45 -0400
IronPort-SDR: QW+O0+UmWe7EUvfzAem4RwCY3ybkRc1Ve0ZJzC2aUyI6jxxPX2Ogt7GeJgMgmdN21xWw5MuJn+
 qlhG4c+4Wzag==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="197764649"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="197764649"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 08:53:06 -0700
IronPort-SDR: G4fgxFfKg4X+vyaysxA4vL4KHoW3hECwU6YfKJUNntDKfog/8zO1j7VboMTcV+naM8fz1f8ddi
 3U+L8IL3QT6A==
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="542112774"
Received: from vkrish9-mobl.amr.corp.intel.com ([10.209.133.220])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 08:53:03 -0700
Message-ID: <7dc2bb343052c6c8fbb60d38c2ce7dac708f568a.camel@linux.intel.com>
Subject: Re: [PATCH] thermal: intel: Initialize RW trip to
 THERMAL_TEMP_INVALID
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org, amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Wed, 12 May 2021 08:52:55 -0700
In-Reply-To: <20210430122343.1789899-1-srinivas.pandruvada@linux.intel.com>
References: <20210430122343.1789899-1-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-04-30 at 05:23 -0700, Srinivas Pandruvada wrote:
> After commit 81ad4276b505 ("Thermal: Ignore invalid trip points") all
> user_space governor notifications via RW trip point is broken in
> intel
> thermal drivers. This commits marks trip_points with value of 0
> during
> call to thermal_zone_device_register() as invalid. RW trip points can
> be
> 0 as user space will set the correct trip temperature later.
> 
> During driver init, x86_package_temp and all int340x drivers sets RW
> trip
> temperature as 0. This results in all these trips marked as invalid
> by
> the thermal core.
> 
> To fix this initialize RW trips to THERMAL_TEMP_INVALID instead of 0.
> 
Any chance that we can take care of this issue during 5.13-rc*?

Thanks,
Srinivas

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Srinivas Pandruvada <
> srinivas.pandruvada@linux.intel.com>
> ---
>  drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c | 4
> ++++
>  drivers/thermal/intel/x86_pkg_temp_thermal.c                 | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git
> a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> index d1248ba943a4..62c0aa5d0783 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> @@ -237,6 +237,8 @@ struct int34x_thermal_zone
> *int340x_thermal_zone_add(struct acpi_device *adev,
>         if (ACPI_FAILURE(status))
>                 trip_cnt = 0;
>         else {
> +               int i;
> +
>                 int34x_thermal_zone->aux_trips =
>                         kcalloc(trip_cnt,
>                                 sizeof(*int34x_thermal_zone-
> >aux_trips),
> @@ -247,6 +249,8 @@ struct int34x_thermal_zone
> *int340x_thermal_zone_add(struct acpi_device *adev,
>                 }
>                 trip_mask = BIT(trip_cnt) - 1;
>                 int34x_thermal_zone->aux_trip_nr = trip_cnt;
> +               for (i = 0; i < trip_cnt; ++i)
> +                       int34x_thermal_zone->aux_trips[i] =
> THERMAL_TEMP_INVALID;
>         }
>  
>         trip_cnt = int340x_thermal_read_trips(int34x_thermal_zone);
> diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> index 295742e83960..4d8edc61a78b 100644
> --- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> +++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> @@ -166,7 +166,7 @@ static int sys_get_trip_temp(struct
> thermal_zone_device *tzd,
>         if (thres_reg_value)
>                 *temp = zonedev->tj_max - thres_reg_value * 1000;
>         else
> -               *temp = 0;
> +               *temp = THERMAL_TEMP_INVALID;
>         pr_debug("sys_get_trip_temp %d\n", *temp);
>  
>         return 0;


