Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435FF3A859
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbfFIQ7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbfFIQ73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72A01204EC;
        Sun,  9 Jun 2019 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099569;
        bh=uy1zZLB+AkKVM+qyopiBM8i0e074O0Uwc97z9JC1Mgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzO2E42yAKrvE59yPDSAEnWtRjvkGLg5TtlsbK6Frj/4uNblxIza1sZ2rNkduhJ8+
         S/TraGSZfKlZ4JxUZVPhqA/TK0sAA1DnWcDsxo1xe4SKXS8FXO6SA+9OuPnaU9Qtz/
         h3zaIhS2ebelXmxk+WirjjpXG7UxeLKEuLBuWrLo=
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
Subject: [PATCH 4.4 085/241] hugetlb: use same fault hash key for shared and private mappings
Date:   Sun,  9 Jun 2019 18:40:27 +0200
Message-Id: <20190609164150.229271039@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
 mm/hugetlb.c            |   19 +++++--------------
 3 files changed, 8 insertions(+), 23 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -414,9 +414,7 @@ static void remove_inode_hugepages(struc
 			if (next >= end)
 				break;
 
-			hash = hugetlb_fault_mutex_hash(h, current->mm,
-							&pseudo_vma,
-							mapping, next, 0);
+			hash = hugetlb_fault_mutex_hash(h, mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			lock_page(page);
@@ -569,7 +567,6 @@ static long hugetlbfs_fallocate(struct f
 	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
 	struct vm_area_struct pseudo_vma;
-	struct mm_struct *mm = current->mm;
 	loff_t hpage_size = huge_page_size(h);
 	unsigned long hpage_shift = huge_page_shift(h);
 	pgoff_t start, index, end;
@@ -633,8 +630,7 @@ static long hugetlbfs_fallocate(struct f
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
-						index, addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -91,9 +91,7 @@ void putback_active_hugepage(struct page
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode, bool restore_reserve);
 extern struct mutex *hugetlb_fault_mutex_table;
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-				struct vm_area_struct *vma,
-				struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 				pgoff_t idx, unsigned long address);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3703,21 +3703,14 @@ backout_unlocked:
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
 
@@ -3728,9 +3721,7 @@ u32 hugetlb_fault_mutex_hash(struct hsta
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
@@ -3776,7 +3767,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping, idx, address);
+	hash = hugetlb_fault_mutex_hash(h, mapping, idx, address);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);


