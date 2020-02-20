Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052D41656FA
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 06:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgBTFfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 00:35:10 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35065 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgBTFfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 00:35:10 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1091357plt.2
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 21:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NKOsDlonI6ZZnqYhj8NP6zsInFEyFSvYMOHlkhHk/d4=;
        b=POZtORHdgH72O8bDBEfA5gjhoqk2cdAjFNd2Zi3GjYKTTbjLRikgh4fk0PMZrJ6i5M
         z28UPuMvpAmF4Hr3CA7uqZsLEG38XcJ8pc5TyCufQ2P7OJUg5nk7ZGpfoHVGHVT4CDhU
         AFMSG5nHpmp1cR0bMtiuC/l3v7Ie96ScSk3ry7coQjDNDRzRl+wcuiesnNlOnFEze+ZY
         b9XPs7QqHNRy61xALzh3VdA6zAOrTev0+/x1MHHyHaOuU0s54570Lm3zFFk2JspXsyX6
         yaheXMTYlQHMiQFUnBHQfdIKftLgdTYm0AWeTIa587H0XDsgQHoUZLg52utgAnCAsb3F
         25hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKOsDlonI6ZZnqYhj8NP6zsInFEyFSvYMOHlkhHk/d4=;
        b=fypW+UOWgWSigkeme/l+CBAcwTqWM9qItN0NPBKyg7NCsRyJHWuhGvbCzvXyNtB5TT
         GF+e/Jb//ouWrm8KBB3SuZ/7mvRZjxJqHh2vwvvyFNOmCzs6j/oPIZgxLik+jiw7+N9n
         Sw5KWOLAvncQUmeb4nRUZajP48+2Xk7ePH2xOmX265hk1NO84PeetHGKz5TWkm/S7xa3
         eQHW+iIeZjjkc5FzYGYdmgV5C2sifdxzLm/C17OYaUh9wAdTKK7XER+EyS+5EOJfxDea
         3xddjLbbz9yiU0bx0za3GpJKRAvIigvzfHer1MAmT4mGXNlOdacX2j6fp9/8weq4wV7U
         U7HA==
X-Gm-Message-State: APjAAAWcsvrQf+b8oeSVa91c3LUZzU28LdKA4PP/DZuYQ+Jxcatwoq3Q
        aT3kiv191aSZsYJvTOdtIrJInQ==
X-Google-Smtp-Source: APXvYqyyPoeNybZrSmK+0WHyI+lggbO8N/MMUcjHQHOypDxitVIxCh0Lsjl5NTHnErYegDfvoTyeuw==
X-Received: by 2002:a17:902:6a8c:: with SMTP id n12mr29129863plk.191.1582176909748;
        Wed, 19 Feb 2020 21:35:09 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.71])
        by smtp.gmail.com with ESMTPSA id r11sm1664262pgi.9.2020.02.19.21.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 21:35:09 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/6] asm-generic/tlb: Track freeing of page-table directories in struct mmu_gather
Date:   Thu, 20 Feb 2020 11:04:52 +0530
Message-Id: <20200220053457.930231-2-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220053457.930231-1-santosh@fossix.org>
References: <20200220053457.930231-1-santosh@fossix.org>
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

