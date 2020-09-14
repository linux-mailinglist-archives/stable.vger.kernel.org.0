Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60082692CB
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgINRPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:15:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726020AbgINRPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 13:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600103713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=HzTW20ZKs/inGf15Jbec1gHB6oz2+QU3swiUkNg053E=;
        b=gbTv2DthXAcx+XenFPDihRBg1PqVYJO3ohwjMlYQK+BRtIrxXrmwIowJWLsqmWnqs62m+8
        A6fjg8EYlpSYRadSlQZZFfnxfdfWRmEMQtwH4feIHaTNZyyVGoSFZL41a75qSmGWtQCTy3
        FsuwMv43cakqd5vK9/9qILr1co7kvkI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-cCp3waOIOXisWoEJqP5Tqw-1; Mon, 14 Sep 2020 13:15:06 -0400
X-MC-Unique: cCp3waOIOXisWoEJqP5Tqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF30A10066FF;
        Mon, 14 Sep 2020 17:15:04 +0000 (UTC)
Received: from [10.36.112.147] (ovpn-112-147.ams2.redhat.com [10.36.112.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4C8D5DA8F;
        Mon, 14 Sep 2020 17:15:01 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] mm: don't rely on system state to detect hot-plug
 operations
To:     Laurent Dufour <ldufour@linux.ibm.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
References: <20200914165042.96218-1-ldufour@linux.ibm.com>
 <20200914165042.96218-3-ldufour@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <c378a52b-ab7b-0cb9-cd34-68e20a9d02b0@redhat.com>
Date:   Mon, 14 Sep 2020 19:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914165042.96218-3-ldufour@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>  arch/ia64/mm/init.c  |  4 +--
>  drivers/base/node.c  | 86 ++++++++++++++++++++++++++++----------------
>  include/linux/node.h | 11 +++---
>  mm/memory_hotplug.c  |  5 +--
>  4 files changed, 68 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
> index b5054b5e77c8..8e7b8c6c576e 100644
> --- a/arch/ia64/mm/init.c
> +++ b/arch/ia64/mm/init.c
> @@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
>  	if (map_start < map_end)
>  		memmap_init_zone((unsigned long)(map_end - map_start),
>  				 args->nid, args->zone, page_to_pfn(map_start),
> -				 MEMPLUG_EARLY, NULL);
> +				 MEMINIT_EARLY, NULL);

Patch #1.

>  	return 0;
>  }
>  
> @@ -548,7 +548,7 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
>  {
>  	if (!vmem_map) {
>  		memmap_init_zone(size, nid, zone, start_pfn,
> -				 MEMPLUG_EARLY, NULL);
> +				 MEMINIT_EARLY, NULL);
>  	} else {
>  		struct page *start;
>  		struct memmap_init_callback_data args;
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 508b80f6329b..01ee73c9d675 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -761,14 +761,36 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>  	return pfn_to_nid(pfn);
>  }
>  
> +static int do_register_memory_block_under_node(int nid,
> +					       struct memory_block *mem_blk)
> +{
> +	int ret;
> +
> +	/*
> +	 * If this memory block spans multiple nodes, we only indicate
> +	 * the last processed node.
> +	 */
> +	mem_blk->nid = nid;
> +
> +	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
> +				       &mem_blk->dev.kobj,
> +				       kobject_name(&mem_blk->dev.kobj));
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
> +				&node_devices[nid]->dev.kobj,
> +				kobject_name(&node_devices[nid]->dev.kobj));
> +}
> +
>  /* register memory section under specified node if it spans that node */
> -static int register_mem_sect_under_node(struct memory_block *mem_blk,
> -					 void *arg)
> +static int register_mem_block_under_node_early(struct memory_block *mem_blk,
> +					       void *arg)
>  {
>  	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
>  	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
>  	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
> -	int ret, nid = *(int *)arg;
> +	int nid = *(int *)arg;
>  	unsigned long pfn;
>  
>  	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
> @@ -785,38 +807,34 @@ static int register_mem_sect_under_node(struct memory_block *mem_blk,
>  		}
>  
>  		/*
> -		 * We need to check if page belongs to nid only for the boot
> -		 * case, during hotplug we know that all pages in the memory
> -		 * block belong to the same node.
> -		 */
> -		if (system_state == SYSTEM_BOOTING) {
> -			page_nid = get_nid_for_pfn(pfn);
> -			if (page_nid < 0)
> -				continue;
> -			if (page_nid != nid)
> -				continue;
> -		}
> -
> -		/*
> -		 * If this memory block spans multiple nodes, we only indicate
> -		 * the last processed node.
> +		 * We need to check if page belongs to nid only at the boot
> +		 * case because node's ranges can be interleaved.
>  		 */
> -		mem_blk->nid = nid;
> -
> -		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
> -					&mem_blk->dev.kobj,
> -					kobject_name(&mem_blk->dev.kobj));
> -		if (ret)
> -			return ret;
> +		page_nid = get_nid_for_pfn(pfn);
> +		if (page_nid < 0)
> +			continue;
> +		if (page_nid != nid)
> +			continue;
>  
> -		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
> -				&node_devices[nid]->dev.kobj,
> -				kobject_name(&node_devices[nid]->dev.kobj));
> +		/* The memory block is registered to the first matching node */

That comment is misleading in that context.

A memory block is registered if there is at least a page that belongs to
the nid. It's perfectly fine to have a single memory block belong to
multiple NUMA nodes (when the split is within a memory block). I'd just
drop it.

[...]

-- 
Thanks,

David / dhildenb

