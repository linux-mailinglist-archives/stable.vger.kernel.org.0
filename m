Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9E337C894
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhELQKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:10:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:18008 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238593AbhELQFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:05:35 -0400
IronPort-SDR: Xiz4iL6aLPvRM93GV85//6CJLtqRRQRXnttSCHjpDISEH+iX0f2erhdPYimRCLIw3TcvwN2QKD
 UxEQOiD3ZIgQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="196648509"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="196648509"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 09:02:12 -0700
IronPort-SDR: R9o5pxGE8b+WnXMVLp2Iz9RSUdpLee3fsNWIlvW6U0/UD5MwpT8loUZxmJm6vXExDhozN4Za/r
 Q0lmLnIhFimQ==
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="462617131"
Received: from vkrish9-mobl.amr.corp.intel.com ([10.209.133.220])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 09:02:08 -0700
Message-ID: <4c562d23506b21a40e2558f21e95f841d557ec0a.camel@linux.intel.com>
Subject: Re: [PATCH] thermal: intel: Initialize RW trip to
 THERMAL_TEMP_INVALID
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, rui.zhang@intel.com,
        amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Wed, 12 May 2021 09:02:05 -0700
In-Reply-To: <62b8cdf7-29b1-d856-2686-34fdab5d485d@linaro.org>
References: <20210430122343.1789899-1-srinivas.pandruvada@linux.intel.com>
         <7dc2bb343052c6c8fbb60d38c2ce7dac708f568a.camel@linux.intel.com>
         <62b8cdf7-29b1-d856-2686-34fdab5d485d@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-05-12 at 17:54 +0200, Daniel Lezcano wrote:
> On 12/05/2021 17:52, Srinivas Pandruvada wrote:
> > On Fri, 2021-04-30 at 05:23 -0700, Srinivas Pandruvada wrote:
> > > After commit 81ad4276b505 ("Thermal: Ignore invalid trip points")
> > > all
> > > user_space governor notifications via RW trip point is broken in
> > > intel
> > > thermal drivers. This commits marks trip_points with value of 0
> > > during
> > > call to thermal_zone_device_register() as invalid. RW trip points
> > > can
> > > be
> > > 0 as user space will set the correct trip temperature later.
> > > 
> > > During driver init, x86_package_temp and all int340x drivers sets
> > > RW
> > > trip
> > > temperature as 0. This results in all these trips marked as
> > > invalid
> > > by
> > > the thermal core.
> > > 
> > > To fix this initialize RW trips to THERMAL_TEMP_INVALID instead
> > > of 0.
> > > 
> > Any chance that we can take care of this issue during 5.13-rc*?
> 
> Yes, I will take care of it

Thanks.

> 
> 
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Srinivas Pandruvada <
> > > srinivas.pandruvada@linux.intel.com>
> > > ---
> > >  drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c | 4
> > > ++++
> > >  drivers/thermal/intel/x86_pkg_temp_thermal.c                 | 2
> > > +-
> > >  2 files changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git
> > > a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > > b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > > index d1248ba943a4..62c0aa5d0783 100644
> > > ---
> > > a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > > +++
> > > b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > > @@ -237,6 +237,8 @@ struct int34x_thermal_zone
> > > *int340x_thermal_zone_add(struct acpi_device *adev,
> > >         if (ACPI_FAILURE(status))
> > >                 trip_cnt = 0;
> > >         else {
> > > +               int i;
> > > +
> > >                 int34x_thermal_zone->aux_trips =
> > >                         kcalloc(trip_cnt,
> > >                                 sizeof(*int34x_thermal_zone-
> > > > aux_trips),
> > > @@ -247,6 +249,8 @@ struct int34x_thermal_zone
> > > *int340x_thermal_zone_add(struct acpi_device *adev,
> > >                 }
> > >                 trip_mask = BIT(trip_cnt) - 1;
> > >                 int34x_thermal_zone->aux_trip_nr = trip_cnt;
> > > +               for (i = 0; i < trip_cnt; ++i)
> > > +                       int34x_thermal_zone->aux_trips[i] =
> > > THERMAL_TEMP_INVALID;
> > >         }
> > >  
> > >         trip_cnt =
> > > int340x_thermal_read_trips(int34x_thermal_zone);
> > > diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> > > b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> > > index 295742e83960..4d8edc61a78b 100644
> > > --- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> > > +++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> > > @@ -166,7 +166,7 @@ static int sys_get_trip_temp(struct
> > > thermal_zone_device *tzd,
> > >         if (thres_reg_value)
> > >                 *temp = zonedev->tj_max - thres_reg_value * 1000;
> > >         else
> > > -               *temp = 0;
> > > +               *temp = THERMAL_TEMP_INVALID;
> > >         pr_debug("sys_get_trip_temp %d\n", *temp);
> > >  
> > >         return 0;
> > 
> > 
> 
> 


