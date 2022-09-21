Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ED45BF43F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiIUDXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUDXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:23:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBFE79682;
        Tue, 20 Sep 2022 20:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CEBEB81F18;
        Wed, 21 Sep 2022 03:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEA0C433C1;
        Wed, 21 Sep 2022 03:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663730607;
        bh=tzVpyonWg2wvFH3/Tacs6bLOU6Y//b6mvOx4iigfXC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qFGCUK8m6XOUqC/W+RPNcW+hzltTEWYhYLsC6vn4QcZPjK7X/Q5v3Wsp4DyO6mCW/
         HF8J6fSLb1o7u230pOMgYHPX6FPWLl2wnsbYZM0zlhiS3bMCKX/wc10qCFnh9fHEPL
         T4Ib6VjDiUBmnvpJyBSlYSRcVZ9M1faIp5p+PkUK0lLxPcjnIxLXFbZj9kcDdFF7v4
         u+MUM1HmwkR2KU3gJi4bhpYpCMuuuoR5kPYPKoIIxQa4J+L9rcacuznW+FRhQTT+4v
         kiCGgwjJ+RzKyCYHo/qTr6CZ2gjfAe15zub+B71pDMEWWD6dDKxVd41nql+PuI8NFA
         8mq4Dgxi8Qajg==
Date:   Wed, 21 Sep 2022 08:53:23 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [RESEND PATCH v5 1/2] dmaengine: mxs: use
 platform_driver_register
Message-ID: <YyqDq9FL1W5gMveQ@matsya>
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
 <20220913163510.GR6477@pengutronix.de>
 <CABGWkvpur+A1UHwhJ6CCStyaYH79_aqJo4eWOW-s1p2jakbFMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABGWkvpur+A1UHwhJ6CCStyaYH79_aqJo4eWOW-s1p2jakbFMA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-09-22, 19:10, Dario Binacchi wrote:
> Hi Vinoud,
> 
> On Tue, Sep 13, 2022 at 6:35 PM Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >
> > Hi Dario,
> >
> > On Sun, Sep 04, 2022 at 04:10:19PM +0200, Dario Binacchi wrote:
> > > Driver registration fails on SOC imx8mn as its supplier, the clock
> > > control module, is probed later than subsys initcall level. This driver
> > > uses platform_driver_probe which is not compatible with deferred probing
> > > and won't be probed again later if probe function fails due to clock not
> > > being available at that time.
> > >
> > > This patch replaces the use of platform_driver_probe with
> > > platform_driver_register which will allow probing the driver later again
> > > when the clock control module will be available.
> > >
> > > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > Cc: stable@vger.kernel.org
> >
> > How I see it v3 of this patch is perfectly fine and should be taken
> > instead of this one. I just commented that to v3.
> >
> > Not sure if Vinod would take v3, or if you should resend v3 as v6
> > instead. If you do, you can add my Acked-by.
> >
> > Vinod, please let us know what you prefer.
> 
> Could you please let me know how to proceed? This patch has been pending for
> a while and it's a real shame as the change is minimal and fixes a
> real issue that is
> still present in the mainline and stable kernels.

Ooops, Somehow this seems to have really slipped. Sorry I owe you an
apology for this

I am still not sure of this patch yet, lets get it right and merged
quickly. I will send my review later today

-- 
~Vinod
