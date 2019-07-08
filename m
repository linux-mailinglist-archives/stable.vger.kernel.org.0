Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E7561BFC
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 10:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfGHIyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 04:54:45 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44966 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728869AbfGHIyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 04:54:45 -0400
Received: by mail-ot1-f67.google.com with SMTP id b7so15371418otl.11
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 01:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=efd+BnPGvehL2A2UX02caz/Y1NvKnWaen2fuHX7MRzE=;
        b=SBKlIJU/kRPxduwNsmhn4tfli4XHsNgkuvfs0vrliM2bO588TzaFFyJH5mpAvTSpyE
         vMNX4Bd77Rl3/PaXl+2+z4JVB7NPoSm4GhlWUjVRlavKIQpL2Cxrd/FBWWa1j55aw4da
         /QaiPrUGXrShadGQrBe86H0v+jTxpYgYb6ccgPiEacmVlt5b1e8v9q9rKiRW0dUtPMwT
         0+XtYxiegFoER2tF+EwxhAwN0zyalL9YZrWD3dxmWJEgF864gq1gMwcHWrRSXfR1rdDs
         GAgOGW8Zf5t8AedaZCgZCJOOkkpuaUfNlSBafi8WRxtyWJjnJiKk2YQymWEe/jUuSyjM
         3EVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=efd+BnPGvehL2A2UX02caz/Y1NvKnWaen2fuHX7MRzE=;
        b=Psf0B4cQJbgTCBBfjeJ9P8/wMNvu9SU3wUu9m5+jRpntJ50cw2au723T5ud6k9FbmT
         uOWDwNA36CqPTInTLN43QbnpfK2dhqfiso3JZNNNb71P+AuOZFt1WcHrbFUDUzCQFxJI
         xeQD2gf1lH+UfZGhXy59emJE+6/Lm5YSEoetNNOblGjOA93Tk9uJokqHUmmNgB1Vu+L/
         yANBHu938kNinVIuvbq/LDnMKhCI4kaKNtTm6Up0HR/2q4oM0SJ34TpkphZ6m4Vvi7MD
         E3m+5BXfz/8n08lLdbP2AZ58Yg0ZIth70ouZCUafVUUxUpMkv9okrHFb6/ecDja9nSZt
         GOUA==
X-Gm-Message-State: APjAAAWVzIjK0Aw1dBwI0vpQvpttXxsOZ5PbN5Xhkvc/aMSEA9vv4aPL
        bPaObotWkwHmEvCMDvbwU4K8Cpj+AqbM62e3t7wbKwggfkY=
X-Google-Smtp-Source: APXvYqwNmok92+w9MyPlUpAdoQ0jznixJXwNaN4TFLNBf7nxlThGFjRAFzCSBqIuTyVm+vHd/Yc8XBJSCd7lJMaOlJQ=
X-Received: by 2002:a05:6830:1681:: with SMTP id k1mr13388848otr.256.1562576084924;
 Mon, 08 Jul 2019 01:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190708052308.27802-1-michael.wu@vatics.com>
In-Reply-To: <20190708052308.27802-1-michael.wu@vatics.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Mon, 8 Jul 2019 10:54:34 +0200
Message-ID: <CAMpxmJXZskz-cnqXVMRnUqxHjbQLwWZzQFrDc4eyGmronATCpg@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: fix incorrect IRQ requesting of an active-low lineevent
To:     Michael Wu <michael.wu@vatics.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, morgan.chang@vatics.com,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pon., 8 lip 2019 o 07:23 Michael Wu <michael.wu@vatics.com> napisa=C5=82(a)=
:
>
> When a pin is active-low, logical trigger edge should be inverted to matc=
h
> the same interrupt opportunity.
>
> For example, a button pushed triggers falling edge in ACTIVE_HIGH case; i=
n
> ACTIVE_LOW case, the button pushed triggers rising edge. For user space t=
he
> IRQ requesting doesn't need to do any modification except to configuring
> GPIOHANDLE_REQUEST_ACTIVE_LOW.
>
> For example, we want to catch the event when the button is pushed. The
> button on the original board drives level to be low when it is pushed, an=
d
> drives level to be high when it is released.
>
> In user space we can do:
>
>         req.handleflags =3D GPIOHANDLE_REQUEST_INPUT;
>         req.eventflags =3D GPIOEVENT_REQUEST_FALLING_EDGE;
>
>         while (1) {
>                 read(fd, &dat, sizeof(dat));
>                 if (dat.id =3D=3D GPIOEVENT_EVENT_FALLING_EDGE)
>                         printf("button pushed\n");
>         }
>
> Run the same logic on another board which the polarity of the button is
> inverted; it drives level to be high when pushed, and level to be low whe=
n
> released. For this inversion we add flag GPIOHANDLE_REQUEST_ACTIVE_LOW:
>
>         req.handleflags =3D GPIOHANDLE_REQUEST_INPUT |
>                 GPIOHANDLE_REQUEST_ACTIVE_LOW;
>         req.eventflags =3D GPIOEVENT_REQUEST_FALLING_EDGE;
>
> At the result, there are no any events caught when the button is pushed.
> By the way, button releasing will emit a "falling" event. The timing of
> "falling" catching is not expected.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Wu <michael.wu@vatics.com>
> ---
> Changes from v1:
> - Correct undeclared 'IRQ_TRIGGER_RISING'
> - Add an example to descibe the issue
> ---
>  drivers/gpio/gpiolib.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index e013d417a936..9c9597f929d7 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -956,9 +956,11 @@ static int lineevent_create(struct gpio_device *gdev=
, void __user *ip)
>         }
>
>         if (eflags & GPIOEVENT_REQUEST_RISING_EDGE)
> -               irqflags |=3D IRQF_TRIGGER_RISING;
> +               irqflags |=3D test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
> +                       IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
>         if (eflags & GPIOEVENT_REQUEST_FALLING_EDGE)
> -               irqflags |=3D IRQF_TRIGGER_FALLING;
> +               irqflags |=3D test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
> +                       IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
>         irqflags |=3D IRQF_ONESHOT;
>
>         INIT_KFIFO(le->events);
> --
> 2.17.1
>

Tested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
