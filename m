Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC49546799
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiFJNs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 09:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiFJNsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 09:48:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F3522B35;
        Fri, 10 Jun 2022 06:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 582E3B83500;
        Fri, 10 Jun 2022 13:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F34C34114;
        Fri, 10 Jun 2022 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654868895;
        bh=T+pPDaDcvZBdzFlfEgDE/742pWO4FIoVsNv9CScJ/4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SANMuVrPIf1A4ysoL3oDttK/kvQYqkGdgddwxMRf4rzO3lJXrSHANVgrcLg3RfAnP
         znsT8L7iR7heDAfk1cl/HdupPnK1FGfRmpcZtw4ZFhnSDFh3z6W+p2EZyxaOfE8lb1
         vrKs51/mWKp4SeuBjgSH8iToYiqM7xr4ai5Jz5ZJzHvmasxJZiP/KIo7vThuOvWb9t
         MJnX7DDIz7WxqWFnROwR4qKMYA2RAq4eqbQw/9zN2amRRW8/OMt0Tm3D5wciZ1Nh3A
         ATB8715JCHdYX9FjACZEew86eYDC1Bu7EOxddiVkHykIxaOiKdFOmFM09rn7SFRq1D
         ISvCHTEFFtkAA==
Date:   Fri, 10 Jun 2022 19:18:10 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH v2] dmaengine: mxs: fix driver registering
Message-ID: <YqNLmixdb3fv7Cgs@matsya>
References: <20220607095829.1035903-1-dario.binacchi@amarulasolutions.com>
 <YqGJnORzbp2xiEU3@matsya>
 <CAOf5uwkxit8kAAmwWGgTqR57m_SRmAxere10rCucOuBHU5+8fw@mail.gmail.com>
 <YqGODNACHfKKHBOf@matsya>
 <CAOf5uw=8j1F3tLE9fLAjFGhVt4WXsU7GJdCkEhPtAAxvzM2fyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOf5uw=8j1F3tLE9fLAjFGhVt4WXsU7GJdCkEhPtAAxvzM2fyg@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09-06-22, 08:18, Michael Nazzareno Trimarchi wrote:
> Hi Vinod
> 
> On Thu, Jun 9, 2022 at 8:07 AM Vinod Koul <vkoul@kernel.org> wrote:
> >
> > On 09-06-22, 08:01, Michael Nazzareno Trimarchi wrote:
> > > Hi
> > >
> > > On Thu, Jun 9, 2022 at 7:48 AM Vinod Koul <vkoul@kernel.org> wrote:
> > > >
> > > > On 07-06-22, 11:58, Dario Binacchi wrote:
> > > > > Driver registration fails on SOC imx8mn as its supplier, the clock
> > > > > control module, is not ready. Since platform_driver_probe(), as
> > > > > reported by its description, is incompatible with deferred probing,
> > > > > we have to use platform_driver_register().
> > > > >
> > > > > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > > > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > > > Cc: stable@vger.kernel.org
> > > > >
> > > > > ---
> > > > >
> > > > > Changes in v2:
> > > > > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> > > > >
> > > > >  drivers/dma/mxs-dma.c | 11 ++++-------
> > > > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > > > > index 994fc4d2aca4..b8a3e692330d 100644
> > > > > --- a/drivers/dma/mxs-dma.c
> > > > > +++ b/drivers/dma/mxs-dma.c
> > > > > @@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
> > > > >       return mxs_chan->status;
> > > > >  }
> > > > >
> > > > > -static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > > > > +static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > > >
> > > > why drop __init for these...?
> > > >
> > >
> > > I think that you refer to the fact that it can not be compiled as a
> > > module, am I right?
> >
> > It is still declared as a module_platform_driver... From changelog I can
> > understand that you are changing init level from subsys to module (in
> > fact clocks should be moved up as arch level and dmaengine users as
> > module) ...
> 
> The way the driver was using to register was:
> platform_driver_probe(&driver, driver_probe);
> 
> The function try to register the driver, one time and if the
> dependences is not satisfied,
> then there will not a next try, so the driver initialized that way can
> not depends to anything
> apart himself, or all the dependencies should be ready at the time the
> driver_probe is called

There are two ways to solve this, you lowered the init level of this
driver but your consumers are going to have same issue...

> 
> >
> > But why remove __init declaration from these? Whatever purpose that may
> > solve needs to be documented in changelog and perhaps a different patch
> >
> 
> I was thinking that driver can be compiled as module as other driver
> but is bool and not tristate

Ok, but why drop __init()

-- 
~Vinod
