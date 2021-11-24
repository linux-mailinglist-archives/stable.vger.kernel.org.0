Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B263B45BABB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243365AbhKXMOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242902AbhKXMNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:13:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE3561107;
        Wed, 24 Nov 2021 12:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755644;
        bh=wLir8ilpmVMiKeD4WBoYyuXsdFAUGAWLWeq7+tYRG8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXyWQOURZNxX+8/SXoOT2rMPNeGGPRmgr+Mb7I8YyrgDwDk19FhOdeKckT1XEJFKX
         rpffGRNs2nDidL41UF8aptyidSmQfEAtQogcmRqWeXc1V7k4SQ5HN9KV7k4nhHBWBM
         W4GeZjwFHwL+YjqMGli22oi7BGBBsvPx813tT86U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 162/162] hugetlbfs: flush TLBs correctly after huge_pmd_unshare
Date:   Wed, 24 Nov 2021 12:57:45 +0100
Message-Id: <20211124115703.516847842@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
 include/asm-generic/tlb.h |    7 +++++++
 mm/hugetlb.c              |    5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

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


