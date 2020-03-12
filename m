Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86218315B
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgCLN2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:28:12 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51004 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLN2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:28:11 -0400
Received: by mail-pj1-f67.google.com with SMTP id u10so2567295pjy.0
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=epu6wmj6Ft/4Rps2Jy4h0kjSZmJ0dnkFAY3fVVQ+XPg=;
        b=lErWO/yWGrzIPqhIYqCx37unoh4hD8+ENeQOFWwu56C7E4ve4ApmFIQycC+29+E5Iu
         Yah327Pd326g0OJJ53e3pJf6dv0cmu2jxl1qXkSdXCZqJQmDdtMJn4rNTPsgb+Yhgyk6
         Df/sLLdFl1PbpU7WRz7bRwHhdeXVMT63Rw1HCefEl0GO0Eju0s1LcotA8lWlbgKZjAlP
         gkXros2rl0jiNf38tNpRwYFMc44tM32jdbu2MRgc/gASDQpDFVMf6j8B/Q9S/LMNEJPM
         u4G4JQvqgxx1SRVwKgCb94U67LwWuE9YcqEHI4X3NyM/Sb9xI20T26qzmvJo5Eu8WAcC
         8aiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epu6wmj6Ft/4Rps2Jy4h0kjSZmJ0dnkFAY3fVVQ+XPg=;
        b=KbyZZc8vmEkfJyGDKOLkr2TGWZ+QGBgf3vIV0cqf5PBVxViXC0OyP8HYdiMuxr/OJe
         di9ZUNIL64tXAlx0HJxB5UZWESguoKyelrq7BhEIVSwZzDPw07ih6vVIiRQuu1wzR962
         vrUnWO0SvRr4yrvNv0QHNajQ9qQGNgpP5XFR9en09xEbJA4pIEaQ1h19DZTGvIXHASCI
         do3WEHKHyhhQ4aE3Hd3Kw/y2pS0wRVadAGXxCOR7gAyFQ5vyR9rfIVrs8hrJ7rXjTxRT
         zsPo67f6bOcWOKUKLNiDPsl5k0nSDNVUplb3MSvg1tQmuO33MMagxKDi94Gk/bOWZz02
         3a4g==
X-Gm-Message-State: ANhLgQ080EQKWSDsPXS78jY0DnMYMdZwDwpqDQA6XbZ7Lqoe0Im1y3uy
        hey/PB4+1/ew1fef6YP5AYVAFIDIOAs=
X-Google-Smtp-Source: ADFU+vv0JOQGQhpb4v/9/M3jT392OAGyw4apgSqJSgTdp8YhgbpqAZvk354HwGUpiR/BQ5ED+Fm2cA==
X-Received: by 2002:a17:90a:21ce:: with SMTP id q72mr4074655pjc.160.1584019689969;
        Thu, 12 Mar 2020 06:28:09 -0700 (PDT)
Received: from santosiv.in.ibm.com ([111.125.206.208])
        by smtp.gmail.com with ESMTPSA id w206sm13007435pfc.54.2020.03.12.06.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:28:08 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 1/6] asm-generic/tlb: Track freeing of page-table directories in struct mmu_gather
Date:   Thu, 12 Mar 2020 18:57:35 +0530
Message-Id: <20200312132740.225241-2-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312132740.225241-1-santosh@fossix.org>
References: <20200312132740.225241-1-santosh@fossix.org>
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
2.24.1

