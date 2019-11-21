Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92834105D03
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUXG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfKUXG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 18:06:29 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1AF6206B6;
        Thu, 21 Nov 2019 23:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574377588;
        bh=Ptm2J2HxpN9LwOUHQuqiPMz68itkFJEYC3rEHUnQmY4=;
        h=Date:From:To:Subject:From;
        b=TMC8baq1GBUhaTLTYwh7xMKZ5zrOTOmYkDS9fVNUpJuJsXJyzxrp0uwlMy5nxJAa8
         md02Q035miwj+1vHpbGL6swi6LTCzS8mYmxEj6RNl7hyukWbhrxQWHVBYk0p9yWzQc
         qncFLIm49gjzQOkrIkKoyOduSnrGWjDwOOOU3DZM=
Date:   Thu, 21 Nov 2019 15:06:27 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        zhongjiang@huawei.com
Subject:  [merged]
 =?US-ASCII?Q?mm-fix-trying-to-reclaim-unevictable-lru-page-when-calling-m?=
 =?US-ASCII?Q?advise=5Fpageout.patch?= removed from -mm tree
Message-ID: <20191121230627.bGPDQc4us%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix trying to reclaim unevictable lru page when calling madvise_pageout
has been removed from the -mm tree.  Its filename was
     mm-fix-trying-to-reclaim-unevictable-lru-page-when-calling-madvise_pageout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm: fix trying to reclaim unevictable lru page when calling madvise_pageout

Recently, I hit the following issue when running upstream.

kernel BUG at mm/vmscan.c:1521!
invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 PID: 23385 Comm: syz-executor.6 Not tainted 5.4.0-rc4+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:shrink_page_list+0x12b6/0x3530 mm/vmscan.c:1521
Code: de f5 ff ff e8 ab 79 eb ff 4c 89 f7 e8 43 33 0d 00 e9 cc f5 ff ff e8 99 79 eb ff 48 c7 c6 a0 34 2b a0 4c 89 f7 e8 1a 4d 05 00 <0f> 0b e8 83 79 eb ff 48 89 d8 48 c1 e8 03 42 80 3c 38 00 0f 85 74
RSP: 0018:ffff88819a3df5a0 EFLAGS: 00010286
RAX: 0000000000040000 RBX: ffffea00061c3980 RCX: ffffffff814fba36
RDX: 00000000000056f7 RSI: ffffc9000c02c000 RDI: ffff8881f70268cc
RBP: ffff88819a3df898 R08: ffffed103ee05de0 R09: ffffed103ee05de0
R10: 0000000000000001 R11: ffffed103ee05ddf R12: ffff88819a3df6f0
R13: ffff88819a3df6f0 R14: ffffea00061c3980 R15: dffffc0000000000
FS:  00007f21b9d8e700(0000) GS:ffff8881f7000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d621000 CR3: 00000001c8c46004 CR4: 00000000007606f0
DR0: 0000000020000140 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
PKRU: 55555554
Call Trace:
 reclaim_pages+0x499/0x800 mm/vmscan.c:2188
 madvise_cold_or_pageout_pte_range+0x58a/0x710 mm/madvise.c:453
 walk_pmd_range mm/pagewalk.c:53 [inline]
 walk_pud_range mm/pagewalk.c:112 [inline]
 walk_p4d_range mm/pagewalk.c:139 [inline]
 walk_pgd_range mm/pagewalk.c:166 [inline]
 __walk_page_range+0x45a/0xc20 mm/pagewalk.c:261
 walk_page_range+0x179/0x310 mm/pagewalk.c:349
 madvise_pageout_page_range mm/madvise.c:506 [inline]
 madvise_pageout+0x1f0/0x330 mm/madvise.c:542
 madvise_vma mm/madvise.c:931 [inline]
 __do_sys_madvise+0x7d2/0x1600 mm/madvise.c:1113
 do_syscall_64+0x9f/0x4c0 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

madvise_pageout() accesses the specified range of the vma and isolates
them, then runs shrink_page_list() to reclaim its memory.  But it also
isolates the unevictable pages to reclaim.  Hence, we can catch the cases
in shrink_page_list().

The root cause is that we scan the page tables instead of specific LRU
list.  and so we need to filter out the unevictable lru pages from our
end.

Link: http://lkml.kernel.org/r/1572616245-18946-1-git-send-email-zhongjiang@huawei.com
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-fix-trying-to-reclaim-unevictable-lru-page-when-calling-madvise_pageout
+++ a/mm/madvise.c
@@ -363,8 +363,12 @@ static int madvise_cold_or_pageout_pte_r
 		ClearPageReferenced(page);
 		test_and_clear_page_young(page);
 		if (pageout) {
-			if (!isolate_lru_page(page))
-				list_add(&page->lru, &page_list);
+			if (!isolate_lru_page(page)) {
+				if (PageUnevictable(page))
+					putback_lru_page(page);
+				else
+					list_add(&page->lru, &page_list);
+			}
 		} else
 			deactivate_page(page);
 huge_unlock:
@@ -441,8 +445,12 @@ regular_page:
 		ClearPageReferenced(page);
 		test_and_clear_page_young(page);
 		if (pageout) {
-			if (!isolate_lru_page(page))
-				list_add(&page->lru, &page_list);
+			if (!isolate_lru_page(page)) {
+				if (PageUnevictable(page))
+					putback_lru_page(page);
+				else
+					list_add(&page->lru, &page_list);
+			}
 		} else
 			deactivate_page(page);
 	}
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-gup-allow-cma-migration-to-propagate-errors-back-to-caller.patch
mm-split_huge_pages_fops-should-be-defined-with-define_debugfs_attribute.patch
mm-cma_debug-use-define_debugfs_attribute-to-define-debugfs-fops.patch
mm-hwpoison-inject-use-define_debugfs_attribute-to-define-debugfs-fops.patch

