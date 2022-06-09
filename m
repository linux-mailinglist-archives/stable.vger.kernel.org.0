Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561115443AE
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 08:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiFIGSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 02:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiFIGSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 02:18:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B84213ADB
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 23:18:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y196so20237767pfb.6
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 23:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zc9ciXx5GwEusH46DNu7OQeRTu8uPCA0lWBlUIVoYFY=;
        b=FPJp1qGCAQjElu/s54wtxTEqyTIo4Gxs5nP0LgIXAqluDKJhDqh2YPEbO7xO5sEmc2
         KtdFjQwB/yd/9PVOLUjQAVNVi5ckB6A5pyl6jV0SqEE82S0J43qdQpFL8JH5f7IICwYW
         bJn7H4/abJvW2FOXUaelhy7QzYHYBE/QHQGEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zc9ciXx5GwEusH46DNu7OQeRTu8uPCA0lWBlUIVoYFY=;
        b=wBJvKKckD77cgA0eb2x/fP0z48nAcVXO0zYU0ggxU+8muJfwCrfjqqfsq+D3cSjcct
         UN4/Eddl5PmJo2jNyKP+kQtH8UYUZ+QtQCI1C6mLvniuTkyZUvr3lfrTggRQKDWtYfjp
         1AeAKoC8N7ZVY6BnZB/NINrOau6YolwZWct4hTyFPtzfWLJJ9Ldb5GpAek6GYok69JCP
         CPS10j/bIXGc4B3LEAO1VTENeMj+uIy4ci+Ahqad+OD2K0zmJ0+xloz7AyJL8PYsYDSW
         zJn7+BSSFv0oR4p7D3s55oM4NAAB4ksj5M3hq0ZptCKeFJzHmHFDs6PADvC5/24Iadr5
         Vkfg==
X-Gm-Message-State: AOAM531Zv1bslLzVJLqrBwmi0lWanagnZLw31WuHq1BIAR/8jSioTPRe
        EPKlvFvRcKBFz2YMEi+vdOtFjQrJEMeF6ytdpYMjeg==
X-Google-Smtp-Source: ABdhPJz6laaOhTm1/LqhS5gL+moibBUAZIoBXJEkGSXtfbv2uUarFGkQ6jjfFH/M3ZdIpAfR8w4WRAqUQvFIbGSErbE=
X-Received: by 2002:a63:5610:0:b0:3f2:7e19:1697 with SMTP id
 k16-20020a635610000000b003f27e191697mr32972858pgb.74.1654755527553; Wed, 08
 Jun 2022 23:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220607095829.1035903-1-dario.binacchi@amarulasolutions.com>
 <YqGJnORzbp2xiEU3@matsya> <CAOf5uwkxit8kAAmwWGgTqR57m_SRmAxere10rCucOuBHU5+8fw@mail.gmail.com>
 <YqGODNACHfKKHBOf@matsya>
In-Reply-To: <YqGODNACHfKKHBOf@matsya>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Thu, 9 Jun 2022 08:18:36 +0200
Message-ID: <CAOf5uw=8j1F3tLE9fLAjFGhVt4WXsU7GJdCkEhPtAAxvzM2fyg@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] dmaengine: mxs: fix driver registering
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vinod

On Thu, Jun 9, 2022 at 8:07 AM Vinod Koul <vkoul@kernel.org> wrote:
>
> On 09-06-22, 08:01, Michael Nazzareno Trimarchi wrote:
> > Hi
> >
> > On Thu, Jun 9, 2022 at 7:48 AM Vinod Koul <vkoul@kernel.org> wrote:
> > >
> > > On 07-06-22, 11:58, Dario Binacchi wrote:
> > > > Driver registration fails on SOC imx8mn as its supplier, the clock
> > > > control module, is not ready. Since platform_driver_probe(), as
> > > > reported by its description, is incompatible with deferred probing,
> > > > we have to use platform_driver_register().
> > > >
> > > > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > > Cc: stable@vger.kernel.org
> > > >
> > > > ---
> > > >
> > > > Changes in v2:
> > > > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> > > >
> > > >  drivers/dma/mxs-dma.c | 11 ++++-------
> > > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > > > index 994fc4d2aca4..b8a3e692330d 100644
> > > > --- a/drivers/dma/mxs-dma.c
> > > > +++ b/drivers/dma/mxs-dma.c
> > > > @@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
> > > >       return mxs_chan->status;
> > > >  }
> > > >
> > > > -static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > > > +static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > >
> > > why drop __init for these...?
> > >
> >
> > I think that you refer to the fact that it can not be compiled as a
> > module, am I right?
>
> It is still declared as a module_platform_driver... From changelog I can
> understand that you are changing init level from subsys to module (in
> fact clocks should be moved up as arch level and dmaengine users as
> module) ...

The way the driver was using to register was:
platform_driver_probe(&driver, driver_probe);

The function try to register the driver, one time and if the
dependences is not satisfied,
then there will not a next try, so the driver initialized that way can
not depends to anything
apart himself, or all the dependencies should be ready at the time the
driver_probe is called

>
> But why remove __init declaration from these? Whatever purpose that may
> solve needs to be documented in changelog and perhaps a different patch
>

I was thinking that driver can be compiled as module as other driver
but is bool and not tristate

Michael

>
> >
> > Michael
> >
> > > >  {
> > > >       int ret;
> > > >
> > > > @@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
> > > >                                    ofdma->of_node);
> > > >  }
> > > >
> > > > -static int __init mxs_dma_probe(struct platform_device *pdev)
> > > > +static int mxs_dma_probe(struct platform_device *pdev)
> > > >  {
> > > >       struct device_node *np = pdev->dev.of_node;
> > > >       const struct mxs_dma_type *dma_type;
> > > > @@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
> > > >               .name   = "mxs-dma",
> > > >               .of_match_table = mxs_dma_dt_ids,
> > > >       },
> > > > +     .probe = mxs_dma_probe,
> > > >  };
> > > >
> > > > -static int __init mxs_dma_module_init(void)
> > > > -{
> > > > -     return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> > > > -}
> > >
> > > > -subsys_initcall(mxs_dma_module_init);
> > > > +module_platform_driver(mxs_dma_driver);
> > > > --
> > > > 2.32.0
> > >
> > > --
> > > ~Vinod
>
> --
> ~Vinod



-- 
Michael Nazzareno Trimarchi
Co-Founder & Chief Executive Officer
M. +39 347 913 2170
michael@amarulasolutions.com
__________________________________

Amarula Solutions BV
Joop Geesinkweg 125, 1114 AB, Amsterdam, NL
T. +31 (0)85 111 9172
info@amarulasolutions.com
www.amarulasolutions.com
