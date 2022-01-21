Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5094960A4
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 15:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350863AbiAUOYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 09:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350836AbiAUOYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 09:24:43 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658C8C061401
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 06:24:43 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id x11so34257204lfa.2
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 06:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ywlwYoLbVf66LRPVuDML6JrCxAFNet8eWQAIvhQatmI=;
        b=qg8MdUSveB3cicbEbA4Xzu5xhxuj+XfY2gmAtK4tDPnW8hav3LfEpO5sNceEsOP5l8
         0sjy3R/c5F3T0t/KtKd3MN3INWMX9kEFWyYO2ZADALWN2/SoqJftcCgqtnvc3DjWEKPt
         qWVyuke7X4TULIcEe7nua8polewLRlKpBWrcU17zl/+EXRvQ2o5uPy702m4D1NLue4r/
         gpXE/cBs6cqjeG4B66T9dZV/Y5sF+4wmxB9FiD2nlXd2Bf3QjdZzlf3hWTZ/JzH4OoBp
         vVtNpE92Ifuxt2oJobhaiRhEsspameHi5y6rm2TMqQhQb+YwOQzCAUTdTV8shOcB9Z3t
         abFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ywlwYoLbVf66LRPVuDML6JrCxAFNet8eWQAIvhQatmI=;
        b=lyP1a91Arvv47Aa9J46heAVkECPZ9xfq2M9wuxADcqSnZCQoZu3P2mo0+dPcWJfnm2
         KIM891Zn5ov+Z/Q5sLrt3Pacc9PbqaZbi5zOA4+ndzKyq/0HmiagLCrDkpcQzMCUwvPa
         gP6hWBg+/QyWOKJYXf854YbHdhVE7YInrac9+ISiBbp3sDQXL/gu6sx7LrL+KUmvzo+7
         eJyWSsQDduD+kMoK14bVSejeDwxF+ErbjPZtPnZyiJVX45fC8X7oDq2bHGjmhVwEHx8y
         5Gz557q8f3y4Jc5Q4d3rKu+XBDDNg35sM7zhuGB8RhDijrrZalEHmtaDTcjMlNRoObL2
         SGnw==
X-Gm-Message-State: AOAM530B8wZ5Y4vSF981BxRyuRCnIehsvjw1B6VvOuu57B1NkOyl1cGX
        N4ld2Jc8lzV10zZG9bEXbXmo4BQmCa0FjZ3ofJ3fiQ==
X-Google-Smtp-Source: ABdhPJw3KmDefhEu9+u11W8ReRDK7zsZD5YPZ35YEQucvJ//0VwehEfRK68CvuGIDKQjXaOnmm8VCKjv8dLC3x142EY=
X-Received: by 2002:a05:6512:20ca:: with SMTP id u10mr3805297lfr.71.1642775081622;
 Fri, 21 Jan 2022 06:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20220114075934.302464-1-gregkh@linuxfoundation.org>
 <CAPDyKFpu0mGchoqdzE-qKc6=9ogncnTCwN8AR7g1wcMZLyRFsw@mail.gmail.com> <Yeq7H0LSegfCNHzl@kroah.com>
In-Reply-To: <Yeq7H0LSegfCNHzl@kroah.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 21 Jan 2022 15:24:05 +0100
Message-ID: <CAPDyKFrQ+1icC-qO6Oo4DAhZYVt9oOSZiKs0qRFMwKdq5=X1Hw@mail.gmail.com>
Subject: Re: [PATCH] moxart: fix potential use-after-free on remove path
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        linux-mmc@vger.kernel.org, stable <stable@vger.kernel.org>,
        whitehat002 <hackyzh002@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 Jan 2022 at 14:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jan 21, 2022 at 01:41:27PM +0100, Ulf Hansson wrote:
> > On Fri, 14 Jan 2022 at 08:59, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > It was reported that the mmc host structure could be accessed after it
> > > was freed in moxart_remove(), so fix this by saving the base register of
> > > the device and using it instead of the pointer dereference.
> > >
> > > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > > Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> > > Cc: Xin Xiong <xiongx18@fudan.edu.cn>
> > > Cc: Xin Tan <tanxin.ctf@gmail.com>
> > > Cc: Tony Lindgren <tony@atomide.com>
> > > Cc: Yang Li <yang.lee@linux.alibaba.com>
> > > Cc: linux-mmc@vger.kernel.org
> > > Cc: stable <stable@vger.kernel.org>
> > > Reported-by: whitehat002 <hackyzh002@gmail.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/mmc/host/moxart-mmc.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
> > > index 16d1c7a43d33..f5d96940a9b8 100644
> > > --- a/drivers/mmc/host/moxart-mmc.c
> > > +++ b/drivers/mmc/host/moxart-mmc.c
> > > @@ -697,6 +697,7 @@ static int moxart_remove(struct platform_device *pdev)
> > >  {
> > >         struct mmc_host *mmc = dev_get_drvdata(&pdev->dev);
> > >         struct moxart_host *host = mmc_priv(mmc);
> > > +       void __iomem *base = host->base;
> > >
> > >         dev_set_drvdata(&pdev->dev, NULL);
> > >
> > > @@ -707,10 +708,10 @@ static int moxart_remove(struct platform_device *pdev)
> > >         mmc_remove_host(mmc);
> > >         mmc_free_host(mmc);
> > >
> > > -       writel(0, host->base + REG_INTERRUPT_MASK);
> > > -       writel(0, host->base + REG_POWER_CONTROL);
> > > -       writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
> > > -              host->base + REG_CLOCK_CONTROL);
> >
> > Rather than doing it like this, I think it would be easier to move
> > mmc_free_host() below this part. That's usually what mmc host drivers
> > do clean up things in ->remove().
> >
> > > +       writel(0, base + REG_INTERRUPT_MASK);
> > > +       writel(0, base + REG_POWER_CONTROL);
> > > +       writel(readl(base + REG_CLOCK_CONTROL) | CLK_OFF,
> > > +              base + REG_CLOCK_CONTROL);
> > >
>
> Ok, I can do that, I didn't know if it would cause any functionality
> changes, so I was trying to preserve the same logic that the driver
> currently has.

Yes, but it's most likely just a simple mistake that was made by the
original author.

>
> Do you have this device to test this with?

No, I don't.

Although, I am confident that it should work fine too.

>
> thanks,
>
> greg k-h

Kind regards
Uffe
