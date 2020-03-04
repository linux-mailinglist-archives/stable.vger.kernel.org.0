Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F117898E
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 05:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCDEat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 23:30:49 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41989 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCDEas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 23:30:48 -0500
Received: by mail-pl1-f193.google.com with SMTP id u3so422141plr.9
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 20:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=epu6wmj6Ft/4Rps2Jy4h0kjSZmJ0dnkFAY3fVVQ+XPg=;
        b=cECgtZC9qjk4WvOfxggZ5URy18CnUollzDaDs8LbzVL2JCNcduSkbxwEHwsQ3wBADs
         8ouBJqfm7EvgGcfBLUHncVr9iAdw/URTHhBL6vIluYACaBzMTEAfByAtOqDYWeHWJwuD
         y4h1b8kxf3I95FTZF78bf9nu+vL3/txd4z7qzWrC+h7iys7X8Cu6ALhKSd4w4P0fmxD4
         2WTIHVBHeFgagrR0HIDZvqhDrIQjFAJam6HwVLAwS0mUWFBw9UMt0zZmRoOKnuXJrbBl
         BlH28zF7nea8szcEAtdXX0RXHGdQLUbn8G4U3tkLQXPxLFHLYyl/2hFR3/ccCIBQQOcg
         3wtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epu6wmj6Ft/4Rps2Jy4h0kjSZmJ0dnkFAY3fVVQ+XPg=;
        b=oODPZcpkiBlZQVCTxjXvg/x+YhGuP6Stvo/vG5T/EIqpNvEbaBxDhzoOUTO/LVIQGN
         mV2TvclaBz7K5mJQjP6DZuCXCnxj2IN22IoAnKiJnSwywnydZKImb9RQDvpyhOgyzCjt
         gZKAmIg1+RIkE9dfQCR/S1GntWTUNUZxGKhnPvHfKZVOlWbJknVkwk3zjO8rRMMvqaVN
         1rSsUUgR85L+/sLFI8jkXCRlxniPXGSVFt8kLcUF3IdkvcEVUe/srdhNrF3FywYFW3pC
         +w6cy8krATJTaKTClNcUpkDMroUAq/2Mm1kEc0bw5dslyQIpig3ekro2S2kNUbi96TQe
         b8cA==
X-Gm-Message-State: ANhLgQ2tGDY8qTBJffcC1In1gDDGTGabiZMr8Zu09fa7oF4rxVTWUTV8
        H4DB2+Jz/7FlM/g0+heC4IwaUBiVcuM=
X-Google-Smtp-Source: ADFU+vu/zINmGdTU9T2/MpY/r/7a8GKl+dPIeAfODhqSlJ464741vMZ4is9IQ64BTDunesJQel4cFw==
X-Received: by 2002:a17:902:8c91:: with SMTP id t17mr1252113plo.98.1583296247470;
        Tue, 03 Mar 2020 20:30:47 -0800 (PST)
Received: from santosiv.in.ibm.com ([2401:4900:16ee:7b5f:eac:4364:ff14:3aaa])
        by smtp.gmail.com with ESMTPSA id y193sm10775723pfg.162.2020.03.03.20.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 20:30:46 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 1/6] asm-generic/tlb: Track freeing of page-table directories in struct mmu_gather
Date:   Wed,  4 Mar 2020 10:00:23 +0530
Message-Id: <20200304043028.280136-2-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304043028.280136-1-santosh@fossix.org>
References: <20200304043028.280136-1-santosh@fossix.org>
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

