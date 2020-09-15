Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18CF26A8BB
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 17:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgIOPYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 11:24:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:34770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbgIOPXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 11:23:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8A288AE0C;
        Tue, 15 Sep 2020 13:35:27 +0000 (UTC)
Date:   Tue, 15 Sep 2020 15:35:11 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by meminit_context
Message-ID: <20200915133511.GA3736@dhcp22.suse.cz>
References: <20200915121541.GD4649@dhcp22.suse.cz>
 <20200915132624.9723-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915132624.9723-1-ldufour@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 15-09-20 15:26:24, Laurent Dufour wrote:
> The memmap_context enum is used to detect whether a memory operation is due
> to a hot-add operation or happening at boot time.
> 
> Make it general to the hotplug operation and rename it as meminit_context.
> 
> There is no functional change introduced by this patch
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  arch/ia64/mm/init.c    |  6 +++---
>  include/linux/mm.h     |  2 +-
>  include/linux/mmzone.h | 11 ++++++++---
>  mm/memory_hotplug.c    |  2 +-
>  mm/page_alloc.c        | 10 +++++-----
>  5 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
> index 0b3fb4c7af29..8e7b8c6c576e 100644
> --- a/arch/ia64/mm/init.c
> +++ b/arch/ia64/mm/init.c
> @@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
>  	if (map_start < map_end)
>  		memmap_init_zone((unsigned long)(map_end - map_start),
>  				 args->nid, args->zone, page_to_pfn(map_start),
> -				 MEMMAP_EARLY, NULL);
> +				 MEMINIT_EARLY, NULL);
>  	return 0;
>  }
>  
> @@ -547,8 +547,8 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
>  	     unsigned long start_pfn)
>  {
>  	if (!vmem_map) {
> -		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY,
> -				NULL);
> +		memmap_init_zone(size, nid, zone, start_pfn,
> +				 MEMINIT_EARLY, NULL);
>  	} else {
>  		struct page *start;
>  		struct memmap_init_callback_data args;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1983e08f5906..e942f91ed155 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2409,7 +2409,7 @@ extern int __meminit __early_pfn_to_nid(unsigned long pfn,
>  
>  extern void set_dma_reserve(unsigned long new_dma_reserve);
>  extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
> -		enum memmap_context, struct vmem_altmap *);
> +		enum meminit_context, struct vmem_altmap *);
>  extern void setup_per_zone_wmarks(void);
>  extern int __meminit init_per_zone_wmark_min(void);
>  extern void mem_init(void);
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 8379432f4f2f..0f7a4ff4b059 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -824,10 +824,15 @@ bool zone_watermark_ok(struct zone *z, unsigned int order,
>  		unsigned int alloc_flags);
>  bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
>  		unsigned long mark, int highest_zoneidx);
> -enum memmap_context {
> -	MEMMAP_EARLY,
> -	MEMMAP_HOTPLUG,
> +/*
> + * Memory initialization context, use to differentiate memory added by
> + * the platform statically or via memory hotplug interface.
> + */
> +enum meminit_context {
> +	MEMINIT_EARLY,
> +	MEMINIT_HOTPLUG,
>  };
> +
>  extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
>  				     unsigned long size);
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index e9d5ab5d3ca0..fc25886ad719 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -729,7 +729,7 @@ void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	 * are reserved so nobody should be touching them so we should be safe
>  	 */
>  	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
> -			MEMMAP_HOTPLUG, altmap);
> +			 MEMINIT_HOTPLUG, altmap);
>  
>  	set_zone_contiguous(zone);
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fab5e97dc9ca..5661fa164f13 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5975,7 +5975,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>   * done. Non-atomic initialization, single-pass.
>   */
>  void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
> -		unsigned long start_pfn, enum memmap_context context,
> +		unsigned long start_pfn, enum meminit_context context,
>  		struct vmem_altmap *altmap)
>  {
>  	unsigned long pfn, end_pfn = start_pfn + size;
> @@ -6007,7 +6007,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>  		 * There can be holes in boot-time mem_map[]s handed to this
>  		 * function.  They do not exist on hotplugged memory.
>  		 */
> -		if (context == MEMMAP_EARLY) {
> +		if (context == MEMINIT_EARLY) {
>  			if (overlap_memmap_init(zone, &pfn))
>  				continue;
>  			if (defer_init(nid, pfn, end_pfn))
> @@ -6016,7 +6016,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>  
>  		page = pfn_to_page(pfn);
>  		__init_single_page(page, pfn, zone, nid);
> -		if (context == MEMMAP_HOTPLUG)
> +		if (context == MEMINIT_HOTPLUG)
>  			__SetPageReserved(page);
>  
>  		/*
> @@ -6099,7 +6099,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  		 * check here not to call set_pageblock_migratetype() against
>  		 * pfn out of zone.
>  		 *
> -		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
> +		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
>  		 * because this is done early in section_activate()
>  		 */
>  		if (!(pfn & (pageblock_nr_pages - 1))) {
> @@ -6137,7 +6137,7 @@ void __meminit __weak memmap_init(unsigned long size, int nid,
>  		if (end_pfn > start_pfn) {
>  			size = end_pfn - start_pfn;
>  			memmap_init_zone(size, nid, zone, start_pfn,
> -					 MEMMAP_EARLY, NULL);
> +					 MEMINIT_EARLY, NULL);
>  		}
>  	}
>  }
> -- 
> 2.28.0

-- 
Michal Hocko
SUSE Labs
