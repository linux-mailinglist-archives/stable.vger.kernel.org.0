Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653BF304BD6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbhAZVyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbhAZRCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 12:02:21 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2447EC061797;
        Tue, 26 Jan 2021 08:41:33 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u8so21718920ior.13;
        Tue, 26 Jan 2021 08:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=noF668HAsWh6B0PaJj016gYYJwQjDmvicFCMUsI1bRs=;
        b=WMl7Lx+tGgX1ACuDlJqnbk7pSgwknR5vVIotif8GTeGjyVlBzSBugNcr64RgctAwr9
         v1AabNcsA/9o/vsGpjPwAmOcIlACM7EOJ7fDxtdoWgJRsQB2xuzxMfOi6EUZcA/kBGJJ
         nEME2Am+VidBBh7RZ1QTb/gA9O0utEm+S5atCwIePPNt/Xw+PPub3TRx68OJKYQ1VctT
         BbclNtWv125e4ZjjWkTCyfGIKkINBr9FKGRs9Z+0oNHOBBiZUcUcwNppljJkdSuW4sRx
         ZRmzo6PSit7Uki39Og4DHZVnPx6FJNIUDG1t7rabkFX+8exi6sDOQcyFv4fYQa9aoeUf
         Hyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=noF668HAsWh6B0PaJj016gYYJwQjDmvicFCMUsI1bRs=;
        b=WxG/0aM32L890XnmLhP/nTbyahdqfJBtBdZygLUl0oCR6Z92IfmlxcXfNlgziP7irS
         lR0kel6JjiyYGLy365FI67rsBd6NnOIBVFc63l3pAdHQCNh3OuRo74NPC0oqlYUhSKIc
         4OGcwZ+iCPE6eug6jcFL8wA9+O2DE+t22w19rxtID85+scGLhyVS6rpblSP7072BnXrL
         KIjyVeG94OHNvp2t4ecRnrAwS/l/QqqiVn3HRdJrjisBJaee4+r0xuMbJo2uZoR9K8E3
         Q6F8enGUQkMAILvbgYxJvyRkgQbVVJOH7FC7QoZHSrTy+GBNGiye1xvHPULG2JBnxTVU
         YTVg==
X-Gm-Message-State: AOAM530Q1CHtGG7SvNMfjgdzCKnGm6NGRXISLyeJ865dY/JxRZ1ne7ni
        16V+ducQ/tfBoYviBCqb1dKhULPjHp6DA2+eigw=
X-Google-Smtp-Source: ABdhPJysUCly5W+Y+gBjDlv6OwEO5GXaEtF85Qq/vidnGYZoXHstctLsPBe7Is/3Gj3yjni5WWc6wHddZFYmCapRgsk=
X-Received: by 2002:a92:bd06:: with SMTP id c6mr5474781ile.158.1611679291832;
 Tue, 26 Jan 2021 08:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20210125125050.102605-1-arnd@kernel.org> <f671f5d2-36c4-ded5-c4b9-93c5c57cc9f2@gmail.com>
 <CAPDyKFoGDHtE8JgLurwuN-W6CmmyBB3GP+7Z-bWqJiWw+TJEaQ@mail.gmail.com>
In-Reply-To: <CAPDyKFoGDHtE8JgLurwuN-W6CmmyBB3GP+7Z-bWqJiWw+TJEaQ@mail.gmail.com>
From:   Alan Cooper <alcooperx@gmail.com>
Date:   Tue, 26 Jan 2021 11:41:20 -0500
Message-ID: <CAOGqxeVmvW-sXs9SBu7MbiNjthDmKH0uK1gvHNNBie8miGRsCQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: brcmstb: Fix sdhci_pltfm_suspend link error
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Adrian Hunter <adrian.hunter@intel.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "# 4.0+" <stable@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I just posted a new patch for this, please have a look and test it.
>
> Kind regards
> Uffe

I tested your new patch and it works.
Reviewed-and-tested-by: Al Cooper <alcooperx@gmail.com>

Thanks
Al



On Tue, Jan 26, 2021 at 4:55 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Mon, 25 Jan 2021 at 18:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > +Nicolas,
> >
> > On 1/25/2021 4:50 AM, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > sdhci_pltfm_suspend() is only available when CONFIG_PM_SLEEP
> > > support is built into the kernel, which caused a regression
> > > in a recent bugfix:
> > >
> > > ld.lld: error: undefined symbol: sdhci_pltfm_suspend
> > >>>> referenced by sdhci-brcmstb.c
> > >>>>               mmc/host/sdhci-brcmstb.o:(sdhci_brcmstb_shutdown) in archive drivers/built-in.a
> > >
> > > Making the call conditional on the symbol fixes the link
> > > error.
> > >
> > > Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
> > > Fixes: e7b5d63a82fe ("mmc: sdhci-brcmstb: Add shutdown callback")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > It would be helpful if someone could test this to ensure that the
> > > driver works correctly even when CONFIG_PM_SLEEP is disabled
> >
> > Why not create stubs for sdhci_pltfm_suspend() when CONFIG_PM_SLEEP=n? I
> > don't think this is going to be a functional issue given that the
> > purpose of having the .shutdown() function is to save power if we cannot
> > that is fine, too.
> > --
> > Florian
>
> I would prefer this approach - we shouldn't leave stub functions
> unimplemented, which is what looks to me.
>
> I just posted a new patch for this, please have a look and test it.
>
> Kind regards
> Uffe
