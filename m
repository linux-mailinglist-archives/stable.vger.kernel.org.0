Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3188A8C457
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 00:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfHMWhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 18:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfHMWhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 18:37:21 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0643920843;
        Tue, 13 Aug 2019 22:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565735839;
        bh=mqOyift66lj7PyqxhI17VTqMsTlI4AY2YXw53xAC60o=;
        h=Date:From:To:Subject:From;
        b=mKt/p5mTt4u/4emCbt6LEJignZnrwVG86/dDy4F/OxkTozRyvy9PmK4yNLLUno+yR
         ziHwoRuYWTDziPSyx/XPXsXVSQ9D2CjzOAA3cbN5J61DB0ld+t80Cx6n1jxIiUB7Cc
         9fmsArkGK/JeEsqu0uC1l7BUOo91QO379wAwy+iM=
Date:   Tue, 13 Aug 2019 15:37:18 -0700
From:   akpm@linux-foundation.org
To:     vbabka@suse.cz, stable@vger.kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, yang.shi@linux.alibaba.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 05/18] mm: mempolicy: handle vma with unmovable
 pages mapped correctly in mbind
Message-ID: <20190813223718.GGw4O%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: mempolicy: handle vma with unmovable pages mapped correctly in mbind

When running syzkaller internally, we ran into the below bug on 4.9.x
kernel:

kernel BUG at mm/huge_memory.c:2124!
invalid opcode: 0000 [#1] SMP KASAN
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in:
CPU: 0 PID: 1518 Comm: syz-executor107 Not tainted 4.9.168+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
task: ffff880067b34900 task.stack: ffff880068998000
RIP: 0010:[<ffffffff81895d6b>]  [<ffffffff81895d6b>] split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
RSP: 0018:ffff88006899f980  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffea00018f1700 RCX: 0000000000000000
RDX: 1ffffd400031e2e7 RSI: 0000000000000001 RDI: ffffea00018f1738
RBP: ffff88006899f9e8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: fffffbfff0d8b13e R12: ffffea00018f1400
R13: ffffea00018f1400 R14: ffffea00018f1720 R15: ffffea00018f1401
FS:  00007fa333996740(0000) GS:ffff88006c600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000040 CR3: 0000000066b9c000 CR4: 00000000000606f0
Stack:
 0000000000000246 ffff880067b34900 0000000000000000 ffff88007ffdc000
 0000000000000000 ffff88006899f9e8 ffffffff812b4015 ffff880064c64e18
 ffffea00018f1401 dffffc0000000000 ffffea00018f1700 0000000020ffd000
Call Trace:
 [<ffffffff818490f1>] split_huge_page include/linux/huge_mm.h:100 [inline]
 [<ffffffff818490f1>] queue_pages_pte_range+0x7e1/0x1480 mm/mempolicy.c:538
 [<ffffffff817ed0da>] walk_pmd_range mm/pagewalk.c:50 [inline]
 [<ffffffff817ed0da>] walk_pud_range mm/pagewalk.c:90 [inline]
 [<ffffffff817ed0da>] walk_pgd_range mm/pagewalk.c:116 [inline]
 [<ffffffff817ed0da>] __walk_page_range+0x44a/0xdb0 mm/pagewalk.c:208
 [<ffffffff817edb94>] walk_page_range+0x154/0x370 mm/pagewalk.c:285
 [<ffffffff81844515>] queue_pages_range+0x115/0x150 mm/mempolicy.c:694
 [<ffffffff8184f493>] do_mbind mm/mempolicy.c:1241 [inline]
 [<ffffffff8184f493>] SYSC_mbind+0x3c3/0x1030 mm/mempolicy.c:1370
 [<ffffffff81850146>] SyS_mbind+0x46/0x60 mm/mempolicy.c:1352
 [<ffffffff810097e2>] do_syscall_64+0x1d2/0x600 arch/x86/entry/common.c:282
 [<ffffffff82ff6f93>] entry_SYSCALL_64_after_swapgs+0x5d/0xdb
Code: c7 80 1c 02 00 e8 26 0a 76 01 <0f> 0b 48 c7 c7 40 46 45 84 e8 4c
RIP  [<ffffffff81895d6b>] split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
 RSP <ffff88006899f980>

with the below test:

---8<---

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
        syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
                                intptr_t res = 0;
        res = syscall(__NR_socket, 0x11, 3, 0x300);
        if (res != -1)
                r[0] = res;
*(uint32_t*)0x20000040 = 0x10000;
*(uint32_t*)0x20000044 = 1;
*(uint32_t*)0x20000048 = 0xc520;
*(uint32_t*)0x2000004c = 1;
        syscall(__NR_setsockopt, r[0], 0x107, 0xd, 0x20000040, 0x10);
        syscall(__NR_mmap, 0x20fed000, 0x10000, 0, 0x8811, r[0], 0);
*(uint64_t*)0x20000340 = 2;
        syscall(__NR_mbind, 0x20ff9000, 0x4000, 0x4002, 0x20000340,
0x45d4, 3);
        return 0;
}

---8<---

Actually the test does:

mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
socket(AF_PACKET, SOCK_RAW, 768)        = 3
setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=65536, block_nr=1, frame_size=50464, frame_nr=1}, 16) = 0
mmap(0x20fed000, 65536, PROT_NONE, MAP_SHARED|MAP_FIXED|MAP_POPULATE|MAP_DENYWRITE, 3, 0) = 0x20fed000
mbind(..., MPOL_MF_STRICT|MPOL_MF_MOVE) = 0

The setsockopt() would allocate compound pages (16 pages in this test) for
packet tx ring, then the mmap() would call packet_mmap() to map the pages
into the user address space specified by the mmap() call.

When calling mbind(), it would scan the vma to queue the pages for
migration to the new node.  It would split any huge page since 4.9 doesn't
support THP migration, however, the packet tx ring compound pages are not
THP and even not movable.  So, the above bug is triggered.

However, the later kernel is not hit by this issue due to
d44d363f65780f2ac2 ("mm: don't assume anonymous pages have SwapBacked
flag"), which just removes the PageSwapBacked check for a different
reason.

But, there is a deeper issue.  According to the semantic of mbind(), it
should return -EIO if MPOL_MF_MOVE or MPOL_MF_MOVE_ALL was specified and
MPOL_MF_STRICT was also specified, but the kernel was unable to move all
existing pages in the range.  The tx ring of the packet socket is
definitely not movable, however, mbind() returns success for this case.

Although the most socket file associates with non-movable pages, but XDP
may have movable pages from gup.  So, it sounds not fine to just check the
underlying file type of vma in vma_migratable().

Change migrate_page_add() to check if the page is movable or not, if it is
unmovable, just return -EIO.  But do not abort pte walk immediately, since
there may be pages off LRU temporarily.  We should migrate other pages if
MPOL_MF_MOVE* is specified.  Set has_unmovable flag if some paged could
not be not moved, then return -EIO for mbind() eventually.

With this change the above test would return -EIO as expected.

[yang.shi@linux.alibaba.com: fix review comments from Vlastimil]
  Link: http://lkml.kernel.org/r/1563556862-54056-3-git-send-email-yang.shi@linux.alibaba.com
Link: http://lkml.kernel.org/r/1561162809-59140-3-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind
+++ a/mm/mempolicy.c
@@ -403,7 +403,7 @@ static const struct mempolicy_operations
 	},
 };
 
-static void migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
 struct queue_pages {
@@ -463,12 +463,11 @@ static int queue_pages_pmd(pmd_t *pmd, s
 	flags = qp->flags;
 	/* go to thp migration */
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-		if (!vma_migratable(walk->vma)) {
+		if (!vma_migratable(walk->vma) ||
+		    migrate_page_add(page, qp->pagelist, flags)) {
 			ret = 1;
 			goto unlock;
 		}
-
-		migrate_page_add(page, qp->pagelist, flags);
 	} else
 		ret = -EIO;
 unlock:
@@ -532,7 +531,14 @@ static int queue_pages_pte_range(pmd_t *
 				has_unmovable = true;
 				break;
 			}
-			migrate_page_add(page, qp->pagelist, flags);
+
+			/*
+			 * Do not abort immediately since there may be
+			 * temporary off LRU pages in the range.  Still
+			 * need migrate other LRU pages.
+			 */
+			if (migrate_page_add(page, qp->pagelist, flags))
+				has_unmovable = true;
 		} else
 			break;
 	}
@@ -961,7 +967,7 @@ static long do_get_mempolicy(int *policy
 /*
  * page migration, thp tail pages can be passed.
  */
-static void migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags)
 {
 	struct page *head = compound_head(page);
@@ -974,8 +980,19 @@ static void migrate_page_add(struct page
 			mod_node_page_state(page_pgdat(head),
 				NR_ISOLATED_ANON + page_is_file_cache(head),
 				hpage_nr_pages(head));
+		} else if (flags & MPOL_MF_STRICT) {
+			/*
+			 * Non-movable page may reach here.  And, there may be
+			 * temporary off LRU pages or non-LRU movable pages.
+			 * Treat them as unmovable pages since they can't be
+			 * isolated, so they can't be moved at the moment.  It
+			 * should return -EIO for this case too.
+			 */
+			return -EIO;
 		}
 	}
+
+	return 0;
 }
 
 /* page allocation callback for NUMA node migration */
@@ -1178,9 +1195,10 @@ static struct page *new_page(struct page
 }
 #else
 
-static void migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags)
 {
+	return -EIO;
 }
 
 int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
_
