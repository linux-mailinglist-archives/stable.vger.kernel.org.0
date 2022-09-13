Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01595B7662
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiIMQXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiIMQXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:23:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBD8A925A
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 08:17:55 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oY7e1-0005K2-JO; Tue, 13 Sep 2022 17:16:13 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oY7e1-0001yU-1A; Tue, 13 Sep 2022 17:16:13 +0200
Date:   Tue, 13 Sep 2022 17:16:12 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] dmaengine: mxs: fix driver registering
Message-ID: <20220913151612.GI12909@pengutronix.de>
References: <20220614101751.3636028-1-dario.binacchi@amarulasolutions.com>
 <Yqs3E0ipEpsCT2T2@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqs3E0ipEpsCT2T2@matsya>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vinod,

On Thu, Jun 16, 2022 at 06:58:43AM -0700, Vinod Koul wrote:
> On 14-06-22, 12:17, Dario Binacchi wrote:
> > Driver registration fails on SOC imx8mn as its supplier, the clock
> > control module, is not ready. Since platform_driver_probe(), as
> > reported by its description, is incompatible with deferred probing,
> > we have to use platform_driver_register().
> > 
> > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> > 
> > Changes in v3:
> > - Restore __init in front of mxs_dma_init() definition.
> > 
> > Changes in v2:
> > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> > 
> >  drivers/dma/mxs-dma.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > index 994fc4d2aca4..6e90540fedc4 100644
> > --- a/drivers/dma/mxs-dma.c
> > +++ b/drivers/dma/mxs-dma.c
> > @@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
> >  				     ofdma->of_node);
> >  }
> >  
> > -static int __init mxs_dma_probe(struct platform_device *pdev)
> > +static int mxs_dma_probe(struct platform_device *pdev)
> 
> why drop __init here, if there is a reason for that please split this
> change and document such reason...

The reason for dropping __init comes with this patch. With
platform_driver_probe() the probe function is called only once, during
init time. The problem with platform_driver_probe() is that the probe
function will never be called again when it initially returns
-EPROBE_DEFER. That's a problem for Dario: The clock is not yet
available, the driver defers probe and will never be probed again
when the clock is finally available.

With platform_driver_register() to which this patch switches to the
probe function can be called at any time, thus __init has to be removed.

For what it's worth:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

for this patch.

Sascha

> 
> >  {
> >  	struct device_node *np = pdev->dev.of_node;
> >  	const struct mxs_dma_type *dma_type;
> > @@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
> >  		.name	= "mxs-dma",
> >  		.of_match_table = mxs_dma_dt_ids,
> >  	},
> > +	.probe = mxs_dma_probe,
> >  };
> >  
> > -static int __init mxs_dma_module_init(void)
> > -{
> > -	return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> > -}
> > -subsys_initcall(mxs_dma_module_init);
> > +module_platform_driver(mxs_dma_driver);
> > -- 
> > 2.32.0
> 
> -- 
> ~Vinod
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
