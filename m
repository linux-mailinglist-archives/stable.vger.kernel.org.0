Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E955BFC7D
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiIUKj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 06:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiIUKjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 06:39:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D775315735
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 03:39:46 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oax8d-0003B3-Nx; Wed, 21 Sep 2022 12:39:31 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oax8c-0007fE-T1; Wed, 21 Sep 2022 12:39:30 +0200
Date:   Wed, 21 Sep 2022 12:39:30 +0200
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
Subject: Re: [RESEND PATCH v5 1/2] dmaengine: mxs: use
 platform_driver_register
Message-ID: <20220921103930.GM12909@pengutronix.de>
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
 <20220913163510.GR6477@pengutronix.de>
 <CABGWkvpur+A1UHwhJ6CCStyaYH79_aqJo4eWOW-s1p2jakbFMA@mail.gmail.com>
 <YyqDq9FL1W5gMveQ@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyqDq9FL1W5gMveQ@matsya>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 08:53:23AM +0530, Vinod Koul wrote:
> On 20-09-22, 19:10, Dario Binacchi wrote:
> > Hi Vinoud,
> > 
> > On Tue, Sep 13, 2022 at 6:35 PM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > >
> > > Hi Dario,
> > >
> > > On Sun, Sep 04, 2022 at 04:10:19PM +0200, Dario Binacchi wrote:
> > > > Driver registration fails on SOC imx8mn as its supplier, the clock
> > > > control module, is probed later than subsys initcall level. This driver
> > > > uses platform_driver_probe which is not compatible with deferred probing
> > > > and won't be probed again later if probe function fails due to clock not
> > > > being available at that time.
> > > >
> > > > This patch replaces the use of platform_driver_probe with
> > > > platform_driver_register which will allow probing the driver later again
> > > > when the clock control module will be available.
> > > >
> > > > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > > Cc: stable@vger.kernel.org
> > >
> > > How I see it v3 of this patch is perfectly fine and should be taken
> > > instead of this one. I just commented that to v3.
> > >
> > > Not sure if Vinod would take v3, or if you should resend v3 as v6
> > > instead. If you do, you can add my Acked-by.
> > >
> > > Vinod, please let us know what you prefer.
> > 
> > Could you please let me know how to proceed? This patch has been pending for
> > a while and it's a real shame as the change is minimal and fixes a
> > real issue that is
> > still present in the mainline and stable kernels.
> 
> Ooops, Somehow this seems to have really slipped. Sorry I owe you an
> apology for this
> 
> I am still not sure of this patch yet, lets get it right and merged
> quickly. I will send my review later today

I just realized that unlike what I said v3 of this patch is still wrong
as it leaves the __init annotation on mxs_dma_init() which is called
from (non __init) mxs_dma_probe(). v3 probably doesn't give a section
mismatch warning because mxs_dma_init() is inlined.

Really v2 is the one we should take which is at:

https://lore.kernel.org/linux-arm-kernel/20220523132247.1429321-1-dario.binacchi@amarulasolutions.com/T/

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
