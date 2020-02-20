Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4E1165970
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 09:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgBTImx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 03:42:53 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40172 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgBTImw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 03:42:52 -0500
Received: by mail-pj1-f67.google.com with SMTP id 12so582088pjb.5
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 00:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QcZMDkYbi4PCaUtgytpxeZUUFI6CVIxTM3TjTbEOqmA=;
        b=aZBjkKJ2rVHe7rG5DUHlj7/eibX2Klyvbn3HTxEtx4u85XoVuNvgTtpvfL0MA0vy2V
         RHPbeNC4CUxmxtTdq/RfVgWYKRntHcgzRe6RfS8BhYHLImZRv5Ms2O7/xTBW0CwgkLM8
         pTvyD5fq2geW3l0vxIFwviI4m5VFRv6rSKFMo0zs0zMc/iCZwBUdipfqyUQwKs6XntEg
         4BxNsm5UVI7GTUFjA1aG/PbNLrF6URGCs8HsAJU+Zp8AINLlFqvgBy5yp9VWQ4sUBg+H
         j76p0Jc9sdrK8Te3O1P6Tgr2PSRZUf+40IT9Am99gsPIrHvvxiiBEPID3UYO+Hz4iY92
         09xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QcZMDkYbi4PCaUtgytpxeZUUFI6CVIxTM3TjTbEOqmA=;
        b=p4pZAfYkug+iJPP+wnjXpbzdDUyBPoI73TvgyiJz0adYHaCFYRIv80UQy4sC+lxszc
         jR3nQMJcHM+pKotvYuXgTEK82tJ9ZOUkRjS83cBxE//HYuMkaii1iQDGyBqCCpU/Gw7e
         q7+mGhtjBAJSVeC26wKDc6jz8wbPcb9VvHr0bai9PwldPzwZgoM/YfvtUeGjzvWyadU2
         pECEZh/qYI1sk+2BvGdskavlCWwBUtwWYZWyYbDLYAAl4hRjAojiCQUUBBpoIe8x6Ni/
         YTrZ7zYolJK5ZLeH+mfzjLsZiulDATMAh0bBvqGCEcHE59tzpsfCJ5AQ4f5YinF3E6fz
         fwZw==
X-Gm-Message-State: APjAAAXiWf25PA5jJVVMRbZ4fGnHJcEZvV7ApMLLD1lB7BA4o9+ZsOb0
        I7sb2S0NrjbCclNo2fkXPtVNdw==
X-Google-Smtp-Source: APXvYqzpPpHl4pph9y6TCwrhJEG2S0gwgXFbtpQWfS2cafaroEQ9IUoKfj1WXHIXUjMC/jH/bAhUnw==
X-Received: by 2002:a17:90a:ec02:: with SMTP id l2mr2411354pjy.12.1582188172089;
        Thu, 20 Feb 2020 00:42:52 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.72])
        by smtp.gmail.com with ESMTPSA id r145sm2512381pfr.5.2020.02.20.00.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 00:42:51 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, gregkh@linuxfoundation.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/6] asm-generic/tlb: Track freeing of page-table directories in struct mmu_gather
Date:   Thu, 20 Feb 2020 14:12:24 +0530
Message-Id: <20200220084229.1278137-2-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220084229.1278137-1-santosh@fossix.org>
References: <20200220084229.1278137-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Some architectures require different TLB invalidation instructions
depending on whether it is only the last-level of page table being
changed, or whether there are also changes to the intermediate
(directory) entries higher up the tree.

Add a new bit to the flags bitfield in struct mmu_gather so that the
architecture code can operate accordingly if it's the intermediate
levels being invalidated.

22a61c3c4f1379 in upstream

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: prerequisite for tlbflush backports]
---
 include/asm-generic/tlb.h | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index b3353e21f3b3..97306b32d8d2 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -97,12 +97,22 @@ struct mmu_gather {
 #endif
 	unsigned long		start;
 	unsigned long		end;
-	/* we are in the middle of an operation to clear
-	 * a full mm and can make some optimizations */
-	unsigned int		fullmm : 1,
-	/* we have performed an operation which
-	 * requires a complete flush of the tlb */
-				need_flush_all : 1;
+	/*
+	 * we are in the middle of an operation to clear
+	 * a full mm and can make some optimizations
+	 */
+	unsigned int		fullmm : 1;
+
+	/*
+	 * we have performed an operation which
+	 * requires a complete flush of the tlb
+	 */
+	unsigned int		need_flush_all : 1;
+
+	/*
+	 * we have removed page directories
+	 */
+	unsigned int		freed_tables : 1;
 
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
@@ -137,6 +147,7 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 		tlb->start = TASK_SIZE;
 		tlb->end = 0;
 	}
+	tlb->freed_tables = 0;
 }
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
@@ -278,6 +289,7 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 #endif
@@ -285,7 +297,8 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #ifndef pmd_free_tlb
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 #endif
@@ -295,6 +308,7 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
@@ -304,7 +318,8 @@ static inline void tlb_remove_check_page_size_change(struct mmu_gather *tlb,
 #ifndef p4d_free_tlb
 #define p4d_free_tlb(tlb, pudp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__p4d_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
-- 
2.24.1

