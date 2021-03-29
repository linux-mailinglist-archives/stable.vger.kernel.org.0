Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4242E34C6FF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhC2ILf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhC2IKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B40B61601;
        Mon, 29 Mar 2021 08:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005449;
        bh=IX9H4AcplSR0EDkMc7aZlgW094f7+ZIwMWvyuTjNvRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voIu/+fAKFgtDINI5RYN4vHMVnHmOM0YBUTWIlnSAV6p9kpK5EF5iHunD7XKx9+ZW
         ZvqTk0qSRmol6g3lLRgQfQwKj8XMRc7m2k4u50PIwY1cs0yXc+belecwHu2EKPDmS1
         c8opYoj1V+xFR1MaaMXbzRI2H4Nf4pdrv/3bUpyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 001/111] hugetlbfs: hugetlb_fault_mutex_hash() cleanup
Date:   Mon, 29 Mar 2021 09:57:09 +0200
Message-Id: <20210329075615.235292111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 552546366a30d88bd1d6f5efe848b2ab50fd57e5 upstream.

A new clang diagnostic (-Wsizeof-array-div) warns about the calculation
to determine the number of u32's in an array of unsigned longs.
Suppress warning by adding parentheses.

While looking at the above issue, noticed that the 'address' parameter
to hugetlb_fault_mutex_hash is no longer used.  So, remove it from the
definition and all callers.

No functional change.

Link: http://lkml.kernel.org/r/20190919011847.18400-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Ilie Halip <ilie.halip@gmail.com>
Cc: David Bolvansky <david.bolvansky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c    |    4 ++--
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |   10 +++++-----
 mm/userfaultfd.c        |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -440,7 +440,7 @@ static void remove_inode_hugepages(struc
 			u32 hash;
 
 			index = page->index;
-			hash = hugetlb_fault_mutex_hash(h, mapping, index, 0);
+			hash = hugetlb_fault_mutex_hash(h, mapping, index);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
@@ -644,7 +644,7 @@ static long hugetlbfs_fallocate(struct f
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -106,7 +106,7 @@ void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
-				pgoff_t idx, unsigned long address);
+				pgoff_t idx);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4020,7 +4020,7 @@ retry:
 			 * handling userfault.  Reacquire after handling
 			 * fault to make calling code simpler.
 			 */
-			hash = hugetlb_fault_mutex_hash(h, mapping, idx, haddr);
+			hash = hugetlb_fault_mutex_hash(h, mapping, idx);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
@@ -4148,7 +4148,7 @@ backout_unlocked:
 
 #ifdef CONFIG_SMP
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
-			    pgoff_t idx, unsigned long address)
+			    pgoff_t idx)
 {
 	unsigned long key[2];
 	u32 hash;
@@ -4156,7 +4156,7 @@ u32 hugetlb_fault_mutex_hash(struct hsta
 	key[0] = (unsigned long) mapping;
 	key[1] = idx;
 
-	hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
+	hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);
 
 	return hash & (num_fault_mutexes - 1);
 }
@@ -4166,7 +4166,7 @@ u32 hugetlb_fault_mutex_hash(struct hsta
  * return 0 and avoid the hashing overhead.
  */
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
-			    pgoff_t idx, unsigned long address)
+			    pgoff_t idx)
 {
 	return 0;
 }
@@ -4210,7 +4210,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = hugetlb_fault_mutex_hash(h, mapping, idx, haddr);
+	hash = hugetlb_fault_mutex_hash(h, mapping, idx);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -269,7 +269,7 @@ retry:
 		 */
 		idx = linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
-		hash = hugetlb_fault_mutex_hash(h, mapping, idx, dst_addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		err = -ENOMEM;


