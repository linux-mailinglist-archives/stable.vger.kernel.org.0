Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A0942DC28
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhJNO5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhJNO5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 661B361167;
        Thu, 14 Oct 2021 14:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223298;
        bh=FzleLb60opWfS4vshlpQvL1BuwwN21j2FAHZqTK+D8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mx4FNhd5pU3tWSfRdL2/u6U1kBcZvmEp8jRvheRvOVhy1j5bjxFBTOKLXuCKFJ0sp
         HHMJ7q/Wt3aZIcN3AV0L1u75f2pxM0et8xsigAv3ylqEGzVfY3+aDt4GeZtlNmNPUs
         Lu2LvGBXcdvYu6n9lDGZ1M95rKsTGVT/bpytp+o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Saunders <tbsaunde@tbsaunde.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.4 12/18] mm: check VMA flags to avoid invalid PROT_NONE NUMA balancing
Date:   Thu, 14 Oct 2021 16:53:44 +0200
Message-Id: <20211014145206.721654546@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
References: <20211014145206.330102860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Stoakes <lstoakes@gmail.com>

commit 38e088546522e1e86d2b8f401a1354ad3a9b3303 upstream.

The NUMA balancing logic uses an arch-specific PROT_NONE page table flag
defined by pte_protnone() or pmd_protnone() to mark PTEs or huge page
PMDs respectively as requiring balancing upon a subsequent page fault.
User-defined PROT_NONE memory regions which also have this flag set will
not normally invoke the NUMA balancing code as do_page_fault() will send
a segfault to the process before handle_mm_fault() is even called.

However if access_remote_vm() is invoked to access a PROT_NONE region of
memory, handle_mm_fault() is called via faultin_page() and
__get_user_pages() without any access checks being performed, meaning
the NUMA balancing logic is incorrectly invoked on a non-NUMA memory
region.

A simple means of triggering this problem is to access PROT_NONE mmap'd
memory using /proc/self/mem which reliably results in the NUMA handling
functions being invoked when CONFIG_NUMA_BALANCING is set.

This issue was reported in bugzilla (issue 99101) which includes some
simple repro code.

There are BUG_ON() checks in do_numa_page() and do_huge_pmd_numa_page()
added at commit c0e7cad to avoid accidentally provoking strange
behaviour by attempting to apply NUMA balancing to pages that are in
fact PROT_NONE.  The BUG_ON()'s are consistently triggered by the repro.

This patch moves the PROT_NONE check into mm/memory.c rather than
invoking BUG_ON() as faulting in these pages via faultin_page() is a
valid reason for reaching the NUMA check with the PROT_NONE page table
flag set and is therefore not always a bug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=99101
Reported-by: Trevor Saunders <tbsaunde@tbsaunde.org>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
[cascardo: context adjustments were necessary]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    3 ---
 mm/memory.c      |   12 +++++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1340,9 +1340,6 @@ int do_huge_pmd_numa_page(struct mm_stru
 	bool was_writable;
 	int flags = 0;
 
-	/* A PROT_NONE fault should not end up here */
-	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
-
 	ptl = pmd_lock(mm, pmdp);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3209,9 +3209,6 @@ static int do_numa_page(struct mm_struct
 	bool was_writable = pte_write(pte);
 	int flags = 0;
 
-	/* A PROT_NONE fault should not end up here */
-	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
-
 	/*
 	* The "pte" at this point cannot be used safely without
 	* validation through pte_unmap_same(). It's of NUMA type but
@@ -3304,6 +3301,11 @@ static int wp_huge_pmd(struct mm_struct
 	return VM_FAULT_FALLBACK;
 }
 
+static inline bool vma_is_accessible(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE);
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3350,7 +3352,7 @@ static int handle_pte_fault(struct mm_st
 					pte, pmd, flags, entry);
 	}
 
-	if (pte_protnone(entry))
+	if (pte_protnone(entry) && vma_is_accessible(vma))
 		return do_numa_page(mm, vma, address, entry, pte, pmd);
 
 	ptl = pte_lockptr(mm, pmd);
@@ -3425,7 +3427,7 @@ static int __handle_mm_fault(struct mm_s
 			if (pmd_trans_splitting(orig_pmd))
 				return 0;
 
-			if (pmd_protnone(orig_pmd))
+			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(mm, vma, address,
 							     orig_pmd, pmd);
 


