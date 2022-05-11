Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1056C523C4A
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 20:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiEKSOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 14:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346094AbiEKSON (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 14:14:13 -0400
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E4DE15CE;
        Wed, 11 May 2022 11:14:12 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2f7d7e3b5bfso30830277b3.5;
        Wed, 11 May 2022 11:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HLM5UrVEFAMy1YzHX4aRkPBSHPjPij5ZKHaASows/yQ=;
        b=FtJ1YybRhvLTIcs9rQwpQygnM0QlIbNwCKcjTaFdQ7I1tMc27lBmVBkX3s4TnsoLgP
         cbBJ4/50Iny8OA+2NEojTBWLd9vITzkSWI5R2A84/hbwoi1YM3xzNqxM33IhKMqCRFjp
         szpMaORcp+PesYSCZaB29PKsKu8QTWscgUWTxGUxkQD31Mlw2r5v1W4STjs577ZsxlLC
         FlDmWGqHGSiqQa2aASPOqSDKYOU6YXKvhq8VQXX+gzxWlKUg9V1zGszT5sDtXnnTznt+
         1P1wUMWNjSeBOcoQ6V5TfckvykzQsWF9mhpPLK6kU56m4SZnu1UvztQ2wZM4ukG3bcyA
         861Q==
X-Gm-Message-State: AOAM531zxY8IzkobRXArQvaOCKjZ6KZSHkOvwvKVBDj0mPbnaCGcWG40
        Wcmb3P9i0Xs8+YVRIIq4rocL/0c3F7mtSNIZXiY3IQMm
X-Google-Smtp-Source: ABdhPJwJgb5GseduKipcgYhSAba9IjmbsT3Bite0shM1myaAv+GAR6NQCFESaNLoOaOjuUZM9UZS6BbX0NKEYReQORY=
X-Received: by 2002:a81:260a:0:b0:2f4:ca82:a42f with SMTP id
 m10-20020a81260a000000b002f4ca82a42fmr26796687ywm.149.1652292851808; Wed, 11
 May 2022 11:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220510182221.3990256-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20220510182221.3990256-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 11 May 2022 20:14:00 +0200
Message-ID: <CAJZ5v0hDN=iGBQei6XeJ1b3qLiRxPDm+ZFtKU1PcHbBcyxGpZw@mail.gmail.com>
Subject: Re: [UPDATE][PATCH] thermal: int340x: Mode setting with new OS handshake
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 8:22 PM Srinivas Pandruvada
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
> Fixes: c7ff29763989 ("thermal: int340x: Update OS policy capability handshake")
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org

This is not -stable material yet.

> ---
> update:
> Added Fixes tag
>
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

This change worries me a bit, because it means replaying an already
established _OSC handshake which shouldn't be done by the spec.

But I suppose you have tested this?

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

Patch applied as 5.18-rc material, but I've removed some unneeded
parens from the new code, so please double check the result in
bleeding-edge.

Thanks!
