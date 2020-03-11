Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B8218183C
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 13:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgCKMjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 08:39:25 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41316 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgCKMjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 08:39:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id l21so1375226qtr.8
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 05:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pC5l7siATsFnyj3jv8ys73MV+m6Z/ppLVUOkmlqQeUI=;
        b=hiYkrxidfWS0oHycb1QcW9KllKAjrM2xTKfUUs5axL7h1ovLi01T6XNtf2l4A4iRyY
         fBSYznjD53d1JNTffHJH93/plBhd2qHFQR6RcGKb8A3DvZI0muPnqm3CgsYAFlByfY3W
         +QZgHPV9Z5X0HI30CG/EdtRUzs1LzGpNSQGFxdFZ7nBC8Bf0+ROUoFV8uZ4IdzIbcGeq
         NNYeB9IzXATqkTHjsfK4NQdqX21f3f/yPHDLTcW2dv5rsS3No9ilC0+TPg7EEd6UHXR8
         VdSOCOtPTLcuHQQqkoSslTFr2bWXYXB4cdPqAi8lvE0YrEjQgjQjRO8Y9Bwl07rM6nfK
         8RHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pC5l7siATsFnyj3jv8ys73MV+m6Z/ppLVUOkmlqQeUI=;
        b=ory+P1BT4F12/Lq6z66Vba/GcidQpN0pJhwZPrhzsFkTgwqzIwzKIKuMWkyQ/2200N
         us+hnsmMZ/gHdVE7L9nGalRy6tiQLbMsx/wX+fm5DNB5pSlVwWxKVMzC/Ya/JhEor4IQ
         kGVaemy9XitQcQjbhH24qcvPwUzVGgamKqfHlFqZ/rhSX3leqPVoC3cYQgFUpUkbKzy4
         ajFWY8210+zKudeIQwLfTdEcHgdLQAzCXARyVQIbxAtdlpMY6RbkZ+sQtwbx96UwUgmw
         zmFx7wuQKOggwOAnFb6xR+bZneXTVSFHvs+wJ+XQXOkSJV4SudT9XI7qLOn8P0+g5ggE
         evBA==
X-Gm-Message-State: ANhLgQ1PmT/YngYG2HcT2IXDp9X+nLMCx5PftlpY16TUy9jaBs7XiMLD
        vt5+abgJPDJP+rcHSKBQu0OF56PdETsq94roPOinlw==
X-Google-Smtp-Source: ADFU+vvbbLcSt99jxS2B0V5cZvbHbqwd0JNT1WkQncBARpvfW/UvBV8sRl9gT3eOrJW7gvFGZAE3kt+jyNb60Fckmd8=
X-Received: by 2002:ac8:5208:: with SMTP id r8mr2468281qtn.131.1583930363508;
 Wed, 11 Mar 2020 05:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200306132326.1329640-1-linus.walleij@linaro.org>
In-Reply-To: <20200306132326.1329640-1-linus.walleij@linaro.org>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Wed, 11 Mar 2020 13:39:12 +0100
Message-ID: <CAMpxmJWLoa8mxbpM6=rqL5PQSPi+eqiWMt+OqJzDF6mE610TkQ@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Fix irq_disable() semantics
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio <linux-gpio@vger.kernel.org>,
        Brian Masney <masneyb@onstation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pt., 6 mar 2020 o 14:23 Linus Walleij <linus.walleij@linaro.org> napisa=C5=
=82(a):
>
> The implementation if .irq_disable() which kicks in between
> the gpiolib and the driver is not properly mimicking the
> expected semantics of the irqchip core: the irqchip will
> call .irq_disable() if that exists, else it will call
> mask_irq() which first checks if .irq_mask() is defined
> before calling it.
>
> Since we are calling it unconditionally, we get this bug
> from drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c, as it only
> defines .irq_mask_ack and not .irq_mask:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
000
> pgd =3D (ptrval)
> (...)
> PC is at 0x0
> LR is at gpiochip_irq_disable+0x20/0x30
>
> Fix this by only calling .irq_mask() if it exists.
>
> Cc: Brian Masney <masneyb@onstation.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org
> Fixes: 461c1a7d4733 ("gpiolib: override irq_enable/disable")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpiolib.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index bdbc1649eafa..d0bb962f42d5 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2169,9 +2169,16 @@ static void gpiochip_irq_disable(struct irq_data *=
d)
>  {
>         struct gpio_chip *chip =3D irq_data_get_irq_chip_data(d);
>
> +       /*
> +        * Since we override .irq_disable() we need to mimic the
> +        * behaviour of __irq_disable() in irq/chip.c.
> +        * First call .irq_disable() if it exists, else mimic the
> +        * behaviour of mask_irq() which calls .irq_mask() if
> +        * it exists.
> +        */
>         if (chip->irq.irq_disable)
>                 chip->irq.irq_disable(d);
> -       else
> +       else if (chip->irq.chip->irq_mask)
>                 chip->irq.chip->irq_mask(d);
>         gpiochip_disable_irq(chip, d->hwirq);
>  }
> --
> 2.24.1
>

Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
