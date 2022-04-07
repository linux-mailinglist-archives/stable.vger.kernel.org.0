Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C714F79E8
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbiDGIgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243158AbiDGIgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:36:39 -0400
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A08A24A121;
        Thu,  7 Apr 2022 01:34:40 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id BF869101C60; Thu,  7 Apr 2022 08:34:37 +0000 (UTC)
Date:   Thu, 7 Apr 2022 09:34:37 +0100
From:   Sean Young <sean@mess.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?utf-8?B?0JzQuNGF0LDQuNC7?= <vrserver1@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 5.16 0172/1017] media: gpio-ir-tx: fix transmit with long
 spaces on Orange Pi PC
Message-ID: <Yk6iHfvLffyocjrK@gofer.mess.org>
References: <20220405070354.155796697@linuxfoundation.org>
 <20220405070359.334460978@linuxfoundation.org>
 <CAMuHMdUovU-zaPPCV0tbOMEy3GsH6heSe+21koW3Ti3S+4qD5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUovU-zaPPCV0tbOMEy3GsH6heSe+21koW3Ti3S+4qD5g@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 03:16:07PM +0200, Geert Uytterhoeven wrote:
> On Tue, Apr 5, 2022 at 1:33 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > From: Sean Young <sean@mess.org>
> >
> > commit 5ad05ecad4326ddaa26a83ba2233a67be24c1aaa upstream.
> >
> > Calling udelay for than 1000us does not always yield the correct
> > results.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Михаил <vrserver1@gmail.com>
> > Signed-off-by: Sean Young <sean@mess.org>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/media/rc/gpio-ir-tx.c |   28 +++++++++++++++++++++-------
> >  1 file changed, 21 insertions(+), 7 deletions(-)
> >
> > --- a/drivers/media/rc/gpio-ir-tx.c
> > +++ b/drivers/media/rc/gpio-ir-tx.c
> > @@ -48,11 +48,29 @@ static int gpio_ir_tx_set_carrier(struct
> >         return 0;
> >  }
> >
> > +static void delay_until(ktime_t until)
> > +{
> > +       /*
> > +        * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
> > +        * m68k ndelay(s64) does not compile; so use s32 rather than s64.
> > +        */
> > +       s32 delta;
> > +
> > +       while (true) {
> > +               delta = ktime_us_delta(until, ktime_get());
> > +               if (delta <= 0)
> > +                       return;
> > +
> > +               /* udelay more than 1ms may not work */
> > +               delta = min(delta, 1000);
> > +               udelay(delta);
> > +       }
> 
> Yeah, that's why we have mdelay(), which loops around udelay() if no
> arch-specific implementation is provided.

That is a good point. That doesn't make this patch incorrect, just a bit ugly.
Can this patch be merged as-is please, and I'll write an patch upstream that
simplifies the code.

Thanks
Sean

> 
> > +}
> > +
> >  static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
> >                                    uint count)
> >  {
> >         ktime_t edge;
> > -       s32 delta;
> >         int i;
> >
> >         local_irq_disable();
> > @@ -63,9 +81,7 @@ static void gpio_ir_tx_unmodulated(struc
> >                 gpiod_set_value(gpio_ir->gpio, !(i % 2));
> >
> >                 edge = ktime_add_us(edge, txbuf[i]);
> > -               delta = ktime_us_delta(edge, ktime_get());
> > -               if (delta > 0)
> > -                       udelay(delta);
> > +               delay_until(edge);
> >         }
> >
> >         gpiod_set_value(gpio_ir->gpio, 0);
> > @@ -97,9 +113,7 @@ static void gpio_ir_tx_modulated(struct
> >                 if (i % 2) {
> >                         // space
> >                         edge = ktime_add_us(edge, txbuf[i]);
> > -                       delta = ktime_us_delta(edge, ktime_get());
> > -                       if (delta > 0)
> > -                               udelay(delta);
> > +                       delay_until(edge);
> >                 } else {
> >                         // pulse
> >                         ktime_t last = ktime_add_us(edge, txbuf[i]);
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
