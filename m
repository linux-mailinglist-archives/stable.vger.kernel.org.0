Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B544D2EFC4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbfE3DSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbfE3DSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C8A24779;
        Thu, 30 May 2019 03:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186320;
        bh=8V/djj7n2UwkZEhgqEcVbopB5yeGDmz/7VoaNTY769M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYZlx6Brz/XmyWoDO+S93tRNZ7hFoggIibYafRON77UzGeR9mycrVWyp9TRx+izj9
         xiGP7GGX8ymAGXmw739+68rrMYK1d7y150jxY0OyYpI4oB92bZ4KDnFVTG/07BSnvb
         mrQtgXGVJ1WLb8DbudilisDsUVIEleF0GBOvlPMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 022/193] hugetlb: use same fault hash key for shared and private mappings
Date:   Wed, 29 May 2019 20:04:36 -0700
Message-Id: <20190530030451.882753502@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 1b426bac66e6cc83c9f2d92b96e4e72acf43419a upstream.

hugetlb uses a fault mutex hash table to prevent page faults of the
same pages concurrently.  The key for shared and private mappings is
different.  Shared keys off address_space and file index.  Private keys
off mm and virtual address.  Consider a private mappings of a populated
hugetlbfs file.  A fault will map the page from the file and if needed
do a COW to map a writable page.

Hugetlbfs hole punch uses the fault mutex to prevent mappings of file
pages.  It uses the address_space file index key.  However, private
mappings will use a different key and could race with this code to map
the file page.  This causes problems (BUG) for the page cache remove
code as it expects the page to be unmapped.  A sample stack is:

page dumped because: VM_BUG_ON_PAGE(page_mapped(page))
kernel BUG at mm/filemap.c:169!
...
RIP: 0010:unaccount_page_cache_page+0x1b8/0x200
...
Call Trace:
__delete_from_page_cache+0x39/0x220
delete_from_page_cache+0x45/0x70
remove_inode_hugepages+0x13c/0x380
? __add_to_page_cache_locked+0x162/0x380
hugetlbfs_fallocate+0x403/0x540
? _cond_resched+0x15/0x30
? __inode_security_revalidate+0x5d/0x70
? selinux_file_permission+0x100/0x130
vfs_fallocate+0x13f/0x270
ksys_fallocate+0x3c/0x80
__x64_sys_fallocate+0x1a/0x20
do_syscall_64+0x5b/0x180
entry_SYSCALL_64_after_hwframe+0x44/0xa9

There seems to be another potential COW issue/race with this approach
of different private and shared keys as noted in commit 8382d914ebf7
("mm, hugetlb: improve page-fault scalability").

Since every hugetlb mapping (even anon and private) is actually a file
mapping, just use the address_space index key for all mappings.  This
results in potentially more hash collisions.  However, this should not
be the common case.

Link: http://lkml.kernel.org/r/20190328234704.27083-3-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20190412165235.t4sscoujczfhuiyt@linux-r8p5
Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hugetlbfs/inode.c    |    8 ++------
 include/linux/hugetlb.h |    4 +---
 mm/hugetlb.c            |   23 +++++++----------------
 mm/userfaultfd.c        |    3 +--
 4 files changed, 11 insertions(+), 27 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -436,9 +436,7 @@ static void remove_inode_hugepages(struc
 			u32 hash;
 
 			index = page->index;
-			hash = hugetlb_fault_mutex_hash(h, current->mm,
-							&pseudo_vma,
-							mapping, index, 0);
+			hash = hugetlb_fault_mutex_hash(h, mapping, index, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
@@ -557,7 +555,6 @@ static long hugetlbfs_fallocate(struct f
 	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
 	struct vm_area_struct pseudo_vma;
-	struct mm_struct *mm = current->mm;
 	loff_t hpage_size = huge_page_size(h);
 	unsigned long hpage_shift = huge_page_shift(h);
 	pgoff_t start, index, end;
@@ -621,8 +618,7 @@ static long hugetlbfs_fallocate(struct f
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
-						index, addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -122,9 +122,7 @@ void putback_active_hugepage(struct page
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-				struct vm_area_struct *vma,
-				struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 				pgoff_t idx, unsigned long address);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3729,8 +3729,8 @@ retry:
 			 * handling userfault.  Reacquire after handling
 			 * fault to make calling code simpler.
 			 */
-			hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping,
-							idx, address);
+			hash = hugetlb_fault_mutex_hash(h, mapping, idx,
+							address);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
@@ -3842,21 +3842,14 @@ backout_unlocked:
 }
 
 #ifdef CONFIG_SMP
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-			    struct vm_area_struct *vma,
-			    struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
 {
 	unsigned long key[2];
 	u32 hash;
 
-	if (vma->vm_flags & VM_SHARED) {
-		key[0] = (unsigned long) mapping;
-		key[1] = idx;
-	} else {
-		key[0] = (unsigned long) mm;
-		key[1] = address >> huge_page_shift(h);
-	}
+	key[0] = (unsigned long) mapping;
+	key[1] = idx;
 
 	hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
 
@@ -3867,9 +3860,7 @@ u32 hugetlb_fault_mutex_hash(struct hsta
  * For uniprocesor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-			    struct vm_area_struct *vma,
-			    struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
 {
 	return 0;
@@ -3915,7 +3906,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping, idx, address);
+	hash = hugetlb_fault_mutex_hash(h, mapping, idx, address);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -272,8 +272,7 @@ retry:
 		 */
 		idx = linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
-		hash = hugetlb_fault_mutex_hash(h, dst_mm, dst_vma, mapping,
-								idx, dst_addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, idx, dst_addr);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		err = -ENOMEM;


