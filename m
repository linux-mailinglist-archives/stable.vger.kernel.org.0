Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF812522170
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 18:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245723AbiEJQor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 12:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345425AbiEJQoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 12:44:46 -0400
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9A81D1;
        Tue, 10 May 2022 09:40:46 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id w187so31737721ybe.2;
        Tue, 10 May 2022 09:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HGoPv6W6CM1DO2fVfWosWDd56IU/7LHJWw4c0lAvJA4=;
        b=yvBxknRisfq9swtcJocG9WwgmwooxJe6idDXOi2tI8fOyvot1EKmcFjT0dNEhVZp5n
         E3LjGBZMcNHU3/WJowDxKT+B2en26WHwCa2F0FiTMWRbl1X55Z2lFXrZ/eThuNIopJwj
         OfEC9vSZKYXVmTFe0ecTzlGIoZHW0Eb/rdWuTYvsXBFxqoaLwqrrOxVgCny4JJBt3dU6
         f23mg5ew95hLH7ADPwqwkFbAP1+fIuevRj7BIeT9UrYtNmKroaVMrr5GkTYpXBEtYWRt
         VqFNTe0J7wzR25YK217KAHOb1zDsLMrJbEsuy/pm8hEtXAoZEun2CYIpWEGllovRZM4l
         saug==
X-Gm-Message-State: AOAM532n3Erpei054ayZqrj/QtkyEcjCtwYAU0EeUwhz+pkuJpV3c/aI
        9zK6GwmFGRdJmVj6UjlCCvl5lZqFN11N5Q2HGHY=
X-Google-Smtp-Source: ABdhPJzt3lisSBKrlknwiaLfEFImDorjTjrExik21oVqLt+AIUyKLfyONbcQGpvGYBEJhAuq1ttlOmXUi1pCjBPmYjQ=
X-Received: by 2002:a25:da84:0:b0:648:423e:57b0 with SMTP id
 n126-20020a25da84000000b00648423e57b0mr18644611ybf.137.1652200845998; Tue, 10
 May 2022 09:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220506122052.659129-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20220506122052.659129-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 10 May 2022 18:40:34 +0200
Message-ID: <CAJZ5v0h5ZvB2yQz3m5Z149jCMvNhzwt_a76tm5bVK8VzC5YY9A@mail.gmail.com>
Subject: Re: [PATCH] thermal: int340x: Mode setting with new OS handshake
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 6, 2022 at 2:21 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> With the new OS handshake introduced with the commit: "c7ff29763989
> ("thermal: int340x: Update OS policy capability handshake")",
> thermal zone mode "enabled" doesn't work in the same way as the legacy
> handshake. The mode "enabled" fails with -EINVAL using new handshake.
>
> To address this issue, when the new OS UUID mask is set:
> - When mode is "enabled", return 0 as the firmware already has the
> latest policy mask.
> - When mode is "disabled", update the firmware with UUID mask of zero.
> In this way firmware can take control of the thermal control. Also
> reset the OS UUID mask. This allows user space to update with new
> set of policies.
>
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org

It would be good to have a Fixes tag for this one.

> ---
>  .../intel/int340x_thermal/int3400_thermal.c   | 48 ++++++++++++-------
>  1 file changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index d97f496bab9b..1061728ad5a9 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -194,12 +194,31 @@ static int int3400_thermal_run_osc(acpi_handle handle, char *uuid_str, int *enab
>         return result;
>  }
>
> +static int set_os_uuid_mask(struct int3400_thermal_priv *priv, u32 mask)
> +{
> +       int cap = 0;
> +
> +       /*
> +        * Capability bits:
> +        * Bit 0: set to 1 to indicate DPTF is active
> +        * Bi1 1: set to 1 to active cooling is supported by user space daemon
> +        * Bit 2: set to 1 to passive cooling is supported by user space daemon
> +        * Bit 3: set to 1 to critical trip is handled by user space daemon
> +        */
> +       if (mask)
> +               cap = ((priv->os_uuid_mask << 1) | 0x01);
> +
> +       return int3400_thermal_run_osc(priv->adev->handle,
> +                                      "b23ba85d-c8b7-3542-88de-8de2ffcfd698",
> +                                      &cap);
> +}
> +
>  static ssize_t current_uuid_store(struct device *dev,
>                                   struct device_attribute *attr,
>                                   const char *buf, size_t count)
>  {
>         struct int3400_thermal_priv *priv = dev_get_drvdata(dev);
> -       int i;
> +       int ret, i;
>
>         for (i = 0; i < INT3400_THERMAL_MAXIMUM_UUID; ++i) {
>                 if (!strncmp(buf, int3400_thermal_uuids[i],
> @@ -231,19 +250,7 @@ static ssize_t current_uuid_store(struct device *dev,
>         }
>
>         if (priv->os_uuid_mask) {
> -               int cap, ret;
> -
> -               /*
> -                * Capability bits:
> -                * Bit 0: set to 1 to indicate DPTF is active
> -                * Bi1 1: set to 1 to active cooling is supported by user space daemon
> -                * Bit 2: set to 1 to passive cooling is supported by user space daemon
> -                * Bit 3: set to 1 to critical trip is handled by user space daemon
> -                */
> -               cap = ((priv->os_uuid_mask << 1) | 0x01);
> -               ret = int3400_thermal_run_osc(priv->adev->handle,
> -                                             "b23ba85d-c8b7-3542-88de-8de2ffcfd698",
> -                                             &cap);
> +               ret = set_os_uuid_mask(priv, priv->os_uuid_mask);
>                 if (ret)
>                         return ret;
>         }
> @@ -469,17 +476,26 @@ static int int3400_thermal_change_mode(struct thermal_zone_device *thermal,
>         if (mode != thermal->mode) {
>                 int enabled;
>
> +               enabled = (mode == THERMAL_DEVICE_ENABLED);
> +
> +               if (priv->os_uuid_mask) {
> +                       if (!enabled) {
> +                               priv->os_uuid_mask = 0;
> +                               result = set_os_uuid_mask(priv, priv->os_uuid_mask);
> +                       }
> +                       goto eval_odvp;
> +               }
> +
>                 if (priv->current_uuid_index < 0 ||
>                     priv->current_uuid_index >= INT3400_THERMAL_MAXIMUM_UUID)
>                         return -EINVAL;
>
> -               enabled = (mode == THERMAL_DEVICE_ENABLED);
>                 result = int3400_thermal_run_osc(priv->adev->handle,
>                                                  int3400_thermal_uuids[priv->current_uuid_index],
>                                                  &enabled);
>         }
>
> -
> +eval_odvp:
>         evaluate_odvp(priv);
>
>         return result;
> --
> 2.31.1
>
