Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C09D6437
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 15:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731126AbfJNNjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 09:39:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42698 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730549AbfJNNjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 09:39:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id c195so11834453lfg.9
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 06:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RTz668O2M1TdPlkPofYFi1wxVnsQ2zgCzbQgNwsLcFs=;
        b=f6aTR8zWy623wf1SMFYsJVJA1xBCoZlNFAZaew0jBVwLci9tfek8eAs2ooLV1HEN+R
         msnoWdcRKbJUS5TwYXM0xz61cfSzaei4UQd2H6Z2ZJxlOHpWnyiqsV9NJPvZbfNirRqj
         N3ofmsSwvIlALeEbVYRfQwWNN79WiUNzwdW2M7/Af3ESgm6t13VEJutsyp8WdvM6Xe/M
         FRx+neZfGjlx5qgnP510Jqw0fbeuQcP8MDxWYTsPrl3zgQIhSMXGLf33DCmHgMKuD33K
         7hYhohoNPZ+9oKbfo5h9Ba8+QgmZGaw8tDC/kC7oF8sYakVJKvBxdJoYrA9otzw4lz0o
         lkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RTz668O2M1TdPlkPofYFi1wxVnsQ2zgCzbQgNwsLcFs=;
        b=Od8LHlDqWXBQ8fcsgnRNa8xAg7BghFYXIFUSjGRuSFP9cq5SXSyAyG99BY+IAU3HZn
         meKZ/aLAxdBoeJaZCMElVkEq88GJDM89epF3jDANmlV/ZixWDp5SH6dxYgjtLJfRd7Eq
         jroFprljhm0cKdI6bYrO2bM7p3rLk7kRHf9EwsZ2qUERxs9r9TRtHvQoqQU99rpVlWlc
         Ipil8EoOG6P0LkbITf7Nx5ZnVpcSambK3DgX5y+9A0uhO6s1uASFX2ipIWeW+ngduW33
         dOWatO6K/rOk632ls+o52G3J2OKwJGjwuupcKr9MteMjqw9Vmk9UjnWFDxW9AyyYWmj9
         GIng==
X-Gm-Message-State: APjAAAVSohUySe7LZpWTCUbtYB25A7a09LEa2l6jGyOUApnL0s4BfVB8
        evT8KWLEPnHzYLu2CtwjF4tMzW0mbUmUwwmF+CpDHQ==
X-Google-Smtp-Source: APXvYqxHCsifA/d3Sg4dUFPo7u2CP3yycMdyPwtZphOXhtVlBf97zjPOGexHNW0FylSR7U2Hi7qKFIRlnKU4m1OLQAQ=
X-Received: by 2002:ac2:533c:: with SMTP id f28mr17754216lfh.0.1571060349612;
 Mon, 14 Oct 2019 06:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org> <20191014122732.d6ow5tbko5xdwd7g@holly.lan>
In-Reply-To: <20191014122732.d6ow5tbko5xdwd7g@holly.lan>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 14 Oct 2019 19:08:58 +0530
Message-ID: <CAFA6WYM4xeczVjq4wrpQ5aWvvOQMnutaQyyf+=LjoSBFeNnFmw@mail.gmail.com>
Subject: Re: [PATCH] hwrng: omap - Fix RNG wait loop timeout
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, dsaxena@plexity.net,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        romain.perier@free-electrons.com, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralph Siemsen <ralph.siemsen@linaro.org>,
        Milan STEVANOVIC <milan.stevanovic@se.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Oct 2019 at 17:57, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> On Mon, Oct 14, 2019 at 05:32:45PM +0530, Sumit Garg wrote:
> > Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
> > data rate which takes approx. 700us to produce 16 bytes of output data
> > as per testing results. So configure the timeout as 1000us to also take
> > account of lack of udelay()'s reliability.
>
> What "lack of udelay()'s reliability" are you concerned about?
>

For this I took reference from "drivers/char/hw_random/st-rng.c +33".
I think it's probably safe to take additional timeout rather than
relying on accuracy of udelay() based measurements. Specifically if
udelay() returns early than the expected delay (see:
include/linux/delay.h).

-Sumit

>
> Daniel.
>
> >
> > Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >  drivers/char/hw_random/omap-rng.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> > index b27f396..e329f82 100644
> > --- a/drivers/char/hw_random/omap-rng.c
> > +++ b/drivers/char/hw_random/omap-rng.c
> > @@ -66,6 +66,13 @@
> >  #define OMAP4_RNG_OUTPUT_SIZE                        0x8
> >  #define EIP76_RNG_OUTPUT_SIZE                        0x10
> >
> > +/*
> > + * EIP76 RNG takes approx. 700us to produce 16 bytes of output data
> > + * as per testing results. And to account for the lack of udelay()'s
> > + * reliability, we keep the timeout as 1000us.
> > + */
> > +#define RNG_DATA_FILL_TIMEOUT                        100
> > +
> >  enum {
> >       RNG_OUTPUT_0_REG = 0,
> >       RNG_OUTPUT_1_REG,
> > @@ -176,7 +183,7 @@ static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
> >       if (max < priv->pdata->data_size)
> >               return 0;
> >
> > -     for (i = 0; i < 20; i++) {
> > +     for (i = 0; i < RNG_DATA_FILL_TIMEOUT; i++) {
> >               present = priv->pdata->data_present(priv);
> >               if (present || !wait)
> >                       break;
> > --
> > 2.7.4
> >
