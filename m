Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1444167A3F8
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 21:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjAXUdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 15:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjAXUdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 15:33:07 -0500
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5932346A5;
        Tue, 24 Jan 2023 12:33:02 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id w11so4316171edv.0;
        Tue, 24 Jan 2023 12:33:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hLMuamyiEkVxFlo4bpu/j50H3Gmc39mnq5ps46HJInM=;
        b=B7Uf301KQdUEU4wLXYWeo5Xt/tHFq/mYNwm8GQ7en0DSI5/MUUiytmvGUlVfGzMFpN
         FYHZWvlvt5pNHy9+FhlcXHyn7Y0lYBGZbL7zasVE78Dbg52QO7aaaXf+CSP1g0jUYOcy
         lh7Lq0XJ+Ak+gLi91cn9329gdcn4qqoOemxMO/CZumzFHq3jP0SB/8lH8kA+OS1LMhDz
         SViJAUPkJQ0mZYC3oBWHpImb2H8jd/ZzFY8WYRCI6Evr+jeq5NwLVDZcPZWvNYnW5btD
         47Op6xdE0mntdiA+CDDdUldEaDqD9fc2tsTXaS7HwGgM5f/kHsRWUWtODlkIVpAJlHrJ
         Q+7g==
X-Gm-Message-State: AFqh2ko2bnT5YOrfM0c2djfIph+RLFzr06YeM/GJVAY4MTYtgxdxhzTI
        U0z4EBPym9uN8a7dAKkESzYzNwD3ohndOz4cyKA=
X-Google-Smtp-Source: AMrXdXsi9Z4o6NR9nxS+XvbV4TvF/2sYLkf+RWnW0dEd8aSqKvrYiEcKljqXfFK0PjovolbaZHJ9xkgq3p1zbIIwfwY=
X-Received: by 2002:a05:6402:1002:b0:49a:1676:4280 with SMTP id
 c2-20020a056402100200b0049a16764280mr3625796edu.16.1674592380903; Tue, 24 Jan
 2023 12:33:00 -0800 (PST)
MIME-Version: 1.0
References: <20230123172110.376549-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20230123172110.376549-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 24 Jan 2023 21:32:49 +0100
Message-ID: <CAJZ5v0hBy2Jgezhuamz+++_EVfrO2gyuaC8vXvRMHvE5MjxtXw@mail.gmail.com>
Subject: Re: [PATCH v2] thermal: int340x: Protect trip temperature from
 dynamic update
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 6:26 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> Trip temperatures are read using ACPI methods and stored in the memory
> during zone initializtion and when the firmware sends a notification for
> change. This trip temperature is returned when the thermal core calls via
> callback get_trip_temp().
>
> But it is possible that while updating the memory copy of the trips when
> the firmware sends a notification for change, thermal core is reading the
> trip temperature via the callback get_trip_temp(). This may return invalid
> trip temperature.
>
> To address this add a mutex to protect the invalid temperature reads in
> the callback get_trip_temp() and int340x_thermal_read_trips().
>
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org # 5.0+
> ---
> v2:
> - rebased on linux-next

So I've rebased it back onto 6.2-rc5 and pushed the result into the
thermal-intel-fixes branch.  Please see if it looks good to you and
let me know.

I'd prefer to push it for 6.2-rc.

> - Add ret variable and remove return as suugested by Rafael

Thanks!

>  .../int340x_thermal/int340x_thermal_zone.c     | 18 +++++++++++++++---
>  .../int340x_thermal/int340x_thermal_zone.h     |  1 +
>  2 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> index 228f44260b27..5fda1e67b793 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> @@ -41,7 +41,9 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
>                                          int trip, int *temp)
>  {
>         struct int34x_thermal_zone *d = zone->devdata;
> -       int i;
> +       int i, ret = 0;
> +
> +       mutex_lock(&d->trip_mutex);
>
>         if (trip < d->aux_trip_nr)
>                 *temp = d->aux_trips[trip];
> @@ -60,10 +62,12 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
>                         }
>                 }
>                 if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
> -                       return -EINVAL;
> +                       ret = -EINVAL;
>         }
>
> -       return 0;
> +       mutex_unlock(&d->trip_mutex);
> +
> +       return ret;
>  }
>
>  static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
> @@ -165,6 +169,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
>         int trip_cnt = int34x_zone->aux_trip_nr;
>         int i;
>
> +       mutex_lock(&int34x_zone->trip_mutex);
> +
>         int34x_zone->crt_trip_id = -1;
>         if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
>                                              &int34x_zone->crt_temp))
> @@ -192,6 +198,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
>                 int34x_zone->act_trips[i].valid = true;
>         }
>
> +       mutex_unlock(&int34x_zone->trip_mutex);
> +
>         return trip_cnt;
>  }
>  EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
> @@ -215,6 +223,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
>         if (!int34x_thermal_zone)
>                 return ERR_PTR(-ENOMEM);
>
> +       mutex_init(&int34x_thermal_zone->trip_mutex);
> +
>         int34x_thermal_zone->adev = adev;
>
>         int34x_thermal_zone->ops = kmemdup(&int340x_thermal_zone_ops,
> @@ -277,6 +287,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
>  err_trip_alloc:
>         kfree(int34x_thermal_zone->ops);
>  err_ops_alloc:
> +       mutex_destroy(&int34x_thermal_zone->trip_mutex);
>         kfree(int34x_thermal_zone);
>         return ERR_PTR(ret);
>  }
> @@ -289,6 +300,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
>         acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
>         kfree(int34x_thermal_zone->aux_trips);
>         kfree(int34x_thermal_zone->ops);
> +       mutex_destroy(&int34x_thermal_zone->trip_mutex);
>         kfree(int34x_thermal_zone);
>  }
>  EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> index e28ab1ba5e06..6610a9cc441b 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> @@ -32,6 +32,7 @@ struct int34x_thermal_zone {
>         struct thermal_zone_device_ops *ops;
>         void *priv_data;
>         struct acpi_lpat_conversion_table *lpat_table;
> +       struct mutex trip_mutex;
>  };
>
>  struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
> --
> 2.31.1
>
