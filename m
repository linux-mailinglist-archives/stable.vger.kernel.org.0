Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF716A433
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgBXKns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 05:43:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgBXKns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 05:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582541026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=4rv8UKgCFdqVcsiaIyB/vNEEElHAiCNnjs4DcoZCTmk=;
        b=Ip6XEIx7leMCCUHweZkvhaT4bOAayMk2Nicu4mhwMk4hII4FcTpoBMANdrPQI9Uzwt1jsv
        1yo8tv9MXo5qjZi9LgHIeUamUT2SSmXr0LhVLJpisC/llDquMMU0/AY6CQ4Br9ejS8WXhh
        MQTy3UO+w2PQvkxk5s8txQAeFehXOkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-EFnnzn13P3alW8-0kL18Sw-1; Mon, 24 Feb 2020 05:43:45 -0500
X-MC-Unique: EFnnzn13P3alW8-0kL18Sw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70E1518A6EC3;
        Mon, 24 Feb 2020 10:43:43 +0000 (UTC)
Received: from [10.36.118.193] (unknown [10.36.118.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 499BD82063;
        Mon, 24 Feb 2020 10:43:37 +0000 (UTC)
Subject: Re: [PATCH] mm, hotplug: fix page online with DEBUG_PAGEALLOC
 compiled but not enabled
To:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Qian Cai <cai@lca.pw>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        stable@vger.kernel.org
References: <20200224094651.18257-1-vbabka@suse.cz>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <48d481b7-3acd-3cf0-e27f-17755272df9e@redhat.com>
Date:   Mon, 24 Feb 2020 11:43:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224094651.18257-1-vbabka@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.02.20 10:46, Vlastimil Babka wrote:
> Commit cd02cf1aceea ("mm/hotplug: fix an imbalance with DEBUG_PAGEALLOC") fixed
> memory hotplug with debug_pagealloc enabled, where onlining a page goes through
> page freeing, which removes the direct mapping. Some arches don't like when the
> page is not mapped in the first place, so generic_online_page() maps it first.
> This is somewhat wasteful, but better than special casing page freeing fast
> paths.
> 
> The commit however missed that DEBUG_PAGEALLOC configured doesn't mean it's
> actually enabled. One has to test debug_pagealloc_enabled() since 031bc5743f15
> ("mm/debug-pagealloc: make debug-pagealloc boottime configurable"), or alternatively
> debug_pagealloc_enabled_static() since 8e57f8acbbd1 ("mm, debug_pagealloc:
> don't rely on static keys too early"), but this is not done.
> 
> As a result, a s390 kernel with DEBUG_PAGEALLOC configured but not enabled
> will crash:
> 
> Unable to handle kernel pointer dereference in virtual kernel address space
> Failing address: 0000000000000000 TEID: 0000000000000483
> Fault in home space mode while using kernel ASCE.
> AS:0000001ece13400b R2:000003fff7fd000b R3:000003fff7fcc007 S:000003fff7fd7000 P:000000000000013d
> Oops: 0004 ilc:2 [#1] SMP
> CPU: 1 PID: 26015 Comm: chmem Kdump: loaded Tainted: GX 5.3.18-5-default #1 SLE15-SP2 (unreleased)
> Krnl PSW : 0704e00180000000 0000001ecd281b9e (__kernel_map_pages+0x166/0x188)
> R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000000800 0000400b00000000 0000000000000100
> 0000000000000001 0000000000000000 0000000000000002 0000000000000100
> 0000001ece139230 0000001ecdd98d40 0000400b00000100 0000000000000000
> 000003ffa17e4000 001fffe0114f7d08 0000001ecd4d93ea 001fffe0114f7b20
> Krnl Code: 0000001ecd281b8e: ec17ffff00d8 ahik %r1,%r7,-1
> 0000001ecd281b94: ec111dbc0355 risbg %r1,%r1,29,188,3
>> 0000001ecd281b9e: 94fb5006 ni 6(%r5),251
> 0000001ecd281ba2: 41505008 la %r5,8(%r5)
> 0000001ecd281ba6: ec51fffc6064 cgrj %r5,%r1,6,1ecd281b9e
> 0000001ecd281bac: 1a07 ar %r0,%r7
> 0000001ecd281bae: ec03ff584076 crj %r0,%r3,4,1ecd281a5e
> Call Trace:
> [<0000001ecd281b9e>] __kernel_map_pages+0x166/0x188
> [<0000001ecd4d9516>] online_pages_range+0xf6/0x128
> [<0000001ecd2a8186>] walk_system_ram_range+0x7e/0xd8
> [<0000001ecda28aae>] online_pages+0x2fe/0x3f0
> [<0000001ecd7d02a6>] memory_subsys_online+0x8e/0xc0
> [<0000001ecd7add42>] device_online+0x5a/0xc8
> [<0000001ecd7d0430>] state_store+0x88/0x118
> [<0000001ecd5b9f62>] kernfs_fop_write+0xc2/0x200
> [<0000001ecd5064b6>] vfs_write+0x176/0x1e0
> [<0000001ecd50676a>] ksys_write+0xa2/0x100
> [<0000001ecda315d4>] system_call+0xd8/0x2c8
> 
> Fix this by checking debug_pagealloc_enabled_static() before calling
> kernel_map_pages(). Backports for kernel before 5.5 should use
> debug_pagealloc_enabled() instead. Also add comments.
> 
> Fixes: cd02cf1aceea ("mm/hotplug: fix an imbalance with DEBUG_PAGEALLOC")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: <stable@vger.kernel.org>
> ---
>  include/linux/mm.h  | 4 ++++
>  mm/memory_hotplug.c | 8 +++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git include/linux/mm.h include/linux/mm.h
> index 52269e56c514..c54fb96cb1e6 100644
> --- include/linux/mm.h
> +++ include/linux/mm.h
> @@ -2715,6 +2715,10 @@ static inline bool debug_pagealloc_enabled_static(void)
>  #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
>  extern void __kernel_map_pages(struct page *page, int numpages, int enable);
>  
> +/*
> + * When called in DEBUG_PAGEALLOC context, the call should most likely be
> + * guarded by debug_pagealloc_enabled() or debug_pagealloc_enabled_static()
> + */
>  static inline void
>  kernel_map_pages(struct page *page, int numpages, int enable)
>  {
> diff --git mm/memory_hotplug.c mm/memory_hotplug.c
> index 0a54ffac8c68..19389cdc16a5 100644
> --- mm/memory_hotplug.c
> +++ mm/memory_hotplug.c
> @@ -574,7 +574,13 @@ EXPORT_SYMBOL_GPL(restore_online_page_callback);
>  
>  void generic_online_page(struct page *page, unsigned int order)
>  {
> -	kernel_map_pages(page, 1 << order, 1);
> +	/*
> +	 * Freeing the page with debug_pagealloc enabled will try to unmap it,
> +	 * so we should map it first. This is better than introducing a special
> +	 * case in page freeing fast path.
> +	 */
> +	if (debug_pagealloc_enabled_static())
> +		kernel_map_pages(page, 1 << order, 1);
>  	__free_pages_core(page, order);
>  	totalram_pages_add(1UL << order);
>  #ifdef CONFIG_HIGHMEM
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

