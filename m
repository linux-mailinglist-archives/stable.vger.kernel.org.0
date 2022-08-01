Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B35870DC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiHATEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiHATDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:03:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97CE31DF4;
        Mon,  1 Aug 2022 12:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5523B81615;
        Mon,  1 Aug 2022 19:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E6BC4314F;
        Mon,  1 Aug 2022 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380574;
        bh=YtD2IPeiwFHCoAQzO5yVCDNb/oS17//n3lkxt2qr7XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRUHpJnS0slQ/TyETjlhEPa/hHYhD9w2zGFzw+jbnyeRsCK1mShqPZryrLtUNwQ5S
         hU0h9Hpx8mPi/nJN8zkkrVZ2hNecvFuuvO2Nu/+9dIRRy+EFILOyiwBs++2wWdHBD/
         AQ9i5dn8/qvmAnMcUeXWmH6A4TpkKMVWImgTkZg+kVVbjdlD9Tg5nGq5Ty2UH0P3CE
         VY5j5LiwaBp5VRl9D+BPiuuWsgdIM4NTm/3NTvNuqpaS/miQhs02/xdfTnHoYK8RQt
         OKBP7d40cgZVlRaBIqq6cvF6/2ZM9Q+EY5NEyTn67F3o1bNh+nWqzJRC097Ar0EeiP
         9lwCrgvWgxchw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        npiggin@gmail.com, linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.15 5/8] mmu_gather: Let there be one tlb_{start,end}_vma() implementation
Date:   Mon,  1 Aug 2022 15:02:40 -0400
Message-Id: <20220801190243.3818811-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190243.3818811-1-sashal@kernel.org>
References: <20220801190243.3818811-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 18ba064e42df3661e196ab58a23931fc732a420b ]

Now that architectures are no longer allowed to override
tlb_{start,end}_vma() re-arrange code so that there is only one
implementation for each of these functions.

This much simplifies trying to figure out what they actually do.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/tlb.h | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 71942a1c642d..17815e9d38b7 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -334,8 +334,8 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
 
 #ifdef CONFIG_MMU_GATHER_NO_RANGE
 
-#if defined(tlb_flush) || defined(tlb_start_vma) || defined(tlb_end_vma)
-#error MMU_GATHER_NO_RANGE relies on default tlb_flush(), tlb_start_vma() and tlb_end_vma()
+#if defined(tlb_flush)
+#error MMU_GATHER_NO_RANGE relies on default tlb_flush()
 #endif
 
 /*
@@ -355,17 +355,10 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 static inline void
 tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 
-#define tlb_end_vma tlb_end_vma
-static inline void tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
-
 #else /* CONFIG_MMU_GATHER_NO_RANGE */
 
 #ifndef tlb_flush
 
-#if defined(tlb_start_vma) || defined(tlb_end_vma)
-#error Default tlb_flush() relies on default tlb_start_vma() and tlb_end_vma()
-#endif
-
 /*
  * When an architecture does not provide its own tlb_flush() implementation
  * but does have a reasonably efficient flush_vma_range() implementation
@@ -486,7 +479,6 @@ static inline unsigned long tlb_get_unmap_size(struct mmu_gather *tlb)
  * case where we're doing a full MM flush.  When we're doing a munmap,
  * the vmas are adjusted to only cover the region to be torn down.
  */
-#ifndef tlb_start_vma
 static inline void tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
 {
 	if (tlb->fullmm)
@@ -495,9 +487,7 @@ static inline void tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct *
 	tlb_update_vma_flags(tlb, vma);
 	flush_cache_range(vma, vma->vm_start, vma->vm_end);
 }
-#endif
 
-#ifndef tlb_end_vma
 static inline void tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
 {
 	if (tlb->fullmm)
@@ -511,7 +501,6 @@ static inline void tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vm
 	 */
 	tlb_flush_mmu_tlbonly(tlb);
 }
-#endif
 
 /*
  * tlb_flush_{pte|pmd|pud|p4d}_range() adjust the tlb->start and tlb->end,
-- 
2.35.1

