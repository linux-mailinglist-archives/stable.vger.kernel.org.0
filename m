Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F403252EC
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 17:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhBYQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 11:00:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhBYQAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 11:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614268768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TqEs2s9NIJ3mhMA0+/qlDylBOaw6l4Ll6nMq3B0MxfE=;
        b=b5EF6q0+amub7bsDQw0qTjHNFUbhS5pe3ODUWPDixD6TBGD5EuaNDZPqU+OhPKbS+MZScl
        NqDmyimYhlAFyStP/yyQ5HtceLRvKdvNyWVAsNN0gRfy/MMaWov8BCJhgT+J5g8qEtR5Qf
        mP2Sh0/pbB7RmMYN19WzTw0lKYcScOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-31PQjnKxPSmTSlKR5Bx0sA-1; Thu, 25 Feb 2021 10:59:23 -0500
X-MC-Unique: 31PQjnKxPSmTSlKR5Bx0sA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CD43107ACC7;
        Thu, 25 Feb 2021 15:59:20 +0000 (UTC)
Received: from [10.36.114.58] (ovpn-114-58.ams2.redhat.com [10.36.114.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E74696EF76;
        Thu, 25 Feb 2021 15:59:06 +0000 (UTC)
To:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of struct
 page for holes in memory layout
Message-ID: <515b4abf-ff07-a43a-ac2e-132c33681886@redhat.com>
Date:   Thu, 25 Feb 2021 16:59:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210224153950.20789-2-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.02.21 16:39, Mike Rapoport wrote:
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
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Reviewed-by: Baoquan He <bhe@redhat.com>
> ---
>   mm/page_alloc.c | 147 +++++++++++++++++++++---------------------------
>   1 file changed, 64 insertions(+), 83 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e93f8b29bae..a11a9acde708 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6280,12 +6280,60 @@ static void __meminit zone_init_free_lists(struct zone *zone)
>   	}
>   }
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
>   void __meminit __weak memmap_init_zone(struct zone *zone)
>   {
>   	unsigned long zone_start_pfn = zone->zone_start_pfn;
>   	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>   	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> +	static unsigned long hole_pfn = 0;
>   	unsigned long start_pfn, end_pfn;
> +	u64 pgcnt = 0;
>   
>   	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>   		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> @@ -6295,7 +6343,23 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
>   			memmap_init_range(end_pfn - start_pfn, nid,
>   					zone_id, start_pfn, zone_end_pfn,
>   					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
> +
> +		if (hole_pfn < start_pfn)
> +			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
> +							zone_id, nid);
> +		hole_pfn = end_pfn;
>   	}
> +
> +#ifdef CONFIG_SPARSEMEM
> +	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
> +	if (hole_pfn < end_pfn)
> +		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
> +						zone_id, nid);

We might still double-initialize PFNs when two zones overlap within a 
section, correct? This might worth documenting - also, you might want to 
take some of the original comment the accompanied this code.

You should also document (in the patch description?) that node/zone 
spans are not properly handled yet for such hole pfns and that this 
might require care in the future.


I played a little with weird setups and expected the memap state using 
page-types (well, I can't inspect the node/zone that way but at least 
have a look if the memmap was initialized). No surprises.

-- 
Thanks,

David / dhildenb

