Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA8E2A016B
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 10:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJ3J3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 05:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3J3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 05:29:31 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC08620728
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604050168;
        bh=IGbCujS20JYunuVqkL9NB3jtW8MwPdsdjo/WXA38uNI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AtbJhTYK0/44U9VxwQEZk+A3oEs0Qvund5OHTSdeq8lrX1h8kgMMjM0CKrmkA+ynM
         SZyDug6tJoS8+60NxW89Gw9Ua1W2OMxTPWaIUTJd1RcWXBePCjwVGfYdFucxKlpMJa
         v6oglTxdCuXKJTh7IhTcsjvNQLvvYqTJTYhQ0sds=
Received: by mail-ot1-f53.google.com with SMTP id k3so5011072otp.1
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 02:29:28 -0700 (PDT)
X-Gm-Message-State: AOAM531yBLqHMyiZcVvWIGzBNl/cq5eC/q6kG7/t9DSr4zQE+3cJzO1I
        2Xs3UQXMxfPy5enaz4Xu+EwlwWxPh88hd/cZSNM=
X-Google-Smtp-Source: ABdhPJxrDiMIvnB87kufLhzjVYXVx3Ut2BKpS5zwNx3DT55+rz9rBYMatBFw3pHxo39mcF9V9CqMoeNewlcBpfvawdQ=
X-Received: by 2002:a9d:7ad0:: with SMTP id m16mr575737otn.77.1604050167856;
 Fri, 30 Oct 2020 02:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20201029110334.4118-1-ardb@kernel.org> <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
 <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com>
In-Reply-To: <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Oct 2020 10:29:16 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
Message-ID: <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
Subject: Re: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory reservations
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(+ Mike)

On Fri, 30 Oct 2020 at 03:25, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 10/29/2020 4:14 AM, Ard Biesheuvel wrote:
> > On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
> >>
> >> free_highpages() iterates over the free memblock regions in high
> >> memory, and marks each page as available for the memory management
> >> system. However, as it rounds the end of each region downwards, we
> >> may end up freeing a page that is memblock_reserve()d, resulting
> >> in memory corruption. So align the end of the range to the next
> >> page instead.
> >>
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >> ---
> >>  arch/arm/mm/init.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> >> index a391804c7ce3..d41781cb5496 100644
> >> --- a/arch/arm/mm/init.c
> >> +++ b/arch/arm/mm/init.c
> >> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
> >>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> >>                                 &range_start, &range_end, NULL) {
> >>                 unsigned long start = PHYS_PFN(range_start);
> >> -               unsigned long end = PHYS_PFN(range_end);
> >> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
> >>
> >
> > Apologies, this should be
> >
> > -               unsigned long start = PHYS_PFN(range_start);
> > +               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
> >                 unsigned long end = PHYS_PFN(range_end);
> >
> >
> > Strangely enough, the wrong version above also fixed the issue I was
> > seeing, but it is start that needs rounding up, not end.
>
> Is there a particular commit that you identified which could be used as
>  Fixes: tag to ease the back porting of such a change?

Ah hold on. This appears to be a very recent regression, in
cddb5ddf2b76debdb8cad1728ad0a9321383d933, added in v5.10-rc1.

The old code was

unsigned long start = memblock_region_memory_base_pfn(mem);

which uses PFN_UP() to round up, whereas the new code rounds down.

Looks like this is broken on a lot of platforms.

Mike?
