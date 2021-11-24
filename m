Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96F45C277
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346599AbhKXN3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349005AbhKXN1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:27:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746AA61B98;
        Wed, 24 Nov 2021 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758228;
        bh=Ni1KfV9kPurpIO91b1GgBzIBQBq+LXfa3yBah1RTUuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZN5TwEUkup+t2GFrnPOCZ2qnSsv+RG/5kYMMf4xAu7X1DWdP5E6TaL/AU5o5Uwq2
         BjYyLAjYDpFOu9VEXZOuUscadfJtvFAAElm32q5iY0LN8aP2VWqFb7yt0OWAjUp2Jw
         NM9m7W6mHOiQjP318ztnMp2foU5QVGvQjeEOV1Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Zhenyu Ye <yezhenyu2@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 099/100] tlb: mmu_gather: add tlb_flush_*_range APIs
Date:   Wed, 24 Nov 2021 12:58:55 +0100
Message-Id: <20211124115658.053711524@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra (Intel) <peterz@infradead.org>

commit 2631ed00b0498810f8d5c2163c6b5270d893687b upstream.

tlb_flush_{pte|pmd|pud|p4d}_range() adjust the tlb->start and
tlb->end, then set corresponding cleared_*.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Zhenyu Ye <yezhenyu2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20200625080314.230-5-yezhenyu2@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/tlb.h |   55 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 15 deletions(-)

--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -495,6 +495,38 @@ static inline void tlb_end_vma(struct mm
 }
 #endif
 
+/*
+ * tlb_flush_{pte|pmd|pud|p4d}_range() adjust the tlb->start and tlb->end,
+ * and set corresponding cleared_*.
+ */
+static inline void tlb_flush_pte_range(struct mmu_gather *tlb,
+				     unsigned long address, unsigned long size)
+{
+	__tlb_adjust_range(tlb, address, size);
+	tlb->cleared_ptes = 1;
+}
+
+static inline void tlb_flush_pmd_range(struct mmu_gather *tlb,
+				     unsigned long address, unsigned long size)
+{
+	__tlb_adjust_range(tlb, address, size);
+	tlb->cleared_pmds = 1;
+}
+
+static inline void tlb_flush_pud_range(struct mmu_gather *tlb,
+				     unsigned long address, unsigned long size)
+{
+	__tlb_adjust_range(tlb, address, size);
+	tlb->cleared_puds = 1;
+}
+
+static inline void tlb_flush_p4d_range(struct mmu_gather *tlb,
+				     unsigned long address, unsigned long size)
+{
+	__tlb_adjust_range(tlb, address, size);
+	tlb->cleared_p4ds = 1;
+}
+
 #ifndef __tlb_remove_tlb_entry
 #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
 #endif
@@ -508,19 +540,17 @@ static inline void tlb_end_vma(struct mm
  */
 #define tlb_remove_tlb_entry(tlb, ptep, address)		\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
-		tlb->cleared_ptes = 1;				\
+		tlb_flush_pte_range(tlb, address, PAGE_SIZE);	\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	do {							\
 		unsigned long _sz = huge_page_size(h);		\
-		__tlb_adjust_range(tlb, address, _sz);		\
 		if (_sz == PMD_SIZE)				\
-			tlb->cleared_pmds = 1;			\
+			tlb_flush_pmd_range(tlb, address, _sz);	\
 		else if (_sz == PUD_SIZE)			\
-			tlb->cleared_puds = 1;			\
+			tlb_flush_pud_range(tlb, address, _sz);	\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
@@ -534,8 +564,7 @@ static inline void tlb_end_vma(struct mm
 
 #define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)			\
 	do {								\
-		__tlb_adjust_range(tlb, address, HPAGE_PMD_SIZE);	\
-		tlb->cleared_pmds = 1;					\
+		tlb_flush_pmd_range(tlb, address, HPAGE_PMD_SIZE);	\
 		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);		\
 	} while (0)
 
@@ -549,8 +578,7 @@ static inline void tlb_end_vma(struct mm
 
 #define tlb_remove_pud_tlb_entry(tlb, pudp, address)			\
 	do {								\
-		__tlb_adjust_range(tlb, address, HPAGE_PUD_SIZE);	\
-		tlb->cleared_puds = 1;					\
+		tlb_flush_pud_range(tlb, address, HPAGE_PUD_SIZE);	\
 		__tlb_remove_pud_tlb_entry(tlb, pudp, address);		\
 	} while (0)
 
@@ -575,9 +603,8 @@ static inline void tlb_end_vma(struct mm
 #ifndef pte_free_tlb
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb_flush_pmd_range(tlb, address, PAGE_SIZE);	\
 		tlb->freed_tables = 1;				\
-		tlb->cleared_pmds = 1;				\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 #endif
@@ -585,9 +612,8 @@ static inline void tlb_end_vma(struct mm
 #ifndef pmd_free_tlb
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb_flush_pud_range(tlb, address, PAGE_SIZE);	\
 		tlb->freed_tables = 1;				\
-		tlb->cleared_puds = 1;				\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 #endif
@@ -596,9 +622,8 @@ static inline void tlb_end_vma(struct mm
 #ifndef pud_free_tlb
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb_flush_p4d_range(tlb, address, PAGE_SIZE);	\
 		tlb->freed_tables = 1;				\
-		tlb->cleared_p4ds = 1;				\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif


