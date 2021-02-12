Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36E9319C33
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 10:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhBLJ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 04:58:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhBLJ56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 04:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613123791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7yGM74b6IVdGi3cBHRm26f8aU2+QxRSs1cbPQ3iAFeo=;
        b=JptDVXo+6CMJ4t2c3QNU4Judk+KIzMXibiXNfoP1O2IgVJy71AhvqKzJnR771MyC7JHUkr
        lD0vSAq6Ksj5rpzvwQqptGcOXIqkDyUVvs3X39i7K75xzJzyi/uRZjmMPJzaU0LcF0r0xN
        +wnGce3FKslTrgtumZ4cxVTlgge4Ey4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-wpJ0hdjQNhmAQoQiGbTfcw-1; Fri, 12 Feb 2021 04:56:27 -0500
X-MC-Unique: wpJ0hdjQNhmAQoQiGbTfcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B83CB192AB78;
        Fri, 12 Feb 2021 09:56:24 +0000 (UTC)
Received: from [10.36.114.178] (ovpn-114-178.ams2.redhat.com [10.36.114.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B09660BF1;
        Fri, 12 Feb 2021 09:56:20 +0000 (UTC)
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
From:   David Hildenbrand <david@redhat.com>
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
References: <20210208110820.6269-1-rppt@kernel.org>
 <5dccbc93-f260-7f14-23bc-6dee2dff6c13@redhat.com>
Organization: Red Hat GmbH
Message-ID: <a6cf3a26-a174-abab-a5a0-6cf89ebe4af7@redhat.com>
Date:   Fri, 12 Feb 2021 10:56:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <5dccbc93-f260-7f14-23bc-6dee2dff6c13@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.02.21 10:55, David Hildenbrand wrote:
> On 08.02.21 12:08, Mike Rapoport wrote:
>> From: Mike Rapoport <rppt@linux.ibm.com>
>>
>> There could be struct pages that are not backed by actual physical memory.
>> This can happen when the actual memory bank is not a multiple of
>> SECTION_SIZE or when an architecture does not register memory holes
>> reserved by the firmware as memblock.memory.
>>
>> Such pages are currently initialized using init_unavailable_mem() function
>> that iterates through PFNs in holes in memblock.memory and if there is a
>> struct page corresponding to a PFN, the fields of this page are set to
>> default values and it is marked as Reserved.
>>
>> init_unavailable_mem() does not take into account zone and node the page
>> belongs to and sets both zone and node links in struct page to zero.
>>
>> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
>> instance in a configuration below:
>>
>> 	# grep -A1 E820 /proc/iomem
>> 	7a17b000-7a216fff : Unknown E820 type
>> 	7a217000-7bffffff : System RAM
>>
>> unset zone link in struct page will trigger
>>
>> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
>>
>> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
>> in struct page) in the same pageblock.
>>
>> Moreover, it is possible that the lowest node and zone start is not aligned
>> to the section boundarie, for example on x86:
>>
>> [    0.078898] Zone ranges:
>> [    0.078899]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>> ...
>> [    0.078910] Early memory node ranges
>> [    0.078912]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
>> [    0.078913]   node   0: [mem 0x0000000000100000-0x000000003fffffff]
>>
>> and thus with SPARSEMEM memory model the beginning of the memory map will
>> have struct pages that are not spanned by any node and zone.
>>
>> Update detection of node boundaries in get_pfn_range_for_nid() so that the
>> node range will be expanded to cover memory map section. Since zone spans
>> are derived from the node span, there always will be a zone that covers the
>> part of the memory map with unavailable pages.
>>
>> Interleave initialization of the unavailable pages with the normal
>> initialization of memory map, so that zone and node information will be
>> properly set on struct pages that are not backed by the actual memory.
>>
>> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
>> that check each PFN")
>> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>> Cc: Baoquan He <bhe@redhat.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Qian Cai <cai@lca.pw>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>    mm/page_alloc.c | 160 +++++++++++++++++++++++-------------------------
>>    1 file changed, 75 insertions(+), 85 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 6446778cbc6b..1c3f7521028f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6257,22 +6257,84 @@ static void __meminit zone_init_free_lists(struct zone *zone)
>>    	}
>>    }
>>    
>> +#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
>> +/*
>> + * Only struct pages that correspond to ranges defined by memblock.memory
>> + * are zeroed and initialized by going through __init_single_page() during
>> + * memmap_init_zone().
>> + *
>> + * But, there could be struct pages that correspond to holes in
>> + * memblock.memory. This can happen because of the following reasons:
>> + * - phyiscal memory bank size is not necessarily the exact multiple of the
>> + *   arbitrary section size
>> + * - early reserved memory may not be listed in memblock.memory
>> + * - memory layouts defined with memmap= kernel parameter may not align
>> + *   nicely with memmap sections
>> + *
>> + * Explicitly initialize those struct pages so that:
>> + * - PG_Reserved is set
>> + * - zone and node links point to zone and node that span the page
>> + */
>> +static u64 __meminit init_unavailable_range(unsigned long spfn,
>> +					    unsigned long epfn,
>> +					    int zone, int node)
>> +{
>> +	unsigned long pfn;
>> +	u64 pgcnt = 0;
>> +
>> +	for (pfn = spfn; pfn < epfn; pfn++) {
>> +		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
>> +			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
>> +				+ pageblock_nr_pages - 1;
>> +			continue;
>> +		}
>> +		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
>> +		__SetPageReserved(pfn_to_page(pfn));
>> +		pgcnt++;
>> +	}
>> +
>> +	return pgcnt;
>> +}
>> +#else
>> +static inline u64 init_unavailable_range(unsigned long spfn, unsigned long epfn,
>> +					 int zone, int node)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>>    void __meminit __weak memmap_init_zone(struct zone *zone)
>>    {
>>    	unsigned long zone_start_pfn = zone->zone_start_pfn;
>>    	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>>    	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
>>    	unsigned long start_pfn, end_pfn;
>> +	unsigned long hole_pfn = 0;
>> +	u64 pgcnt = 0;
>>    
>>    	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>>    		start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>>    		end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
>> +		hole_pfn = clamp(hole_pfn, zone_start_pfn, zone_end_pfn);
>>    
>>    		if (end_pfn > start_pfn)
>>    			memmap_init_range(end_pfn - start_pfn, nid,
>>    					zone_id, start_pfn, zone_end_pfn,
>>    					MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
>> +
>> +		if (hole_pfn < start_pfn)
>> +			pgcnt += init_unavailable_range(hole_pfn, start_pfn,
>> +							zone_id, nid);
>> +		hole_pfn = end_pfn;
>>    	}
>> +
>> +	if (hole_pfn < zone_end_pfn)
>> +		pgcnt += init_unavailable_range(hole_pfn, zone_end_pfn,
>> +						zone_id, nid);
>> +
>> +	if (pgcnt)
>> +		pr_info("  %s zone: %lld pages in unavailable ranges\n",
>> +			zone->name, pgcnt);
>>    }
>>    
>>    static int zone_batchsize(struct zone *zone)
>> @@ -6519,8 +6581,19 @@ void __init get_pfn_range_for_nid(unsigned int nid,
>>    		*end_pfn = max(*end_pfn, this_end_pfn);
>>    	}
>>    
>> -	if (*start_pfn == -1UL)
>> +	if (*start_pfn == -1UL) {
>>    		*start_pfn = 0;
>> +		return;
>> +	}
>> +
>> +#ifdef CONFIG_SPARSEMEM
>> +	/*
>> +	 * Sections in the memory map may not match actual populated
>> +	 * memory, extend the node span to cover the entire section.
>> +	 */
>> +	*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
>> +	*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
> 
> Does that mean that we might create overlapping zones when one node

s/overlapping zones/overlapping nodes/

> starts in the middle of a section and the other one ends in the middle
> of a section?
> 
> Could it be a problem? (e.g., would we have to look at neighboring nodes
> when making the decision to extend, and how far to extend?)
> 


-- 
Thanks,

David / dhildenb

