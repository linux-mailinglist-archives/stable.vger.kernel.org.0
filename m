Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F3AFED72
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfKPPoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfKPPoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEFE2073B;
        Sat, 16 Nov 2019 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919057;
        bh=RgYEdoLQTvVEYewfCzVEnGtA8NhBcnTFTDtXu/wCQdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIAv5qQFnYxeCYYcp06+RAjuu3NyY2yOs1Wc5XBBztIPF/rEzFPda6XRjFylPm8hI
         exSFU54/xbgMff8l+7dRFQr20jNZvtiR/cXfxWVL4L+5zvsex1VLsxN2QYt4oi06HZ
         MXSpaneh3b3Ap39E1Uo0M4Afj+bcrYgIxIe7auaE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 132/237] mm: thp: fix MADV_DONTNEED vs migrate_misplaced_transhuge_page race condition
Date:   Sat, 16 Nov 2019 10:39:27 -0500
Message-Id: <20191116154113.7417-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

[ Upstream commit d7c3393413fe7e7dc54498ea200ea94742d61e18 ]

Patch series "migrate_misplaced_transhuge_page race conditions".

Aaron found a new instance of the THP MADV_DONTNEED race against
pmdp_clear_flush* variants, that was apparently left unfixed.

While looking into the race found by Aaron, I may have found two more
issues in migrate_misplaced_transhuge_page.

These race conditions would not cause kernel instability, but they'd
corrupt userland data or leave data non zero after MADV_DONTNEED.

I did only minor testing, and I don't expect to be able to reproduce this
(especially the lack of ->invalidate_range before migrate_page_copy,
requires the latest iommu hardware or infiniband to reproduce).  The last
patch is noop for x86 and it needs further review from maintainers of
archs that implement flush_cache_range() (not in CC yet).

To avoid confusion, it's not the first patch that introduces the bug fixed
in the second patch, even before removing the
pmdp_huge_clear_flush_notify, that _notify suffix was called after
migrate_page_copy already run.

This patch (of 3):

This is a corollary of ced108037c2aa ("thp: fix MADV_DONTNEED vs.  numa
balancing race"), 58ceeb6bec8 ("thp: fix MADV_DONTNEED vs.  MADV_FREE
race") and 5b7abeae3af8c ("thp: fix MADV_DONTNEED vs clear soft dirty
race).

When the above three fixes where posted Dave asked
https://lkml.kernel.org/r/929b3844-aec2-0111-fef7-8002f9d4e2b9@intel.com
but apparently this was missed.

The pmdp_clear_flush* in migrate_misplaced_transhuge_page() was introduced
in a54a407fbf7 ("mm: Close races between THP migration and PMD numa
clearing").

The important part of such commit is only the part where the page lock is
not released until the first do_huge_pmd_numa_page() finished disarming
the pagenuma/protnone.

The addition of pmdp_clear_flush() wasn't beneficial to such commit and
there's no commentary about such an addition either.

I guess the pmdp_clear_flush() in such commit was added just in case for
safety, but it ended up introducing the MADV_DONTNEED race condition found
by Aaron.

At that point in time nobody thought of such kind of MADV_DONTNEED race
conditions yet (they were fixed later) so the code may have looked more
robust by adding the pmdp_clear_flush().

This specific race condition won't destabilize the kernel, but it can
confuse userland because after MADV_DONTNEED the memory won't be zeroed
out.

This also optimizes the code and removes a superfluous TLB flush.

[akpm@linux-foundation.org: reflow comment to 80 cols, fix grammar and typo (beacuse)]
Link: http://lkml.kernel.org/r/20181013002430.698-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 0c48191a90368..4d3588c012034 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2048,15 +2048,26 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
 	/*
-	 * Clear the old entry under pagetable lock and establish the new PTE.
-	 * Any parallel GUP will either observe the old page blocking on the
-	 * page lock, block on the page table lock or observe the new page.
-	 * The SetPageUptodate on the new page and page_add_new_anon_rmap
-	 * guarantee the copy is visible before the pagetable update.
+	 * Overwrite the old entry under pagetable lock and establish
+	 * the new PTE. Any parallel GUP will either observe the old
+	 * page blocking on the page lock, block on the page table
+	 * lock or observe the new page. The SetPageUptodate on the
+	 * new page and page_add_new_anon_rmap guarantee the copy is
+	 * visible before the pagetable update.
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
 	page_add_anon_rmap(new_page, vma, mmun_start, true);
-	pmdp_huge_clear_flush_notify(vma, mmun_start, pmd);
+	/*
+	 * At this point the pmd is numa/protnone (i.e. non present) and the TLB
+	 * has already been flushed globally.  So no TLB can be currently
+	 * caching this non present pmd mapping.  There's no need to clear the
+	 * pmd before doing set_pmd_at(), nor to flush the TLB after
+	 * set_pmd_at().  Clearing the pmd here would introduce a race
+	 * condition against MADV_DONTNEED, because MADV_DONTNEED only holds the
+	 * mmap_sem for reading.  If the pmd is set to NULL at any given time,
+	 * MADV_DONTNEED won't wait on the pmd lock and it'll skip clearing this
+	 * pmd.
+	 */
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	update_mmu_cache_pmd(vma, address, &entry);
 
@@ -2070,7 +2081,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	 * No need to double call mmu_notifier->invalidate_range() callback as
 	 * the above pmdp_huge_clear_flush_notify() did already call it.
 	 */
-	mmu_notifier_invalidate_range_only_end(mm, mmun_start, mmun_end);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	/* Take an "isolate" reference and put new page on the LRU. */
 	get_page(new_page);
-- 
2.20.1

