Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60BE496003
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 14:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350568AbiAUNyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 08:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350341AbiAUNyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 08:54:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72924C061574;
        Fri, 21 Jan 2022 05:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59A84616F0;
        Fri, 21 Jan 2022 13:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B912C340E1;
        Fri, 21 Jan 2022 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642773287;
        bh=MsGTfQONatWIvmB+ivBn7GztIxbSTJkJ4CdpKN2PPh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g91iKuk5lY+J2J7MmuPExW4S7EYjj/FcXwJYf7QI9502AbYrToyaXIblqIXbeHsaT
         gHBa5SHiFz2fP5gEiIbEE0WgIN1kpgLj2uK2m3cc/+fXBS/6kDB420Ow1mL1jmVknt
         ieKCl7zu846j+LYjAz+1qU+wBOSeVEmPq8gGpFqs=
Date:   Fri, 21 Jan 2022 14:54:39 +0100
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
Message-ID: <Yeq7H0LSegfCNHzl@kroah.com>
References: <20220114075934.302464-1-gregkh@linuxfoundation.org>
 <CAPDyKFpu0mGchoqdzE-qKc6=9ogncnTCwN8AR7g1wcMZLyRFsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpu0mGchoqdzE-qKc6=9ogncnTCwN8AR7g1wcMZLyRFsw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 01:41:27PM +0100, Ulf Hansson wrote:
> On Fri, 14 Jan 2022 at 08:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > It was reported that the mmc host structure could be accessed after it
> > was freed in moxart_remove(), so fix this by saving the base register of
> > the device and using it instead of the pointer dereference.
> >
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> > Cc: Xin Xiong <xiongx18@fudan.edu.cn>
> > Cc: Xin Tan <tanxin.ctf@gmail.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Yang Li <yang.lee@linux.alibaba.com>
> > Cc: linux-mmc@vger.kernel.org
> > Cc: stable <stable@vger.kernel.org>
> > Reported-by: whitehat002 <hackyzh002@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/mmc/host/moxart-mmc.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
> > index 16d1c7a43d33..f5d96940a9b8 100644
> > --- a/drivers/mmc/host/moxart-mmc.c
> > +++ b/drivers/mmc/host/moxart-mmc.c
> > @@ -697,6 +697,7 @@ static int moxart_remove(struct platform_device *pdev)
> >  {
> >         struct mmc_host *mmc = dev_get_drvdata(&pdev->dev);
> >         struct moxart_host *host = mmc_priv(mmc);
> > +       void __iomem *base = host->base;
> >
> >         dev_set_drvdata(&pdev->dev, NULL);
> >
> > @@ -707,10 +708,10 @@ static int moxart_remove(struct platform_device *pdev)
> >         mmc_remove_host(mmc);
> >         mmc_free_host(mmc);
> >
> > -       writel(0, host->base + REG_INTERRUPT_MASK);
> > -       writel(0, host->base + REG_POWER_CONTROL);
> > -       writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
> > -              host->base + REG_CLOCK_CONTROL);
> 
> Rather than doing it like this, I think it would be easier to move
> mmc_free_host() below this part. That's usually what mmc host drivers
> do clean up things in ->remove().
> 
> > +       writel(0, base + REG_INTERRUPT_MASK);
> > +       writel(0, base + REG_POWER_CONTROL);
> > +       writel(readl(base + REG_CLOCK_CONTROL) | CLK_OFF,
> > +              base + REG_CLOCK_CONTROL);
> >

Ok, I can do that, I didn't know if it would cause any functionality
changes, so I was trying to preserve the same logic that the driver
currently has.

Do you have this device to test this with?

thanks,

greg k-h
