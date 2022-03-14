Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC334D8859
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbiCNPlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242670AbiCNPlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 11:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5566443F7;
        Mon, 14 Mar 2022 08:40:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA2E61274;
        Mon, 14 Mar 2022 15:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6E9C340E9;
        Mon, 14 Mar 2022 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647272437;
        bh=N1ifLpIgpRyYM2X3kH35gK6SnVXZ+nbBy9A+jPeXgNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uD5H4O6+coUBFsCf4fK4LZgvjR2Cd3aTCyXWAd6DT5oWoApFckalq34tQJW0fctXG
         IeCvu+s2eI00ZjmcPTHcNyJh386gwZH72RtkGRCqg/PwQ84CoZF3VGxIG2awuWkl/X
         snPWL9Erf/iijlopvkbv3ImsSKDpeWGUYHQJOOiBbNMlSJFy+lMTMsT8OjMXHoTHsp
         6YPKSfns04BKVKiNaBCx5vHoQ9Imbzjm0WX/5fyq7ORmbXnY7v1cinOnwpjWiKLtxt
         su8Bcm0BZy9Og2Z3yWu6rumprqgU/wer2q2R7DvAjSRXZ7FnY3K01hj07h2scUdTmS
         XKZ2PMSDiyWIg==
Received: by pali.im (Postfix)
        id E242E824; Mon, 14 Mar 2022 16:40:33 +0100 (CET)
Date:   Mon, 14 Mar 2022 16:40:33 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Ziji Hu <huziji@marvell.com>,
        Adrian Hunter <adrian.hunter@intel.com>, jaz@semihalf.com,
        tn@semihalf.com, Kostya Porotchkin <kostap@marvell.com>,
        Alex Leibovich <alexl@marvell.com>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci-xenon: fix 1.8v regulator stabilization
Message-ID: <20220314154033.4x74zscayee32rrj@pali>
References: <20201211141656.24915-1-mw@semihalf.com>
 <CAPDyKFqsSO+f9iG8vccwXZXDDNHgLEg7bfUe-KfHn2C-ZnOU4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFqsSO+f9iG8vccwXZXDDNHgLEg7bfUe-KfHn2C-ZnOU4A@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 11 January 2021 19:06:24 Ulf Hansson wrote:
> On Fri, 11 Dec 2020 at 15:17, Marcin Wojtas <mw@semihalf.com> wrote:
> >
> > From: Alex Leibovich <alexl@marvell.com>
> >
> > Automatic Clock Gating is a feature used for the power
> > consumption optimisation. It turned out that
> > during early init phase it may prevent the stable voltage
> > switch to 1.8V - due to that on some platfroms an endless
> > printout in dmesg can be observed:
> > "mmc1: 1.8V regulator output did not became stable"
> > Fix the problem by disabling the ACG at very beginning
> > of the sdhci_init and let that be enabled later.
> >
> > Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
> > Signed-off-by: Alex Leibovich <alexl@marvell.com>
> > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > Cc: stable@vger.kernel.org
> 
> Applied for fixes (by fixing the typos), thanks!

Hello!

Is not this patch address same issue which was fixed by patch which was
merged earlier?

bb32e1987bc5 ("mmc: sdhci-xenon: fix annoying 1.8V regulator warning")
https://lore.kernel.org/linux-mmc/CAPDyKFqAsvgAjfL-c9ukFNWeGJmufQosR2Eg9SKjXMVpNitdkA@mail.gmail.com/

> Kind regards
> Uffe
> 
> 
> > ---
> >  drivers/mmc/host/sdhci-xenon.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
> > index c67611fdaa8a..4b05f6fdefb4 100644
> > --- a/drivers/mmc/host/sdhci-xenon.c
> > +++ b/drivers/mmc/host/sdhci-xenon.c
> > @@ -168,7 +168,12 @@ static void xenon_reset_exit(struct sdhci_host *host,
> >         /* Disable tuning request and auto-retuning again */
> >         xenon_retune_setup(host);
> >
> > -       xenon_set_acg(host, true);
> > +       /*
> > +        * The ACG should be turned off at the early init time, in order
> > +        * to solve a possile issues with the 1.8V regulator stabilization.
> > +        * The feature is enabled in later stage.
> > +        */
> > +       xenon_set_acg(host, false);
> >
> >         xenon_set_sdclk_off_idle(host, sdhc_id, false);
> >
> > --
> > 2.29.0
> >
