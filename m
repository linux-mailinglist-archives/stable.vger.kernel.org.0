Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F0130A959
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 15:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhBAOHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 09:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhBAOHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 09:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED6764EA1;
        Mon,  1 Feb 2021 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612188377;
        bh=tQ4WmAzlyE4k3CyxrsslSldFLnH7v9mWZ6r3RsrN92o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UL5SEVGET2SxXOjmGMFgkjoD6BYDZRygtnBjTNJu8V+/pemWyIGsJvG9bgE7KLyje
         Lj0fREqDV8/aSZzmEAC740HLoqXoVG8YqsDmdtGjgNYIh4bifIIX4bgm9L2Vgn6Qf/
         skfj+H8rithoJoc6YyhJjD5NsHlPBaL1DNXlpEOI3++atJAMJ/RAF4wjCfZWEiyizL
         b3v4OtZj7m63wkIDoMx+H025TmfyvnDFwsqtqVWV8MWE793bhKAI75OWUW/xLAwoFI
         +7e+KAO1E4+vH6oUMtql/UMjfj+ECQfyOhDT3uXO8MgZzW6B1/vWG//Ibrwenv7RS0
         RycHCDmybViNw==
Date:   Mon, 1 Feb 2021 16:06:05 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as
 memblock.memory
Message-ID: <20210201140605.GG242749@kernel.org>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <CAHk-=wjJLdjqN2W_hwUmYCM8u=1tWnKsm46CYfdKPP__anGvJw@mail.gmail.com>
 <20210131080356.GE242749@kernel.org>
 <CAHk-=wg-qT41Q1WgPUZPC9UmCi6xquk1KE3_yvxORbmDV3os0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg-qT41Q1WgPUZPC9UmCi6xquk1KE3_yvxORbmDV3os0g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 31, 2021 at 01:49:27PM -0800, Linus Torvalds wrote:
> On Sun, Jan 31, 2021 at 12:04 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > >
> > > That's *particularly* true when the very line above it did a
> > > "memblock_reserve()" of the exact same range that the memblock_add()
> > > "adds".
> >
> > The most correct thing to do would have been to
> >
> >         memblock_add(0, end_of_first_memory_bank);
> >
> > Somewhere at e820__memblock_setup().
> 
> You miss my complaint.
> 
> Why does the memblock code care about this magical "memblock_add()",
> when we just told it that the SAME REGION is reserved by doing a
> "memblock_reserve()"?
> 
> IOW, I'm not interested in "the correct thing to do would have been
> [another memblock_add()]". I'm saying that the memblock code itself is
> being confused, and no additional thing should have been required at
> all, because we already *did* that memblock_reserve().
> 
> See?

There is nothing magical about memblock_add().

Memblock presumes that arch code uses memblock_add() to register populated
physical memory ranges and memblock_reserve() to protect memory ranges that
should not be touched. These ranges do not necessarily overlap, so there
maybe reserved ranges that do not have the corresponding registered memory.

This lets architectures to say "here are the memory banks I have" and "this
memory is in use" (or even "this memory _might_ be in use" ) independently
of each other.

The downside is that if there is a reserved range there is no way to tell
whether it is backed by populated memory.

We could change this semantics and enforce the overlap, e.g. by
implicitly adding all the reserved ranges to the registered memory.
I've already tried that and I've found out that there are systems that rely
on memblock's ability to track reserved and available ranges independently.
For example, arm systems I've mentioned in the previous mail always have a
reserved chunk at 0xfe000000 in their DTS, but they may have only 2G of
memory actually populated. 

Now, on x86 there is a gap between e820 and memblock since 2.6 times. As of
now, only E820_TYPE_RAM is added to memblock as memory, some of the
E820_*_RESERVED are reserved and on top there are reservations of the
memory that's known to be used by BIOS or kernel.

I'm trying to close this gap with small steps and with changes that I
believe will not break too many things at once so it'll become
unmanageable.

> Honestly, I'm not seeing it being a good thing to move further towards
> memblock code as the primary model for memory initialization, when the
> memblock code is so confused.

I'm not sure I follow you here.
If I'm not mistaken, memblock is used as the primary model for memmap and
page allocator initialization for almost a decade now...
 
>               Linus

-- 
Sincerely yours,
Mike.
