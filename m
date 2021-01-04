Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2BB2E9DF0
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 20:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbhADTEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 14:04:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727760AbhADTEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 14:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609786992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rv1a1PFTKGIIkbDUAzNchjyjGu+fF3e2AblRRFRuv9k=;
        b=SBmT/4WwipiKysn44Q3CIyLaGscjoLzeU17MVReCuuv3wIXXaWQQc9fWkXoqMKGD5QqdzV
        YhnNUBdPOid5kSnj1p07VXGQGYkzxsaCbaWjmRbuKW5Wlq6BHH9TLBZra5CeWQlW6RarCf
        lcBpeNCzf71LYU/Z+hSh3HOR9+L0hC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-irMMAGfSPeewfF8GipDtoQ-1; Mon, 04 Jan 2021 14:03:09 -0500
X-MC-Unique: irMMAGfSPeewfF8GipDtoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA135612A0;
        Mon,  4 Jan 2021 19:03:05 +0000 (UTC)
Received: from ovpn-66-203.rdu2.redhat.com (unknown [10.10.67.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 557DD5D751;
        Mon,  4 Jan 2021 19:03:01 +0000 (UTC)
Message-ID: <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
From:   Qian Cai <qcai@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Mon, 04 Jan 2021 14:03:00 -0500
In-Reply-To: <20201209214304.6812-3-rppt@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
         <20201209214304.6812-3-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-12-09 at 23:43 +0200, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> There could be struct pages that are not backed by actual physical memory.
> This can happen when the actual memory bank is not a multiple of
> SECTION_SIZE or when an architecture does not register memory holes
> reserved by the firmware as memblock.memory.
> 
> Such pages are currently initialized using init_unavailable_mem() function
> that iterated through PFNs in holes in memblock.memory and if there is a
> struct page corresponding to a PFN, the fields if this page are set to
> default values and it is marked as Reserved.
> 
> init_unavailable_mem() does not take into account zone and node the page
> belongs to and sets both zone and node links in struct page to zero.
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
> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link in
> struct page) in the same pageblock.
> 
> Interleave initialization of pages that correspond to holes with the
> initialization of memory map, so that zone and node information will be
> properly set on such pages.
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
> that check each PFN")
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Reverting this commit on the top of today's linux-next fixed a crash while
reading /proc/kpagecount on a NUMA server.

[ 8858.006726][T99897] BUG: unable to handle page fault for address: fffffffffffffffe
[ 8858.014814][T99897] #PF: supervisor read access in kernel mode
[ 8858.020686][T99897] #PF: error_code(0x0000) - not-present page
[ 8858.026557][T99897] PGD 1371417067 P4D 1371417067 PUD 1371419067 PMD 0 
[ 8858.033224][T99897] Oops: 0000 [#1] SMP KASAN NOPTI
[ 8858.038710][T99897] CPU: 28 PID: 99897 Comm: proc01 Tainted: G           O      5.11.0-rc1-next-20210104 #1
[ 8858.048515][T99897] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
[ 8858.057794][T99897] RIP: 0010:kpagecount_read+0x1be/0x5e0
PageSlab at include/linux/page-flags.h:342
(inlined by) kpagecount_read at fs/proc/page.c:69
[ 8858.063717][T99897] Code: 3c 30 00 0f 85 29 03 00 00 48 8b 53 08 48 8d 42 ff 83 e2 01 48 0f 44 c3 48 89 c2 48 c1 ea 03 42 80 3c 32 00 0f 85 e7 02 00 00 <48> 83 38 ff 0f 84 f3 01 00 00 48 89 c8 48 c1 e8 03 42 80 3c 30 00
[ 8858.083303][T99897] RSP: 0018:ffffc9002159fdd0 EFLAGS: 00010246
[ 8858.089637][T99897] RAX: fffffffffffffffe RBX: ffffea0011fce000 RCX: ffffea0011fce008
[ 8858.097518][T99897] RDX: 1fffffffffffffff RSI: 000000000064d7c0 RDI: ffffffff951f91c8
[ 8858.105396][T99897] RBP: 000000000064d7c0 R08: ffffed129063f402 R09: ffffed129063f402
[ 8858.113760][T99897] R10: ffff8894831fa00b R11: ffffed129063f401 R12: 000000000047f380
[ 8858.121639][T99897] R13: 0000000000000400 R14: dffffc0000000000 R15: 000000000064d7c0
[ 8858.129517][T99897] FS:  00007fd18849d040(0000) GS:ffff88a02fc00000(0000) knlGS:0000000000000000
[ 8858.138886][T99897] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8858.145369][T99897] CR2: fffffffffffffffe CR3: 0000001c8b5d0000 CR4: 00000000003506e0
[ 8858.153247][T99897] Call Trace:
[ 8858.156415][T99897]  proc_reg_read+0x1a6/0x240
[ 8858.161345][T99897]  vfs_read+0x175/0x440
[ 8858.165383][T99897]  ksys_read+0xf1/0x1c0
[ 8858.169420][T99897]  ? vfs_write+0x870/0x870
[ 8858.173719][T99897]  ? task_work_run+0xeb/0x170
[ 8858.178284][T99897]  ? syscall_enter_from_user_mode+0x1c/0x40
[ 8858.184073][T99897]  do_syscall_64+0x33/0x40
[ 8858.188863][T99897]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8858.194652][T99897] RIP: 0033:0x7fd187da1d5d
[ 8858.198952][T99897] Code: 31 11 2b 00 31 c9 64 83 3e 0b 75 ca eb b8 e8 ca fb ff ff 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 39 ca 77 2b 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 0b c3 66 2e 0f 1f 84 00 00 00 00 00 48 8b 15
[ 8858.218978][T99897] RSP: 002b:00007ffe733de1f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 8858.227297][T99897] RAX: ffffffffffffffda RBX: 00007ffe733df370 RCX: 00007fd187da1d5d
[ 8858.235824][T99897] RDX: 0000000000000400 RSI: 000000000064d7c0 RDI: 0000000000000004
[ 8858.243739][T99897] RBP: 0000000000000400 R08: 00000000018fbe73 R09: 00007fd187e13d40
[ 8858.251617][T99897] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000023f9c00
[ 8858.259496][T99897] R13: 0000000000000004 R14: 000000000044663c R15: 0000000000000000
[ 8858.267856][T99897] Modules linked in: vfat fat fuse vfio_pci vfio_virqfd vfio_iommu_type1 vfio loop iavf kvm_amd ses kvm enclosure irqbypass acpi_cpufreq ip_tables x_tables sd_mod smartpqi bnxt_en scsi_transport_sas tg3 i40e firmware_class libphy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: init_module]
[ 8858.296328][T99897] CR2: fffffffffffffffe
[ 8858.300365][T99897] ---[ end trace a307ff8b6e284ee0 ]---
[ 8858.305712][T99897] RIP: 0010:kpagecount_read+0x1be/0x5e0
[ 8858.311613][T99897] Code: 3c 30 00 0f 85 29 03 00 00 48 8b 53 08 48 8d 42 ff 83 e2 01 48 0f 44 c3 48 89 c2 48 c1 ea 03 42 80 3c 32 00 0f 85 e7 02 00 00 <48> 83 38 ff 0f 84 f3 01 00 00 48 89 c8 48 c1 e8 03 42 80 3c 30 00
[ 8858.331200][T99897] RSP: 0018:ffffc9002159fdd0 EFLAGS: 00010246
[ 8858.337573][T99897] RAX: fffffffffffffffe RBX: ffffea0011fce000 RCX: ffffea0011fce008
[ 8858.345454][T99897] RDX: 1fffffffffffffff RSI: 000000000064d7c0 RDI: ffffffff951f91c8
[ 8858.353333][T99897] RBP: 000000000064d7c0 R08: ffffed129063f402 R09: ffffed129063f402
[ 8858.361618][T99897] R10: ffff8894831fa00b R11: ffffed129063f401 R12: 000000000047f380
[ 8858.369497][T99897] R13: 0000000000000400 R14: dffffc0000000000 R15: 000000000064d7c0
[ 8858.377377][T99897] FS:  00007fd18849d040(0000) GS:ffff88a02fc00000(0000) knlGS:0000000000000000
[ 8858.386696][T99897] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8858.393177][T99897] CR2: fffffffffffffffe CR3: 0000001c8b5d0000 CR4: 00000000003506e0
[ 8858.401056][T99897] Kernel panic - not syncing: Fatal exception
[ 8858.407348][T99897] Kernel Offset: 0x12600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[ 8858.419260][T99897] ---[ end Kernel panic - not syncing: Fatal exception ]---

> ---
>  mm/page_alloc.c | 152 +++++++++++++++++++++---------------------------
>  1 file changed, 65 insertions(+), 87 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dbc57dbbacd8..ea5aefef0004 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6185,24 +6185,85 @@ static void __meminit zone_init_free_lists(struct zone
> *zone)
>  	}
>  }
>  
> -void __meminit __weak memmap_init(unsigned long size, int nid,
> -				  unsigned long zone,
> -				  unsigned long range_start_pfn)
> +#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> +/*
> + * Only struct pages that are backed by physical memory available to the
> + * kernel are zeroed and initialized by memmap_init_zone().
> + * But, there are some struct pages that are either reserved by firmware or
> + * do not correspond to physical page frames becuase the actual memory bank
> + * is not a multiple of SECTION_SIZE.
> + * Fields of those struct pages may be accessed (for example page_to_pfn()
> + * on some configuration accesses page flags) so we must explicitly
> + * initialize those struct pages.
> + */
> +static u64 __init init_unavailable_range(unsigned long spfn, unsigned long
> epfn,
> +					 int zone, int node)
>  {
> -	unsigned long start_pfn, end_pfn;
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
> +static inline u64 init_unavailable_range(unsigned long spfn, unsigned long
> epfn,
> +					 int zone, int node)
> +{
> +	return 0;
> +}
> +#endif
> +
> +void __init __weak memmap_init(unsigned long size, int nid,
> +			       unsigned long zone,
> +			       unsigned long range_start_pfn)
> +{
> +	unsigned long start_pfn, end_pfn, hole_start_pfn = 0;
>  	unsigned long range_end_pfn = range_start_pfn + size;
> +	u64 pgcnt = 0;
>  	int i;
>  
>  	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>  		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
>  		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> +		hole_start_pfn = clamp(hole_start_pfn, range_start_pfn,
> +				       range_end_pfn);
>  
>  		if (end_pfn > start_pfn) {
>  			size = end_pfn - start_pfn;
>  			memmap_init_zone(size, nid, zone, start_pfn,
>  					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
>  		}
> +
> +		if (hole_start_pfn < start_pfn)
> +			pgcnt += init_unavailable_range(hole_start_pfn,
> +							start_pfn, zone, nid);
> +		hole_start_pfn = end_pfn;
>  	}
> +
> +	/*
> +	 * Early sections always have a fully populated memmap for the whole
> +	 * section - see pfn_valid(). If the last section has holes at the
> +	 * end and that section is marked "online", the memmap will be
> +	 * considered initialized. Make sure that memmap has a well defined
> +	 * state.
> +	 */
> +	if (hole_start_pfn < range_end_pfn)
> +		pgcnt += init_unavailable_range(hole_start_pfn, range_end_pfn,
> +						zone, nid);
> +
> +	if (pgcnt)
> +		pr_info("%s: Zeroed struct page in unavailable ranges: %lld\n",
> +			zone_names[zone], pgcnt);
>  }
>  
>  static int zone_batchsize(struct zone *zone)
> @@ -6995,88 +7056,6 @@ void __init free_area_init_memoryless_node(int nid)
>  	free_area_init_node(nid);
>  }
>  
> -#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
> -/*
> - * Initialize all valid struct pages in the range [spfn, epfn) and mark them
> - * PageReserved(). Return the number of struct pages that were initialized.
> - */
> -static u64 __init init_unavailable_range(unsigned long spfn, unsigned long
> epfn)
> -{
> -	unsigned long pfn;
> -	u64 pgcnt = 0;
> -
> -	for (pfn = spfn; pfn < epfn; pfn++) {
> -		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
> -			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
> -				+ pageblock_nr_pages - 1;
> -			continue;
> -		}
> -		/*
> -		 * Use a fake node/zone (0) for now. Some of these pages
> -		 * (in memblock.reserved but not in memblock.memory) will
> -		 * get re-initialized via reserve_bootmem_region() later.
> -		 */
> -		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
> -		__SetPageReserved(pfn_to_page(pfn));
> -		pgcnt++;
> -	}
> -
> -	return pgcnt;
> -}
> -
> -/*
> - * Only struct pages that are backed by physical memory are zeroed and
> - * initialized by going through __init_single_page(). But, there are some
> - * struct pages which are reserved in memblock allocator and their fields
> - * may be accessed (for example page_to_pfn() on some configuration accesses
> - * flags). We must explicitly initialize those struct pages.
> - *
> - * This function also addresses a similar issue where struct pages are left
> - * uninitialized because the physical address range is not covered by
> - * memblock.memory or memblock.reserved. That could happen when memblock
> - * layout is manually configured via memmap=, or when the highest physical
> - * address (max_pfn) does not end on a section boundary.
> - */
> -static void __init init_unavailable_mem(void)
> -{
> -	phys_addr_t start, end;
> -	u64 i, pgcnt;
> -	phys_addr_t next = 0;
> -
> -	/*
> -	 * Loop through unavailable ranges not covered by memblock.memory.
> -	 */
> -	pgcnt = 0;
> -	for_each_mem_range(i, &start, &end) {
> -		if (next < start)
> -			pgcnt += init_unavailable_range(PFN_DOWN(next),
> -							PFN_UP(start));
> -		next = end;
> -	}
> -
> -	/*
> -	 * Early sections always have a fully populated memmap for the whole
> -	 * section - see pfn_valid(). If the last section has holes at the
> -	 * end and that section is marked "online", the memmap will be
> -	 * considered initialized. Make sure that memmap has a well defined
> -	 * state.
> -	 */
> -	pgcnt += init_unavailable_range(PFN_DOWN(next),
> -					round_up(max_pfn, PAGES_PER_SECTION));
> -
> -	/*
> -	 * Struct pages that do not have backing memory. This could be because
> -	 * firmware is using some of this memory, or for some other reasons.
> -	 */
> -	if (pgcnt)
> -		pr_info("Zeroed struct page in unavailable ranges: %lld pages",
> pgcnt);
> -}
> -#else
> -static inline void __init init_unavailable_mem(void)
> -{
> -}
> -#endif /* !CONFIG_FLAT_NODE_MEM_MAP */
> -
>  #if MAX_NUMNODES > 1
>  /*
>   * Figure out the number of possible node ids.
> @@ -7507,7 +7486,6 @@ void __init free_area_init(unsigned long *max_zone_pfn)
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();
> -	init_unavailable_mem();
>  	for_each_online_node(nid) {
>  		pg_data_t *pgdat = NODE_DATA(nid);
>  		free_area_init_node(nid);
> -- 
> 2.28.0
> 
> 

