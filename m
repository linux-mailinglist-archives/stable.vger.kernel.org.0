Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80883C543F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348177AbhGLH52 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 12 Jul 2021 03:57:28 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:52184 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347684AbhGLHxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 03:53:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-SL5PkOnLNIyX8sjq6PFYdA-1; Mon, 12 Jul 2021 03:50:49 -0400
X-MC-Unique: SL5PkOnLNIyX8sjq6PFYdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6A4D84B9FF;
        Mon, 12 Jul 2021 07:50:47 +0000 (UTC)
Received: from bahia.lan (ovpn-112-172.ams2.redhat.com [10.36.112.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17B2D69CB4;
        Mon, 12 Jul 2021 07:50:41 +0000 (UTC)
Date:   Mon, 12 Jul 2021 09:50:32 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] memblock: make for_each_mem_range() traverse
 MEMBLOCK_HOTPLUG regions
Message-ID: <20210712095032.1f6666e5@bahia.lan>
In-Reply-To: <20210712071132.20902-1-rppt@kernel.org>
References: <20210712071132.20902-1-rppt@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 10:11:32 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Commit b10d6bca8720 ("arch, drivers: replace for_each_membock() with
> for_each_mem_range()") didn't take into account that when there is
> movable_node parameter in the kernel command line, for_each_mem_range()
> would skip ranges marked with MEMBLOCK_HOTPLUG.
> 
> The page table setup code in POWER uses for_each_mem_range() to create the
> linear mapping of the physical memory and since the regions marked as
> MEMORY_HOTPLUG are skipped, they never make it to the linear map.
> 
> A later access to the memory in those ranges will fail:
> 
> [    2.271743] BUG: Unable to handle kernel data access on write at 0xc000000400000000
> [    2.271984] Faulting instruction address: 0xc00000000008a3c0
> [    2.272568] Oops: Kernel access of bad area, sig: 11 [#1]
> [    2.272683] LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
> [    2.273063] Modules linked in:
> [    2.273435] CPU: 0 PID: 53 Comm: kworker/u2:0 Not tainted 5.13.0 #7
> [    2.273832] NIP:  c00000000008a3c0 LR: c0000000003c1ed8 CTR: 0000000000000040
> [    2.273918] REGS: c000000008a57770 TRAP: 0300   Not tainted  (5.13.0)
> [    2.274036] MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 84222202  XER: 20040000
> [    2.274454] CFAR: c0000000003c1ed4 DAR: c000000400000000 DSISR: 42000000 IRQMASK: 0
> [    2.274454] GPR00: c0000000003c1ed8 c000000008a57a10 c0000000019da700 c000000400000000
> [    2.274454] GPR04: 0000000000000280 0000000000000180 0000000000000400 0000000000000200
> [    2.274454] GPR08: 0000000000000100 0000000000000080 0000000000000040 0000000000000300
> [    2.274454] GPR12: 0000000000000380 c000000001bc0000 c0000000001660c8 c000000006337e00
> [    2.274454] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [    2.274454] GPR20: 0000000040000000 0000000020000000 c000000001a81990 c000000008c30000
> [    2.274454] GPR24: c000000008c20000 c000000001a81998 000fffffffff0000 c000000001a819a0
> [    2.274454] GPR28: c000000001a81908 c00c000001000000 c000000008c40000 c000000008a64680
> [    2.275520] NIP [c00000000008a3c0] clear_user_page+0x50/0x80
> [    2.276333] LR [c0000000003c1ed8] __handle_mm_fault+0xc88/0x1910
> [    2.276688] Call Trace:
> [    2.276839] [c000000008a57a10] [c0000000003c1e94] __handle_mm_fault+0xc44/0x1910 (unreliable)
> [    2.277142] [c000000008a57af0] [c0000000003c2c90] handle_mm_fault+0x130/0x2a0
> [    2.277331] [c000000008a57b40] [c0000000003b5f08] __get_user_pages+0x248/0x610
> [    2.277541] [c000000008a57c40] [c0000000003b848c] __get_user_pages_remote+0x12c/0x3e0
> [    2.277768] [c000000008a57cd0] [c000000000473f24] get_arg_page+0x54/0xf0
> [    2.277959] [c000000008a57d10] [c000000000474a7c] copy_string_kernel+0x11c/0x210
> [    2.278159] [c000000008a57d80] [c00000000047663c] kernel_execve+0x16c/0x220
> [    2.278361] [c000000008a57dd0] [c000000000166270] call_usermodehelper_exec_async+0x1b0/0x2f0
> [    2.278543] [c000000008a57e10] [c00000000000d5ec] ret_from_kernel_thread+0x5c/0x70
> [    2.278870] Instruction dump:
> [    2.279214] 79280fa4 79271764 79261f24 794ae8e2 7ca94214 7d683a14 7c893a14 7d893050
> [    2.279416] 7d4903a6 60000000 60000000 60000000 <7c001fec> 7c091fec 7c081fec 7c051fec
> [    2.280193] ---[ end trace 490b8c67e6075e09 ]---
> 
> Making for_each_mem_range() include MEMBLOCK_HOTPLUG regions in the
> traversal fixes this issue.
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1976100
> Fixes: b10d6bca8720 ("arch, drivers: replace for_each_membock() with for_each_mem_range()")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---

This fixes the issue I was observing with both radix and hash.

Thanks !

Tested-by: Greg Kurz <groug@kaod.org>

Cc'ing linuxppc-dev so that POWER folks know about the fix
and stable.

Cc: stable@vger.kernel.org # v5.10

>  include/linux/memblock.h | 4 ++--
>  mm/memblock.c            | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index cbf46f56d105..4a53c3ca86bd 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -209,7 +209,7 @@ static inline void __next_physmem_range(u64 *idx, struct memblock_type *type,
>   */
>  #define for_each_mem_range(i, p_start, p_end) \
>  	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,	\
> -			     MEMBLOCK_NONE, p_start, p_end, NULL)
> +			     MEMBLOCK_HOTPLUG, p_start, p_end, NULL)
>  
>  /**
>   * for_each_mem_range_rev - reverse iterate through memblock areas from
> @@ -220,7 +220,7 @@ static inline void __next_physmem_range(u64 *idx, struct memblock_type *type,
>   */
>  #define for_each_mem_range_rev(i, p_start, p_end)			\
>  	__for_each_mem_range_rev(i, &memblock.memory, NULL, NUMA_NO_NODE, \
> -				 MEMBLOCK_NONE, p_start, p_end, NULL)
> +				 MEMBLOCK_HOTPLUG, p_start, p_end, NULL)
>  
>  /**
>   * for_each_reserved_mem_range - iterate over all reserved memblock areas
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 0041ff62c584..de7b553baa50 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -947,7 +947,8 @@ static bool should_skip_region(struct memblock_type *type,
>  		return true;
>  
>  	/* skip hotpluggable memory regions if needed */
> -	if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
> +	if (movable_node_is_enabled() && memblock_is_hotpluggable(m) &&
> +	    !(flags & MEMBLOCK_HOTPLUG))
>  		return true;
>  
>  	/* if we want mirror memory skip non-mirror memory regions */
> 
> base-commit: e73f0f0ee7541171d89f2e2491130c7771ba58d3

