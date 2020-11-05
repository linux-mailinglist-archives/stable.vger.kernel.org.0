Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66232A8797
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 20:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgKETvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 14:51:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 14:51:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5JoQkS073637;
        Thu, 5 Nov 2020 19:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=/6/OKMS/SxQDgxzZKIo3AGZkBVxxiHMUMKrXEJC+vcU=;
 b=VqpznkDiABmfVTA1CSrMxfV2p0itnPGRRkmrJJeSusk29iFuN4rwxA/JmS7hKPfCBclw
 Kt767ZqqJIySczlDKYPxakR5vuRQoIpzgib/RcoMGiqPjuz051gjlmGT39fYBC/WZDF+
 xDdB1UUWGZKB4tCJoJuV+2YNqsDwT4LVBtix4c2CPR/L5LjDnd+w40yPRvSI+ZLgYk47
 syx+EEntoZhKdiY3C9Apj2fXscxO48zLKv2FV64SxgXAllnIF8SZmomZzNpVr7UauyMm
 X+PYONvgeO7sEG88T2A6VRKZFoc6TzdR0oUJAim4E2CcACb+a30aIyZ1In++ZXoZNlYR QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvcnu7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 19:51:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5Jius9157879;
        Thu, 5 Nov 2020 19:51:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34jf4cq125-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 19:51:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A5JpAu7010662;
        Thu, 5 Nov 2020 19:51:11 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Nov 2020 11:51:09 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Qian Cai <cai@lca.pm>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] hugetlbfs: fix anon huge page migration race
Date:   Thu,  5 Nov 2020 11:50:58 -0800
Message-Id: <20201105195058.78401-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9796 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9796 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050127
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qian Cai reported the following BUG in [1]

[ 6147.019063][T45242] LTP: starting move_pages12
[ 6147.475680][T64921] BUG: unable to handle page fault for address: ffffffffffffffe0
...
[ 6147.525866][T64921] RIP: 0010:anon_vma_interval_tree_iter_first+0xa2/0x170
avc_start_pgoff at mm/interval_tree.c:63
[ 6147.620914][T64921] Call Trace:
[ 6147.624078][T64921]  rmap_walk_anon+0x141/0xa30
rmap_walk_anon at mm/rmap.c:1864
[ 6147.628639][T64921]  try_to_unmap+0x209/0x2d0
try_to_unmap at mm/rmap.c:1763
[ 6147.633026][T64921]  ? rmap_walk_locked+0x140/0x140
[ 6147.637936][T64921]  ? page_remove_rmap+0x1190/0x1190
[ 6147.643020][T64921]  ? page_not_mapped+0x10/0x10
[ 6147.647668][T64921]  ? page_get_anon_vma+0x290/0x290
[ 6147.652664][T64921]  ? page_mapcount_is_zero+0x10/0x10
[ 6147.657838][T64921]  ? hugetlb_page_mapping_lock_write+0x97/0x180
[ 6147.663972][T64921]  migrate_pages+0x1005/0x1fb0
[ 6147.668617][T64921]  ? remove_migration_pte+0xac0/0xac0
[ 6147.673875][T64921]  move_pages_and_store_status.isra.47+0xd7/0x1a0
[ 6147.680181][T64921]  ? migrate_pages+0x1fb0/0x1fb0
[ 6147.685002][T64921]  __x64_sys_move_pages+0xa5c/0x1100
[ 6147.690176][T64921]  ? trace_hardirqs_on+0x20/0x1b5
[ 6147.695084][T64921]  ? move_pages_and_store_status.isra.47+0x1a0/0x1a0
[ 6147.701653][T64921]  ? rcu_read_lock_sched_held+0xaa/0xd0
[ 6147.707088][T64921]  ? switch_fpu_return+0x196/0x400
[ 6147.712083][T64921]  ? lockdep_hardirqs_on_prepare+0x38c/0x550
[ 6147.717954][T64921]  ? do_syscall_64+0x24/0x310
[ 6147.722513][T64921]  do_syscall_64+0x5f/0x310
[ 6147.726897][T64921]  ? trace_hardirqs_off+0x12/0x1a0
[ 6147.731894][T64921]  ? asm_exc_page_fault+0x8/0x30
[ 6147.736714][T64921]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Hugh Dickens diagnosed this as a migration bug caused by code introduced
to use i_mmap_rwsem for pmd sharing synchronization.  Specifically, the
routine unmap_and_move_huge_page() is always passing the TTU_RMAP_LOCKED
flag to try_to_unmap() while holding i_mmap_rwsem.   This is wrong for
anon pages as the anon_vma_lock should be held in this case.  Further
analysis suggested that i_mmap_rwsem was not required to he held at all
when calling try_to_unmap for anon pages as an anon page could never be
part of a shared pmd mapping.

Discussion also revealed that the hack in hugetlb_page_mapping_lock_write
to drop page lock and acquire i_mmap_rwsem is wrong.  There is no way to
keep mapping valid while dropping page lock.

This patch does the following:
- Do not take i_mmap_rwsem and set TTU_RMAP_LOCKED for anon pages when
  calling try_to_unmap.
- Remove the hacky code in hugetlb_page_mapping_lock_write.  The routine
  will now simply do a 'trylock' while still holding the page lock.  If
  the trylock fails, it will return NULL.  This could impact the callers:
  - migration calling code will receive -EAGAIN and retry up to the hard
    coded limit (10).
  - memory error code will treat the page as BUSY.  This will force
    killing (SIGKILL) instead of SIGBUS any mapping tasks.
  Do note that this change in behavior only happens when there is a race.
  None of the standard kernel testing suites actually hit this race, but
  it is possible.

[1] https://lore.kernel.org/lkml/20200708012044.GC992@lca.pw/
[2] https://lore.kernel.org/linux-mm/alpine.LSU.2.11.2010071833100.2214@eggly.anvils/

Reported-by: Qian Cai <cai@lca.pw>
Suggested-by: Hugh Dickins <hughd@google.com>
Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c        | 90 +++------------------------------------------
 mm/memory-failure.c | 36 +++++++++---------
 mm/migrate.c        | 44 ++++++++++++----------
 mm/rmap.c           |  5 +--
 4 files changed, 47 insertions(+), 128 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fe76f8fd5a73..15fc4f210a72 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1568,104 +1568,24 @@ int PageHeadHuge(struct page *page_head)
 	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
 
-/*
- * Find address_space associated with hugetlbfs page.
- * Upon entry page is locked and page 'was' mapped although mapped state
- * could change.  If necessary, use anon_vma to find vma and associated
- * address space.  The returned mapping may be stale, but it can not be
- * invalid as page lock (which is held) is required to destroy mapping.
- */
-static struct address_space *_get_hugetlb_page_mapping(struct page *hpage)
-{
-	struct anon_vma *anon_vma;
-	pgoff_t pgoff_start, pgoff_end;
-	struct anon_vma_chain *avc;
-	struct address_space *mapping = page_mapping(hpage);
-
-	/* Simple file based mapping */
-	if (mapping)
-		return mapping;
-
-	/*
-	 * Even anonymous hugetlbfs mappings are associated with an
-	 * underlying hugetlbfs file (see hugetlb_file_setup in mmap
-	 * code).  Find a vma associated with the anonymous vma, and
-	 * use the file pointer to get address_space.
-	 */
-	anon_vma = page_lock_anon_vma_read(hpage);
-	if (!anon_vma)
-		return mapping;  /* NULL */
-
-	/* Use first found vma */
-	pgoff_start = page_to_pgoff(hpage);
-	pgoff_end = pgoff_start + pages_per_huge_page(page_hstate(hpage)) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-					pgoff_start, pgoff_end) {
-		struct vm_area_struct *vma = avc->vma;
-
-		mapping = vma->vm_file->f_mapping;
-		break;
-	}
-
-	anon_vma_unlock_read(anon_vma);
-	return mapping;
-}
-
 /*
  * Find and lock address space (mapping) in write mode.
  *
- * Upon entry, the page is locked which allows us to find the mapping
- * even in the case of an anon page.  However, locking order dictates
- * the i_mmap_rwsem be acquired BEFORE the page lock.  This is hugetlbfs
- * specific.  So, we first try to lock the sema while still holding the
- * page lock.  If this works, great!  If not, then we need to drop the
- * page lock and then acquire i_mmap_rwsem and reacquire page lock.  Of
- * course, need to revalidate state along the way.
+ * Upon entry, the page is locked which means that page_mapping() is
+ * stable.  Due to locking order, we can only trylock_write.  If we can
+ * not get the lock, simply return NULL to caller.
  */
 struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
 {
-	struct address_space *mapping, *mapping2;
+	struct address_space *mapping = page_mapping(hpage);
 
-	mapping = _get_hugetlb_page_mapping(hpage);
-retry:
 	if (!mapping)
 		return mapping;
 
-	/*
-	 * If no contention, take lock and return
-	 */
 	if (i_mmap_trylock_write(mapping))
 		return mapping;
 
-	/*
-	 * Must drop page lock and wait on mapping sema.
-	 * Note:  Once page lock is dropped, mapping could become invalid.
-	 * As a hack, increase map count until we lock page again.
-	 */
-	atomic_inc(&hpage->_mapcount);
-	unlock_page(hpage);
-	i_mmap_lock_write(mapping);
-	lock_page(hpage);
-	atomic_add_negative(-1, &hpage->_mapcount);
-
-	/* verify page is still mapped */
-	if (!page_mapped(hpage)) {
-		i_mmap_unlock_write(mapping);
-		return NULL;
-	}
-
-	/*
-	 * Get address space again and verify it is the same one
-	 * we locked.  If not, drop lock and retry.
-	 */
-	mapping2 = _get_hugetlb_page_mapping(hpage);
-	if (mapping2 != mapping) {
-		i_mmap_unlock_write(mapping);
-		mapping = mapping2;
-		goto retry;
-	}
-
-	return mapping;
+	return NULL;
 }
 
 pgoff_t __basepage_index(struct page *page)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c0bb186bba62..5d880d4eb9a2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1057,27 +1057,25 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	if (!PageHuge(hpage)) {
 		unmap_success = try_to_unmap(hpage, ttu);
 	} else {
-		/*
-		 * For hugetlb pages, try_to_unmap could potentially call
-		 * huge_pmd_unshare.  Because of this, take semaphore in
-		 * write mode here and set TTU_RMAP_LOCKED to indicate we
-		 * have taken the lock at this higer level.
-		 *
-		 * Note that the call to hugetlb_page_mapping_lock_write
-		 * is necessary even if mapping is already set.  It handles
-		 * ugliness of potentially having to drop page lock to obtain
-		 * i_mmap_rwsem.
-		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
-
-		if (mapping) {
-			unmap_success = try_to_unmap(hpage,
+		if (!PageAnon(hpage)) {
+			/*
+			 * For hugetlb pages in shared mappings, try_to_unmap
+			 * could potentially call huge_pmd_unshare.  Because of
+			 * this, take semaphore in write mode here and set
+			 * TTU_RMAP_LOCKED to indicate we have taken the lock
+			 * at this higer level.
+			 */
+			mapping = hugetlb_page_mapping_lock_write(hpage);
+			if (mapping) {
+				unmap_success = try_to_unmap(hpage,
 						     ttu|TTU_RMAP_LOCKED);
-			i_mmap_unlock_write(mapping);
+				i_mmap_unlock_write(mapping);
+			} else {
+				pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
+				unmap_success = false;
+			}
 		} else {
-			pr_info("Memory failure: %#lx: could not find mapping for mapped huge page\n",
-				pfn);
-			unmap_success = false;
+			unmap_success = try_to_unmap(hpage, ttu);
 		}
 	}
 	if (!unmap_success)
diff --git a/mm/migrate.c b/mm/migrate.c
index 5ca5842df5db..5795cb82e27c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1328,34 +1328,38 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
-		/*
-		 * try_to_unmap could potentially call huge_pmd_unshare.
-		 * Because of this, take semaphore in write mode here and
-		 * set TTU_RMAP_LOCKED to let lower levels know we have
-		 * taken the lock.
-		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
-		if (unlikely(!mapping))
-			goto unlock_put_anon;
+		bool mapping_locked = false;
+		enum ttu_flags ttu = TTU_MIGRATION|TTU_IGNORE_MLOCK|
+					TTU_IGNORE_ACCESS;
+
+		if (!PageAnon(hpage)) {
+			/*
+			 * In shared mappings, try_to_unmap could potentially
+			 * call huge_pmd_unshare.  Because of this, take
+			 * semaphore in write mode here and set TTU_RMAP_LOCKED
+			 * to let lower levels know we have taken the lock.
+			 */
+			mapping = hugetlb_page_mapping_lock_write(hpage);
+			if (unlikely(!mapping))
+				goto unlock_put_anon;
+
+			mapping_locked = true;
+			ttu |= TTU_RMAP_LOCKED;
+		}
 
-		try_to_unmap(hpage,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
-			TTU_RMAP_LOCKED);
+		try_to_unmap(hpage, ttu);
 		page_was_mapped = 1;
-		/*
-		 * Leave mapping locked until after subsequent call to
-		 * remove_migration_ptes()
-		 */
+
+		if (mapping_locked)
+			i_mmap_unlock_write(mapping);
 	}
 
 	if (!page_mapped(hpage))
 		rc = move_to_new_page(new_hpage, hpage, mode);
 
-	if (page_was_mapped) {
+	if (page_was_mapped)
 		remove_migration_ptes(hpage,
-			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, true);
-		i_mmap_unlock_write(mapping);
-	}
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, false);
 
 unlock_put_anon:
 	unlock_page(new_hpage);
diff --git a/mm/rmap.c b/mm/rmap.c
index 1b84945d655c..31b29321adfe 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1413,9 +1413,6 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		/*
 		 * If sharing is possible, start and end will be adjusted
 		 * accordingly.
-		 *
-		 * If called for a huge page, caller must hold i_mmap_rwsem
-		 * in write mode as it is possible to call huge_pmd_unshare.
 		 */
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
 						     &range.end);
@@ -1462,7 +1459,7 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
 		address = pvmw.address;
 
-		if (PageHuge(page)) {
+		if (PageHuge(page) && !PageAnon(page)) {
 			/*
 			 * To call huge_pmd_unshare, i_mmap_rwsem must be
 			 * held in write mode.  Caller needs to explicitly
-- 
2.28.0

