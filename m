Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD1B30A9C8
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 15:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBAObL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 09:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhBAObI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 09:31:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE0764E46;
        Mon,  1 Feb 2021 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612189826;
        bh=pSp6KogtqHICua0+XffQWrWfoLcultom2kfK3j81FgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HX8Fi86s+eeswzryT4zcy1KUCIumjs5yI5tU+H2q0Qr8Mg+gbz7uwYYAsIaiuOhwI
         Mm/8BKIaQcq+/58nkb8gOx1xLgKtNdiCiEJiPlr6UPROFfOAPYx6TvIhcfwSYcHGrU
         /t/wZ2TwK6cGn8MQ0LL1RgOQ/OPY6nxJYIxjCCA3gv+9r+ezeoAP/SIB0/nbj0unmG
         CX5mmqxywWGPjyLAPwisX5Qmcja40vEZ1F9lwh+87sYUOnccV44UZRmzSyLFCj09kn
         jEpS79p8trrsaktnJK305wJ2pfKuuVJI1PFxWauCN/4yBM2s9CQeDmYzKwfw1AbzJP
         YxQflX/7f+iRw==
Date:   Mon, 1 Feb 2021 16:30:14 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as
 memblock.memory
Message-ID: <20210201143014.GI242749@kernel.org>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 10:32:44AM +0100, David Hildenbrand wrote:
> On 30.01.21 23:10, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The physical memory on an x86 system starts at address 0, but this is not
> > always reflected in e820 map. For example, the BIOS can have e820 entries
> > like
> > 
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000001000-0x000000000009ffff] usable
> > 
> > or
> > 
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000001000-0x0000000000057fff] usable
> > 
> > In either case, e820__memblock_setup() won't add the range 0x0000 - 0x1000
> > to memblock.memory and later during memory map initialization this range is
> > left outside any zone.
> > 
> > With SPARSEMEM=y there is always a struct page for pfn 0 and this struct
> > page will have it's zone link wrong no matter what value will be set there.
> > 
> > To avoid this inconsistency, add the beginning of RAM to memblock.memory.
> > Limit the added chunk size to match the reserved memory to avoid
> > registering memory that may be used by the firmware but never reserved at
> > e820__memblock_setup() time.
> > 
> > Fixes: bde9cfa3afe4 ("x86/setup: don't remove E820_TYPE_RAM for pfn 0")
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > Cc: stable@vger.kernel.org
> > ---
> >   arch/x86/kernel/setup.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 3412c4595efd..67c77ed6eef8 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -727,6 +727,14 @@ static void __init trim_low_memory_range(void)
> >   	 * Kconfig help text for X86_RESERVE_LOW.
> >   	 */
> >   	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
> > +
> > +	/*
> > +	 * Even if the firmware does not report the memory at address 0 as
> > +	 * usable, inform the generic memory management about its existence
> > +	 * to ensure it is a part of ZONE_DMA and the memory map for it is
> > +	 * properly initialized.
> > +	 */
> > +	memblock_add(0, ALIGN(reserve_low, PAGE_SIZE));
> >   }
> >   	
> >   /*
> > 
> 
> I think, to make that code more robust, and to not rely on archs to do the
> right thing, we should do something like
> 
> 1) Make sure in free_area_init() that each PFN with a memmap (i.e., falls
> into a partial present section) is spanned by a zone; that would include PFN
> 0 in this case.
> 
> 2) In init_zone_unavailable_mem(), similar to round_up(max_pfn,
> PAGES_PER_SECTION) handling, consider range
> 	[round_down(min_pfn, PAGES_PER_SECTION), min_pfn - 1]
> which would handle in the x86-64 case [0..0] and, therefore, initialize PFN
> 0.
> 
> Also, I think the special-case of PFN 0 is analogous to the
> round_up(max_pfn, PAGES_PER_SECTION) handling in
> init_zone_unavailable_mem(): who guarantees that these PFN above the highest
> present PFN are actually spanned by a zone?
> 
> I'd suggest going through all zone ranges in free_area_init() first, dealing
> with zones that have "not section aligned start/end", clamping them up/down
> if required such that no holes within a section are left uncovered by a
> zone.

I thought about changing the way zone extents are calculated so that zone
start/end will be always on a section boundary, but zone->zone_start_pfn
depends on node->node_start_pfn which is defined by hardware and expanding
a node to make its start pfn aligned at the section boundary might violate
the HW addressing scheme.

Maybe this could never happen, or maybe it's not really important as the
pages there will be reserved anyway, but I'm not sure I can estimate all
the implications. 

-- 
Sincerely yours,
Mike.
