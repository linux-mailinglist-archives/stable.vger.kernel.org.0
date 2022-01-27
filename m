Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46B49DBB4
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiA0HeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:34:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58104 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiA0HeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 02:34:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2AFB0CE2109;
        Thu, 27 Jan 2022 07:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0A5C340E4;
        Thu, 27 Jan 2022 07:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643268837;
        bh=99uVPzaahdu2LLS3zdhU8BqoM2kwwQywXPkVSB8TZ4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uX5vERj7n5vVUDhrDUKuIh/pvAAqh2OOLqMpocrU0vvo/JQN17hEK2U5ih2DyVGM9
         Lg450e8c4w8/N+JnHiZSXRDskDWag22hq/9dqP7bUBze51SZz4mfssUJOiJYZsCvp+
         zuQhdqZA7+Xow+VeWuU500xM5IdkUWxMMThs4JwY=
Date:   Thu, 27 Jan 2022 08:33:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        linux-mmc@vger.kernel.org, stable <stable@vger.kernel.org>,
        whitehat002 <hackyzh002@gmail.com>
Subject: Re: [PATCH] moxart: fix potential use-after-free on remove path
Message-ID: <YfJK4tRVPFszo+z3@kroah.com>
References: <20220114075934.302464-1-gregkh@linuxfoundation.org>
 <CAPDyKFpu0mGchoqdzE-qKc6=9ogncnTCwN8AR7g1wcMZLyRFsw@mail.gmail.com>
 <Yeq7H0LSegfCNHzl@kroah.com>
 <CAPDyKFrQ+1icC-qO6Oo4DAhZYVt9oOSZiKs0qRFMwKdq5=X1Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFrQ+1icC-qO6Oo4DAhZYVt9oOSZiKs0qRFMwKdq5=X1Hw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 03:24:05PM +0100, Ulf Hansson wrote:
> On Fri, 21 Jan 2022 at 14:54, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jan 21, 2022 at 01:41:27PM +0100, Ulf Hansson wrote:
> > > On Fri, 14 Jan 2022 at 08:59, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > It was reported that the mmc host structure could be accessed after it
> > > > was freed in moxart_remove(), so fix this by saving the base register of
> > > > the device and using it instead of the pointer dereference.
> > > >
> > > > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > > > Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> > > > Cc: Xin Xiong <xiongx18@fudan.edu.cn>
> > > > Cc: Xin Tan <tanxin.ctf@gmail.com>
> > > > Cc: Tony Lindgren <tony@atomide.com>
> > > > Cc: Yang Li <yang.lee@linux.alibaba.com>
> > > > Cc: linux-mmc@vger.kernel.org
> > > > Cc: stable <stable@vger.kernel.org>
> > > > Reported-by: whitehat002 <hackyzh002@gmail.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  drivers/mmc/host/moxart-mmc.c | 9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
> > > > index 16d1c7a43d33..f5d96940a9b8 100644
> > > > --- a/drivers/mmc/host/moxart-mmc.c
> > > > +++ b/drivers/mmc/host/moxart-mmc.c
> > > > @@ -697,6 +697,7 @@ static int moxart_remove(struct platform_device *pdev)
> > > >  {
> > > >         struct mmc_host *mmc = dev_get_drvdata(&pdev->dev);
> > > >         struct moxart_host *host = mmc_priv(mmc);
> > > > +       void __iomem *base = host->base;
> > > >
> > > >         dev_set_drvdata(&pdev->dev, NULL);
> > > >
> > > > @@ -707,10 +708,10 @@ static int moxart_remove(struct platform_device *pdev)
> > > >         mmc_remove_host(mmc);
> > > >         mmc_free_host(mmc);
> > > >
> > > > -       writel(0, host->base + REG_INTERRUPT_MASK);
> > > > -       writel(0, host->base + REG_POWER_CONTROL);
> > > > -       writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
> > > > -              host->base + REG_CLOCK_CONTROL);
> > >
> > > Rather than doing it like this, I think it would be easier to move
> > > mmc_free_host() below this part. That's usually what mmc host drivers
> > > do clean up things in ->remove().
> > >
> > > > +       writel(0, base + REG_INTERRUPT_MASK);
> > > > +       writel(0, base + REG_POWER_CONTROL);
> > > > +       writel(readl(base + REG_CLOCK_CONTROL) | CLK_OFF,
> > > > +              base + REG_CLOCK_CONTROL);
> > > >
> >
> > Ok, I can do that, I didn't know if it would cause any functionality
> > changes, so I was trying to preserve the same logic that the driver
> > currently has.
> 
> Yes, but it's most likely just a simple mistake that was made by the
> original author.
> 
> >
> > Do you have this device to test this with?
> 
> No, I don't.
> 
> Although, I am confident that it should work fine too.

Great, now sent v2:
	https://lore.kernel.org/r/20220127071638.4057899-1-gregkh@linuxfoundation.org
