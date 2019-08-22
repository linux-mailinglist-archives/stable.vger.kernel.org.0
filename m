Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6599C34
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389719AbfHVRb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404495AbfHVRZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:48 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54DEB2341A;
        Thu, 22 Aug 2019 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494746;
        bh=U29n78LQGMWWz5d1OvpOm/x7cQq3lqqOPA5ASAaP7sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bwlp0m6HHYsDBq6DpAurCWLr60uL6/kqJLJQd9SIcvAQz68nRQsbVRMlls62x803
         dXsPFQfcxDMJIQAsgNFsAk0CsP2KAN3twfE+Z7CNLXyvnKDhWG1dieuc4tlzgF1uBZ
         KHpGEuPGLX5WACMhXgNnV+/JAb6dBdLeZ27e7l4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 05/85] mm: mempolicy: handle vma with unmovable pages mapped correctly in mbind
Date:   Thu, 22 Aug 2019 10:18:38 -0700
Message-Id: <20190822171731.233581237@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit a53190a4aaa36494f4d7209fd1fcc6f2ee08e0e0 upstream.

When running syzkaller internally, we ran into the below bug on 4.9.x
kernel:

  kernel BUG at mm/huge_memory.c:2124!
  invalid opcode: 0000 [#1] SMP KASAN
  CPU: 0 PID: 1518 Comm: syz-executor107 Not tainted 4.9.168+ #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
  task: ffff880067b34900 task.stack: ffff880068998000
  RIP: split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
  Call Trace:
    split_huge_page include/linux/huge_mm.h:100 [inline]
    queue_pages_pte_range+0x7e1/0x1480 mm/mempolicy.c:538
    walk_pmd_range mm/pagewalk.c:50 [inline]
    walk_pud_range mm/pagewalk.c:90 [inline]
    walk_pgd_range mm/pagewalk.c:116 [inline]
    __walk_page_range+0x44a/0xdb0 mm/pagewalk.c:208
    walk_page_range+0x154/0x370 mm/pagewalk.c:285
    queue_pages_range+0x115/0x150 mm/mempolicy.c:694
    do_mbind mm/mempolicy.c:1241 [inline]
    SYSC_mbind+0x3c3/0x1030 mm/mempolicy.c:1370
    SyS_mbind+0x46/0x60 mm/mempolicy.c:1352
    do_syscall_64+0x1d2/0x600 arch/x86/entry/common.c:282
    entry_SYSCALL_64_after_swapgs+0x5d/0xdb
  Code: c7 80 1c 02 00 e8 26 0a 76 01 <0f> 0b 48 c7 c7 40 46 45 84 e8 4c
  RIP  [<ffffffff81895d6b>] split_huge_page_to_list+0x8fb/0x1030 mm/huge_memory.c:2124
   RSP <ffff88006899f980>

with the below test:

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
        syscall(__NR_mbind, 0x20ff9000, 0x4000, 0x4002, 0x20000340, 0x45d4, 3);
        return 0;
  }

Actually the test does:

  mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
  socket(AF_PACKET, SOCK_RAW, 768)        = 3
  setsockopt(3, SOL_PACKET, PACKET_TX_RING, {block_size=65536, block_nr=1, frame_size=50464, frame_nr=1}, 16) = 0
  mmap(0x20fed000, 65536, PROT_NONE, MAP_SHARED|MAP_FIXED|MAP_POPULATE|MAP_DENYWRITE, 3, 0) = 0x20fed000
  mbind(..., MPOL_MF_STRICT|MPOL_MF_MOVE) = 0

The setsockopt() would allocate compound pages (16 pages in this test)
for packet tx ring, then the mmap() would call packet_mmap() to map the
pages into the user address space specified by the mmap() call.

When calling mbind(), it would scan the vma to queue the pages for
migration to the new node.  It would split any huge page since 4.9
doesn't support THP migration, however, the packet tx ring compound
pages are not THP and even not movable.  So, the above bug is triggered.

However, the later kernel is not hit by this issue due to commit
d44d363f6578 ("mm: don't assume anonymous pages have SwapBacked flag"),
which just removes the PageSwapBacked check for a different reason.

But, there is a deeper issue.  According to the semantic of mbind(), it
should return -EIO if MPOL_MF_MOVE or MPOL_MF_MOVE_ALL was specified and
MPOL_MF_STRICT was also specified, but the kernel was unable to move all
existing pages in the range.  The tx ring of the packet socket is
definitely not movable, however, mbind() returns success for this case.

Although the most socket file associates with non-movable pages, but XDP
may have movable pages from gup.  So, it sounds not fine to just check
the underlying file type of vma in vma_migratable().

Change migrate_page_add() to check if the page is movable or not, if it
is unmovable, just return -EIO.  But do not abort pte walk immediately,
since there may be pages off LRU temporarily.  We should migrate other
pages if MPOL_MF_MOVE* is specified.  Set has_unmovable flag if some
paged could not be not moved, then return -EIO for mbind() eventually.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
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
@@ -947,7 +953,7 @@ static long do_get_mempolicy(int *policy
 /*
  * page migration, thp tail pages can be passed.
  */
-static void migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags)
 {
 	struct page *head = compound_head(page);
@@ -960,8 +966,19 @@ static void migrate_page_add(struct page
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
@@ -1164,9 +1181,10 @@ static struct page *new_page(struct page
 }
 #else
 
-static void migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags)
 {
+	return -EIO;
 }
 
 int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,


