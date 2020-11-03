Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A822A37BB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 01:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgKCAaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 19:30:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47138 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgKCAaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 19:30:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30Suko088119;
        Tue, 3 Nov 2020 00:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=NmQ2PFivlGfrOZg00Ymm2k7iW7oVbhi3wCqoQABAwwQ=;
 b=dtKkjXWVML9UztitT+4RqPWJ2EXAlFbdCsZH6D9v0Wzit5qVEYx8akpEr0s416yB1jOo
 DhG6BzVkashN9SxtMnkqeAWF3mVw/bcI3LESx420vPVkfuzS30zMuS02d/MbUD7WIVG3
 dAxKAxGAkySTQRiIigUqXQIPPJdRwppqS1lyfH2DxzuqEB9YRWLM8J2l4ntnSOD8C/UI
 r2l+PcX0LzGgcf36SnkamRph8FrI6NB1uQY64LhwphHQj2JrJOzEiXnQ45uA0JybB5fy
 Be3+d7ioFoSOK5N1YLjSS4dezVoTCzaLHmVcGl2t/Ax77ivIh69kYoQqmyzQYXtoc1yx 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34hhb1xt6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 00:28:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30AkE3045781;
        Tue, 3 Nov 2020 00:28:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf47f62a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 00:28:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A30SmUS028857;
        Tue, 3 Nov 2020 00:28:48 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 16:28:48 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] Revert hugetlbfs: Use i_mmap_rwsem to address page fault/truncate race
Date:   Mon,  2 Nov 2020 16:28:38 -0800
Message-Id: <20201103002841.273161-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103002841.273161-1-mike.kravetz@oracle.com>
References: <20201026233150.371577-1-mike.kravetz@oracle.com>
 <20201103002841.273161-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 87bf91d39bb5 ("hugetlbfs: Use i_mmap_rwsem to address page
fault/truncate race") was made possible because a prior
commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") took i_mmap_rwsem in read mode during huge page
faults.  Using i_mmap_rwsem for pmd sharing synchronization has proven
problematic and will be removed in later patches.  As a result, the
assumptions upon which this patch was based will no longer be true.

This reverts commit 87bf91d39bb52b688fb411d668fbe7df278b29ae

Fixes 7bf91d39bb5 ("hugetlbfs: Use i_mmap_rwsem to address page
fault/truncate race")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c | 28 ++++++++--------------------
 mm/hugetlb.c         | 23 ++++++++++++-----------
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b5c109703daa..c1057378dbf4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -444,9 +444,10 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end)
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
  *	maps and global counts.  Page faults can not race with truncation
- *	in this routine.  hugetlb_no_page() holds i_mmap_rwsem and prevents
- *	page faults in the truncated range by checking i_size.  i_size is
- *	modified while holding i_mmap_rwsem.
+ *	in this routine.  hugetlb_no_page() prevents page faults in the
+ *	truncated range.  It checks i_size before allocation, and again after
+ *	with the page table lock for the page held.  The same lock must be
+ *	acquired to unmap a page.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserv map
@@ -486,15 +487,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 
 			index = page->index;
 			hash = hugetlb_fault_mutex_hash(mapping, index);
-			if (!truncate_op) {
-				/*
-				 * Only need to hold the fault mutex in the
-				 * hole punch case.  This prevents races with
-				 * page faults.  Races are not possible in the
-				 * case of truncation.
-				 */
-				mutex_lock(&hugetlb_fault_mutex_table[hash]);
-			}
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
 			 * If page is mapped, it was faulted in after being
@@ -537,8 +530,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			}
 
 			unlock_page(page);
-			if (!truncate_op)
-				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		huge_pagevec_release(&pvec);
 		cond_resched();
@@ -576,8 +568,8 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
-	i_mmap_lock_write(mapping);
 	i_size_write(inode, offset);
+	i_mmap_lock_write(mapping);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
@@ -699,11 +691,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		/* addr is the offset within the file (zero based) */
 		addr = index * hpage_size;
 
-		/*
-		 * fault mutex taken here, protects against fault path
-		 * and hole punch.  inode_lock previously taken protects
-		 * against truncation.
-		 */
+		/* mutex taken here, fault path and hole punch */
 		hash = hugetlb_fault_mutex_hash(mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fe76f8fd5a73..8a82b90ca3ee 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4335,17 +4335,16 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	}
 
 	/*
-	 * We can not race with truncation due to holding i_mmap_rwsem.
-	 * i_size is modified when holding i_mmap_rwsem, so check here
-	 * once for faults beyond end of file.
+	 * Use page lock to guard against racing truncation
+	 * before we get page_table_lock.
 	 */
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
-		goto out;
-
 retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
+		size = i_size_read(mapping->host) >> huge_page_shift(h);
+		if (idx >= size)
+			goto out;
+
 		/*
 		 * Check for page in userfault range
 		 */
@@ -4451,6 +4450,10 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
+	size = i_size_read(mapping->host) >> huge_page_shift(h);
+	if (idx >= size)
+		goto backout;
+
 	ret = 0;
 	if (!huge_pte_none(huge_ptep_get(ptep)))
 		goto backout;
@@ -4550,10 +4553,8 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	/*
 	 * Acquire i_mmap_rwsem before calling huge_pte_alloc and hold
-	 * until finished with ptep.  This serves two purposes:
-	 * 1) It prevents huge_pmd_unshare from being called elsewhere
-	 *    and making the ptep no longer valid.
-	 * 2) It synchronizes us with i_size modifications during truncation.
+	 * until finished with ptep.  This prevents huge_pmd_unshare from
+	 * being called elsewhere and making the ptep no longer valid.
 	 *
 	 * ptep could have already be assigned via huge_pte_offset.  That
 	 * is OK, as huge_pte_alloc will return the same value unless
-- 
2.28.0

