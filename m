Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268C7395C0F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhEaN1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232047AbhEaNZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:25:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997C06135C;
        Mon, 31 May 2021 13:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467260;
        bh=0ctFWL4093UdTLuZGJN21vegAHSAgkacxllsZn20GM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jl/OcM1sYvDHHYmJuBi+Keil+fk4kf83WADkFXkmICI25XsVO5NcHNrfjMMCQC/rH
         cGqxkXiDhCeG5STTouECCuO33KqeZESP1VnFNlNWp4usNaWN0l0dR/rhqzwY6VobOm
         70SntMkHTqCyFjPDDcK1WAYQ017nrUz0WXX29/X4=
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
Subject: [PATCH 4.9 65/66] hugetlbfs: hugetlb_fault_mutex_hash() cleanup
Date:   Mon, 31 May 2021 15:14:38 +0200
Message-Id: <20210531130638.307899456@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
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
 mm/hugetlb.c            |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -451,7 +451,7 @@ static void remove_inode_hugepages(struc
 			if (next >= end)
 				break;
 
-			hash = hugetlb_fault_mutex_hash(h, mapping, next, 0);
+			hash = hugetlb_fault_mutex_hash(h, mapping, next);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
@@ -634,7 +634,7 @@ static long hugetlbfs_fallocate(struct f
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, index);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -93,7 +93,7 @@ void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
-				pgoff_t idx, unsigned long address);
+				pgoff_t idx);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3887,7 +3887,7 @@ backout_unlocked:
 
 #ifdef CONFIG_SMP
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
-			    pgoff_t idx, unsigned long address)
+			    pgoff_t idx)
 {
 	unsigned long key[2];
 	u32 hash;
@@ -3895,7 +3895,7 @@ u32 hugetlb_fault_mutex_hash(struct hsta
 	key[0] = (unsigned long) mapping;
 	key[1] = idx;
 
-	hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
+	hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);
 
 	return hash & (num_fault_mutexes - 1);
 }
@@ -3905,7 +3905,7 @@ u32 hugetlb_fault_mutex_hash(struct hsta
  * return 0 and avoid the hashing overhead.
  */
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
-			    pgoff_t idx, unsigned long address)
+			    pgoff_t idx)
 {
 	return 0;
 }
@@ -3950,7 +3950,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = hugetlb_fault_mutex_hash(h, mapping, idx, address);
+	hash = hugetlb_fault_mutex_hash(h, mapping, idx);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);


