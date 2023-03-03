Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1A6AA028
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjCCTgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCCTgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:36:37 -0500
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD42BF13;
        Fri,  3 Mar 2023 11:36:36 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id x3so14457062edb.10;
        Fri, 03 Mar 2023 11:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677872195;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5mcUtU244uidtpDMEVk5QlRXljdmyDcnX6mrTISZDTg=;
        b=iYH8bLxGLeHXh+D1J4dUE/yKdAVczrqHmJMSu33W35Z+z/SE5uC3L7+a/AVWehvlZ4
         Wl6TsTQ7WfJgh2KgO1twRW5WZlhZVw9CSl7o717HV/nJFkmPKA9ylqjjBkm5td/lXjPi
         +9pMXnvn0r5iQobw+1xTv/3TWtRPIzWhW2BoN9PN7rfLu61HaTLATQ72IwVdzBbR6uem
         YKQB3WL0u61P1cK+n66gY6gVz7BcyTmKFc+B0QYcqtaJyL3vMCa53PnZyAyGrDRInDF3
         rHRfhO6xtL4F1eu73KoQbW//aTsPOb58+AjfwzFE5doeURAQgIcX+QurMmFEbrU9lInz
         ueng==
X-Gm-Message-State: AO0yUKXd1P2Jwv2OTvRwlEtNaAs4dGk8pQnS4pUyRA0H+RoYlddNsXGc
        XamHDjbWWv9WSdYqlDkhYLZaoYrWl8prrpC3hg0=
X-Google-Smtp-Source: AK7set/heFAgQ5UpujknlIKpstWJapNZfIevFDlt9TAk1sSBhskvY2ifABm8k/hiw0ts4kxFoFM81OhD/LLxH1HPeEI=
X-Received: by 2002:a50:d758:0:b0:4bd:ce43:9ee8 with SMTP id
 i24-20020a50d758000000b004bdce439ee8mr1784937edj.6.1677872194869; Fri, 03 Mar
 2023 11:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20230303161910.3195805-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20230303161910.3195805-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 3 Mar 2023 20:36:23 +0100
Message-ID: <CAJZ5v0hRyA80dNqtK=fzp5Hrz4RwGuVPBVnWAyU-UAcStYPxwg@mail.gmail.com>
Subject: Re: [PATCH] thermal: int340x: processor_thermal: Fix deadlock
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 3, 2023 at 5:19 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
>
> When user space updates the trip point there is a deadlock, which results
> in caller gets blocked forever.
>
> Commit 05eeee2b51b4 ("thermal/core: Protect sysfs accesses to thermal
> operations with thermal zone mutex"), added a mutex for tz->lock in the
> function trip_point_temp_store(). Hence, trip set callback() can't
> call any thermal zone API as they are protected with the same mutex lock.
>
> The callback here calling thermal_zone_device_enable(), which will result
> in deadlock.
>
> Move the thermal_zone_device_enable() to proc_thermal_pci_probe() to
> avoid this deadlock.
>
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
> Cc: stable@vger.kernel.org
> ---
> The commit which caused this issue was added during v6.2 cycle.
>
>  .../intel/int340x_thermal/processor_thermal_device_pci.c     | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
> index bf1b1cdfade4..acc11ad56975 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
> @@ -194,7 +194,6 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp
>         proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, _temp);
>         proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 1);
>
> -       thermal_zone_device_enable(tzd);
>         pci_info->stored_thres = temp;
>
>         return 0;
> @@ -277,6 +276,10 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
>                 goto err_free_vectors;
>         }
>
> +       ret = thermal_zone_device_enable(pci_info->tzone);
> +       if (ret)
> +               goto err_free_vectors;
> +
>         return 0;
>
>  err_free_vectors:
> --

Now queued up for 6.3-rc with a Fixes: tag added, thanks!
