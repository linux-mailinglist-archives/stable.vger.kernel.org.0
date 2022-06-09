Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6954438D
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 08:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiFIGHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 02:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFIGHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 02:07:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCD638BF6;
        Wed,  8 Jun 2022 23:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6705B82C3B;
        Thu,  9 Jun 2022 06:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E2C34114;
        Thu,  9 Jun 2022 06:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654754833;
        bh=wYbwwJ+Aa+HpKBoymvEz/JHg6apC+/opk1EDP3A0QfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i8ygFyHyqvX/0nadMHVjSaMWmmk3FjVdojRZ+zovP5wvdC7zoeu9imws2SgVNDy/Y
         kQT89YpEDHpTkfhifdyLQyo/aGoA/mOI+8Hn14MCak9Vhbjyju86e6HvJloT/0dTmu
         j4gMA7WjcK7IWNOy/h0me6WJMmG6Q2c4z4CWFjY/qwDZPTwCEYL55UOZ2zPTBvPv8v
         S69x4O9Iw8z9mumUdS71+s3+RWtvcXL1sCrosaZwSrbckGJ3YIMCK4R1Qh2DUv1vkO
         DGQGKKfKinLaYKjwpBsIrvaE0n7Svl1AYvkinQugbEosbfwIte8EbjR+z3cYPMdHUh
         KfTlMB2ihpFtw==
Date:   Thu, 9 Jun 2022 11:37:08 +0530
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
Message-ID: <YqGODNACHfKKHBOf@matsya>
References: <20220607095829.1035903-1-dario.binacchi@amarulasolutions.com>
 <YqGJnORzbp2xiEU3@matsya>
 <CAOf5uwkxit8kAAmwWGgTqR57m_SRmAxere10rCucOuBHU5+8fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOf5uwkxit8kAAmwWGgTqR57m_SRmAxere10rCucOuBHU5+8fw@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09-06-22, 08:01, Michael Nazzareno Trimarchi wrote:
> Hi
> 
> On Thu, Jun 9, 2022 at 7:48 AM Vinod Koul <vkoul@kernel.org> wrote:
> >
> > On 07-06-22, 11:58, Dario Binacchi wrote:
> > > Driver registration fails on SOC imx8mn as its supplier, the clock
> > > control module, is not ready. Since platform_driver_probe(), as
> > > reported by its description, is incompatible with deferred probing,
> > > we have to use platform_driver_register().
> > >
> > > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > Cc: stable@vger.kernel.org
> > >
> > > ---
> > >
> > > Changes in v2:
> > > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> > >
> > >  drivers/dma/mxs-dma.c | 11 ++++-------
> > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > > index 994fc4d2aca4..b8a3e692330d 100644
> > > --- a/drivers/dma/mxs-dma.c
> > > +++ b/drivers/dma/mxs-dma.c
> > > @@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
> > >       return mxs_chan->status;
> > >  }
> > >
> > > -static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > > +static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> >
> > why drop __init for these...?
> >
> 
> I think that you refer to the fact that it can not be compiled as a
> module, am I right?

It is still declared as a module_platform_driver... From changelog I can
understand that you are changing init level from subsys to module (in
fact clocks should be moved up as arch level and dmaengine users as
module) ...

But why remove __init declaration from these? Whatever purpose that may
solve needs to be documented in changelog and perhaps a different patch


> 
> Michael
> 
> > >  {
> > >       int ret;
> > >
> > > @@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
> > >                                    ofdma->of_node);
> > >  }
> > >
> > > -static int __init mxs_dma_probe(struct platform_device *pdev)
> > > +static int mxs_dma_probe(struct platform_device *pdev)
> > >  {
> > >       struct device_node *np = pdev->dev.of_node;
> > >       const struct mxs_dma_type *dma_type;
> > > @@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
> > >               .name   = "mxs-dma",
> > >               .of_match_table = mxs_dma_dt_ids,
> > >       },
> > > +     .probe = mxs_dma_probe,
> > >  };
> > >
> > > -static int __init mxs_dma_module_init(void)
> > > -{
> > > -     return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> > > -}
> >
> > > -subsys_initcall(mxs_dma_module_init);
> > > +module_platform_driver(mxs_dma_driver);
> > > --
> > > 2.32.0
> >
> > --
> > ~Vinod

-- 
~Vinod
