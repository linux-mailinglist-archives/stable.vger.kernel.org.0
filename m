Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59833254DF
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 18:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhBYRxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 12:53:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:60978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232982AbhBYRwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 12:52:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37A0BAD57;
        Thu, 25 Feb 2021 17:51:54 +0000 (UTC)
To:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of struct
 page for holes in memory layout
Message-ID: <a4b2ba7e-96a5-6a75-dad7-626d054f9e8b@suse.cz>
Date:   Thu, 25 Feb 2021 18:51:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224153950.20789-2-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/24/21 4:39 PM, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>

Hi, thanks for your efforts. I'll just nit pick on the description/comments as I
don't feel confident about judging the implementation correctness, sorry :)

> There could be struct pages that are not backed by actual physical memory.
> This can happen when the actual memory bank is not a multiple of
> SECTION_SIZE or when an architecture does not register memory holes
> reserved by the firmware as memblock.memory.
> 
> Such pages are currently initialized using init_unavailable_mem() function
> that iterates through PFNs in holes in memblock.memory and if there is a
> struct page corresponding to a PFN, the fields of this page are set to
> default values and it is marked as Reserved.
> 
> init_unavailable_mem() does not take into account zone and node the page
> belongs to and sets both zone and node links in struct page to zero.
> 
> Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> rather that check each PFN") the holes inside a zone were re-initialized
> during memmap_init() and got their zone/node links right. However, after
> that commit nothing updates the struct pages representing such holes.
> 
> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> instance in a configuration below:
> 
> 	# grep -A1 E820 /proc/iomem
> 	7a17b000-7a216fff : Unknown E820 type
> 	7a217000-7bffffff : System RAM
> 
> unset zone link in struct page will trigger
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

... in set_pfnblock_flags_mask() when called with a struct page from the
"Unknown E820 type" range.

> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> in struct page) in the same pageblock.

I would say "there are apparently pages" ... "and ZONE_DMA does not span this range"

> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.
> 
> With this change the pages for holes inside a zone will get proper
> zone/node links and the pages that are not spanned by any node will get
> links to the adjacent zone/node.

What if two zones are adjacent? I.e. if the hole was at a boundary between two
zones.

> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Reviewed-by: Baoquan He <bhe@redhat.com>

For the approach:
Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 147 +++++++++++++++++++++---------------------------
>  1 file changed, 64 insertions(+), 83 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e93f8b29bae..a11a9acde708 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6280,12 +6280,60 @@ static void __meminit zone_init_free_lists(struct zone *zone)
>  	}
>  }
>  
> +#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> +/*
> + * Only struct pages that correspond to ranges defined by memblock.memory
> + * are zeroed and initialized by going through __init_single_page() during
> + * memmap_init_zone().
> + *
> + * But, there could be struct pages that correspond to holes in
> + * memblock.memory. This can happen because of the following reasons:
> + * - phyiscal memory bank size is not necessarily the exact multiple of the

        physical

> + *   arbitrary section size
> + * - early reserved memory may not be listed in memblock.memory
> + * - memory layouts defined with memmap= kernel parameter may not align
> + *   nicely with memmap sections
> + *
> + * Explicitly initialize those struct pages so that:
> + * - PG_Reserved is set
> + * - zone and node links point to zone and node that span the page

Yes spanned pages are the most important, but should you also describe here the
adjacent ones, as you do in commit log?

> + */
> +static u64 __meminit init_unavailable_range(unsigned long spfn,
> +					    unsigned long epfn,
> +					    int zone, int node)
> +{
> +	unsigned long pfn;
> +	u64 pgcnt = 0;
> +
> +	for (pfn = spfn; pfn < epfn; pfn++) {
> +		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
> +			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
> +				+ pageblock_nr_pages - 1;
> +			continue;
> +		}
> +		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> +		__SetPageReserved(pfn_to_page(pfn));
> +		pgcnt++;
> +	}
> +
> +	return pgcnt;
> +}
> +#else
> +static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
> +					 int zone, int node)
> +{
> +	return 0;
> +}
> +#endif
> +
>  void __meminit __weak memmap_init_zone(struct zone *zone)
>  {
>  	unsigned long zone_start_pfn = zone->zone_start_pfn;
>  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>  	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> +	static unsigned long hole_pfn = 0;
>  	unsigned long start_pfn, end_pfn;
> +	u64 pgcnt = 0;
>  
>  	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>  		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> @@ -6295,7 +6343,23 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
>  			memmap_init_range(end_pfn - start_pfn, nid,
>  					zone_id, start_pfn, zone_end_pfn,
>  					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
> +
> +		if (hole_pfn < start_pfn)
> +			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
> +							zone_id, nid);
> +		hole_pfn = end_pfn;
>  	}
> +
> +#ifdef CONFIG_SPARSEMEM
> +	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
> +	if (hole_pfn < end_pfn)
> +		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
> +						zone_id, nid);
> +#endif
> +
> +	if (pgcnt)
> +		pr_info("  %s zone: %lld pages in unavailable ranges\n",
> +			zone->name, pgcnt);
>  }
>  
>  static int zone_batchsize(struct zone *zone)
> @@ -7092,88 +7156,6 @@ void __init free_area_init_memoryless_node(int nid)
>  	free_area_init_node(nid);
>  }
>  
> -#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> -/*
> - * Initialize all valid struct pages in the range [spfn, epfn) and mark them
> - * PageReserved(). Return the number of struct pages that were initialized.
> - */
> -static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
> -{
> -	unsigned long pfn;
> -	u64 pgcnt = 0;
> -
> -	for (pfn = spfn; pfn < epfn; pfn++) {
> -		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
> -			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
> -				+ pageblock_nr_pages - 1;
> -			continue;
> -		}
> -		/*
> -		 * Use a fake node/zone (0) for now. Some of these pages
> -		 * (in memblock.reserved but not in memblock.memory) will
> -		 * get re-initialized via reserve_bootmem_region() later.
> -		 */
> -		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
> -		__SetPageReserved(pfn_to_page(pfn));
> -		pgcnt++;
> -	}
> -
> -	return pgcnt;
> -}
> -
> -/*
> - * Only struct pages that are backed by physical memory are zeroed and
> - * initialized by going through __init_single_page(). But, there are some
> - * struct pages which are reserved in memblock allocator and their fields
> - * may be accessed (for example page_to_pfn() on some configuration accesses
> - * flags). We must explicitly initialize those struct pages.
> - *
> - * This function also addresses a similar issue where struct pages are left
> - * uninitialized because the physical address range is not covered by
> - * memblock.memory or memblock.reserved. That could happen when memblock
> - * layout is manually configured via memmap=, or when the highest physical
> - * address (max_pfn) does not end on a section boundary.
> - */
> -static void __init init_unavailable_mem(void)
> -{
> -	phys_addr_t start, end;
> -	u64 i, pgcnt;
> -	phys_addr_t next = 0;
> -
> -	/*
> -	 * Loop through unavailable ranges not covered by memblock.memory.
> -	 */
> -	pgcnt = 0;
> -	for_each_mem_range(i, &start, &end) {
> -		if (next < start)
> -			pgcnt += init_unavailable_range(PFN_DOWN(next),
> -							PFN_UP(start));
> -		next = end;
> -	}
> -
> -	/*
> -	 * Early sections always have a fully populated memmap for the whole
> -	 * section - see pfn_valid(). If the last section has holes at the
> -	 * end and that section is marked "online", the memmap will be
> -	 * considered initialized. Make sure that memmap has a well defined
> -	 * state.
> -	 */
> -	pgcnt += init_unavailable_range(PFN_DOWN(next),
> -					round_up(max_pfn, PAGES_PER_SECTION));
> -
> -	/*
> -	 * Struct pages that do not have backing memory. This could be because
> -	 * firmware is using some of this memory, or for some other reasons.
> -	 */
> -	if (pgcnt)
> -		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
> -}
> -#else
> -static inline void __init init_unavailable_mem(void)
> -{
> -}
> -#endif /* !CONFIG_FLAT_NODE_MEM_MAP */
> -
>  #if MAX_NUMNODES > 1
>  /*
>   * Figure out the number of possible node ids.
> @@ -7597,7 +7579,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();
> -	init_unavailable_mem();
>  	for_each_online_node(nid) {
>  		pg_data_t *pgdat = NODE_DATA(nid);
>  		free_area_init_node(nid);
> 

