Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222002E9AAC
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbhADP7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727679AbhADP7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E3B225A9;
        Mon,  4 Jan 2021 15:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775961;
        bh=0u/2AcnhmUltOpsdX2/8tyhxMNkbVKW3Q79Iurb2J6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOwD8L72lzBn6YAVjHnSdxtLQS5BUSvTfXZnbVXvBES6YAlRPCSozC6yyRKOibtsX
         gww2jpZotHmL0DXWYekio/01WclRQJ9r0/SAHXre4tAM5LDeHdtJ/iBptp+xcqBqN6
         yVxXEmYX1Bi6T0GT4Z7rfY600o1i9H66vJzXJd/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH 4.19 15/35] asm-generic/tlb: Track freeing of page-table directories in struct mmu_gather
Date:   Mon,  4 Jan 2021 16:57:18 +0100
Message-Id: <20210104155704.147719067@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 22a61c3c4f1379ef8b0ce0d5cb78baf3178950e2 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/tlb.h |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

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
@@ -137,6 +147,7 @@ static inline void __tlb_reset_range(str
 		tlb->start = TASK_SIZE;
 		tlb->end = 0;
 	}
+	tlb->freed_tables = 0;
 }
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
@@ -278,6 +289,7 @@ static inline void tlb_remove_check_page
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 #endif
@@ -285,7 +297,8 @@ static inline void tlb_remove_check_page
 #ifndef pmd_free_tlb
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 #endif
@@ -295,6 +308,7 @@ static inline void tlb_remove_check_page
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
@@ -304,7 +318,8 @@ static inline void tlb_remove_check_page
 #ifndef p4d_free_tlb
 #define p4d_free_tlb(tlb, pudp, address)			\
 	do {							\
-		__tlb_adjust_range(tlb, address, PAGE_SIZE);		\
+		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
+		tlb->freed_tables = 1;			\
 		__p4d_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif


