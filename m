Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2852D2139
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 03:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgLHC7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 21:59:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbgLHC7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 21:59:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607396265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gGQr3v6Nk16K2k5/uYho3hvGD3gQs3qkjS8EzdAbUeI=;
        b=fe1JTmCvI18lWED+wql5mPE561rczn7aFeLzO7Nsl9x8iALMLs85/tbQSXq6YAORvrlfKU
        E3FVzXGit63Zqe2iX4lKDIzgtBhPy+wrOSyENKyXUe0xVhBqdA9tz8ShDkTVloydIgnFn7
        SrQ7WgQ2533nBqkXg3yK5EbneGaQfrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-qVs5fXu3MAGV8FC4rJl5Pw-1; Mon, 07 Dec 2020 21:57:43 -0500
X-MC-Unique: qVs5fXu3MAGV8FC4rJl5Pw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3CE010054FF;
        Tue,  8 Dec 2020 02:57:41 +0000 (UTC)
Received: from mail (ovpn-112-148.rdu2.redhat.com [10.10.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D6F847;
        Tue,  8 Dec 2020 02:57:38 +0000 (UTC)
Date:   Mon, 7 Dec 2020 21:57:37 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <X87rodZBmvJCyjBi@redhat.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <20201206064849.GW123287@linux.ibm.com>
 <X80xQ6mvSwJZ0RvC@redhat.com>
 <20201207165037.GH1112728@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207165037.GH1112728@linux.ibm.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 06:50:37PM +0200, Mike Rapoport wrote:
> On Sun, Dec 06, 2020 at 02:30:11PM -0500, Andrea Arcangeli wrote:
> > On Sun, Dec 06, 2020 at 08:48:49AM +0200, Mike Rapoport wrote:
> > > I don't see why we need all this complexity when a simple fixup was
> > > enough.
> > 
> > Note the memblock bug crashed my systems:
> > 
> > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > 
> > Please note how zone_spans_pfn expands:
> > 
> > static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
> > {
> > 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
> > }
> > 
> > For pfn_to_page(0), the zone_start_pfn is 1 for DMA zone. pfn is 0.
> 
> I don't know why you keep calling it "memblock bug" as pfn 0 was not
> part of DMA zone at least for ten years.
> 
> If you backport this VM_BUG_ON_PAGE() to 2.6.36 that has no memblock on
> x86 it will happily trigger there.

I guess it wasn't considered a bug until your patch that was meant to
enforce this invariant for all pfn_valid was merged in -mm?

> The problem, as I see it, in, hmm, questionable semantics for
> !E820_TYPE_RAM ranges on x86.
> 
> I keep asking this simple question again and again and I still have no
> clear "yes" or "no" answer:
> 
> 	Is PFN 0 on x86 memory?

The pfn is the same regardless if it's RAM or non RAM, so I don't
think it makes any difference in this respect if it's RAM or not.

> Let's step back for a second and instead of blaming memblock in lack of
> enforcement for .memory and .reserved to overlap and talking about how
> memblock core was not robust enough we'll get to the point where we have
> clear defintions of what e820 ranges represent.

I don't see why we should go back into the direction that the caller
needs improvement like in commit
124049decbb121ec32742c94fb5d9d6bed8f24d8 and to try to massage the raw
e820 data before giving it to the linux common code.

Even if you wanted to enforce overlap at all times (not possible
because of the direct mapping issue) you could do it simply by calling
memblock_add first thing in memblock_reserve (if it wasn't already
fully overlapping) without the need to add an explicit memblock_add in
the caller.

> > > > +	/*
> > > > +	 * memblock.reserved isn't enforced to overlap with
> > > > +	 * memblock.memory so initialize the struct pages for
> > > > +	 * memblock.reserved too in case it wasn't overlapping.
> > > > +	 *
> > > > +	 * If any struct page associated with a memblock.reserved
> > > > +	 * range isn't overlapping with a zone range, it'll be left
> > > > +	 * uninitialized, ideally with PagePoison, and it'll be a more
> > > > +	 * easily detectable error.
> > > > +	 */
> > > > +	for_each_res_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> > > > +		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
> > > > +		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> > > > +
> > > > +		if (end_pfn > start_pfn)
> > > > +			pgcnt += init_unavailable_range(start_pfn, end_pfn,
> > > > +							zone, nid);
> > > > +	}
> > > 
> > > This means we are going iterate over all memory allocated before
> > > free_area_ini() from memblock extra time. One time here and another time
> > > in reserve_bootmem_region().
> > > And this can be substantial for CMA and alloc_large_system_hash().
> > 
> > The above loops over memory.reserved only.
> 
> Right, this loops over memory.reserved which happens to include CMA and
> the memory allocated in alloc_large_system_hash(). This can be a lot.
> And memmap_init() runs before threads are available so this cannot be
> parallelized.
> The deferred memmap initialization starts much later than this.

Can you convert the memblock.memory and memblock.reserved to an
interval tree? interval tree shall work perfectly since the switch to
long mode, no need of dynamic RAM allocations for its inner
working. There's no need to keep memblock a O(N) list.

Such change would benefit the code even if we remove the loop over
memblock.reserved.

> > > > @@ -7126,7 +7155,13 @@ unsigned long __init node_map_pfn_alignm
> > > >   */
> > > >  unsigned long __init find_min_pfn_with_active_regions(void)
> > > >  {
> > > > -	return PHYS_PFN(memblock_start_of_DRAM());
> > > > +	/*
> > > > +	 * reserved regions must be included so that their page
> > > > +	 * structure can be part of a zone and obtain a valid zoneid
> > > > +	 * before __SetPageReserved().
> > > > +	 */
> > > > +	return min(PHYS_PFN(memblock_start_of_DRAM()),
> > > > +		   PHYS_PFN(memblock.reserved.regions[0].base));
> > > 
> > > So this implies that reserved memory starts before memory. Don't you
> > > find this weird?
> > 
> > The above is a more complex way to write the below, which will make it
> > more clear there's never overlap:
> > 
> > 		if (entry->type == E820_TYPE_SOFT_RESERVED)
> > 			memblock_reserve(entry->addr, entry->size);
> > 		else if (entry->type == E820_TYPE_RAM || entry->type == E820_TYPE_RESERVED_KERN)
> > 			memblock_add(entry->addr, entry->size);
> 
> So what about E820_TYPE_ACPI or E820_TYPE_NVS?
> How should they be treated?
> 
> It happend that we memblock_reserve() the first page, but what if the
> BIOS marks pfn 1 as E820_TYPE_ACPI? It's neither in .memory nor in
> .reserved. Does it belong to zone 0 and node 0?
> 
> Or, if, say, node 1 starts at 4G and the BIOS claimed several first pages
> of node 1 as type 20?
> What should we do then?

I see we still have dependencies on the caller to send down good data,
which would be ideal to remove.

I guess before worrying of pfn 1 not being added to memblock.reserved,
I'd worry about pfn 0 itself not being added to memblock.reserved.

My above worry about pfn 0 not being added to memblock.reserved
doesn't change that:

- we still need to enlarge the DMA zone, even if pfn 0 is not added to
  memblock.reserved, if we want to really enforce the invariant that
  you can go to the start of the pageblock and pass the invariant on
  the first pfn, if any pfn in the first pageblock is in
  memblock.memory. So we also need to round down the start of the zone by
  the pageblock size. And adjust all range walks accordingly.

- Even after the rounddown, we still have to initialize the reserved
  ranges with pfn_valid or reserve_bootmem_region won't work at all if
  they don't happen to covered by the rounddown described above.

Still with the complex patch applied, if something goes wrong
DEBUG_VM=y will make it reproducible, with the simple fix we return in
non-reproducible land.

So I agree there's room for improvement and I believe the rounddown to
the start of the pageblock is needed for those zones that have no
adjacent region.

The important thing is that uninitialized pages are now left with
PagePoison now, at least with DEBUG_VM=y. And when a zoneid is
assigned to a page, that page is really is part of the zone. Both were
false before, so things already improved in that direction :).

Thanks,
Andrea

