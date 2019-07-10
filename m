Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D9C644FF
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 12:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGJKNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 06:13:16 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36895 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbfGJKNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 06:13:16 -0400
Received: by mail-oi1-f193.google.com with SMTP id t76so1187039oih.4;
        Wed, 10 Jul 2019 03:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMQ20HN1HkUQ5iXeyevGIec1BiPAteEIkUj5csryX4M=;
        b=PogKRyCeV6WJxMOTIuNo1D1IqzdIsVHnScXRn7SUoxFp82wmm6VXfDLKk8no1su/qq
         j+FQgqsyQaHYQT1RsGowx2nF2b5kSQbiV1HpPcdDW4203eKi7j3pbC6sjn/sZhhIDYhw
         2CoqveccXMxfSE/V1STFLW7cdJ2vkp3TZsT4Yorm2YYTdRC7Xyg1tQJ/DyqO/ItAhfnj
         V+DHeCH4Gywy3OPXohY9oZufL5MKNZG5Kz0qrhATZemAS5NzEGfHbfQ1nLuKqgk3MSca
         x2K+Uvty8d3ZSJmFqIkRCT56on76edK7QPsmeNKHEFAxlAmIWvj/VIbb5saMh23M+RpU
         x8bw==
X-Gm-Message-State: APjAAAW/ZyFXSO5tBhCApcszpdH5shvoCDLsldDxfY9JlKZLz5I4Eh4X
        q4MGLb90pmP6Bgt1cWVxF6P2o7pxn8eGYd5CFqs=
X-Google-Smtp-Source: APXvYqw7XmF+8mgq1SOVrjfC5LsQ/5ZaBFuBF9bzZRW00yqQKLq2uowodCNWOPtfwnJP/gRhEVpUnkVdqZP3FSTJE7I=
X-Received: by 2002:aca:bd43:: with SMTP id n64mr2639388oif.148.1562753595363;
 Wed, 10 Jul 2019 03:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190710090852.9239-1-brgl@bgdev.pl> <510f14c9-fc3b-734c-53ff-cbf4a7579e32@electromag.com.au>
In-Reply-To: <510f14c9-fc3b-734c-53ff-cbf4a7579e32@electromag.com.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 10 Jul 2019 12:13:04 +0200
Message-ID: <CAMuHMdUB7fU1grp7jgrFWad183RLcRE7CDNQYczgm_Ur-Nu_9g@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: em: remove the gpiochip before removing the irq domain
To:     Phil Reid <preid@electromag.com.au>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Phil,

On Wed, Jul 10, 2019 at 11:37 AM Phil Reid <preid@electromag.com.au> wrote:
> On 10/07/2019 17:08, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > In commit 8764c4ca5049 ("gpio: em: use the managed version of
> > gpiochip_add_data()") we implicitly altered the ordering of resource
> > freeing: since gpiochip_remove() calls gpiochip_irqchip_remove()
> > internally, we now can potentially use the irq_domain after it was
> > destroyed in the remove() callback (as devm resources are freed after
> > remove() has returned).
> >
> > Use devm_add_action() to keep the ordering right and entirely kill
> > the remove() callback in the driver.
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add_data()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

> > --- a/drivers/gpio/gpio-em.c
> > +++ b/drivers/gpio/gpio-em.c

> > @@ -333,39 +340,32 @@ static int em_gio_probe(struct platform_device *pdev)
> >               return -ENXIO;
> >       }
> >
> > +     ret = devm_add_action(&pdev->dev,
> > +                           em_gio_irq_domain_remove, p->irq_domain);
>
> Could devm_add_action_or_reset be used?

Thank you very much for bringing this function to my attention!
I was just wondering if devm_add_action() should call the action on
failure, as this is what most callers seem to do anyway.

>
> > +     if (ret) {
> > +             irq_domain_remove(p->irq_domain);
> > +             return ret;
> > +     }

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
