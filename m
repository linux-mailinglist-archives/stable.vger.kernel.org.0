Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D2024A8AC
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 23:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHSVlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSVlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 17:41:24 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D7AC061757;
        Wed, 19 Aug 2020 14:41:23 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id jp10so227404ejb.0;
        Wed, 19 Aug 2020 14:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hTEF7FpoeYL8Q+HCa82yrWFkKA4EpFDf03/6zdi5GWQ=;
        b=MwgEkw0yg/KcYyXPPcMMmJuf+Qw4NS78WxxEs0le3mSafWxPPbgcnXgUhm6VcduzsN
         zos+oNhxkRkSTRzB4oZU/ZAtqlE70/k8fyJ6g0a+HwjL7t6FjAhyqWhp36AFzBhGgBfG
         8V/nAzZWbVGHkfnZU2qx5L7ojmuYaIlIZpuRutUmRW9jdaZUbVy6XzHdVvN+Db2LIRs6
         IYScJdHh3UhhSotLlxsvYUvCY7WHRDPkw+X78csVgiPLuc052gSIDlVJU6sMrEYcgOwC
         5Mn7gcYB1aRLAuLDKs2dp7VFvXasnKs5hmss60nSmt/zwISwFythi89Hjh0Lf3mAdITW
         ne+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hTEF7FpoeYL8Q+HCa82yrWFkKA4EpFDf03/6zdi5GWQ=;
        b=ku9zTTgwLzbCvEX6pyZ1AMu2LbjluklXXtcXmgtBu9ke57gWiMtLWJt4bYXzsGimux
         /crfJtMHqiGSOyk6W/poyCRLP50eqcL4nQNOcPXgVnlV+9mugKrfFY87vD4QsrlLPFS4
         Fpq7b+wq13odT/LKkiMEXHjRirbaq7ItztIY+B155vcOw7xQAi5kRgry+Hst/GlU1P19
         zAosDDkA7TIN5gEd/wExY0er66G+X0ib0kJrhJYEHI2+oR5kY6YpArwMJek9IBWHFHRE
         nti2eKGBMfSfZnniTgl/NNsVytkvG5CqYYZZG4YREtE450UD6rgKaIC/HYlKeZ/WRAJO
         occw==
X-Gm-Message-State: AOAM533Gbup00AwNDtGhZNyaFbAH9Ek/7NC/fUaK+jKJDlSENuqEfxQr
        ZUgLWPnL0d6yTZIKXotsgmsbPUSHCBsIIfnbkeTyX73oYgIG1g==
X-Google-Smtp-Source: ABdhPJwxPAtVBNKW3xTK2NrvC/hdbP3RA59iQgS6IIjCTV03UOTkvS8epO49JduoeBGiyV5jkb2JDkwmGaRxRFVlIZk=
X-Received: by 2002:a17:906:ca4f:: with SMTP id jx15mr302048ejb.449.1597873282341;
 Wed, 19 Aug 2020 14:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200819195613.24269-1-hsiangkao@redhat.com> <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
 <20200819201509.GA26216@xiangao.remote.csb>
In-Reply-To: <20200819201509.GA26216@xiangao.remote.csb>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 19 Aug 2020 14:41:08 -0700
Message-ID: <CAHbLzkqr3Z0OuzjqrGjNX6kajr9J533FpqQd8zJYD4pjd+CGMg@mail.gmail.com>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by mistake
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 1:15 PM Gao Xiang <hsiangkao@redhat.com> wrote:
>
> Hi Andrew,
>
> On Wed, Aug 19, 2020 at 01:05:06PM -0700, Andrew Morton wrote:
> > On Thu, 20 Aug 2020 03:56:13 +0800 Gao Xiang <hsiangkao@redhat.com> wrote:
> >
> > > SWP_FS doesn't mean the device is file-backed swap device,
> > > which just means each writeback request should go through fs
> > > by DIO. Or it'll just use extents added by .swap_activate(),
> > > but it also works as file-backed swap device.
> >
> > This is very hard to understand :(
>
> Thanks for your reply...
>
> The related logic is in __swap_writepage() and setup_swap_extents(),
> and also see e.g generic_swapfile_activate() or iomap_swapfile_activate()...

I think just NFS falls into this case, so you may rephrase it to:

SWP_FS is only used for swap files over NFS. So, !SWP_FS means non NFS
swap, it could be either file backed or device backed.

Does this look more understandable?

> I will also talk with "Huang, Ying" in person if no response here.
>
> >
> > > So in order to achieve the goal of the original patch,
> > > SWP_BLKDEV should be used instead.
> > >
> > > FS corruption can be observed with SSD device + XFS +
> > > fragmented swapfile due to CONFIG_THP_SWAP=y.
> > >
> > > Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
> > > Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
> >
> > Why do you think it has taken three years to discover this?
>
> I'm not sure if the Redhat BZ is available for public, it can be reproduced
> since rhel 8
> https://bugzilla.redhat.com/show_bug.cgi?id=1855474
>
> It seems hard to believe, but I think just because rare user uses the SSD device +
> THP + file-backed swap device combination... maybe I'm wrong here, but my test
> shows as it is.
>
> Thanks,
> Gao Xiang
>
> >
> >
> >
>
>
