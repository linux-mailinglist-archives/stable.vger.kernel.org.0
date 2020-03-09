Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEE117E9C0
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgCIULk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:11:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbgCIULj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 16:11:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E749AE59;
        Mon,  9 Mar 2020 20:11:36 +0000 (UTC)
Subject: Re: Patch "mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled
 but not enabled" has been added to the 5.4-stable tree
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, cai@lca.pw, david@redhat.com,
        gerald.schaefer@de.ibm.com, iamjoonsoo.kim@lge.com,
        torvalds@linux-foundation.org
Cc:     stable-commits@vger.kernel.org
References: <1583781746100221@kroah.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <4e806950-6fbc-9898-32a4-0309cc37bf7e@suse.cz>
Date:   Mon, 9 Mar 2020 21:11:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1583781746100221@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/2020 8:22 PM, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled but not enabled
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      mm-hotplug-fix-page-online-with-debug_pagealloc-compiled-but-not-enabled.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> From c87cbc1f007c4b46165f05ceca04e1973cda0b9c Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Thu, 5 Mar 2020 22:28:42 -0800
> Subject: mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled but not enabled
> 
> From: Vlastimil Babka <vbabka@suse.cz>
> 
> commit c87cbc1f007c4b46165f05ceca04e1973cda0b9c upstream.
> 
> Commit cd02cf1aceea ("mm/hotplug: fix an imbalance with DEBUG_PAGEALLOC")
> fixed memory hotplug with debug_pagealloc enabled, where onlining a page
> goes through page freeing, which removes the direct mapping.  Some arches
> don't like when the page is not mapped in the first place, so
> generic_online_page() maps it first.  This is somewhat wasteful, but
> better than special casing page freeing fast paths.
> 
> The commit however missed that DEBUG_PAGEALLOC configured doesn't mean
> it's actually enabled.  One has to test debug_pagealloc_enabled() since
> 031bc5743f15 ("mm/debug-pagealloc: make debug-pagealloc boottime
> configurable"), or alternatively debug_pagealloc_enabled_static() since
> 8e57f8acbbd1 ("mm, debug_pagealloc: don't rely on static keys too early"),
> but this is not done.
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
> Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Cc: <stable@vger.kernel.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Qian Cai <cai@lca.pw>
> Link: http://lkml.kernel.org/r/20200224094651.18257-1-vbabka@suse.cz
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  include/linux/mm.h  |    4 ++++
>  mm/memory_hotplug.c |    8 +++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2695,6 +2695,10 @@ static inline bool debug_pagealloc_enabl
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
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -598,7 +598,13 @@ EXPORT_SYMBOL_GPL(__online_page_free);
>  
>  static void generic_online_page(struct page *page, unsigned int order)
>  {
> -	kernel_map_pages(page, 1 << order, 1);
> +	/*
> +	 * Freeing the page with debug_pagealloc enabled will try to unmap it,
> +	 * so we should map it first. This is better than introducing a special
> +	 * case in page freeing fast path.
> +	 */
> +	if (debug_pagealloc_enabled_static())

Won't build on 5.4, see in changelog "Backports for kernel before 5.5 should use
debug_pagealloc_enabled() instead."

> +		kernel_map_pages(page, 1 << order, 1);
>  	__free_pages_core(page, order);
>  	totalram_pages_add(1UL << order);
>  #ifdef CONFIG_HIGHMEM
> 
> 
> Patches currently in stable-queue which might be from vbabka@suse.cz are
> 
> queue-5.4/mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
> queue-5.4/mm-hotplug-fix-page-online-with-debug_pagealloc-compiled-but-not-enabled.patch
> queue-5.4/mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch
> 

