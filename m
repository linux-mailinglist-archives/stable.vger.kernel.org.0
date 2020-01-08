Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9F1134196
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 13:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgAHMYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 07:24:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43964 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgAHMYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 07:24:03 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so1490926pga.10;
        Wed, 08 Jan 2020 04:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FimBHJzaK0+hvUwMczWq5KMiQgEkmFVQr2l4bwrxpl4=;
        b=fS/D3ze8BLHvhSfqLds0RkX7mXGktHNcVEswaRStYZJnSvbhdBV73qiau2+qscPAw/
         xycIgCoaR7TsK2pJwBcdpu6Nuvf5Wgya7LEZy/ejCBFZ/3ZS0B74gngIIYAhUHjNj/zi
         DgmWz+JaPD+4sKxXXvXbBfAaRNIMrrPZecYLwUhBj6WQgJiMMyhfdJEcuZ1+On3HkuWj
         xurCM0haEuiqqBIkkQdgz5AMtig8lU8ZToMjYRF0aQH+nAgoE36FDoH8V+68+JKeT+o9
         pAr+5vKjGntCFF9vMI/m4cM1vvB958SBdV/G5/KFwBj0Sj3bpfd0f94CZnQSZ7zbPlul
         JA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FimBHJzaK0+hvUwMczWq5KMiQgEkmFVQr2l4bwrxpl4=;
        b=hshUb+DRe/6mpQN0nR+OXswFLXiv3W5gxdovDvH6ZKeM3QccGtdnPz1CvT9gN7/gmL
         UurY9Mi0VgkEQc5gvd2z0aZq310qNO/ctxx+7Vq11iytwqjRCrNedZTYbHCqwVxTyoQn
         Dhfgr8CRljklOWc7X0/6HeRB/ozFmBlxYqU7mlpbGRknm7L8Zs3DjLjfd5SqOpz/+xj5
         BArgaoZwgKOD5c5isAnBioa3njwPAscUKmKjLoqPQ0gDHEvCaGIuZpwnKVYkRxJxIYqe
         gwbC5jAKAyA3urGuuf5tId00h1XHG/QN2B7rvroca7X+F7OJCmmLz1kQCp97FHX9cEZI
         bNYw==
X-Gm-Message-State: APjAAAXvxSPDet+Ggj6WLbTPpck91rR3p0oMqDR22Z3A3TGerDbB3HjK
        I84S/UudwfCM8EYLgFSrSwBMAVH85yfaOU8Ca3M=
X-Google-Smtp-Source: APXvYqwgoDXCANBomqGXARmKolSKbug3Em9RM2qXD8GXaDBp3/kR8EEcBZZd8Q3yFTAZHTAHICsaspNFthhzS43Udtk=
X-Received: by 2002:a65:5242:: with SMTP id q2mr4844790pgp.74.1578486242452;
 Wed, 08 Jan 2020 04:24:02 -0800 (PST)
MIME-Version: 1.0
References: <20200106144219.525215-1-hdegoede@redhat.com>
In-Reply-To: <20200106144219.525215-1-hdegoede@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 8 Jan 2020 14:23:53 +0200
Message-ID: <CAHp75Vdqd9GQ8eM9mk+4jr54MojySH+ZKGZSJ7mNBHy567XGPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] platform/x86: GPD pocket fan: Use default values when
 wrong modparams are given
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Jason Anderson <jasona.594@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 6, 2020 at 4:42 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Use our default values when wrong module-parameters are given, instead of
> refusing to load. Refusing to load leaves the fan at the BIOS default
> setting, which is "Off". The CPU's thermal throttling should protect the
> system from damage, but not-loading is really not the best fallback in this
> case.
>
> This commit fixes this by re-setting module-parameter values to their
> defaults if they are out of range, instead of failing the probe with
> -EINVAL.
>
> Cc: stable@vger.kernel.org
> Cc: Jason Anderson <jasona.594@gmail.com>
> Reported-by: Jason Anderson <jasona.594@gmail.com>
> Fixes: 594ce6db326e ("platform/x86: GPD pocket fan: Use a min-speed of 2 while charging")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/platform/x86/gpd-pocket-fan.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/platform/x86/gpd-pocket-fan.c b/drivers/platform/x86/gpd-pocket-fan.c
> index be85ed966bf3..1e6a42f2ea8a 100644
> --- a/drivers/platform/x86/gpd-pocket-fan.c
> +++ b/drivers/platform/x86/gpd-pocket-fan.c
> @@ -16,17 +16,26 @@
>
>  #define MAX_SPEED 3
>
> -static int temp_limits[3] = { 55000, 60000, 65000 };
> +#define TEMP_LIMIT0_DEFAULT    55000
> +#define TEMP_LIMIT1_DEFAULT    60000
> +#define TEMP_LIMIT2_DEFAULT    65000
> +
> +#define HYSTERESIS_DEFAULT     3000
> +
> +#define SPEED_ON_AC_DEFAULT    2
> +
> +static int temp_limits[3] = {
> +       TEMP_LIMIT0_DEFAULT, TEMP_LIMIT1_DEFAULT, TEMP_LIMIT2_DEFAULT };

I would rather put }; on the next line.
But okay, I'll do it myself when applying.

>  module_param_array(temp_limits, int, NULL, 0444);
>  MODULE_PARM_DESC(temp_limits,
>                  "Millicelsius values above which the fan speed increases");
>
> -static int hysteresis = 3000;
> +static int hysteresis = HYSTERESIS_DEFAULT;
>  module_param(hysteresis, int, 0444);
>  MODULE_PARM_DESC(hysteresis,
>                  "Hysteresis in millicelsius before lowering the fan speed");
>
> -static int speed_on_ac = 2;
> +static int speed_on_ac = SPEED_ON_AC_DEFAULT;
>  module_param(speed_on_ac, int, 0444);
>  MODULE_PARM_DESC(speed_on_ac,
>                  "minimum fan speed to allow when system is powered by AC");
> @@ -120,18 +129,21 @@ static int gpd_pocket_fan_probe(struct platform_device *pdev)
>                 if (temp_limits[i] < 40000 || temp_limits[i] > 70000) {
>                         dev_err(&pdev->dev, "Invalid temp-limit %d (must be between 40000 and 70000)\n",
>                                 temp_limits[i]);
> -                       return -EINVAL;
> +                       temp_limits[0] = TEMP_LIMIT0_DEFAULT;
> +                       temp_limits[1] = TEMP_LIMIT1_DEFAULT;
> +                       temp_limits[2] = TEMP_LIMIT2_DEFAULT;
> +                       break;
>                 }
>         }
>         if (hysteresis < 1000 || hysteresis > 10000) {
>                 dev_err(&pdev->dev, "Invalid hysteresis %d (must be between 1000 and 10000)\n",
>                         hysteresis);
> -               return -EINVAL;
> +               hysteresis = HYSTERESIS_DEFAULT;
>         }
>         if (speed_on_ac < 0 || speed_on_ac > MAX_SPEED) {
>                 dev_err(&pdev->dev, "Invalid speed_on_ac %d (must be between 0 and 3)\n",
>                         speed_on_ac);
> -               return -EINVAL;
> +               speed_on_ac = SPEED_ON_AC_DEFAULT;
>         }
>
>         fan = devm_kzalloc(&pdev->dev, sizeof(*fan), GFP_KERNEL);
> --
> 2.24.1
>


-- 
With Best Regards,
Andy Shevchenko
