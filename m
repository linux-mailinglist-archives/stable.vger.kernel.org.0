Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3632236D
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 02:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBWBRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 20:17:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhBWBRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 20:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614042967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z06oP2BonMtvWqkjwE3/34hVf9FcpnpURlORAYi8j3g=;
        b=Y0FvxUpStx1Wmvy32yiHIWUfOZaN7BVAYEAGHHwEY3O2qeP6Ze99rTLxPWsa6e8voijeyk
        jjNe0ReMJtHpktc2oX0/ryTkKqhIXUT9xQuZBrzahoE0OBxXPQmfK+OTgW62S88043BDjT
        wCx2MxXxceK2WHwOgYLa2wsnVOtIxBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-jP6MU6_jNrOzD0wXp7FWHA-1; Mon, 22 Feb 2021 20:16:03 -0500
X-MC-Unique: jP6MU6_jNrOzD0wXp7FWHA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5F12107ACF6;
        Tue, 23 Feb 2021 01:16:00 +0000 (UTC)
Received: from localhost (ovpn-12-41.pek2.redhat.com [10.72.12.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72A306091A;
        Tue, 23 Feb 2021 01:15:56 +0000 (UTC)
Date:   Tue, 23 Feb 2021 09:15:54 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v6 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210223011554.GP2871@MiWiFi-R3L-srv>
References: <20210222105728.28636-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222105728.28636-1-rppt@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/22/21 at 12:57pm, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
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

Yeah, and the old code re-initialized the unavailable memory in a
implicit and confusing way. This patch does it explicitly in the similar
way to make it basically consistent with the old code. This looks great
to me.

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
> 
> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> in struct page) in the same pageblock.
> 
> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.
> 
> With this change the pages for holes inside a zone will get proper
> zone/node links and the pages that are not spanned by any node will get
> links to the adjacent zone/node.

Thanks for spending so much effort with patience to fix this.

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/page_alloc.c | 144 ++++++++++++++++++++----------------------------
>  1 file changed, 61 insertions(+), 83 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e93f8b29bae..1f1db70b7789 100644
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
> + *   arbitrary section size
> + * - early reserved memory may not be listed in memblock.memory
> + * - memory layouts defined with memmap= kernel parameter may not align
> + *   nicely with memmap sections
> + *
> + * Explicitly initialize those struct pages so that:
> + * - PG_Reserved is set
> + * - zone and node links point to zone and node that span the page
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
> @@ -6295,7 +6343,20 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
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
> +	if (hole_pfn < zone_end_pfn)
> +		pgcnt += init_unavailable_range(hole_pfn, zone_end_pfn,
> +						zone_id, nid);
> +
> +	if (pgcnt)
> +		pr_info("  %s zone: %lld pages in unavailable ranges\n",
> +			zone->name, pgcnt);
>  }
>  
>  static int zone_batchsize(struct zone *zone)
> @@ -7092,88 +7153,6 @@ void __init free_area_init_memoryless_node(int nid)
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
> @@ -7597,7 +7576,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();
> -	init_unavailable_mem();
>  	for_each_online_node(nid) {
>  		pg_data_t *pgdat = NODE_DATA(nid);
>  		free_area_init_node(nid);
> -- 
> 2.28.0
> 

