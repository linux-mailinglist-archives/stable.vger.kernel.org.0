Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B211469A06
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345424AbhLFPFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345303AbhLFPEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E975C07E5C5;
        Mon,  6 Dec 2021 07:00:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C223F612A5;
        Mon,  6 Dec 2021 15:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F5FC341C5;
        Mon,  6 Dec 2021 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802836;
        bh=dV5YfUIrpF97d1WxsmcU/9RanFNhNw3i4waL1u+RIcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKbjHsrVJotMjAnhg2mkLUzxcmhjzz1R0BnQZOSlTdm4B6dAYQE0oSInSkMfRjGZD
         38eDcgNjXuqTMeUi5FcmfjFweupx0ehedMhIRoVVc2zFhZ5AZEGKM1TKu/hczmcie0
         UcGlScuarbeyhdQnQHAILt1rNqKOJbs41cN9tbzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 19/52] hugetlbfs: flush TLBs correctly after huge_pmd_unshare
Date:   Mon,  6 Dec 2021 15:56:03 +0100
Message-Id: <20211206145548.546472716@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit a4a118f2eead1d6c49e00765de89878288d4b890 upstream.

When __unmap_hugepage_range() calls to huge_pmd_unshare() succeed, a TLB
flush is missing.  This TLB flush must be performed before releasing the
i_mmap_rwsem, in order to prevent an unshared PMDs page from being
released and reused before the TLB flush took place.

Arguably, a comprehensive solution would use mmu_gather interface to
batch the TLB flushes and the PMDs page release, however it is not an
easy solution: (1) try_to_unmap_one() and try_to_migrate_one() also call
huge_pmd_unshare() and they cannot use the mmu_gather interface; and (2)
deferring the release of the page reference for the PMDs page until
after i_mmap_rwsem is dropeed can confuse huge_pmd_unshare() into
thinking PMDs are shared when they are not.

Fix __unmap_hugepage_range() by adding the missing TLB flush, and
forcing a flush when unshare is successful.

Fixes: 24669e58477e ("hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages)" # 3.6
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/tlb.h  |    8 ++++++++
 arch/ia64/include/asm/tlb.h |   10 ++++++++++
 arch/s390/include/asm/tlb.h |   13 +++++++++++++
 arch/sh/include/asm/tlb.h   |   10 ++++++++++
 arch/um/include/asm/tlb.h   |   12 ++++++++++++
 include/asm-generic/tlb.h   |    7 +++++++
 mm/hugetlb.c                |    5 ++++-
 7 files changed, 64 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -257,6 +257,14 @@ tlb_remove_pmd_tlb_entry(struct mmu_gath
 	tlb_add_flush(tlb, addr);
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	tlb_add_flush(tlb, address);
+	tlb_add_flush(tlb, address + size - PMD_SIZE);
+}
+
 #define pte_free_tlb(tlb, ptep, addr)	__pte_free_tlb(tlb, ptep, addr)
 #define pmd_free_tlb(tlb, pmdp, addr)	__pmd_free_tlb(tlb, pmdp, addr)
 #define pud_free_tlb(tlb, pudp, addr)	pud_free((tlb)->mm, pudp)
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -251,6 +251,16 @@ __tlb_remove_tlb_entry (struct mmu_gathe
 	tlb->end_addr = address + PAGE_SIZE;
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	if (tlb->start_addr > address)
+		tlb->start_addr = address;
+	if (tlb->end_addr < address + size)
+		tlb->end_addr = address + size;
+}
+
 #define tlb_migrate_finish(mm)	platform_tlb_migrate_finish(mm)
 
 #define tlb_start_vma(tlb, vma)			do { } while (0)
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -97,6 +97,19 @@ static inline void tlb_remove_page(struc
 {
 	free_page_and_swap_cache(page);
 }
+static inline void tlb_flush_pmd_range(struct mmu_gather *tlb,
+				unsigned long address, unsigned long size)
+{
+	/*
+	 * the range might exceed the original range that was provided to
+	 * tlb_gather_mmu(), so we need to update it despite the fact it is
+	 * usually not updated.
+	 */
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + size)
+		tlb->end = address + size;
+}
 
 /*
  * pte_free_tlb frees a pte table and clears the CRSTE for the
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -65,6 +65,16 @@ tlb_remove_tlb_entry(struct mmu_gather *
 		tlb->end = address + PAGE_SIZE;
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + size)
+		tlb->end = address + size;
+}
+
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
--- a/arch/um/include/asm/tlb.h
+++ b/arch/um/include/asm/tlb.h
@@ -110,6 +110,18 @@ static inline void tlb_remove_page(struc
 	__tlb_remove_page(tlb, page);
 }
 
+static inline void
+tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
+		    unsigned long size)
+{
+	tlb->need_flush = 1;
+
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + size)
+		tlb->end = address + size;
+}
+
 /**
  * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
  *
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -165,6 +165,13 @@ static inline void __tlb_reset_range(str
 #define tlb_end_vma	__tlb_end_vma
 #endif
 
+static inline void tlb_flush_pmd_range(struct mmu_gather *tlb,
+				unsigned long address, unsigned long size)
+{
+	tlb->start = min(tlb->start, address);
+	tlb->end = max(tlb->end, address + size);
+}
+
 #ifndef __tlb_remove_tlb_entry
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
 #endif
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3290,8 +3290,11 @@ again:
 			continue;
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep))
+		if (huge_pmd_unshare(mm, &address, ptep)) {
+			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
+			force_flush = 1;
 			goto unlock;
+		}
 
 		pte = huge_ptep_get(ptep);
 		if (huge_pte_none(pte))


