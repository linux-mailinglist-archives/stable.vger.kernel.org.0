Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289D026A303
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 12:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIOKRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 06:17:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726102AbgIOKRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 06:17:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600165063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=oJ2rAB4SOLfURcd7/LtQ+u/ygWwDntMtn4B4YzvQGK8=;
        b=Jf5NZ1vzyh+celdLvhvBYwqUDifb96WwYkfH5ISlVWUfMxI2WGhk7tTkIrw4+NXmrNsTUq
        oYiIw0VOEuAtONDGOz5NYELkeLh8cXzLxSE9jcQmQTp0jaTPm4wOEubz4hTSuf/ZbBJ9zu
        1N3cL7fP5aaCyG9uxE2rJ6g477pRbW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-oJ2Lq-d6MRqVxRRBCKjbug-1; Tue, 15 Sep 2020 06:17:39 -0400
X-MC-Unique: oJ2Lq-d6MRqVxRRBCKjbug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E013857058;
        Tue, 15 Sep 2020 10:17:34 +0000 (UTC)
Received: from [10.36.114.89] (ovpn-114-89.ams2.redhat.com [10.36.114.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F13DF5C3E0;
        Tue, 15 Sep 2020 10:17:31 +0000 (UTC)
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by memplug_context
To:     Laurent Dufour <ldufour@linux.ibm.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, mhocko@suse.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200915094143.79181-1-ldufour@linux.ibm.com>
 <20200915094143.79181-2-ldufour@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <249ad69d-b676-f6f8-4a16-faf055510b90@redhat.com>
Date:   Tue, 15 Sep 2020 12:17:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915094143.79181-2-ldufour@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.09.20 11:41, Laurent Dufour wrote:
> The memmap_context is used to detect whether a memory operation is due to a
> hot-add operation or happening at boot time.
> 
> Make it general to the hotplug operation and rename it at memplug_context.
> 
> There is no functional change introduced by this patch
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
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
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

