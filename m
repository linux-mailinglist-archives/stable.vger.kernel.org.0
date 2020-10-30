Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE632A106D
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 22:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgJ3VlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 17:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgJ3VlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 17:41:25 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54352224D
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604094084;
        bh=dieLb+RD8J65XW12hKG2LNqgLQ0vXw+BmMIkhoVqYVg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oW8sRrVqW88qOl0DqiB0EW6bChm1q9H0sCfummKKeoT5E9g3Qa9+ojgxhZQxxLt4U
         Q45Oi7eKI2yI3mDUWJLtf6xaQRrjVYTJkSdr66MQhMXU9gc5fd4GzftOHurX27xFpZ
         NoapSJqkau7Q5j1MbtsL7hmwKtyOVW9VH3lUmpkA=
Received: by mail-oi1-f181.google.com with SMTP id f7so8131151oib.4
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 14:41:23 -0700 (PDT)
X-Gm-Message-State: AOAM5325WVOJejYJeBxAJWKiyHad6cVA8kDnw/JD3gRdWuHWqJynEKeY
        dur6samyplzAgTwjnHF9UevcHZXFswYHt//HJog=
X-Google-Smtp-Source: ABdhPJxlFblka84gy9zR2hJHtRJxd2VceIXGaF/4ZOtnqv37L2mSsEJ3d4niFMXQcbbgzkpECvlpC27LBFjhod5YCdk=
X-Received: by 2002:aca:2310:: with SMTP id e16mr2831476oie.47.1604094083019;
 Fri, 30 Oct 2020 14:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201029110334.4118-1-ardb@kernel.org> <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
 <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com> <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
 <20201030151822.GA16907@linux.ibm.com> <CAMj1kXEOnSPvkjY7Wd3gpOj+JfpU6bNNtoZ68cEhTK8rin3dTw@mail.gmail.com>
 <20201030213159.GA14584@linux.ibm.com>
In-Reply-To: <20201030213159.GA14584@linux.ibm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Oct 2020 22:41:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHVbZDSXMa6Q6EDQ95wexXzSrd195V6-Y-Dsw-rovy0cA@mail.gmail.com>
Message-ID: <CAMj1kXHVbZDSXMa6Q6EDQ95wexXzSrd195V6-Y-Dsw-rovy0cA@mail.gmail.com>
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

On Fri, 30 Oct 2020 at 22:32, Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> On Fri, Oct 30, 2020 at 04:22:37PM +0100, Ard Biesheuvel wrote:
> > On Fri, 30 Oct 2020 at 16:18, Mike Rapoport <rppt@linux.ibm.com> wrote:
> > >
> > > Hi Ard,
> > >
> > > > > On 10/29/2020 4:14 AM, Ard Biesheuvel wrote:
> > > > > > On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > > >>
> > > > > >> free_highpages() iterates over the free memblock regions in high
> > > > > >> memory, and marks each page as available for the memory management
> > > > > >> system. However, as it rounds the end of each region downwards, we
> > > > > >> may end up freeing a page that is memblock_reserve()d, resulting
> > > > > >> in memory corruption. So align the end of the range to the next
> > > > > >> page instead.
> > > > > >>
> > > > > >> Cc: <stable@vger.kernel.org>
> > > > > >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > >> ---
> > > > > >>  arch/arm/mm/init.c | 2 +-
> > > > > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >>
> > > > > >> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > > > > >> index a391804c7ce3..d41781cb5496 100644
> > > > > >> --- a/arch/arm/mm/init.c
> > > > > >> +++ b/arch/arm/mm/init.c
> > > > > >> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
> > > > > >>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> > > > > >>                                 &range_start, &range_end, NULL) {
> > > > > >>                 unsigned long start = PHYS_PFN(range_start);
> > > > > >> -               unsigned long end = PHYS_PFN(range_end);
> > > > > >> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
> > > > > >>
> > > > > >
> > > > > > Apologies, this should be
> > > > > >
> > > > > > -               unsigned long start = PHYS_PFN(range_start);
> > > > > > +               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
> > > > > >                 unsigned long end = PHYS_PFN(range_end);
> > > > > >
> > > > > >
> > > > > > Strangely enough, the wrong version above also fixed the issue I was
> > > > > > seeing, but it is start that needs rounding up, not end.
> > > > >
> > > > > Is there a particular commit that you identified which could be used as
> > > > >  Fixes: tag to ease the back porting of such a change?
> > > >
> > > > Ah hold on. This appears to be a very recent regression, in
> > > > cddb5ddf2b76debdb8cad1728ad0a9321383d933, added in v5.10-rc1.
> > > >
> > > > The old code was
> > > >
> > > > unsigned long start = memblock_region_memory_base_pfn(mem);
> > > >
> > > > which uses PFN_UP() to round up, whereas the new code rounds down.
> > > >
> > > > Looks like this is broken on a lot of platforms.
> > > >
> > > > Mike?
> > >
> > > I've reviewed again the whole series and it seems that only highmem
> > > initialization on arm and xtensa (that copied this code from arm) have
> > > this problem. I might have missed something again, though.
> > >
> > > So, to restore the original behaviour I think the fix should be
> > >
> > >         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> > >                                 &range_start, &range_end, NULL) {
> > >                 unsigned long start = PHYS_UP(range_start);
> > >                 unsigned long end = PHYS_DOWN(range_end);
> > >
> > >
> >
> > PHYS_UP and PHYS_DOWN don't exist.
> >
> > Could you please send a patch that fixes this everywhere where it's broken?
>
> Argh, this should have been PFN_{UP,DOWN}.
> With the patch below qemu-system-arm boots for me. Does it fix your
> setup as well?
>

Yeah that looks fine.

> I kept your authorship as you did the heavy lifting here :)
>
> With acks from ARM and xtensa maintainers I can take it via memblock
> tree.
>

That would be up to Russell (on cc) and whoever the xtensa maintainers
are, who are not on CC.

Would you mind chasing them?


> From 5399699b9f8de405819c59c3feddecaac0ed1399 Mon Sep 17 00:00:00 2001
> From: Ard Biesheuvel <ardb@kernel.org>
> Date: Fri, 30 Oct 2020 22:53:02 +0200
> Subject: [PATCH] ARM, xtensa: highmem: avoid clobbering non-page aligned
>  memory reservations
>
> free_highpages() iterates over the free memblock regions in high
> memory, and marks each page as available for the memory management
> system.
>
> Until commit cddb5ddf2b76 ("arm, xtensa: simplify initialization of
> high memory pages") it rounded beginning of each region upwards and end of
> each region downwards.
>
> However, after that commit free_highmem() rounds the beginning and end of
> each region downwards, we and may end up freeing a page that is

we may end up

> memblock_reserve()d, resulting in memory corruption.
>
> Restore the original rounding of the region boundaries to avoid freeing
> reserved pages.
>
> Fixes: cddb5ddf2b76 ("arm, xtensa: simplify initialization of high memory pages")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Co-developed-by:  Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/arm/mm/init.c    | 4 ++--
>  arch/xtensa/mm/init.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index d57112a276f5..c23dbf8bebee 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -354,8 +354,8 @@ static void __init free_highpages(void)
>         /* set highmem page free */
>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
>                                 &range_start, &range_end, NULL) {
> -               unsigned long start = PHYS_PFN(range_start);
> -               unsigned long end = PHYS_PFN(range_end);
> +               unsigned long start = PFN_UP(range_start);
> +               unsigned long end = PFN_DOWN(range_end);
>
>                 /* Ignore complete lowmem entries */
>                 if (end <= max_low)
> diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
> index c6fc83efee0c..8731b7ad9308 100644
> --- a/arch/xtensa/mm/init.c
> +++ b/arch/xtensa/mm/init.c
> @@ -89,8 +89,8 @@ static void __init free_highpages(void)
>         /* set highmem page free */
>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
>                                 &range_start, &range_end, NULL) {
> -               unsigned long start = PHYS_PFN(range_start);
> -               unsigned long end = PHYS_PFN(range_end);
> +               unsigned long start = PFN_UP(range_start);
> +               unsigned long end = PFN_DOWN(range_end);
>
>                 /* Ignore complete lowmem entries */
>                 if (end <= max_low)
> --
> 2.28.0
>
>
> --
> Sincerely yours,
> Mike.
