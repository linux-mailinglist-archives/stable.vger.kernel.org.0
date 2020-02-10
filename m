Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A873F157B25
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgBJN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgBJMg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 182EC2168B;
        Mon, 10 Feb 2020 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338188;
        bh=rkQI/mN/RICzz37RIM3SPzs5nkxmeDde/PGxr8Ue2FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuuU/kbgdHSaQ3asxsCuSfvVPGG11232e1NJWZgUac7IBbo/ztjtML3mZ4BvY+tbd
         Ht61ppBGIKNvPhr1K5zgPeUb+per+JcgBymrO/5/hPSA2g5x0XkX/WP43SCV7wLNC9
         bHyuOAgBnYSlWsUogDK1oUnZDxKQ8fLqSra7cNl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Ingo Molnar <mingo@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/195] mm: zero remaining unavailable struct pages
Date:   Mon, 10 Feb 2020 04:34:06 -0800
Message-Id: <20200210122323.582766781@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

[ Upstream commit 907ec5fca3dc38d37737de826f06f25b063aa08e ]

Patch series "mm: Fix for movable_node boot option", v3.

This patch series contains a fix for the movable_node boot option issue
which was introduced by commit 124049decbb1 ("x86/e820: put !E820_TYPE_RAM
regions into memblock.reserved").

The commit breaks the option because it changed the memory gap range to
reserved memblock.  So, the node is marked as Normal zone even if the SRAT
has Hot pluggable affinity.

First and second patch fix the original issue which the commit tried to
fix, then revert the commit.

This patch (of 3):

There is a kernel panic that is triggered when reading /proc/kpageflags on
the kernel booted with kernel parameter 'memmap=nn[KMG]!ss[KMG]':

  BUG: unable to handle kernel paging request at fffffffffffffffe
  PGD 9b20e067 P4D 9b20e067 PUD 9b210067 PMD 0
  Oops: 0000 [#1] SMP PTI
  CPU: 2 PID: 1728 Comm: page-types Not tainted 4.17.0-rc6-mm1-v4.17-rc6-180605-0816-00236-g2dfb086ef02c+ #160
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.fc28 04/01/2014
  RIP: 0010:stable_page_flags+0x27/0x3c0
  Code: 00 00 00 0f 1f 44 00 00 48 85 ff 0f 84 a0 03 00 00 41 54 55 49 89 fc 53 48 8b 57 08 48 8b 2f 48 8d 42 ff 83 e2 01 48 0f 44 c7 <48> 8b 00 f6 c4 01 0f 84 10 03 00 00 31 db 49 8b 54 24 08 4c 89 e7
  RSP: 0018:ffffbbd44111fde0 EFLAGS: 00010202
  RAX: fffffffffffffffe RBX: 00007fffffffeff9 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: 0000000000000202 RDI: ffffed1182fff5c0
  RBP: ffffffffffffffff R08: 0000000000000001 R09: 0000000000000001
  R10: ffffbbd44111fed8 R11: 0000000000000000 R12: ffffed1182fff5c0
  R13: 00000000000bffd7 R14: 0000000002fff5c0 R15: ffffbbd44111ff10
  FS:  00007efc4335a500(0000) GS:ffff93a5bfc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: fffffffffffffffe CR3: 00000000b2a58000 CR4: 00000000001406e0
  Call Trace:
   kpageflags_read+0xc7/0x120
   proc_reg_read+0x3c/0x60
   __vfs_read+0x36/0x170
   vfs_read+0x89/0x130
   ksys_pread64+0x71/0x90
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7efc42e75e23
  Code: 09 00 ba 9f 01 00 00 e8 ab 81 f4 ff 66 2e 0f 1f 84 00 00 00 00 00 90 83 3d 29 0a 2d 00 00 75 13 49 89 ca b8 11 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 db d3 01 00 48 89 04 24

According to kernel bisection, this problem became visible due to commit
f7f99100d8d9 which changes how struct pages are initialized.

Memblock layout affects the pfn ranges covered by node/zone.  Consider
that we have a VM with 2 NUMA nodes and each node has 4GB memory, and the
default (no memmap= given) memblock layout is like below:

  MEMBLOCK configuration:
   memory size = 0x00000001fff75c00 reserved size = 0x000000000300c000
   memory.cnt  = 0x4
   memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
   memory[0x1]     [0x0000000000100000-0x00000000bffd6fff], 0x00000000bfed7000 bytes on node 0 flags: 0x0
   memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x0
   memory[0x3]     [0x0000000140000000-0x000000023fffffff], 0x0000000100000000 bytes on node 1 flags: 0x0
   ...

If you give memmap=1G!4G (so it just covers memory[0x2]),
the range [0x100000000-0x13fffffff] is gone:

  MEMBLOCK configuration:
   memory size = 0x00000001bff75c00 reserved size = 0x000000000300c000
   memory.cnt  = 0x3
   memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
   memory[0x1]     [0x0000000000100000-0x00000000bffd6fff], 0x00000000bfed7000 bytes on node 0 flags: 0x0
   memory[0x2]     [0x0000000140000000-0x000000023fffffff], 0x0000000100000000 bytes on node 1 flags: 0x0
   ...

This causes shrinking node 0's pfn range because it is calculated by the
address range of memblock.memory.  So some of struct pages in the gap
range are left uninitialized.

We have a function zero_resv_unavail() which does zeroing the struct pages
outside memblock.memory, but currently it covers only the reserved
unavailable range (i.e.  memblock.memory && !memblock.reserved).  This
patch extends it to cover all unavailable range, which fixes the reported
issue.

Link: http://lkml.kernel.org/r/20181002143821.5112-2-msys.mizuma@gmail.com
Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Tested-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memblock.h | 15 ---------------
 mm/page_alloc.c          | 36 +++++++++++++++++++++++++-----------
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5169205493782..2acdd046df2d5 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -265,21 +265,6 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 	for_each_mem_range_rev(i, &memblock.memory, &memblock.reserved,	\
 			       nid, flags, p_start, p_end, p_nid)
 
-/**
- * for_each_resv_unavail_range - iterate through reserved and unavailable memory
- * @i: u64 used as loop variable
- * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
- * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
- *
- * Walks over unavailable but reserved (reserved && !memory) areas of memblock.
- * Available as soon as memblock is initialized.
- * Note: because this memory does not belong to any physical node, flags and
- * nid arguments do not make sense and thus not exported as arguments.
- */
-#define for_each_resv_unavail_range(i, p_start, p_end)			\
-	for_each_mem_range(i, &memblock.reserved, &memblock.memory,	\
-			   NUMA_NO_NODE, MEMBLOCK_NONE, p_start, p_end, NULL)
-
 static inline void memblock_set_region_flags(struct memblock_region *r,
 					     enum memblock_flags flags)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 74fb5c338e8fb..19f2e77d1c50b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6462,29 +6462,42 @@ void __init free_area_init_node(int nid, unsigned long *zones_size,
  * struct pages which are reserved in memblock allocator and their fields
  * may be accessed (for example page_to_pfn() on some configuration accesses
  * flags). We must explicitly zero those struct pages.
+ *
+ * This function also addresses a similar issue where struct pages are left
+ * uninitialized because the physical address range is not covered by
+ * memblock.memory or memblock.reserved. That could happen when memblock
+ * layout is manually configured via memmap=.
  */
 void __init zero_resv_unavail(void)
 {
 	phys_addr_t start, end;
 	unsigned long pfn;
 	u64 i, pgcnt;
+	phys_addr_t next = 0;
 
 	/*
-	 * Loop through ranges that are reserved, but do not have reported
-	 * physical memory backing.
+	 * Loop through unavailable ranges not covered by memblock.memory.
 	 */
 	pgcnt = 0;
-	for_each_resv_unavail_range(i, &start, &end) {
-		for (pfn = PFN_DOWN(start); pfn < PFN_UP(end); pfn++) {
-			if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
-				pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
-					+ pageblock_nr_pages - 1;
-				continue;
+	for_each_mem_range(i, &memblock.memory, NULL,
+			NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, NULL) {
+		if (next < start) {
+			for (pfn = PFN_DOWN(next); pfn < PFN_UP(start); pfn++) {
+				if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages)))
+					continue;
+				mm_zero_struct_page(pfn_to_page(pfn));
+				pgcnt++;
 			}
-			mm_zero_struct_page(pfn_to_page(pfn));
-			pgcnt++;
 		}
+		next = end;
 	}
+	for (pfn = PFN_DOWN(next); pfn < max_pfn; pfn++) {
+		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages)))
+			continue;
+		mm_zero_struct_page(pfn_to_page(pfn));
+		pgcnt++;
+	}
+
 
 	/*
 	 * Struct pages that do not have backing memory. This could be because
@@ -6494,7 +6507,8 @@ void __init zero_resv_unavail(void)
 	 * this code can be removed.
 	 */
 	if (pgcnt)
-		pr_info("Reserved but unavailable: %lld pages", pgcnt);
+		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
+
 }
 #endif /* CONFIG_HAVE_MEMBLOCK && !CONFIG_FLAT_NODE_MEM_MAP */
 
-- 
2.20.1



