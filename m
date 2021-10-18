Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531F54311E2
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 10:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhJRIKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 04:10:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51022 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhJRIKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 04:10:39 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0EE311FD6E;
        Mon, 18 Oct 2021 08:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634544508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JePU6+2oN7GhGNMVBxegpSr/+E0CIq9+0z2jEMw0y24=;
        b=YxS5QfnCGnhXwKLkAiDaa9YOpt28unqmdaLTNLLCJS2a52Rpy91AdvGAaCv1vG85fSvIZo
        eYE8nQ5g6uRfViPFlKxLq/nutsyMv1N/vzzmxto1G8aNc/CjihJJ/rTuZ0q89KQx0syzy0
        +x7dx2X26yw1SDEdaclqco72YzLFL/g=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CC463A3B83;
        Mon, 18 Oct 2021 08:08:27 +0000 (UTC)
Date:   Mon, 18 Oct 2021 10:08:27 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     david@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        vvs@virtuozzo.com
Subject: Re: + memcg-enable-memory-accounting-in-__alloc_pages_bulk.patch
 added to -mm tree
Message-ID: <YW0rezDJsSdfT79U@dhcp22.suse.cz>
References: <20211015213421.XJL-wQMwi%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015213421.XJL-wQMwi%akpm@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 15-10-21 14:34:21, Andrew Morton wrote:
> 
> The patch titled
>      Subject: memcg: enable memory accounting in __alloc_pages_bulk
> has been added to the -mm tree.  Its filename is
>      memcg-enable-memory-accounting-in-__alloc_pages_bulk.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-memory-accounting-in-__alloc_pages_bulk.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-memory-accounting-in-__alloc_pages_bulk.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Vasily Averin <vvs@virtuozzo.com>
> Subject: memcg: enable memory accounting in __alloc_pages_bulk
> 
> Bulk page allocator is used in vmalloc where it can be called
> with __GFP_ACCOUNT and must charge allocated pages into memory cgroup.
> 
> Link: https://lkml.kernel.org/r/65c1afaf-7947-ce28-55b7-06bde7aeb278@virtuozzo.com
> Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

I haven't acked this patch. Have you mixed this with Shakeel's patch
http://lkml.kernel.org/r/20211014151607.2171970-1-shakeelb@google.com?

> Acked-by: Roman Gushchin <guro@fb.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memcontrol.h |    9 ++++++
>  mm/memcontrol.c            |   50 +++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c            |   12 +++++++-
>  3 files changed, 69 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/memcontrol.h~memcg-enable-memory-accounting-in-__alloc_pages_bulk
> +++ a/include/linux/memcontrol.h
> @@ -1692,6 +1692,9 @@ static inline int memcg_cache_id(struct
>  
>  struct mem_cgroup *mem_cgroup_from_obj(void *p);
>  
> +int memcg_charge_bulk_pages(gfp_t gfp, int nr_pages,
> +			    struct list_head *page_list,
> +			    struct page **page_array);
>  #else
>  static inline bool mem_cgroup_kmem_disabled(void)
>  {
> @@ -1744,6 +1747,12 @@ static inline struct mem_cgroup *mem_cgr
>         return NULL;
>  }
>  
> +int memcg_charge_bulk_pages(gfp_t gfp, int nr_pages,
> +			    struct list_head *page_list,
> +			    struct page **page_array)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_MEMCG_KMEM */
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> --- a/mm/memcontrol.c~memcg-enable-memory-accounting-in-__alloc_pages_bulk
> +++ a/mm/memcontrol.c
> @@ -3288,6 +3288,56 @@ void obj_cgroup_uncharge(struct obj_cgro
>  	refill_obj_stock(objcg, size, true);
>  }
>  
> +/*
> + * memcg_charge_bulk_pages - Charge pages allocated by bulk allocator
> + * @gfp: GFP flags for the allocation
> + * @nr_pages: The number of pages added into the list or array
> + * @page_list: Optional list of allocated pages
> + * @page_array: Optional array of allocated pages
> + *
> + * Walks through array or list of allocated pages.
> + * For each page tries to charge it.
> + * If charge fails removes page from of array/list, frees it,
> + * and repeat it till end of array/list
> + *
> + * Returns the number of freed pages.
> + */
> +int memcg_charge_bulk_pages(gfp_t gfp, int nr_pages,
> +			    struct list_head *page_list,
> +			    struct page **page_array)
> +{
> +	struct page *page, *np = NULL;
> +	bool charge = true;
> +	int i, nr_freed = 0;
> +
> +	if (page_list)
> +		page = list_first_entry(page_list, struct page, lru);
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		if (page_list) {
> +			if (np)
> +				page = np;
> +			np = list_next_entry(page, lru);
> +		} else {
> +			page = page_array[i];
> +		}
> +		/* some pages in incoming array can be charged already */
> +		if (!page->memcg_data) {
> +			if (charge && __memcg_kmem_charge_page(page, gfp, 0))
> +				charge = false;
> +
> +			if (!charge) {
> +				if (page_list)
> +					list_del(&page->lru);
> +				else
> +					page_array[i] = NULL;
> +				__free_pages(page, 0);
> +				nr_freed++;
> +			}
> +		}
> +	}
> +	return nr_freed;
> +}
>  #endif /* CONFIG_MEMCG_KMEM */
>  
>  /*
> --- a/mm/page_alloc.c~memcg-enable-memory-accounting-in-__alloc_pages_bulk
> +++ a/mm/page_alloc.c
> @@ -5203,10 +5203,11 @@ unsigned long __alloc_pages_bulk(gfp_t g
>  	struct zoneref *z;
>  	struct per_cpu_pages *pcp;
>  	struct list_head *pcp_list;
> +	LIST_HEAD(tpl);
>  	struct alloc_context ac;
>  	gfp_t alloc_gfp;
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	int nr_populated = 0, nr_account = 0;
> +	int nr_populated = 0, nr_account = 0, nr_freed = 0;
>  
>  	/*
>  	 * Skip populated array elements to determine if any pages need
> @@ -5300,7 +5301,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		if (page_list)
> -			list_add(&page->lru, page_list);
> +			list_add(&page->lru, &tpl);
>  		else
>  			page_array[nr_populated] = page;
>  		nr_populated++;
> @@ -5308,6 +5309,13 @@ unsigned long __alloc_pages_bulk(gfp_t g
>  
>  	local_unlock_irqrestore(&pagesets.lock, flags);
>  
> +	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT) && nr_account)
> +       		nr_freed = memcg_charge_bulk_pages(gfp, nr_populated,
> +						   page_list ? &tpl : NULL,
> +						   page_array);
> +	nr_account -= nr_freed;
> +	nr_populated -= nr_freed;
> +	list_splice(&tpl, page_list);
>  	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
>  	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
>  
> _
> 
> Patches currently in -mm which might be from vvs@virtuozzo.com are
> 
> memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks.patch
> memcg-enable-memory-accounting-in-__alloc_pages_bulk.patch
> mm-vmalloc-repair-warn_allocs-in-__vmalloc_area_node.patch
> vmalloc-back-off-when-the-current-task-is-oom-killed.patch

-- 
Michal Hocko
SUSE Labs
