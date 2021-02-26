Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D5D326578
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 17:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBZQXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 11:23:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:54466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBZQXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 11:23:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 44B4CAB8C;
        Fri, 26 Feb 2021 16:22:28 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 4.9 STABLE] mm, thp: make do_huge_pmd_wp_page() lock page for testing mapcount
Date:   Fri, 26 Feb 2021 17:22:00 +0100
Message-Id: <20210226162200.20548-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <26569718-050f-fc90-e3ac-79edfaae9ac7@suse.cz>
References: <26569718-050f-fc90-e3ac-79edfaae9ac7@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann reported [1] a race between __split_huge_pmd_locked() and
page_trans_huge_map_swapcount() which can result in a page to be reused
instead of COWed. This was later assigned CVE-2020-29368.

This was fixed by commit c444eb564fb1 ("mm: thp: make the THP mapcount atomic
against __split_huge_pmd_locked()") by doing the split under the page lock,
while all users of page_trans_huge_map_swapcount() were already also under page
lock. The fix was backported also to 4.9 stable series.

When testing the backport on a 4.12 based kernel, Nicolai noticed the POC from
[1] still reproduces after backporting c444eb564fb1 and identified a missing
page lock in do_huge_pmd_wp_page() around the call to
page_trans_huge_mapcount(). The page lock was only added in ba3c4ce6def4 ("mm,
THP, swap: make reuse_swap_page() works for THP swapped out") in 4.14. The
commit also wrapped page_trans_huge_mapcount() into
page_trans_huge_map_swapcount() for the purposes of COW decisions.

I have verified that 4.9.y indeed also reproduces with the POC. Backporting
ba3c4ce6def4 alone however is not possible as it's part of a larger effort of
optimizing THP swapping, which would be risky to backport fully.

Therefore this 4.9-stable-only patch just wraps page_trans_huge_mapcount()
in page_trans_huge_mapcount() under page lock the same way as ba3c4ce6def4
does, but without the page_trans_huge_map_swapcount() part. Other callers
of page_trans_huge_mapcount() are all under page lock already. I have verified
the POC no longer reproduces afterwards.

[1] https://bugs.chromium.org/p/project-zero/issues/detail?id=2045

Reported-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/huge_memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 05ca01ef97f7..14cd0ef33b62 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1022,6 +1022,19 @@ int do_huge_pmd_wp_page(struct fault_env *fe, pmd_t orig_pmd)
 	 * We can only reuse the page if nobody else maps the huge page or it's
 	 * part.
 	 */
+	if (!trylock_page(page)) {
+		get_page(page);
+		spin_unlock(fe->ptl);
+		lock_page(page);
+		spin_lock(fe->ptl);
+		if (unlikely(!pmd_same(*fe->pmd, orig_pmd))) {
+			unlock_page(page);
+			put_page(page);
+			goto out_unlock;
+		}
+		put_page(page);
+	}
+
 	if (page_trans_huge_mapcount(page, NULL) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
@@ -1029,8 +1042,10 @@ int do_huge_pmd_wp_page(struct fault_env *fe, pmd_t orig_pmd)
 		if (pmdp_set_access_flags(vma, haddr, fe->pmd, entry,  1))
 			update_mmu_cache_pmd(vma, fe->address, fe->pmd);
 		ret |= VM_FAULT_WRITE;
+		unlock_page(page);
 		goto out_unlock;
 	}
+	unlock_page(page);
 	get_page(page);
 	spin_unlock(fe->ptl);
 alloc:
-- 
2.30.1

