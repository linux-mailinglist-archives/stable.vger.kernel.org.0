Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170912D9952
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgLNN75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 08:59:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbgLNN75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 08:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607954309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=19AFvZsQ/zMIF0IpM05qhVWQsCmXclZCgWV07nIuE1I=;
        b=XjHzig8FP/rlbjVdrj+UOAwbVZje3RZANo+GOzsebtIvlqzeUgUT8pe10FFYw3L11LpJ+F
        FleVGX174Ed/7AH2O6lAeBTiRqHOU179t0+j2yndgiykQZWd/MSENEsYYONBthJ8UrSXKU
        8hkOALnxRHk0xGAxB2kEIyfZYiFAJNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-9JgNDnytNpi6Hmwov_4l4g-1; Mon, 14 Dec 2020 08:58:27 -0500
X-MC-Unique: 9JgNDnytNpi6Hmwov_4l4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C336F107ACF6;
        Mon, 14 Dec 2020 13:58:24 +0000 (UTC)
Received: from mail (ovpn-119-164.rdu2.redhat.com [10.10.119.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35C4A3828;
        Mon, 14 Dec 2020 13:58:21 +0000 (UTC)
Date:   Mon, 14 Dec 2020 08:58:20 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baoquan He <bhe@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/2] mm: memblock: enforce overlap of memory.memblock
 and memory.reserved
Message-ID: <X9dvfDcSrlEj5y6K@redhat.com>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-2-rppt@kernel.org>
 <522640a5-32ab-2247-4c2a-f248c2528f97@redhat.com>
 <20201214111221.GC198219@kernel.org>
 <a512bd63-b171-3ed5-6996-2c99b6c9a226@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a512bd63-b171-3ed5-6996-2c99b6c9a226@redhat.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 12:18:07PM +0100, David Hildenbrand wrote:
> On 14.12.20 12:12, Mike Rapoport wrote:
> > On Mon, Dec 14, 2020 at 11:11:35AM +0100, David Hildenbrand wrote:
> >> On 09.12.20 22:43, Mike Rapoport wrote:
> >>> From: Mike Rapoport <rppt@linux.ibm.com>
> >>>
> >>> memblock does not require that the reserved memory ranges will be a subset
> >>> of memblock.memory.
> >>>
> >>> As the result there maybe reserved pages that are not in the range of any
> >>> zone or node because zone and node boundaries are detected based on
> >>> memblock.memory and pages that only present in memblock.reserved are not
> >>> taken into account during zone/node size detection.
> >>>
> >>> Make sure that all ranges in memblock.reserved are added to memblock.memory
> >>> before calculating node and zone boundaries.
> >>>
> >>> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> >>> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> >>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> >>> ---
> >>>  include/linux/memblock.h |  1 +
> >>>  mm/memblock.c            | 24 ++++++++++++++++++++++++
> >>>  mm/page_alloc.c          |  7 +++++++
> >>>  3 files changed, 32 insertions(+)
> >>>
> >>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> >>> index ef131255cedc..e64dae2dd1ce 100644
> >>> --- a/include/linux/memblock.h
> >>> +++ b/include/linux/memblock.h
> >>> @@ -120,6 +120,7 @@ int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
> >>>  unsigned long memblock_free_all(void);
> >>>  void reset_node_managed_pages(pg_data_t *pgdat);
> >>>  void reset_all_zones_managed_pages(void);
> >>> +void memblock_enforce_memory_reserved_overlap(void);
> >>>  
> >>>  /* Low level functions */
> >>>  void __next_mem_range(u64 *idx, int nid, enum memblock_flags flags,
> >>> diff --git a/mm/memblock.c b/mm/memblock.c
> >>> index b68ee86788af..9277aca642b2 100644
> >>> --- a/mm/memblock.c
> >>> +++ b/mm/memblock.c
> >>> @@ -1857,6 +1857,30 @@ void __init_memblock memblock_trim_memory(phys_addr_t align)
> >>>  	}
> >>>  }
> >>>  
> >>> +/**
> >>> + * memblock_enforce_memory_reserved_overlap - make sure every range in
> >>> + * @memblock.reserved is covered by @memblock.memory
> >>> + *
> >>> + * The data in @memblock.memory is used to detect zone and node boundaries
> >>> + * during initialization of the memory map and the page allocator. Make
> >>> + * sure that every memory range present in @memblock.reserved is also added
> >>> + * to @memblock.memory even if the architecture specific memory
> >>> + * initialization failed to do so
> >>> + */
> >>> +void __init memblock_enforce_memory_reserved_overlap(void)
> >>> +{
> >>> +	phys_addr_t start, end;
> >>> +	int nid;
> >>> +	u64 i;
> >>> +
> >>> +	__for_each_mem_range(i, &memblock.reserved, &memblock.memory,
> >>> +			     NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, &nid) {
> >>> +		pr_warn("memblock: reserved range [%pa-%pa] is not in memory\n",
> >>> +			&start, &end);
> >>> +		memblock_add_node(start, (end - start), nid);
> >>> +	}
> >>> +}
> >>> +
> >>>  void __init_memblock memblock_set_current_limit(phys_addr_t limit)
> >>>  {
> >>>  	memblock.current_limit = limit;
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index eaa227a479e4..dbc57dbbacd8 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -7436,6 +7436,13 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> >>>  	memset(arch_zone_highest_possible_pfn, 0,
> >>>  				sizeof(arch_zone_highest_possible_pfn));
> >>>  
> >>> +	/*
> >>> +	 * Some architectures (e.g. x86) have reserved pages outside of
> >>> +	 * memblock.memory. Make sure these pages are taken into account
> >>> +	 * when detecting zone and node boundaries
> >>> +	 */
> >>> +	memblock_enforce_memory_reserved_overlap();
> >>> +
> >>>  	start_pfn = find_min_pfn_with_active_regions();
> >>>  	descending = arch_has_descending_max_zone_pfns();
> >>>  
> >>>
> >>
> >> CCing Dan.
> >>
> >> This implies that any memory that is E820_TYPE_SOFT_RESERVED that was
> >> reserved via memblock_reserve() will be added via memblock_add_node() as
> >> well, resulting in all such memory getting a memmap allocated right when
> >> booting up, right?
> >>
> >> IIRC, there are use cases where that is absolutely not desired.
> > 
> > Hmm, if this is the case we need entirely different solution to ensure
> > that we don't have partial pageblocks in a zone and we have all the
> > memory map initialized to a known state.
> > 
> >> Am I missing something? (@Dan?)
> > 
> > BTW, @Dan, why did you need to memblock_reserve(E820_TYPE_SOFT_RESERVED)
> > without memblock_add()ing it?
> 
> I suspect to cover cases where it might partially span memory sections
> (or even sub-sections). Maybe we should focus on initializing that part
> only - meaning, not adding all memory to .memory but only !section
> aligned pieces.

We had that information left in the memblock data structure with the
previous implementation in -mm (before adding all memblock.reserved to
memblock.memory). To avoid destroying that information we'll need a
new flag for each range that is not originally in memblock.memory:

===
What you suggest would require adding extra information to flag which
ranges must not have a direct mapping, but that information is already
in memblock today, for each range in memblock_reserved but not in
memblock.memory or did I misunderstand how that no-direct-map detail works?
===

I guess I was too optimistic that this was already implemented, thanks
for noticing.

For the record, I didn't have time to test the new implementation
yet. Since I'm running the "hack" on all machines things have been
stable on v5.9. I'm actually curious if the hack would also fail boot
on the CI system or not, that would help localize the issue into the
implicit memblock_add at least. The memblock debug output won't give
us a direct reproducer, but we can try to generate one by reproducing
the same e820 map in seabios.

Andrea

