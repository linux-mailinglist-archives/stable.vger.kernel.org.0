Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CF2A37BF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgKCAaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 19:30:16 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47148 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgKCAaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 19:30:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30Susv088111;
        Tue, 3 Nov 2020 00:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=h5+Lu0QflE5OZ+B9UFFP0ald5p6gRIVbsKDocV9JCg0=;
 b=NIi8uErSycKbmI66pWcHyz/fFTsk8wS3L5KQyx8c5yg++sknwOrbh6JtvOKBzNnpICvP
 xPn1oY7nw5jQOQXXrAVKGURg1WhR05YdcdFI6xH23zFtj0US43zlV+/z/f2gIfJHmbBY
 //ulyFsYNXRRzqWTKp8PMKsQWjTNuOVwLgqsEKwzNTRgs+Ui7Qny3uckxriFs/MsNwQO
 5OrEhtgMqxgPKyAG1DAA0/+uZyF9sWnIOEGgRJLLDhMUuqtzKjDtz3+b9M5QBJrwByV3
 YVOpjqr/2nNeInA3rQsAF4PucN0rX/pSlVjfnA9jBMqYtf2uwgzlWHUhn+kiuiOTqpdf Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34hhb1xt6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 00:28:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30AQwE076604;
        Tue, 3 Nov 2020 00:28:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34hw0g068p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 00:28:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A30Sppu000627;
        Tue, 3 Nov 2020 00:28:51 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 16:28:51 -0800
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
Subject: [PATCH 2/4] hugetlbfs: add hinode_rwsem to hugetlb specific inode
Date:   Mon,  2 Nov 2020 16:28:39 -0800
Message-Id: <20201103002841.273161-3-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103002841.273161-1-mike.kravetz@oracle.com>
References: <20201026233150.371577-1-mike.kravetz@oracle.com>
 <20201103002841.273161-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
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

The hugetlb pmd sharing code needs additional synchronization.  This is
because sharing established via a call huge_pte_alloc, could be undone
before control is returned to the caller.  As a result, the returned
value may be invalid.  Ideally, i_mmap_rwsem would be used for this type
of synchronization.  However, previous attempts at using i_mmap_rwsem
have failed.  This is partly due to conflicts with the existing uses
of i_mmap_rwsem that force a locking order not compatible with it's use
for pmd sharing.

Introduce a rwsem (hinode_rwsem) that resides in the hugetlb specific inode
for the purpose of pmd sharing synchronization.  This patch adds the
semaphore to the inode and also provides routines for using the semaphore.
To minimize performance impacts, the routines only acquire the semaphore
if pmd sharing is possible.  In addition, routines which can be used with
lockdep to help ensure proper locking are also added.

Use of the new semaphore and supporting routines will be provided in a
later patch.

Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c    |  12 ++++
 include/linux/hugetlb.h | 121 ++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c            |  13 -----
 3 files changed, 133 insertions(+), 13 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c1057378dbf4..4f1404b9f354 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -85,6 +85,17 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 	{}
 };
 
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline void init_hinode_rwsem(struct hugetlbfs_inode_info *info)
+{
+	init_rwsem(&info->hinode_rwsem);
+}
+#else
+static inline void init_hinode_rwsem(struct hugetlbfs_inode_info *info)
+{
+}
+#endif
+
 #ifdef CONFIG_NUMA
 static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
 					struct inode *inode, pgoff_t index)
@@ -831,6 +842,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
 		inode->i_mapping->private_data = resv_map;
 		info->seals = F_SEAL_SEAL;
+		init_hinode_rwsem(info);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ebca2ef02212..c6a59c2dbc30 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -424,6 +424,9 @@ struct hugetlbfs_inode_info {
 	struct shared_policy policy;
 	struct inode vfs_inode;
 	unsigned int seals;
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+	struct rw_semaphore hinode_rwsem;
+#endif
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -449,6 +452,101 @@ static inline struct hstate *hstate_inode(struct inode *i)
 {
 	return HUGETLBFS_SB(i->i_sb)->hstate;
 }
+
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
+{
+	unsigned long base = addr & PUD_MASK;
+	unsigned long end = base + PUD_SIZE;
+
+	/* check on proper vm_flags and page table alignment */
+	if (vma->vm_flags & VM_MAYSHARE && range_in_vma(vma, base, end))
+		return true;
+	return false;
+}
+
+/*
+ * hugetlb specific hinode_rwsem is used for pmd sharing synchronization.
+ * This routine will take the semaphore in read mode if necessary.  If vma
+ * and addr are NULL, the routine will always acquire the semaphore. If
+ * values are supplied for vma and addr, they are used to determine if pmd
+ * sharing is actually possible, and only acquire the semaphore if possible.
+ * Returns true if lock was acquired, otherwise false.
+ */
+static inline bool hinode_lock_read(struct inode *inode,
+					struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	if (vma && !addr)
+		addr = round_up(vma->vm_start, PUD_SIZE);
+	if (vma && !vma_shareable(vma, addr))
+		return false;
+
+	down_read(&HUGETLBFS_I(inode)->hinode_rwsem);
+	return true;
+}
+
+static inline void hinode_unlock_read(struct inode *inode)
+{
+	up_read(&HUGETLBFS_I(inode)->hinode_rwsem);
+}
+
+/*
+ * Take hinode_rwsem semaphore in write mode if necessary.  See,
+ * hinode_lock_read for details.
+ * Returns true is lock was acquired, otherwise false.
+ */
+static inline bool hinode_lock_write(struct inode *inode,
+					struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	if (vma && !addr)
+		addr = round_up(vma->vm_start, PUD_SIZE);
+	if (vma && !vma_shareable(vma, addr))
+		return false;
+
+	down_write(&HUGETLBFS_I(inode)->hinode_rwsem);
+	return true;
+}
+
+static inline void hinode_unlock_write(struct inode *inode)
+{
+	up_write(&HUGETLBFS_I(inode)->hinode_rwsem);
+}
+
+static inline void hinode_assert_locked(struct address_space *mapping)
+{
+	lockdep_assert_held(&HUGETLBFS_I(mapping->host)->hinode_rwsem);
+}
+
+static inline void hinode_assert_write_locked(struct address_space *mapping)
+{
+	lockdep_assert_held_write(&HUGETLBFS_I(mapping->host)->hinode_rwsem);
+}
+#else
+static inline bool hinode_lock_read(struct inode *inode,
+					struct vm_area_struct *vma,
+					unsigned long addr)
+{
+		return false;
+}
+
+static inline void hinode_unlock_read(struct inode *inode)
+{
+}
+
+static inline bool hinode_lock_write(struct inode *inode,
+					struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	return false;
+}
+
+static inline void hinode_unlock_write(struct inode *inode)
+{
+}
+#endif
+
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			false
@@ -923,6 +1021,29 @@ static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr
 					pte_t *ptep, pte_t pte, unsigned long sz)
 {
 }
+
+static inline bool hinode_lock_read(struct inode *inode,
+					struct vm_area_struct *vma,
+					unsigned long addr)
+{
+		return false;
+}
+
+static inline void hinode_unlock_read(struct inode *inode)
+{
+}
+
+static inline bool hinode_lock_write(struct inode *inode,
+					struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	return false;
+}
+
+static inline void hinode_unlock_write(struct inode *inode)
+{
+}
+
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8a82b90ca3ee..da57018926e4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5296,19 +5296,6 @@ static unsigned long page_table_shareable(struct vm_area_struct *svma,
 	return saddr;
 }
 
-static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
-{
-	unsigned long base = addr & PUD_MASK;
-	unsigned long end = base + PUD_SIZE;
-
-	/*
-	 * check on proper vm_flags and page table alignment
-	 */
-	if (vma->vm_flags & VM_MAYSHARE && range_in_vma(vma, base, end))
-		return true;
-	return false;
-}
-
 /*
  * Determine if start,end range within vma could be mapped by shared pmd.
  * If yes, adjust start and end to cover range associated with possible
-- 
2.28.0

