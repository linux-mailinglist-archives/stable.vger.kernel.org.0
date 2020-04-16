Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1E51ABF91
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 13:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505897AbgDPLhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 07:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506463AbgDPLhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 07:37:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00DA20656;
        Thu, 16 Apr 2020 11:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587037054;
        bh=D6KNpcqoqW+wtZeb9+UJQvNuWWMAtdxBSNCcqPr1D9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rhZni2XChkGutHtdBgN6CzWEqzyRe34NxV7qTHe02YEwxPFPYq64ZsTGUjc3U7biV
         RrB51+YUHAUGMLEzX7v7wX4jcqtgnyLbzxWzyR9Ta79V4v/30sLjR8jpm71TthLj/o
         qE12jM0VcF3eHKXpgW6R1GrE+ADCoS4RqP/iXJlI=
Date:   Thu, 16 Apr 2020 13:37:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "(Exiting) Baolin Wang" <baolin.wang@linaro.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bradley Bolen <bradleybolen@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Aniruddha Tvs Rao <anrao@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] sdhci: tegra: Implement Tegra specific
 set_timeout callback
Message-ID: <20200416113732.GA882109@kroah.com>
References: <1583886030-11339-1-git-send-email-skomatineni@nvidia.com>
 <CA+G9fYvreAv5HmZg0O4VvLvf_PYSvzD1rp08XONNQGExctgQ0Q@mail.gmail.com>
 <CAPDyKFpZEiqTdD6O-y6Sw7ifXF__MHAv0zKT=RFKs+Fmvr-K_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpZEiqTdD6O-y6Sw7ifXF__MHAv0zKT=RFKs+Fmvr-K_Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 12:59:06PM +0200, Ulf Hansson wrote:
> On Wed, 15 Apr 2020 at 19:55, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Fri, 13 Mar 2020 at 06:41, Sowjanya Komatineni
> > <skomatineni@nvidia.com> wrote:
> > >
> > > Tegra host supports HW busy detection and timeouts based on the
> > > count programmed in SDHCI_TIMEOUT_CONTROL register and max busy
> > > timeout it supports is 11s in finite busy wait mode.
> > >
> > > Some operations like SLEEP_AWAKE, ERASE and flush cache through
> > > SWITCH commands take longer than 11s and Tegra host supports
> > > infinite HW busy wait mode where HW waits forever till the card
> > > is busy without HW timeout.
> > >
> > > This patch implements Tegra specific set_timeout sdhci_ops to allow
> > > switching between finite and infinite HW busy detection wait modes
> > > based on the device command expected operation time.
> > >
> > > Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> > > ---
> > >  drivers/mmc/host/sdhci-tegra.c | 31 +++++++++++++++++++++++++++++++
> > >  1 file changed, 31 insertions(+)
> > >
> > > diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> > > index a25c3a4..fa8f6a4 100644
> > > --- a/drivers/mmc/host/sdhci-tegra.c
> > > +++ b/drivers/mmc/host/sdhci-tegra.c
> > > @@ -45,6 +45,7 @@
> > >  #define SDHCI_TEGRA_CAP_OVERRIDES_DQS_TRIM_SHIFT       8
> > >
> > >  #define SDHCI_TEGRA_VENDOR_MISC_CTRL                   0x120
> > > +#define SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT            BIT(0)
> > >  #define SDHCI_MISC_CTRL_ENABLE_SDR104                  0x8
> >
> > >  #define SDHCI_MISC_CTRL_ENABLE_SDR50                   0x10
> > >  #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300          0x20
> > > @@ -1227,6 +1228,34 @@ static u32 sdhci_tegra_cqhci_irq(struct sdhci_host *host, u32 intmask)
> > >         return 0;
> > >  }
> > >
> > > +static void tegra_sdhci_set_timeout(struct sdhci_host *host,
> > > +                                   struct mmc_command *cmd)
> > > +{
> > > +       u32 val;
> > > +
> > > +       /*
> > > +        * HW busy detection timeout is based on programmed data timeout
> > > +        * counter and maximum supported timeout is 11s which may not be
> > > +        * enough for long operations like cache flush, sleep awake, erase.
> > > +        *
> > > +        * ERASE_TIMEOUT_LIMIT bit of VENDOR_MISC_CTRL register allows
> > > +        * host controller to wait for busy state until the card is busy
> > > +        * without HW timeout.
> > > +        *
> > > +        * So, use infinite busy wait mode for operations that may take
> > > +        * more than maximum HW busy timeout of 11s otherwise use finite
> > > +        * busy wait mode.
> > > +        */
> > > +       val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> > > +       if (cmd && cmd->busy_timeout >= 11 * HZ)
> > > +               val |= SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> > > +       else
> > > +               val &= ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> > > +       sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> > > +
> > > +       __sdhci_set_timeout(host, cmd);
> >
> > kernel build on arm and arm64 architecture failed on stable-rc 4.19
> > (arm), 5.4 (arm64) and 5.5 (arm64)
> >
> > drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
> > drivers/mmc/host/sdhci-tegra.c:1256:2: error: implicit declaration of
> > function '__sdhci_set_timeout'; did you mean
> > 'tegra_sdhci_set_timeout'? [-Werror=implicit-function-declaration]
> >   __sdhci_set_timeout(host, cmd);
> >   ^~~~~~~~~~~~~~~~~~~
> >   tegra_sdhci_set_timeout
> >
> > Full build log,
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/83/consoleText
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=juno,label=docker-lkft/158/consoleText
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/511/consoleText
> >
> > - Naresh
> 
> Thanks for reporting! What a mess.
> 
> It turns out that the commit that was queued for stable that is
> causing the above errors, also requires another commit.
> 
> The commit that was queued:
> 5e958e4aacf4 ("sdhci: tegra: Implement Tegra specific set_timeout callback")
> 
> The additional commit needed (which was added in v5.6-rc1):
> 7d76ed77cfbd ("mmc: sdhci: Refactor sdhci_set_timeout()")
> 
> However, the above commit needs a manual backport (quite trivial, but
> still) for the relevant stable kernels, to allow it to solve the build
> problems.
> 
> Greg, Sasha - I suggest you to drop the offending commit from the
> stable kernels, for now. I think it's better to let Sowjanya deal with
> the backports, then send them in small series instead.

Thanks for this, now dropped.

greg k-h
