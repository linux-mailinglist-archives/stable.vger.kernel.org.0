Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6A4DDA10
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbiCRNC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiCRNC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928672D8138;
        Fri, 18 Mar 2022 06:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FF461944;
        Fri, 18 Mar 2022 13:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065AC340EC;
        Fri, 18 Mar 2022 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647608464;
        bh=EvKvDWMjPs8RviERmN4Qeb/n64LMap7LOYadKAjVVkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l+9xq6dRn9tlQYW+m4OOpWxHI7gEPhRgznCS5kNtOTBDzB33jtzQaWbJNW6OdJVce
         oPUCf1KO5zzWHz+11/IbsI5USKTJoioW+dmYWVd2pV9yXpol++zuu5EN4UCc1Oq/q9
         dEfqfRF2/NkkeuEyOx3elvJDBBbqIbmCl+F3hDIPSrhJuwK1fk1ChUD5GGncYr1LG4
         2pmmcbJXnJHRQhThQEWvNN3LaOt4WVOiU8mVjQVhIERPEB5mPFbWQbukxE9lk5Hodw
         Kbj9ZUQTrcfWqRsD/RVpSDc5MGBdDMYSIzgZCeMBh2F7k9TxxesknY87E9ors3quyA
         Wrtp28M5fWYFw==
Received: by pali.im (Postfix)
        id 077999CF; Fri, 18 Mar 2022 14:01:00 +0100 (CET)
Date:   Fri, 18 Mar 2022 14:01:00 +0100
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
Message-ID: <20220318130100.zkdaoviwzwhnixuh@pali>
References: <20201211141656.24915-1-mw@semihalf.com>
 <CAPDyKFqsSO+f9iG8vccwXZXDDNHgLEg7bfUe-KfHn2C-ZnOU4A@mail.gmail.com>
 <20220314154033.4x74zscayee32rrj@pali>
 <CAPv3WKc4MFeLgnJMWx=YNT5Ta5yi6fVhb4f-Rf211FTEmkvyog@mail.gmail.com>
 <20220315230333.eyznbu5tuxneizbs@pali>
 <CAPv3WKc96vDsW_duXYMYbr3X05=-p28N5_cf2PHo-tiwDLjaWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKc96vDsW_duXYMYbr3X05=-p28N5_cf2PHo-tiwDLjaWg@mail.gmail.com>
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

On Wednesday 16 March 2022 02:03:35 Marcin Wojtas wrote:
> Hi Pali,
> 
> śr., 16 mar 2022 o 00:03 Pali Rohár <pali@kernel.org> napisał(a):
> >
> > Hello!
> >
> > On Monday 14 March 2022 16:51:25 Marcin Wojtas wrote:
> > > Hi Pali,
> > >
> > >
> > > pon., 14 mar 2022 o 16:40 Pali Rohár <pali@kernel.org> napisał(a):
> > > >
> > > > On Monday 11 January 2021 19:06:24 Ulf Hansson wrote:
> > > > > On Fri, 11 Dec 2020 at 15:17, Marcin Wojtas <mw@semihalf.com> wrote:
> > > > > >
> > > > > > From: Alex Leibovich <alexl@marvell.com>
> > > > > >
> > > > > > Automatic Clock Gating is a feature used for the power
> > > > > > consumption optimisation. It turned out that
> > > > > > during early init phase it may prevent the stable voltage
> > > > > > switch to 1.8V - due to that on some platfroms an endless
> > > > > > printout in dmesg can be observed:
> > > > > > "mmc1: 1.8V regulator output did not became stable"
> > > > > > Fix the problem by disabling the ACG at very beginning
> > > > > > of the sdhci_init and let that be enabled later.
> > > > > >
> > > > > > Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
> > > > > > Signed-off-by: Alex Leibovich <alexl@marvell.com>
> > > > > > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > >
> > > > > Applied for fixes (by fixing the typos), thanks!
> > > >
> > > > Hello!
> > > >
> > > > Is not this patch address same issue which was fixed by patch which was
> > > > merged earlier?
> > > >
> > > > bb32e1987bc5 ("mmc: sdhci-xenon: fix annoying 1.8V regulator warning")
> > > > https://lore.kernel.org/linux-mmc/CAPDyKFqAsvgAjfL-c9ukFNWeGJmufQosR2Eg9SKjXMVpNitdkA@mail.gmail.com/
> > > >
> > >
> > > This indeed look similar. This fix was originally developed for CN913x
> > > platform without the mentioned patch (I'm wondering if it would also
> > > suffice to fix A3k board's problem). Anyway, I don't think we have an
> > > issue here, as everything seems to work fine on top of mainline Linux
> > > with both changes.
> >
> > Yea, there should be no issue. Just question is if we need _both_ fixes.
> >
> > I could probably try to revert bb32e1987bc5 and check what happens on
> > A3k board.
> >
> 
> Yes, that would be interesting. Please let me know whenever you find
> time to check.

Hello! Now I tested kernel with reverted commit bb32e1987bc5 ("mmc:
sdhci-xenon: fix annoying 1.8V regulator warning") and issue is still
fixed. I reverted also bb32e1987bc5 ("mmc: sdhci-xenon: fix annoying
1.8V regulator warning") commit and then issue appeared again.

So any of this commit is fixing that issue on Armada 3720.

Should we revert one of them?

> Best regards,
> Marcin
> 
> > > > >
> > > > >
> > > > > > ---
> > > > > >  drivers/mmc/host/sdhci-xenon.c | 7 ++++++-
> > > > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
> > > > > > index c67611fdaa8a..4b05f6fdefb4 100644
> > > > > > --- a/drivers/mmc/host/sdhci-xenon.c
> > > > > > +++ b/drivers/mmc/host/sdhci-xenon.c
> > > > > > @@ -168,7 +168,12 @@ static void xenon_reset_exit(struct sdhci_host *host,
> > > > > >         /* Disable tuning request and auto-retuning again */
> > > > > >         xenon_retune_setup(host);
> > > > > >
> > > > > > -       xenon_set_acg(host, true);
> > > > > > +       /*
> > > > > > +        * The ACG should be turned off at the early init time, in order
> > > > > > +        * to solve a possile issues with the 1.8V regulator stabilization.
> > > > > > +        * The feature is enabled in later stage.
> > > > > > +        */
> > > > > > +       xenon_set_acg(host, false);
> > > > > >
> > > > > >         xenon_set_sdclk_off_idle(host, sdhc_id, false);
> > > > > >
> > > > > > --
> > > > > > 2.29.0
> > > > > >
