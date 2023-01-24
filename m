Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E862A67A495
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjAXVIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXVIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:08:16 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE473F286;
        Tue, 24 Jan 2023 13:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674594495; x=1706130495;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bic6hppxNnebo+xUPCxa4lLCVlJSELtjBqOLv8adWFk=;
  b=FaOr92r7Mh3Bv3pJueLMIRvL92o71vQ+6xM+h50snukCeYseJvqFBcXD
   z4GBBZs6Qd7pbcmu0WufHmzB/4SD+1Lq3TSlzauKrzWnPU3QKIgeA2lsf
   9RZtcKPjkKWrKu02FRxVZuLi+C0zMTfOghXUoCbBq+38sT1nOlyTigHlN
   VynFUZFSupTRsvpM1B1nhn9frK6YziW4yJkKp4NAF039lbUJNhU9B3b0J
   oa8DaQCoHSTSgeyw9K15uNgJuAThj+Km9Eb4GUAX5VbTu/SnhmTBxXend
   lI8A+VunZunDBHhFqXUeUgZm+NlLC3S60NdB+XEsoE6b8W98lfT87SuGt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="328491570"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="328491570"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 13:08:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="639705037"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="639705037"
Received: from kabbas-mobl.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.252.131.133])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 13:08:14 -0800
Message-ID: <d93ad3c0717f17e3a6fd065fe35edb2c5820cb82.camel@linux.intel.com>
Subject: Re: [PATCH v2] thermal: int340x: Protect trip temperature from
 dynamic update
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 24 Jan 2023 13:08:14 -0800
In-Reply-To: <CAJZ5v0hBy2Jgezhuamz+++_EVfrO2gyuaC8vXvRMHvE5MjxtXw@mail.gmail.com>
References: <20230123172110.376549-1-srinivas.pandruvada@linux.intel.com>
         <CAJZ5v0hBy2Jgezhuamz+++_EVfrO2gyuaC8vXvRMHvE5MjxtXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-01-24 at 21:32 +0100, Rafael J. Wysocki wrote:
> On Mon, Jan 23, 2023 at 6:26 PM Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
> > 
> > Trip temperatures are read using ACPI methods and stored in the
> > memory
> > during zone initializtion and when the firmware sends a
> > notification for
> > change. This trip temperature is returned when the thermal core
> > calls via
> > callback get_trip_temp().
> > 
> > But it is possible that while updating the memory copy of the trips
> > when
> > the firmware sends a notification for change, thermal core is
> > reading the
> > trip temperature via the callback get_trip_temp(). This may return
> > invalid
> > trip temperature.
> > 
> > To address this add a mutex to protect the invalid temperature
> > reads in
> > the callback get_trip_temp() and int340x_thermal_read_trips().
> > 
> > Signed-off-by: Srinivas Pandruvada
> > <srinivas.pandruvada@linux.intel.com>
> > Cc: stable@vger.kernel.org # 5.0+
> > ---
> > v2:
> > - rebased on linux-next
> 
> So I've rebased it back onto 6.2-rc5 and pushed the result into the
> thermal-intel-fixes branch.  Please see if it looks good to you and
> let me know.
Looks good.

Thanks,
Srinivas

> 
> I'd prefer to push it for 6.2-rc.
> 
> > - Add ret variable and remove return as suugested by Rafael
> 
> Thanks!
> 
> >  .../int340x_thermal/int340x_thermal_zone.c     | 18
> > +++++++++++++++---
> >  .../int340x_thermal/int340x_thermal_zone.h     |  1 +
> >  2 files changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git
> > a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > index 228f44260b27..5fda1e67b793 100644
> > --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> > @@ -41,7 +41,9 @@ static int int340x_thermal_get_trip_temp(struct
> > thermal_zone_device *zone,
> >                                          int trip, int *temp)
> >  {
> >         struct int34x_thermal_zone *d = zone->devdata;
> > -       int i;
> > +       int i, ret = 0;
> > +
> > +       mutex_lock(&d->trip_mutex);
> > 
> >         if (trip < d->aux_trip_nr)
> >                 *temp = d->aux_trips[trip];
> > @@ -60,10 +62,12 @@ static int int340x_thermal_get_trip_temp(struct
> > thermal_zone_device *zone,
> >                         }
> >                 }
> >                 if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
> > -                       return -EINVAL;
> > +                       ret = -EINVAL;
> >         }
> > 
> > -       return 0;
> > +       mutex_unlock(&d->trip_mutex);
> > +
> > +       return ret;
> >  }
> > 
> >  static int int340x_thermal_get_trip_type(struct
> > thermal_zone_device *zone,
> > @@ -165,6 +169,8 @@ int int340x_thermal_read_trips(struct
> > int34x_thermal_zone *int34x_zone)
> >         int trip_cnt = int34x_zone->aux_trip_nr;
> >         int i;
> > 
> > +       mutex_lock(&int34x_zone->trip_mutex);
> > +
> >         int34x_zone->crt_trip_id = -1;
> >         if (!int340x_thermal_get_trip_config(int34x_zone->adev-
> > >handle, "_CRT",
> >                                              &int34x_zone-
> > >crt_temp))
> > @@ -192,6 +198,8 @@ int int340x_thermal_read_trips(struct
> > int34x_thermal_zone *int34x_zone)
> >                 int34x_zone->act_trips[i].valid = true;
> >         }
> > 
> > +       mutex_unlock(&int34x_zone->trip_mutex);
> > +
> >         return trip_cnt;
> >  }
> >  EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
> > @@ -215,6 +223,8 @@ struct int34x_thermal_zone
> > *int340x_thermal_zone_add(struct acpi_device *adev,
> >         if (!int34x_thermal_zone)
> >                 return ERR_PTR(-ENOMEM);
> > 
> > +       mutex_init(&int34x_thermal_zone->trip_mutex);
> > +
> >         int34x_thermal_zone->adev = adev;
> > 
> >         int34x_thermal_zone->ops =
> > kmemdup(&int340x_thermal_zone_ops,
> > @@ -277,6 +287,7 @@ struct int34x_thermal_zone
> > *int340x_thermal_zone_add(struct acpi_device *adev,
> >  err_trip_alloc:
> >         kfree(int34x_thermal_zone->ops);
> >  err_ops_alloc:
> > +       mutex_destroy(&int34x_thermal_zone->trip_mutex);
> >         kfree(int34x_thermal_zone);
> >         return ERR_PTR(ret);
> >  }
> > @@ -289,6 +300,7 @@ void int340x_thermal_zone_remove(struct
> > int34x_thermal_zone
> >         acpi_lpat_free_conversion_table(int34x_thermal_zone-
> > >lpat_table);
> >         kfree(int34x_thermal_zone->aux_trips);
> >         kfree(int34x_thermal_zone->ops);
> > +       mutex_destroy(&int34x_thermal_zone->trip_mutex);
> >         kfree(int34x_thermal_zone);
> >  }
> >  EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
> > diff --git
> > a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> > b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> > index e28ab1ba5e06..6610a9cc441b 100644
> > --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> > +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> > @@ -32,6 +32,7 @@ struct int34x_thermal_zone {
> >         struct thermal_zone_device_ops *ops;
> >         void *priv_data;
> >         struct acpi_lpat_conversion_table *lpat_table;
> > +       struct mutex trip_mutex;
> >  };
> > 
> >  struct int34x_thermal_zone *int340x_thermal_zone_add(struct
> > acpi_device *,
> > --
> > 2.31.1
> > 

