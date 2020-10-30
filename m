Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0532D2A09A7
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgJ3PWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgJ3PWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 11:22:50 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC5D22249
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604071369;
        bh=QIWj6+1l2ccT61w8gx1zVwihD0jvq4SLFjSzn7ucHkA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Km4qCWvw/i+w11iGvDexNP3ZT9eZQqsJqZ/s93Ii/3r/fAja0iQrveCPzCtsVii03
         M3Np9Kw+KkusXf6NLtQ/1PX+aKJlcbjCRxr7Fb3x6X2b7sVNWhc/HWIcNLhW1HCRm4
         Z+0bb24eLYjYrDbjSErir/Qpwseu3MseyuihkMGg=
Received: by mail-oi1-f169.google.com with SMTP id u127so6987847oib.6
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:22:49 -0700 (PDT)
X-Gm-Message-State: AOAM533nANf2msnbqc2sGV0V2nXrcbduGr5+Vc3ARn9PNHkpf17m3it3
        a9fPOpowYkkziiq43W338EWNECt6itoUMYPdrZU=
X-Google-Smtp-Source: ABdhPJwymUsurBcZpJ9hYebZYXEG4XgGzXMtMFu0Nbm0gSWilhFoZnsRw9tBgupRA4FAxgofuKWF9t5Vxe/tRJQdYEY=
X-Received: by 2002:aca:2310:: with SMTP id e16mr1870429oie.47.1604071368489;
 Fri, 30 Oct 2020 08:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201029110334.4118-1-ardb@kernel.org> <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
 <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com> <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
 <20201030151822.GA16907@linux.ibm.com>
In-Reply-To: <20201030151822.GA16907@linux.ibm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Oct 2020 16:22:37 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEOnSPvkjY7Wd3gpOj+JfpU6bNNtoZ68cEhTK8rin3dTw@mail.gmail.com>
Message-ID: <CAMj1kXEOnSPvkjY7Wd3gpOj+JfpU6bNNtoZ68cEhTK8rin3dTw@mail.gmail.com>
Subject: Re: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory reservations
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Oct 2020 at 16:18, Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> Hi Ard,
>
> On Fri, Oct 30, 2020 at 10:29:16AM +0100, Ard Biesheuvel wrote:
> > (+ Mike)
> >
> > On Fri, 30 Oct 2020 at 03:25, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >
> > >
> > >
> > > On 10/29/2020 4:14 AM, Ard Biesheuvel wrote:
> > > > On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >>
> > > >> free_highpages() iterates over the free memblock regions in high
> > > >> memory, and marks each page as available for the memory management
> > > >> system. However, as it rounds the end of each region downwards, we
> > > >> may end up freeing a page that is memblock_reserve()d, resulting
> > > >> in memory corruption. So align the end of the range to the next
> > > >> page instead.
> > > >>
> > > >> Cc: <stable@vger.kernel.org>
> > > >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > >> ---
> > > >>  arch/arm/mm/init.c | 2 +-
> > > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >>
> > > >> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > > >> index a391804c7ce3..d41781cb5496 100644
> > > >> --- a/arch/arm/mm/init.c
> > > >> +++ b/arch/arm/mm/init.c
> > > >> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
> > > >>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> > > >>                                 &range_start, &range_end, NULL) {
> > > >>                 unsigned long start = PHYS_PFN(range_start);
> > > >> -               unsigned long end = PHYS_PFN(range_end);
> > > >> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
> > > >>
> > > >
> > > > Apologies, this should be
> > > >
> > > > -               unsigned long start = PHYS_PFN(range_start);
> > > > +               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
> > > >                 unsigned long end = PHYS_PFN(range_end);
> > > >
> > > >
> > > > Strangely enough, the wrong version above also fixed the issue I was
> > > > seeing, but it is start that needs rounding up, not end.
> > >
> > > Is there a particular commit that you identified which could be used as
> > >  Fixes: tag to ease the back porting of such a change?
> >
> > Ah hold on. This appears to be a very recent regression, in
> > cddb5ddf2b76debdb8cad1728ad0a9321383d933, added in v5.10-rc1.
> >
> > The old code was
> >
> > unsigned long start = memblock_region_memory_base_pfn(mem);
> >
> > which uses PFN_UP() to round up, whereas the new code rounds down.
> >
> > Looks like this is broken on a lot of platforms.
> >
> > Mike?
>
> I've reviewed again the whole series and it seems that only highmem
> initialization on arm and xtensa (that copied this code from arm) have
> this problem. I might have missed something again, though.
>
> So, to restore the original behaviour I think the fix should be
>
>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
>                                 &range_start, &range_end, NULL) {
>                 unsigned long start = PHYS_UP(range_start);
>                 unsigned long end = PHYS_DOWN(range_end);
>
>

PHYS_UP and PHYS_DOWN don't exist.

Could you please send a patch that fixes this everywhere where it's broken?
