Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B8E24BAF8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgHTMVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbgHTJze (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E4CF2075E;
        Thu, 20 Aug 2020 09:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917334;
        bh=BgYMqh4IaKyxG4rv11OsrO6fE16rHAdjPsNRZHHgS6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKox3DaReFnTFsDaZd0UEqjVy2kscg+mJq+nxxL2bpVPfitXgn5KFgUGQVFvsJucP
         1Z2acUiZyerLo7qQGFsRPw50E2efTZEqvf6ZCgHz46pXv4bthSUCRxtMY7k8hW/NaA
         ipinSCsHxBPhGNAsVwPgyjbMXU1guDNnxvCWXRWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 88/92] khugepaged: retract_page_tables() remember to test exit
Date:   Thu, 20 Aug 2020 11:22:13 +0200
Message-Id: <20200820091542.214329888@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 18e77600f7a1ed69f8ce46c9e11cad0985712dfa upstream.

Only once have I seen this scenario (and forgot even to notice what forced
the eventual crash): a sequence of "BUG: Bad page map" alerts from
vm_normal_page(), from zap_pte_range() servicing exit_mmap();
pmd:00000000, pte values corresponding to data in physical page 0.

The pte mappings being zapped in this case were supposed to be from a huge
page of ext4 text (but could as well have been shmem): my belief is that
it was racing with collapse_file()'s retract_page_tables(), found *pmd
pointing to a page table, locked it, but *pmd had become 0 by the time
start_pte was decided.

In most cases, that possibility is excluded by holding mmap lock; but
exit_mmap() proceeds without mmap lock.  Most of what's run by khugepaged
checks khugepaged_test_exit() after acquiring mmap lock:
khugepaged_collapse_pte_mapped_thps() and hugepage_vma_revalidate() do so,
for example.  But retract_page_tables() did not: fix that.

The fix is for retract_page_tables() to check khugepaged_test_exit(),
after acquiring mmap lock, before doing anything to the page table.
Getting the mmap lock serializes with __mmput(), which briefly takes and
drops it in __khugepaged_exit(); then the khugepaged_test_exit() check on
mm_users makes sure we don't touch the page table once exit_mmap() might
reach it, since exit_mmap() will be proceeding without mmap lock, not
expecting anyone to be racing with it.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021215400.27773@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1251,6 +1251,7 @@ static void collect_mm_slot(struct mm_sl
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
+	struct mm_struct *mm;
 	unsigned long addr;
 	pmd_t *pmd, _pmd;
 
@@ -1264,7 +1265,8 @@ static void retract_page_tables(struct a
 			continue;
 		if (vma->vm_end < addr + HPAGE_PMD_SIZE)
 			continue;
-		pmd = mm_find_pmd(vma->vm_mm, addr);
+		mm = vma->vm_mm;
+		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
 			continue;
 		/*
@@ -1273,14 +1275,16 @@ static void retract_page_tables(struct a
 		 * re-fault. Not ideal, but it's more important to not disturb
 		 * the system too much.
 		 */
-		if (down_write_trylock(&vma->vm_mm->mmap_sem)) {
-			spinlock_t *ptl = pmd_lock(vma->vm_mm, pmd);
-			/* assume page table is clear */
-			_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			spin_unlock(ptl);
-			up_write(&vma->vm_mm->mmap_sem);
-			mm_dec_nr_ptes(vma->vm_mm);
-			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
+		if (down_write_trylock(&mm->mmap_sem)) {
+			if (!khugepaged_test_exit(mm)) {
+				spinlock_t *ptl = pmd_lock(mm, pmd);
+				/* assume page table is clear */
+				_pmd = pmdp_collapse_flush(vma, addr, pmd);
+				spin_unlock(ptl);
+				mm_dec_nr_ptes(mm);
+				pte_free(mm, pmd_pgtable(_pmd));
+			}
+			up_write(&mm->mmap_sem);
 		}
 	}
 	i_mmap_unlock_write(mapping);


