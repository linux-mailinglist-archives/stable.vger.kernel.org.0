Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4325E64A35C
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 15:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiLLOat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 09:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiLLOas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 09:30:48 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE23112AC5
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 06:30:47 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id 3so11372805vsq.7
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 06:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B0oBhmPpqjpCQ3pSDLW0VUeFJCBwI6s931jO+DuoW8A=;
        b=1AtY2omhTg2R3bhoa7ICi4BraTq9+YuOJnGycgdyAw2D30TMTB7ifWTi+nrtNPqKz/
         SsFL2luWSDWxgbuzBIsCkd0qPgaXilyI1jz+HKPCys2yP8+0EPiFUKJbetAIxxZabN1J
         v2RyU/yvlEHYelzthGPocBXxkpL5OcjRlIuy5daBMeqHvLIps6Dj+PMAKuLHU31uLwmI
         7IXTU7XfI/OEiG1XlrLmbF2IYBVr7rjzu1qEMkkO73KKd4VvjmXLitrU6tNxbC8FAS3a
         A+mONHK/XLwRAHbKgUP1D9/kM99nVfEB6RPVa5IRDmL/AIl62QFG3Pqw4oPUAdH2893x
         2gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0oBhmPpqjpCQ3pSDLW0VUeFJCBwI6s931jO+DuoW8A=;
        b=wyQPpQr8imoCwg4SJk2xlRWW91Z+X9Ys9ckqAthCphCYvCrmFTlwQcTX6C3iknEfBb
         I3IWN3laJjUKZ4LmwAPTAuxDmGt0Kpjjr5Y2kmMUeKx1SpPB4DkUBnsSPJ7ME+ujZwnw
         4WwPXlPeoI6nOwrE2ONwuSjaeJtAjHYYtwjVAFsThk1cYYLakwXTYNYo0f7Q4kd8aFQI
         E4220/auiXwJRkiFpANE4Ri/EoVbantxfr4JHq8WvzH2uvho2b+AKJIpVKFC++3bhqIc
         bDc10vKgXPPDxOIJ+WdSwkTnhCmo20qyuIlcMv+Uvpz5hE6a4GDIbiNH2iyDywdAofrk
         Qb1A==
X-Gm-Message-State: ANoB5pnsbLIxxjW3DvIEFOOsKOiFtnr+uu93BlgEOUYxa8rDDC9vxLzk
        6mcFGmYWtMFlw/T4EsBf1QCY7ZHviEznhzT1wrzizQ==
X-Google-Smtp-Source: AA0mqf5MekKZlYJc+gKxPWOq0+oucOPlAOHdRnxap/ZabiNMAKcKonTle6alCR4vKTdvfVr8tsq86TbRVLSTFsh8mO0=
X-Received: by 2002:a05:6102:3109:b0:3b1:3b81:127c with SMTP id
 e9-20020a056102310900b003b13b81127cmr11318131vsh.47.1670855446696; Mon, 12
 Dec 2022 06:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org> <20221212130929.496490427@linuxfoundation.org>
In-Reply-To: <20221212130929.496490427@linuxfoundation.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 12 Dec 2022 15:30:36 +0100
Message-ID: <CAMRc=McmS+JizSqX=y9pBvdr=Ds6t6xt+kK+sTidbcg_6683Hw@mail.gmail.com>
Subject: Re: [PATCH 5.15 061/123] gpiolib: check the ngpios property in core
 gpiolib code
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bartosz Golaszewski <brgl@bgdev.pl>
>
> [ Upstream commit 9dbd1ab20509e85cd3fac9479a00c59e83c08196 ]
>
> Several drivers read the 'ngpios' device property on their own, but
> since it's defined as a standard GPIO property in the device tree bindings
> anyway, it's a good candidate for generalization. If the driver didn't
> set its gc->ngpio, try to read the 'ngpios' property from the GPIO
> device's firmware node before bailing out.
>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpio/gpiolib.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a87c4cd94f7a..b7b5fe151e1a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -599,6 +599,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
>         int base = gc->base;
>         unsigned int i;
>         int ret = 0;
> +       u32 ngpios;
>
>         /*
>          * First: allocate and populate the internal stat container, and
> @@ -646,6 +647,26 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
>                 goto err_free_dev_name;
>         }
>
> +       /*
> +        * Try the device properties if the driver didn't supply the number
> +        * of GPIO lines.
> +        */
> +       if (gc->ngpio == 0) {
> +               ret = device_property_read_u32(&gdev->dev, "ngpios", &ngpios);
> +               if (ret == -ENODATA)
> +                       /*
> +                        * -ENODATA means that there is no property found and
> +                        * we want to issue the error message to the user.
> +                        * Besides that, we want to return different error code
> +                        * to state that supplied value is not valid.
> +                        */
> +                       ngpios = 0;
> +               else if (ret)
> +                       goto err_free_descs;
> +
> +               gc->ngpio = ngpios;
> +       }
> +
>         if (gc->ngpio == 0) {
>                 chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
>                 ret = -EINVAL;
> --
> 2.35.1
>
>
>

This isn't a fix, please drop it from stable.

Bartosz
