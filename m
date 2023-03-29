Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A575C6CF248
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 20:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjC2SiU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 Mar 2023 14:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjC2SiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 14:38:09 -0400
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE931FE2;
        Wed, 29 Mar 2023 11:38:08 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id r11so67122201edd.5;
        Wed, 29 Mar 2023 11:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680115087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqpDvgPhxjybA6O6J83PctT4fmZDiL55ZH7/KdrAc4M=;
        b=b1BGwGt4atOwLwGLVgYjRG+GJk/wlCW3PjEsfaQ0Zq4oZEojfFC5qL7RlJ5RNpW+kO
         J90ma8XVvnb1tbYhQBDRXoSGJBPqQXI9Bliy3nNoUB7FdEsWiuTYOH6VrfMGy2tQanxJ
         /bV3rX8KCiskV6VJK6wkgrqoXdy+Ss5XGxUr62Zm8n/0Swil8n773+WE+WMsk5AldbQ3
         dl7ixtmEFBBHT1/wmX9yG/whjDwm5euQVfSp8MdqGQ81SlzmJCW9j2t4QfKjuqUSq2ZX
         Xcfl4j/P42HLZ43BrhYP8pEtSMJKxc2i6KiwtDJg37n7kYXhbj8o/OZg3RrUuysUZPPN
         0P+A==
X-Gm-Message-State: AAQBX9e/HNHmdLyDeO5e2b1JVHGIEvLz9Gi0WKhWzZdmAZLZiAPxLWVK
        GoYfEtGQ2TCacaXBTVmxnsDWJNx7ME925t18HOo=
X-Google-Smtp-Source: AKy350bHlW2Ztb1e3p6I7MCUYVVt6rsLJAvu+BHmQidJQ8uPC4PVyzvnN8BITUGaFyRF/YPK/ixgKlkTDckqSQw+61I=
X-Received: by 2002:a17:907:d687:b0:93d:a14f:c9b4 with SMTP id
 wf7-20020a170907d68700b0093da14fc9b4mr10307692ejc.2.1680115087111; Wed, 29
 Mar 2023 11:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230329152207.991768-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20230329152207.991768-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 29 Mar 2023 20:37:55 +0200
Message-ID: <CAJZ5v0iz6HAG+bhGb0HHmjwANdGmziJLHzH4XEz_CK7R1MexWQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: intel: int340x: processor_thermal: Fix
 additional deadlock
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 5:23 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> Commit 52f04f10b900 ("thermal: intel: int340x: processor_thermal: Fix
> deadlock") addressed deadlock issue during user space trip update. But it
> missed a case when thermal zone device is disabled when user writes 0.
>
> Call to thermal_zone_device_disable() also causes deadlock as it also
> tries to lock tz->lock, which is already claimed by trip_point_temp_store()
> in the thermal core code.
>
> Remove call to thermal_zone_device_disable() in the function
> sys_set_trip_temp(), which is called from trip_point_temp_store().
>
> Fixes: 52f04f10b900 ("thermal: intel: int340x: processor_thermal: Fix deadlock")
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org # 6.2+
> ---
>  .../thermal/intel/int340x_thermal/processor_thermal_device_pci.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
> index 90526f46c9b1..d71ee50e7878 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
> @@ -153,7 +153,6 @@ static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip, int temp
>                 cancel_delayed_work_sync(&pci_info->work);
>                 proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 0);
>                 proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, 0);
> -               thermal_zone_device_disable(tzd);
>                 pci_info->stored_thres = 0;
>                 return 0;
>         }
> --

Applied as 6.3-rc material, thanks!
