Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3F1DE645
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfJUI0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:26:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:60154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbfJUI0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 04:26:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E95CEBABA;
        Mon, 21 Oct 2019 08:26:13 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:26:10 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr,
        dalias@libc.org, damian.tometzki@gmail.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, fenghua.yu@intel.com, gerald.schaefer@de.ibm.com,
        glider@google.com, gor@linux.ibm.com, gregkh@linuxfoundation.org,
        heiko.carstens@de.ibm.com, hpa@zytor.com, ira.weiny@intel.com,
        jgg@ziepe.ca, linux-mm@kvack.org, logang@deltatee.com,
        luto@kernel.org, mark.rutland@arm.com, mgorman@techsingularity.net,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com,
        pasic@linux.ibm.com, paulus@samba.org,
        pavel.tatashin@microsoft.com, peterz@infradead.org,
        richard.weiyang@gmail.com, richardw.yang@linux.intel.com,
        robin.murphy@arm.com, rppt@linux.ibm.com, stable@vger.kernel.org,
        steve.capper@arm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        tony.luck@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org, willy@infradead.org,
        yamada.masahiro@socionext.com, yaojun8558363@gmail.com,
        ysato@users.sourceforge.jp, yuzhao@google.com
Subject: Re: [patch 07/26] mm/memunmap: don't access uninitialized memmap in
 memunmap_pages()
Message-ID: <20191021082610.GC9379@dhcp22.suse.cz>
References: <20191019031939.9XlSnLGcS%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019031939.9XlSnLGcS%akpm@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Has this been properly reviewed? I do not see any Acks nor Reviewed-bys.

On Fri 18-10-19 20:19:39, Andrew Morton wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Subject: mm/memunmap: don't access uninitialized memmap in memunmap_pages()
> 
> Patch series "mm/memory_hotplug: Shrink zones before removing memory", v6.
> 
> This series fixes the access of uninitialized memmaps when shrinking
> zones/nodes and when removing memory.  Also, it contains all fixes for
> crashes that can be triggered when removing certain namespace using
> memunmap_pages() - ZONE_DEVICE, reported by Aneesh.
> 
> We stop trying to shrink ZONE_DEVICE, as it's buggy, fixing it would be
> more involved (we don't have SECTION_IS_ONLINE as an indicator), and
> shrinking is only of limited use (set_zone_contiguous() cannot detect the
> ZONE_DEVICE as contiguous).
> 
> We continue shrinking !ZONE_DEVICE zones, however, I reduced the amount of
> code to a minimum.  Shrinking is especially necessary to keep
> zone->contiguous set where possible, especially, on memory unplug of DIMMs
> at zone boundaries.
> 
> --------------------------------------------------------------------------
> 
> Zones are now properly shrunk when offlining memory blocks or when
> onlining failed.  This allows to properly shrink zones on memory unplug
> even if the separate memory blocks of a DIMM were onlined to different
> zones or re-onlined to a different zone after offlining.
> 
> Example:
> 
> :/# cat /proc/zoneinfo
> Node 1, zone  Movable
>         spanned  0
>         present  0
>         managed  0
> :/# echo "online_movable" > /sys/devices/system/memory/memory41/state
> :/# echo "online_movable" > /sys/devices/system/memory/memory43/state
> :/# cat /proc/zoneinfo
> Node 1, zone  Movable
>         spanned  98304
>         present  65536
>         managed  65536
> :/# echo 0 > /sys/devices/system/memory/memory43/online
> :/# cat /proc/zoneinfo
> Node 1, zone  Movable
>         spanned  32768
>         present  32768
>         managed  32768
> :/# echo 0 > /sys/devices/system/memory/memory41/online
> :/# cat /proc/zoneinfo
> Node 1, zone  Movable
>         spanned  0
>         present  0
>         managed  0
> 
> 
> This patch (of 10):
> 
> With an altmap, the memmap falling into the reserved altmap space are not
> initialized and, therefore, contain a garbage NID and a garbage zone. 
> Make sure to read the NID/zone from a memmap that was initialized.
> 
> This fixes a kernel crash that is observed when destroying a namespace:
> 
> [   81.356173] kernel BUG at include/linux/mm.h:1107!
> cpu 0x1: Vector: 700 (Program Check) at [c000000274087890]
>     pc: c0000000004b9728: memunmap_pages+0x238/0x340
>     lr: c0000000004b9724: memunmap_pages+0x234/0x340
> ...
>     pid   = 3669, comm = ndctl
> kernel BUG at include/linux/mm.h:1107!
> [c000000274087ba0] c0000000009e3500 devm_action_release+0x30/0x50
> [c000000274087bc0] c0000000009e4758 release_nodes+0x268/0x2d0
> [c000000274087c30] c0000000009dd144 device_release_driver_internal+0x174/0x240
> [c000000274087c70] c0000000009d9dfc unbind_store+0x13c/0x190
> [c000000274087cb0] c0000000009d8a24 drv_attr_store+0x44/0x60
> [c000000274087cd0] c0000000005a7470 sysfs_kf_write+0x70/0xa0
> [c000000274087d10] c0000000005a5cac kernfs_fop_write+0x1ac/0x290
> [c000000274087d60] c0000000004be45c __vfs_write+0x3c/0x70
> [c000000274087d80] c0000000004c26e4 vfs_write+0xe4/0x200
> [c000000274087dd0] c0000000004c2a6c ksys_write+0x7c/0x140
> [c000000274087e20] c00000000000bbd0 system_call+0x5c/0x68
> 
> The "page_zone(pfn_to_page(pfn)" was introduced by 69324b8f4833 ("mm,
> devm_memremap_pages: add MEMORY_DEVICE_PRIVATE support"), however, I
> think we will never have driver reserved memory with
> MEMORY_DEVICE_PRIVATE (no altmap AFAIKS).
> 
> [david@redhat.com: minimze code changes, rephrase description]
> Link: http://lkml.kernel.org/r/20191006085646.5768-2-david@redhat.com
> Fixes: 2c2a5af6fed2 ("mm, memory_hotplug: add nid parameter to arch_remove_memory")
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Damian Tometzki <damian.tometzki@gmail.com>
> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jun Yao <yaojun8558363@gmail.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pankaj Gupta <pagupta@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Steve Capper <steve.capper@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Wei Yang <richardw.yang@linux.intel.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: <stable@vger.kernel.org>	[5.0+]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memremap.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> --- a/mm/memremap.c~mm-memunmap-dont-access-uninitialized-memmap-in-memunmap_pages
> +++ a/mm/memremap.c
> @@ -103,6 +103,7 @@ static void dev_pagemap_cleanup(struct d
>  void memunmap_pages(struct dev_pagemap *pgmap)
>  {
>  	struct resource *res = &pgmap->res;
> +	struct page *first_page;
>  	unsigned long pfn;
>  	int nid;
>  
> @@ -111,14 +112,16 @@ void memunmap_pages(struct dev_pagemap *
>  		put_page(pfn_to_page(pfn));
>  	dev_pagemap_cleanup(pgmap);
>  
> +	/* make sure to access a memmap that was actually initialized */
> +	first_page = pfn_to_page(pfn_first(pgmap));
> +
>  	/* pages are dead and unused, undo the arch mapping */
> -	nid = page_to_nid(pfn_to_page(PHYS_PFN(res->start)));
> +	nid = page_to_nid(first_page);
>  
>  	mem_hotplug_begin();
>  	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
> -		pfn = PHYS_PFN(res->start);
> -		__remove_pages(page_zone(pfn_to_page(pfn)), pfn,
> -				 PHYS_PFN(resource_size(res)), NULL);
> +		__remove_pages(page_zone(first_page), PHYS_PFN(res->start),
> +			       PHYS_PFN(resource_size(res)), NULL);
>  	} else {
>  		arch_remove_memory(nid, res->start, resource_size(res),
>  				pgmap_altmap(pgmap));
> _

-- 
Michal Hocko
SUSE Labs
