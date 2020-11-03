Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED32A37B9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 01:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgKCAaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 19:30:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47136 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgKCAaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 19:30:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30SvUN088145;
        Tue, 3 Nov 2020 00:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=FKqQw36FTOdMVzkcUWz8onJ82dve1+T6c2U3WfZd7e8=;
 b=qcGdrIHL8YLuByFfODBHdI16MREm5sXx9Dg+SR5HmpjQbrzmW9UEsbrrb4z5o5M//1Lg
 jaeTwM76R3HnrOCt2I2/kAsgE8snUV04FHrS+Ll18x3V8aUvMyiYpgunUX+Pkp6HFfJG
 sr2+zAe229gVk3ojuGGNl4CtHGWPbmLulUAjIzUA0YrplE70NvQsPaYv0zD4Z0vitHvG
 dssIXinP+XLfk0j/Z6QdsS9CGM2pqKoPrjJUn/3wvqJxvvPXqggT3Q/IQUUdTAIE5Rdx
 WXq9J+rIlUqjYMPqoTzIEp9XVUF6TxHSiQgc48oxET5r4RrAl0FdPqR6BlWIi+VftBfl gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb1xt6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 00:28:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A309foH086478;
        Tue, 3 Nov 2020 00:28:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34hvrutq2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 00:28:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A30SsNn011245;
        Tue, 3 Nov 2020 00:28:55 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 16:28:54 -0800
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
Subject: [PATCH 4/4] huegtlbfs: handle page fault/truncate races
Date:   Mon,  2 Nov 2020 16:28:41 -0800
Message-Id: <20201103002841.273161-5-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103002841.273161-1-mike.kravetz@oracle.com>
References: <20201026233150.371577-1-mike.kravetz@oracle.com>
 <20201103002841.273161-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=2 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A huegtlb page fault can race with page truncation.  Make the code
identifying and handling these races more robust.

Page fault handling needs to back out pages added to page cache beyond
file size (i_size).  When backing out the page, take care to restore
reserve map entries and counts as necessary.

File truncation (remove_inode_hugepages) needs to handle page mapping
changes before locking the page.  This could happen if page was added
to page cache and later backed out in fault processing.

Fixes 7bf91d39bb5 ("hugetlbfs: Use i_mmap_rwsem to address page
fault/truncate race")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c | 34 ++++++++++++++++++++--------------
 mm/hugetlb.c         | 40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index bc9979382a1e..6b975377558e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -534,23 +534,29 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 
 			lock_page(page);
 			/*
-			 * We must free the huge page and remove from page
-			 * cache (remove_huge_page) BEFORE removing the
-			 * region/reserve map (hugetlb_unreserve_pages).  In
-			 * rare out of memory conditions, removal of the
-			 * region/reserve map could fail. Correspondingly,
-			 * the subpool and global reserve usage count can need
-			 * to be adjusted.
+			 * After locking page, make sure mapping is the same.
+			 * We could have raced with page fault populate and
+			 * backout code.
 			 */
-			VM_BUG_ON(PagePrivate(page));
-			remove_huge_page(page);
-			freed++;
-			if (!truncate_op) {
-				if (unlikely(hugetlb_unreserve_pages(inode,
+			if (page_mapping(page) == mapping) {
+				/*
+				 * We must free the huge page and remove from
+				 * page cache (remove_huge_page) BEFORE
+				 * removing the region/reserve map.  In rare
+				 * out of memory conditions, removal of the
+				 * region/reserve map could fail and the
+				 * subpool and global reserve usage count
+				 * will need to be adjusted.
+				 */
+				VM_BUG_ON(PagePrivate(page));
+				remove_huge_page(page);
+				freed++;
+				if (!truncate_op) {
+					if (unlikely(hugetlb_unreserve_pages(inode,
 							index, index + 1, 1)))
-					hugetlb_fix_reserve_counts(inode);
+						hugetlb_fix_reserve_counts(inode);
+				}
 			}
-
 			unlock_page(page);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 957abc2d02ff..6b348d344f23 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4224,6 +4224,9 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page = false;
+	bool page_cache = false;
+	bool reserve_alloc = false;
+	bool beyond_i_size = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4311,6 +4314,8 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
 		new_page = true;
+		if (PagePrivate(page))
+			reserve_alloc = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = huge_add_to_page_cache(page, mapping, idx);
@@ -4320,6 +4325,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 					goto retry;
 				goto out;
 			}
+			page_cache = true;
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
@@ -4358,8 +4364,10 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 
 	ptl = huge_pte_lock(h, mm, ptep);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
+	if (idx >= size) {
+		beyond_i_size = true;
 		goto backout;
+	}
 
 	ret = 0;
 	if (!huge_pte_none(huge_ptep_get(ptep)))
@@ -4397,8 +4405,36 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 backout:
 	spin_unlock(ptl);
 backout_unlocked:
+	if (new_page) {
+		if (page_cache && beyond_i_size) {
+			/*
+			 * Back out pages added to page cache beyond i_size.
+			 * Otherwise, they will 'sit' there until the file
+			 * is removed.
+			 */
+			ClearPageDirty(page);
+			ClearPageUptodate(page);
+			delete_from_page_cache(page);
+		}
+
+		if (reserve_alloc) {
+			/*
+			 * If reserve was consumed, set PagePrivate so that
+			 * it will be restored in free_huge_page().
+			 */
+			SetPagePrivate(page);
+		}
+
+		if (!beyond_i_size) {
+			/*
+			 * Do not restore reserve map entries beyond i_size.
+			 * there will be leaks when the file is removed.
+			 */
+			restore_reserve_on_error(h, vma, haddr, page);
+		}
+
+	}
 	unlock_page(page);
-	restore_reserve_on_error(h, vma, haddr, page);
 	put_page(page);
 	goto out;
 }
-- 
2.28.0

