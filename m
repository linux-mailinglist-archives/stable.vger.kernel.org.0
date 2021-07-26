Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A739D3D61AA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhGZPcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231598AbhGZP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3DB60FF2;
        Mon, 26 Jul 2021 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315620;
        bh=jbATMcblxcmZ+wilrEF6yrnKHQyOb6/yV9opwv+3hSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJDaoxYxVhwcG5TzP30eqypzDumtUK4Pz+hfpKKV36Z8Nqchy2kK8t4c1HKJ1Senb
         7vhsudDdObJ0rASbeo9b70paFc7mHG/Y2HiEDJGNd8FIZS2K33Fp3VBSLVsdr90ncU
         CR4dp+vSBF+CX0Fu2KWVLno7hRNEy+ZxEA0lx2JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 147/167] memblock: make for_each_mem_range() traverse MEMBLOCK_HOTPLUG regions
Date:   Mon, 26 Jul 2021 17:39:40 +0200
Message-Id: <20210726153844.352613838@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 79e482e9c3ae86e849c701c846592e72baddda5a upstream.

Commit b10d6bca8720 ("arch, drivers: replace for_each_membock() with
for_each_mem_range()") didn't take into account that when there is
movable_node parameter in the kernel command line, for_each_mem_range()
would skip ranges marked with MEMBLOCK_HOTPLUG.

The page table setup code in POWER uses for_each_mem_range() to create
the linear mapping of the physical memory and since the regions marked
as MEMORY_HOTPLUG are skipped, they never make it to the linear map.

A later access to the memory in those ranges will fail:

  BUG: Unable to handle kernel data access on write at 0xc000000400000000
  Faulting instruction address: 0xc00000000008a3c0
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in:
  CPU: 0 PID: 53 Comm: kworker/u2:0 Not tainted 5.13.0 #7
  NIP:  c00000000008a3c0 LR: c0000000003c1ed8 CTR: 0000000000000040
  REGS: c000000008a57770 TRAP: 0300   Not tainted  (5.13.0)
  MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 84222202  XER: 20040000
  CFAR: c0000000003c1ed4 DAR: c000000400000000 DSISR: 42000000 IRQMASK: 0
  GPR00: c0000000003c1ed8 c000000008a57a10 c0000000019da700 c000000400000000
  GPR04: 0000000000000280 0000000000000180 0000000000000400 0000000000000200
  GPR08: 0000000000000100 0000000000000080 0000000000000040 0000000000000300
  GPR12: 0000000000000380 c000000001bc0000 c0000000001660c8 c000000006337e00
  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR20: 0000000040000000 0000000020000000 c000000001a81990 c000000008c30000
  GPR24: c000000008c20000 c000000001a81998 000fffffffff0000 c000000001a819a0
  GPR28: c000000001a81908 c00c000001000000 c000000008c40000 c000000008a64680
  NIP clear_user_page+0x50/0x80
  LR __handle_mm_fault+0xc88/0x1910
  Call Trace:
    __handle_mm_fault+0xc44/0x1910 (unreliable)
    handle_mm_fault+0x130/0x2a0
    __get_user_pages+0x248/0x610
    __get_user_pages_remote+0x12c/0x3e0
    get_arg_page+0x54/0xf0
    copy_string_kernel+0x11c/0x210
    kernel_execve+0x16c/0x220
    call_usermodehelper_exec_async+0x1b0/0x2f0
    ret_from_kernel_thread+0x5c/0x70
  Instruction dump:
  79280fa4 79271764 79261f24 794ae8e2 7ca94214 7d683a14 7c893a14 7d893050
  7d4903a6 60000000 60000000 60000000 <7c001fec> 7c091fec 7c081fec 7c051fec
  ---[ end trace 490b8c67e6075e09 ]---

Making for_each_mem_range() include MEMBLOCK_HOTPLUG regions in the
traversal fixes this issue.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1976100
Link: https://lkml.kernel.org/r/20210712071132.20902-1-rppt@kernel.org
Fixes: b10d6bca8720 ("arch, drivers: replace for_each_membock() with for_each_mem_range()")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Greg Kurz <groug@kaod.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memblock.h |    4 ++--
 mm/memblock.c            |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -207,7 +207,7 @@ static inline void __next_physmem_range(
  */
 #define for_each_mem_range(i, p_start, p_end) \
 	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,	\
-			     MEMBLOCK_NONE, p_start, p_end, NULL)
+			     MEMBLOCK_HOTPLUG, p_start, p_end, NULL)
 
 /**
  * for_each_mem_range_rev - reverse iterate through memblock areas from
@@ -218,7 +218,7 @@ static inline void __next_physmem_range(
  */
 #define for_each_mem_range_rev(i, p_start, p_end)			\
 	__for_each_mem_range_rev(i, &memblock.memory, NULL, NUMA_NO_NODE, \
-				 MEMBLOCK_NONE, p_start, p_end, NULL)
+				 MEMBLOCK_HOTPLUG, p_start, p_end, NULL)
 
 /**
  * for_each_reserved_mem_range - iterate over all reserved memblock areas
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -940,7 +940,8 @@ static bool should_skip_region(struct me
 		return true;
 
 	/* skip hotpluggable memory regions if needed */
-	if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
+	if (movable_node_is_enabled() && memblock_is_hotpluggable(m) &&
+	    !(flags & MEMBLOCK_HOTPLUG))
 		return true;
 
 	/* if we want mirror memory skip non-mirror memory regions */


