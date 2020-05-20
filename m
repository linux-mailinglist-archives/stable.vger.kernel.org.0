Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C791DAD86
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgETIdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETIdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 04:33:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CEAC061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:33:10 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 23so1203088pfy.8
        for <stable@vger.kernel.org>; Wed, 20 May 2020 01:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DvGJDJ10NCwwfIoYiATTvuoTDqLIXlzfFKq1jKX4bOM=;
        b=Cy0hTnTAPs1JQEg5UTxTAbeYYI7lx7paxKnv1ZXiggmOqQ6yTQYOQBZWyxnUhDuhRS
         REHWbOlrE0wkyGkx2fk3lPLVGZzCLrrefyOoPWduJ9ZnsasvuF5teNjOxyj6RrghWAaq
         7Rq2/mr7Fjh5fwJ2JbC2hqTp/3tpJLLgaRZcY+BXBqOY0HCUBi5I/nZeNbW56OQPkYNQ
         kKXE31RBVJqmJNzMBmSebse7yCJMoHzBtNthhlMTgTVSqi3wfjeHRJA4WNogi4jRo7YH
         t5xctEMCLfx41V3pdAx1TljO64UuDJWy5f0AO/gUwpYBLfO6+EhQiHe7niR/xKJbdV4n
         Vrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DvGJDJ10NCwwfIoYiATTvuoTDqLIXlzfFKq1jKX4bOM=;
        b=JZX08L2dRThq6MaXrH2r5UOWd5EOQHeVxAuwFrU61SLji86T65NFXMNZwSoRsXGeu0
         sjRguHoAX/yCRRjG1t+UV9+pXhzc6N6igSK9G1NhnlaKB0q5GxOShfd1kyk4bov71ZAX
         yild2wVrGKXG2ZpVouE4eBhPoHxCjUEKOFqu9YfC+HJlI9D/+066ugmufnDysZpFhKsc
         g2ZCfstkaERm7m67XFwH9DWXI6kCF11QtvF8MbpJOO7jgch9NG+IkG3k5h+3j+Ijqmnl
         zAdRZ4pTaBMT+RXSDujXOpBpJwew3gITzo+hqEzd/Eoctx2yM65ezwtHOd3o9HeqsH2o
         Nulw==
X-Gm-Message-State: AOAM5300dC9UCJDqekvCZElmZJY4ozI/ssi652XEZzYp3iCuZXjwH20S
        9QN/7lr0DsAZXvIvXRPcophLyQHgOfA=
X-Google-Smtp-Source: ABdhPJzuMxVxkEIHchBwUmpORtcFOYOxowBV2WxC+d+eFA7YvFuscZXksRaJ690s125sVI8Tl+S5WA==
X-Received: by 2002:aa7:8084:: with SMTP id v4mr3201873pff.39.1589963590255;
        Wed, 20 May 2020 01:33:10 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([223.181.246.139])
        by smtp.gmail.com with ESMTPSA id 2sm1553980pfz.39.2020.05.20.01.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 01:33:08 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH v4 1/6] asm-generic/tlb: Track freeing of page-table directories in struct mmu_gather
Date:   Wed, 20 May 2020 14:00:20 +0530
Message-Id: <20200520083025.229011-2-santosh@fossix.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520083025.229011-1-santosh@fossix.org>
References: <20200520083025.229011-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
2.25.4

