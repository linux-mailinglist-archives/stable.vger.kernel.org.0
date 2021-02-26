Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE40325A95
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 01:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBZAJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 19:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhBZAJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 19:09:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E2E64F1B;
        Fri, 26 Feb 2021 00:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614298133;
        bh=SPGaR5g39UFjRRi+Wfd5TSNrBSS9mMOZ47S3ieVyolQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aZr7iSM7EJuEHyUbA+qvCZz3rZ2Df2jXCHkrnAt25Wl5S4j3XV0yBGb4OaY63aTOu
         iq08VqOiNPdBH5QjhiU7kLEVMGDrFL0LejspCLsbdV+mWGmZv9iY8WdFbDu2bYkouM
         KdU13l5zpuWp0MtGfxEfuD7Ynr/9cxIZ6qq/KBBk=
Date:   Thu, 25 Feb 2021 16:08:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-Id: <20210225160851.43b50f0d02f8da958a2b7887@linux-foundation.org>
In-Reply-To: <20210225224351.7356-2-rppt@kernel.org>
References: <20210225224351.7356-1-rppt@kernel.org>
        <20210225224351.7356-2-rppt@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Feb 2021 00:43:51 +0200 Mike Rapoport <rppt@kernel.org> wrote:

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
> in set_pfnblock_flags_mask() when called with a struct page from a range
> other than E820_TYPE_RAM because there are pages in the range of ZONE_DMA32
> but the unset zone link in struct page makes them appear as a part of
> ZONE_DMA.
> 
> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.
> 
> With this change the pages for holes inside a zone will get proper
> zone/node links and the pages that are not spanned by any node will get
> links to the adjacent zone/node. The holes between nodes will be prepended
> to the zone/node above the hole and the trailing pages in the last section
> that will be appended to the zone/node below.
> 
> ...
>
> +#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> +/*
> + * Only struct pages that correspond to ranges defined by memblock.memory
> + * are zeroed and initialized by going through __init_single_page() during
> + * memmap_init_zone().
> + *
> + * But, there could be struct pages that correspond to holes in
> + * memblock.memory. This can happen because of the following reasons:
> + * - physical memory bank size is not necessarily the exact multiple of the
> + *   arbitrary section size
> + * - early reserved memory may not be listed in memblock.memory
> + * - memory layouts defined with memmap= kernel parameter may not align
> + *   nicely with memmap sections
> + *
> + * Explicitly initialize those struct pages so that:
> + * - PG_Reserved is set
> + * - zone and node links point to zone and node that span the page if the
> + *   hole is in the middle of a zone
> + * - zone and node links point to adjacent zone/node if the hole falls on
> + *   the zone boundary; the pages in such holes will be prepended to the
> + *   zone/node above the hole except for the trailing pages in the last
> + *   section that will be appended to the zone/node below.
> + */

The comment helps lot.

>  void __meminit __weak memmap_init_zone(struct zone *zone)
>  {
>  	unsigned long zone_start_pfn = zone->zone_start_pfn;
>  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>  	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> +	static unsigned long hole_pfn = 0;

static implies that pgdat->node_zones[] is alwyas sorted in ascending
pfn order.  Always true?

>  	unsigned long start_pfn, end_pfn;
> +	u64 pgcnt = 0;
>  
>  	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>  		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> @@ -6295,7 +6348,29 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
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
> +	/*
> +	 * Initialize the hole in the range [zone_end_pfn, section_end].
> +	 * If zone boundary falls in the middle of a section, this hole
> +	 * will be re-initialized during the call to this function for the
> +	 * higher zone.
> +	 */
> +	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
> +	if (hole_pfn < end_pfn)
> +		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
> +						zone_id, nid);
> +#endif
> +
> +	if (pgcnt)
> +		pr_info("  %s zone: %lld pages in unavailable ranges\n",
> +			zone->name, pgcnt);

I'll make that %llu


