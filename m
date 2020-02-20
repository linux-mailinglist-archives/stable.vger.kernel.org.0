Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D81656FB
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgBTFfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:35:13 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34196 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:35:13 -0500
Received: by mail-pj1-f65.google.com with SMTP id f2so826685pjq.1
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 21:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uf/3nLWcXhbl/6GJxMwHl9q5mCS/THiKWZJhEc1olLc=;
        b=0lhG2GFYeKV570i50/67LM1vJjcfaNmOT9bUNhSNEgN9hwvww6QTPKjnFEyH/9cJ9p
         9v4FmhOVljz7K97aKfrpFwWzpzPtTdHFOfGIIdKV2afuxmBrtz+kQPcAEjyAqwvsMnIM
         bbghOF6K3rDqm7dkfkUTL5eRKDr6Gh9t0vzWBIJa4m4/2SkSBZ2EheCHPW4Tp/fp12sZ
         w7Y5Jzw1S8rQL1L9OKUxQqtJUq167DzTKR/93GTxYvNYOuYAbpHwtzsRtBp0lN2NJTIl
         EFKFSlqJMo9sc9H5nzGbPjprxCSBAyDrzrDTaUDR05mWFHBqZsz9URcq9qvo9i6VLsgk
         Yo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uf/3nLWcXhbl/6GJxMwHl9q5mCS/THiKWZJhEc1olLc=;
        b=qkNnPwON7c7vBONFQrCuIPo6sxo4vh9xS1IKYHSPapN9/zoJkPQsl/Mae4r/kyY6CL
         imMwfIx+sIk4Q1IC/lxJ/L5Ka33rxqob5XI+znn1b/WMvjvJkQysZFi3E65jAreC/cJZ
         KMpUaAbizh7ME01j5SPqe+r0uv7ay5g91QNyHr7HtbCVVglyYzvAA8ZtjNR5AJrNL7dU
         0+wp21e7zFpUs8FJDbT9NmRHTKH47xQsjHIZ+8AxtYAN7aH5ISSddHnMAfDmk5zwwvDk
         8TKUNvJv8o6miXw9KKxCq7SeQVRgX55um+wF3ZYmhMaGjSI9K3W+Nd0X9eXI/oqAyqaT
         vasA==
X-Gm-Message-State: APjAAAXddLF51tYwi6yp4XayCv6qBELGQiBUBQuY1+ozC6FkkbAstBPp
        TwEWCEGlQH+RqDflnpNabXf+IQ==
X-Google-Smtp-Source: APXvYqx5S81E7+9tro0CWQKy/yL8WIeqcw1yLD0OGzLeog+PG7t4YXVagmC8KvpDRv3j9CkkAF86Cg==
X-Received: by 2002:a17:90a:a617:: with SMTP id c23mr1654859pjq.32.1582176912790;
        Wed, 19 Feb 2020 21:35:12 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.71])
        by smtp.gmail.com with ESMTPSA id r11sm1664262pgi.9.2020.02.19.21.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 21:35:12 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 2/6] asm-generic/tlb: Track which levels of the page tables have been cleared
Date:   Thu, 20 Feb 2020 11:04:53 +0530
Message-Id: <20200220053457.930231-3-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220053457.930231-1-santosh@fossix.org>
References: <20200220053457.930231-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

It is common for architectures with hugepage support to require only a
single TLB invalidation operation per hugepage during unmap(), rather than
iterating through the mapping at a PAGE_SIZE increment. Currently,
however, the level in the page table where the unmap() operation occurs
is not stored in the mmu_gather structure, therefore forcing
architectures to issue additional TLB invalidation operations or to give
up and over-invalidate by e.g. invalidating the entire TLB.

Ideally, we could add an interval rbtree to the mmu_gather structure,
which would allow us to associate the correct mapping granule with the
various sub-mappings within the range being invalidated. However, this
is costly in terms of book-keeping and memory management, so instead we
approximate by keeping track of the page table levels that are cleared
and provide a means to query the smallest granule required for invalidation.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: prerequisite for upcoming tlbflush backports]
---
 include/asm-generic/tlb.h | 58 +++++++++++++++++++++++++++++++++------
 mm/memory.c               |  4 ++-
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 97306b32d8d2..f2b9dc9cbaf8 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -114,6 +114,14 @@ struct mmu_gather {
 	 */
 	unsigned int		freed_tables : 1;
 
+	/*
+	 * at which levels have we cleared entries?
+	 */
+	unsigned int		cleared_ptes : 1;
+	unsigned int		cleared_pmds : 1;
+	unsigned int		cleared_puds : 1;
+	unsigned int		cleared_p4ds : 1;
+
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
 	struct page		*__pages[MMU_GATHER_BUNDLE];
@@ -148,6 +156,10 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 		tlb->end = 0;
 	}
 	tlb->freed_tables = 0;
+	tlb->cleared_ptes = 0;
+	tlb->cleared_pmds = 0;
+	tlb->cleared_puds = 0;
+	tlb->cleared_p4ds = 0;
 }
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
@@ -197,6 +209,25 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 }
 #endif
 
+static inline unsigned long tlb_get_unmap_shift(struct mmu_gather *tlb)
+{
+	if (tlb->cleared_ptes)
+		return PAGE_SHIFT;
+	if (tlb->cleared_pmds)
+		return PMD_SHIFT;
+	if (tlb->cleared_puds)
+		return PUD_SHIFT;
+	if (tlb->cleared_p4ds)
+		return P4D_SHIFT;
+
+	return PAGE_SHIFT;
+}
+
+static inline unsigned long tlb_get_unmap_size(struct mmu_gather *tlb)
+{
+	return 1UL << tlb_get_unmap_shift(tlb);
+}
+
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
@@ -230,13 +261,19 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define tlb_remove_tlb_entry(tlb, ptep, address)		\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->cleared_ptes = 1;				\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
-#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	     \
-	do {							     \
-		__tlb_adjust_range(tlb, address, huge_page_size(h)); \
-		__tlb_remove_tlb_entry(tlb, ptep, address);	     \
+#define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
+	do {							\
+		unsigned long _sz = huge_page_size(h);		\
+		__tlb_adjust_range(tlb, address, _sz);		\
+		if (_sz == PMD_SIZE)				\
+			tlb->cleared_pmds = 1;			\
+		else if (_sz == PUD_SIZE)			\
+			tlb->cleared_puds = 1;			\
+		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
 /**
@@ -250,6 +287,7 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)			\
 	do {								\
 		__tlb_adjust_range(tlb, address, HPAGE_PMD_SIZE);	\
+		tlb->cleared_pmds = 1;					\
 		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);		\
 	} while (0)
 
@@ -264,6 +302,7 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define tlb_remove_pud_tlb_entry(tlb, pudp, address)			\
 	do {								\
 		__tlb_adjust_range(tlb, address, HPAGE_PUD_SIZE);	\
+		tlb->cleared_puds = 1;					\
 		__tlb_remove_pud_tlb_entry(tlb, pudp, address);		\
 	} while (0)
 
@@ -289,7 +328,8 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;			\
+		tlb->freed_tables = 1;				\
+		tlb->cleared_pmds = 1;				\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 #endif
@@ -298,7 +338,8 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;			\
+		tlb->freed_tables = 1;				\
+		tlb->cleared_puds = 1;				\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 #endif
@@ -308,7 +349,8 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;			\
+		tlb->freed_tables = 1;				\
+		tlb->cleared_p4ds = 1;				\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
@@ -319,7 +361,7 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define p4d_free_tlb(tlb, pudp, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;			\
+		tlb->freed_tables = 1;				\
 		__p4d_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index bbf0cc4066c8..1832c5ed6ac0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -267,8 +267,10 @@ void arch_tlb_finish_mmu(struct mmu_gather *tlb,
 {
 	struct mmu_gather_batch *batch, *next;
 
-	if (force)
+	if (force) {
+		__tlb_reset_range(tlb);
 		__tlb_adjust_range(tlb, start, end - start);
+	}
 
 	tlb_flush_mmu(tlb);
 
-- 
2.24.1

