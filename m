Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D94F309B13
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 09:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhAaIIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 03:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhAaIEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 03:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E1A64E24;
        Sun, 31 Jan 2021 08:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612080247;
        bh=XnEIzyX83XCKEatOzV7kqGhG0PBgmNDeWpYG8iX3bN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=slnzSlsStNd+xogG8TDKRhOIRBqYOpZCmo9Edm1c99JyQJD9IuQGCoRcRoHSzBZ3M
         ods5OUPngMUIvypaNZ5zMLl85njgdfqs/9hK1bHqugo98fqefezPscmg8rUS+7lT2O
         Frp+fjFnND0oJ0+zhqZxRroHmSAY/qg3koDPzpEqWK2pPyGA8pCDc1BybvsAHzNipz
         eZ8DtTGIM/Oj4ZT9WvbNQz9AaJy7Wm87KYCEo39JOI9XApt3LOCAu31Ym00JMMhQNk
         X8+qBzp/Byz2ivLQzb2Blw9wX7DJryrBLIXDUm1Ph5K55WgJ+FfHDavkwHfNfjMzMJ
         L5SuXgxw2mcww==
Date:   Sun, 31 Jan 2021 10:03:56 +0200
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
Message-ID: <20210131080356.GE242749@kernel.org>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <CAHk-=wjJLdjqN2W_hwUmYCM8u=1tWnKsm46CYfdKPP__anGvJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjJLdjqN2W_hwUmYCM8u=1tWnKsm46CYfdKPP__anGvJw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 30, 2021 at 04:37:54PM -0800, Linus Torvalds wrote:
> On Sat, Jan 30, 2021 at 2:10 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > In either case, e820__memblock_setup() won't add the range 0x0000 - 0x1000
> > to memblock.memory and later during memory map initialization this range is
> > left outside any zone.
> 
> Honestly, this just sounds like memblock being stupid in the first place.
> 
> Why aren't these zones padded to sane alignments?
 
The implicit alignment of zones would be a guess. What alignment would be
sane here? 1M? MAX_ORDER? pageblock_order?

I'm not sure that if an architecture reports its memory at X and we use,
say, round_down(X, 1M) for node[0]->node_start_pfn and
zone[0]->zone_start_pfn it wouldn't cause boot failure on some system out
there in the wild.

> This patch smells like working around the memblock code being fragile
> rather than a real fix.
>
> That's *particularly* true when the very line above it did a
> "memblock_reserve()" of the exact same range that the memblock_add()
> "adds".

The most correct thing to do would have been to 

	memblock_add(0, end_of_first_memory_bank);

Somewhere at e820__memblock_setup().

But that would mean we also must change the way e820__memblock_setup()
reserves memory and that seemed to me like really asking for troubles so
I've limited the registration of memory to the range that's for sure
reserved.

A part of the problem is that x86 adds only usable memory to
memblock.memory omitting holes and reserved areas, while free_area_init()
presumes that memblock.memory covers populated physical memory.

I've tried implicitly adding ranges from memblock.reserved to
memblock.memory if they were not there and it had broken some arm machines:

https://lore.kernel.org/lkml/127999c4-7d56-0c36-7f88-8e1a5c934cae@collabora.com

I do feel that free_area_init() is fragile and no doubt there is a room for
improvement there. But I think the safer way forward is to reduce
inconsistencies between arch and generic code, so that we won't need to
guess what is the memory layout at free_area_init() time.
 
>               Linus

-- 
Sincerely yours,
Mike.
