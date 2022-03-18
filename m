Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3D4DDA1F
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbiCRNHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiCRNHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:07:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C02241CE;
        Fri, 18 Mar 2022 06:06:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81FC6195F;
        Fri, 18 Mar 2022 13:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07992C340E8;
        Fri, 18 Mar 2022 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647608778;
        bh=M9ITTZm/eOgP+09UyLrk/yabCIkGSszZ5U1+MT684bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t/na1wi7PgW+CvqPglEwByXWrLtwko01+8u4TB4FmOzOVGEp0qqO8AbqUMFgysuUL
         riSpm4OR+I70iySgeIajfadrKUgQy4FGLGTryH3Y3dqfStVftWpyf2u+Gdzl3mAcZc
         C0ajj3iJBfVot3DeoK5werdIMTWyQzgjt9VMUyj2ce5H/GFnaNscCiXDszyVo4aHAA
         oW881fEiYoCldgstuS/gTn+z3VkqVO5KgKPxpYBgRDjY6gpeERtgcU9tFSKlyK2vdL
         aElz3gCTZt+1sQbSeWWXV+tJQGCKYjv9DWGNsmzCbOKYrC7OwjLoOUuh56YuhvLb9U
         0CTYZCWu8nHEQ==
Received: by pali.im (Postfix)
        id 376869CF; Fri, 18 Mar 2022 14:06:15 +0100 (CET)
Date:   Fri, 18 Mar 2022 14:06:15 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Ziji Hu <huziji@marvell.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Kostya Porotchkin <kostap@marvell.com>,
        Alex Leibovich <alexl@marvell.com>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci-xenon: fix 1.8v regulator stabilization
Message-ID: <20220318130615.hwa5fhzf2cyquwzr@pali>
References: <20201211141656.24915-1-mw@semihalf.com>
 <CAPDyKFqsSO+f9iG8vccwXZXDDNHgLEg7bfUe-KfHn2C-ZnOU4A@mail.gmail.com>
 <20220314154033.4x74zscayee32rrj@pali>
 <CAPv3WKc4MFeLgnJMWx=YNT5Ta5yi6fVhb4f-Rf211FTEmkvyog@mail.gmail.com>
 <20220315230333.eyznbu5tuxneizbs@pali>
 <CAPv3WKc96vDsW_duXYMYbr3X05=-p28N5_cf2PHo-tiwDLjaWg@mail.gmail.com>
 <20220318130100.zkdaoviwzwhnixuh@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318130100.zkdaoviwzwhnixuh@pali>
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

On Friday 18 March 2022 14:01:00 Pali Rohár wrote:
> On Wednesday 16 March 2022 02:03:35 Marcin Wojtas wrote:
> > Hi Pali,
> > 
> > śr., 16 mar 2022 o 00:03 Pali Rohár <pali@kernel.org> napisał(a):
> > >
> > > Hello!
> > >
> > > On Monday 14 March 2022 16:51:25 Marcin Wojtas wrote:
> > > > Hi Pali,
> > > >
> > > >
> > > > pon., 14 mar 2022 o 16:40 Pali Rohár <pali@kernel.org> napisał(a):
> > > > >
> > > > > On Monday 11 January 2021 19:06:24 Ulf Hansson wrote:
> > > > > > On Fri, 11 Dec 2020 at 15:17, Marcin Wojtas <mw@semihalf.com> wrote:
> > > > > > >
> > > > > > > From: Alex Leibovich <alexl@marvell.com>
> > > > > > >
> > > > > > > Automatic Clock Gating is a feature used for the power
> > > > > > > consumption optimisation. It turned out that
> > > > > > > during early init phase it may prevent the stable voltage
> > > > > > > switch to 1.8V - due to that on some platfroms an endless
> > > > > > > printout in dmesg can be observed:
> > > > > > > "mmc1: 1.8V regulator output did not became stable"
> > > > > > > Fix the problem by disabling the ACG at very beginning
> > > > > > > of the sdhci_init and let that be enabled later.
> > > > > > >
> > > > > > > Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
> > > > > > > Signed-off-by: Alex Leibovich <alexl@marvell.com>
> > > > > > > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > > > > > > Cc: stable@vger.kernel.org
> > > > > >
> > > > > > Applied for fixes (by fixing the typos), thanks!
> > > > >
> > > > > Hello!
> > > > >
> > > > > Is not this patch address same issue which was fixed by patch which was
> > > > > merged earlier?
> > > > >
> > > > > bb32e1987bc5 ("mmc: sdhci-xenon: fix annoying 1.8V regulator warning")
> > > > > https://lore.kernel.org/linux-mmc/CAPDyKFqAsvgAjfL-c9ukFNWeGJmufQosR2Eg9SKjXMVpNitdkA@mail.gmail.com/
> > > > >
> > > >
> > > > This indeed look similar. This fix was originally developed for CN913x
> > > > platform without the mentioned patch (I'm wondering if it would also
> > > > suffice to fix A3k board's problem). Anyway, I don't think we have an
> > > > issue here, as everything seems to work fine on top of mainline Linux
> > > > with both changes.
> > >
> > > Yea, there should be no issue. Just question is if we need _both_ fixes.
> > >
> > > I could probably try to revert bb32e1987bc5 and check what happens on
> > > A3k board.
> > >
> > 
> > Yes, that would be interesting. Please let me know whenever you find
> > time to check.
> 
> Hello! Now I tested kernel with reverted commit bb32e1987bc5 ("mmc:
> sdhci-xenon: fix annoying 1.8V regulator warning") and issue is still
> fixed. I reverted also bb32e1987bc5 ("mmc: sdhci-xenon: fix annoying
> 1.8V regulator warning") commit and then issue appeared again.

I mean that I reverted also 1a3ed0dc3594 ("mmc: sdhci-xenon: fix 1.8v
regulator stabilization") commit and then issue appeared again.

> So any of this commit is fixing that issue on Armada 3720.
> 
> Should we revert one of them?
> 
> > Best regards,
> > Marcin
> > 
> > > > > >
> > > > > >
> > > > > > > ---
> > > > > > >  drivers/mmc/host/sdhci-xenon.c | 7 ++++++-
> > > > > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
> > > > > > > index c67611fdaa8a..4b05f6fdefb4 100644
> > > > > > > --- a/drivers/mmc/host/sdhci-xenon.c
> > > > > > > +++ b/drivers/mmc/host/sdhci-xenon.c
> > > > > > > @@ -168,7 +168,12 @@ static void xenon_reset_exit(struct sdhci_host *host,
> > > > > > >         /* Disable tuning request and auto-retuning again */
> > > > > > >         xenon_retune_setup(host);
> > > > > > >
> > > > > > > -       xenon_set_acg(host, true);
> > > > > > > +       /*
> > > > > > > +        * The ACG should be turned off at the early init time, in order
> > > > > > > +        * to solve a possile issues with the 1.8V regulator stabilization.
> > > > > > > +        * The feature is enabled in later stage.
> > > > > > > +        */
> > > > > > > +       xenon_set_acg(host, false);
> > > > > > >
> > > > > > >         xenon_set_sdclk_off_idle(host, sdhc_id, false);
> > > > > > >
> > > > > > > --
> > > > > > > 2.29.0
> > > > > > >
