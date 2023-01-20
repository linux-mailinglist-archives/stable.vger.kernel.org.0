Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040B0675B0B
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 18:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjATRTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 12:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjATRTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 12:19:06 -0500
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA029AAA6;
        Fri, 20 Jan 2023 09:18:53 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id mg12so15673088ejc.5;
        Fri, 20 Jan 2023 09:18:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJ6JhYd9+j7gVBnwQvGodk2H/uJ2jxB4BimsC/7ijq8=;
        b=KA6kVp8/4oM9OqG44ygaKvWkcPx1R9ui9irUV8qHCZRA+2Epq2iNCrZHhNRBolTr38
         XvSDDAC2Cae1FUqwtrfDzm8kexctJG5tIXOIFiXRC7snQ7EDAF1yYN76bRL1pKCH2boc
         PCu9CSPD/Q65ZSh/rOu1GX4bc3ZLIDR4VYPU6vJZJadHBp55BhvbE8yK9wBoRFEIXl63
         za/3CmEaRtXOtnmmXS+7Hdzmh+9MrNOKNiu3mEshmQAr9W1XjeDjeKo1aiLoC2/QsQuz
         bzza6uMb2SYQIJzL9343jEmVBNrMwb3uHLEYA9TswoeAcLOyhPiDqHhJQ6v1YAen3qMo
         1gCA==
X-Gm-Message-State: AFqh2koHf71/3zwUXd4vtd+hshYz50jrSOJY1eAN0bVmxUGOhyErGmPT
        LXqzFTXzNesMQq60tOFe1sEXP+kV7RdlrNqmwsw=
X-Google-Smtp-Source: AMrXdXt8aTmsW3tIZHJfP01G5f4JXkJ4DuYZHnEUDRgxwgclF8xg4dVqsnKVr5Em7NxTSxNaIg/X7anu2BJU4s8CCvU=
X-Received: by 2002:a17:907:7855:b0:855:63bb:d3cb with SMTP id
 lb21-20020a170907785500b0085563bbd3cbmr1603903ejc.532.1674235132409; Fri, 20
 Jan 2023 09:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20230119192921.3215965-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20230119192921.3215965-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 20 Jan 2023 18:18:41 +0100
Message-ID: <CAJZ5v0ieRhK_bzufRGFVZXtK_rW7vn1PDDA0nFMQLm3_Rm=4rA@mail.gmail.com>
Subject: Re: [PATCH] thermal: int340x: Protect trip temperature from dynamic update
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 8:29 PM Srinivas Pandruvada
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

One nit below.

> ---
>  .../intel/int340x_thermal/int340x_thermal_zone.c | 16 +++++++++++++++-
>  .../intel/int340x_thermal/int340x_thermal_zone.h |  1 +
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> index 62c0aa5d0783..fd9080640e03 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> @@ -49,6 +49,8 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,

I would add a new local var:

int ret = 0;

>         if (d->override_ops && d->override_ops->get_trip_temp)
>                 return d->override_ops->get_trip_temp(zone, trip, temp);
>
> +       mutex_lock(&d->trip_mutex);
> +
>         if (trip < d->aux_trip_nr)
>                 *temp = d->aux_trips[trip];
>         else if (trip == d->crt_trip_id)
> @@ -65,10 +67,14 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
>                                 break;
>                         }
>                 }
> -               if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
> +               if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT) {
> +                       mutex_unlock(&d->trip_mutex);
>                         return -EINVAL;

And then do

                        ret = -EINVAL;

instead of the above.

> +               }
>         }
>
> +       mutex_unlock(&d->trip_mutex);
> +
>         return 0;

And

    return ret;

here.

>  }
>
> @@ -180,6 +186,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
>         int trip_cnt = int34x_zone->aux_trip_nr;
>         int i;
>
> +       mutex_lock(&int34x_zone->trip_mutex);
> +
>         int34x_zone->crt_trip_id = -1;
>         if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
>                                              &int34x_zone->crt_temp))
> @@ -207,6 +215,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
>                 int34x_zone->act_trips[i].valid = true;
>         }
>
> +       mutex_unlock(&int34x_zone->trip_mutex);
> +
>         return trip_cnt;
>  }
>  EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
> @@ -230,6 +240,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
>         if (!int34x_thermal_zone)
>                 return ERR_PTR(-ENOMEM);
>
> +       mutex_init(&int34x_thermal_zone->trip_mutex);
> +
>         int34x_thermal_zone->adev = adev;
>         int34x_thermal_zone->override_ops = override_ops;
>
> @@ -281,6 +293,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
>         acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
>         kfree(int34x_thermal_zone->aux_trips);
>  err_trip_alloc:
> +       mutex_destroy(&int34x_thermal_zone->trip_mutex);
>         kfree(int34x_thermal_zone);
>         return ERR_PTR(ret);
>  }
> @@ -292,6 +305,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
>         thermal_zone_device_unregister(int34x_thermal_zone->zone);
>         acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
>         kfree(int34x_thermal_zone->aux_trips);
> +       mutex_destroy(&int34x_thermal_zone->trip_mutex);
>         kfree(int34x_thermal_zone);
>  }
>  EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> index 3b4971df1b33..8f9872afd0d3 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
> @@ -32,6 +32,7 @@ struct int34x_thermal_zone {
>         struct thermal_zone_device_ops *override_ops;
>         void *priv_data;
>         struct acpi_lpat_conversion_table *lpat_table;
> +       struct mutex trip_mutex;
>  };
>
>  struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
> --
> 2.38.1
>
