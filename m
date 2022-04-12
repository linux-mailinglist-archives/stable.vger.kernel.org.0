Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489C44FCB05
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344826AbiDLBCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344531AbiDLA6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7395C286D6;
        Mon, 11 Apr 2022 17:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D9A4B819D3;
        Tue, 12 Apr 2022 00:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A54C385A4;
        Tue, 12 Apr 2022 00:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724600;
        bh=FxXsQ/0pA/79CvGYTRmab7Da+yVjb4SEgBgD6c/awrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XP5LL7T4xFF2ujVeyuA89uqhaEE5qzowyzEQ0o1mA9GkN8DMQqcD3ONZwvxyhKjZN
         gev1oz4SaCeWMdbJou2YvVWZMw4ggjcwWc03OenXhXwNZCBOIu5eEW9/kWaPUMz76o
         l//0dIX1lmz7ARrKle9Hr/Bp3T/SdH6Uz3yLH14sDVv+52f+yo2c/NGw9xrJXQCnkV
         OrJ0SzmIy2Nb6bMMFd3CEZchyIfGEE/2NzI/shWchurgXZO29fJGEvxfeswSIAbagu
         G9i9+fipI3+zkqu4QOy6z9bjp5ty98KljZdA+JfqKq/h5Vgtfvps7cjFJboDXb30Qb
         4bc7R2ItT4t4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Capper <steve.capper@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com,
        linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.10 19/30] tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry
Date:   Mon, 11 Apr 2022 20:48:53 -0400
Message-Id: <20220412004906.350678-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Capper <steve.capper@arm.com>

[ Upstream commit 697a1d44af8ba0477ee729e632f4ade37999249a ]

tlb_remove_huge_tlb_entry only considers PMD_SIZE and PUD_SIZE when
updating the mmu_gather structure.

Unfortunately on arm64 there are two additional huge page sizes that
need to be covered: CONT_PTE_SIZE and CONT_PMD_SIZE. Where an end-user
attempts to employ contiguous huge pages, a VM_BUG_ON can be experienced
due to the fact that the tlb structure hasn't been correctly updated by
the relevant tlb_flush_p.._range() call from tlb_remove_huge_tlb_entry.

This patch adds inequality logic to the generic implementation of
tlb_remove_huge_tlb_entry s.t. CONT_PTE_SIZE and CONT_PMD_SIZE are
effectively covered on arm64. Also, as well as ptes, pmds and puds;
p4ds are now considered too.

Reported-by: David Hildenbrand <david@redhat.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/linux-mm/811c5c8e-b3a2-85d2-049c-717f17c3a03a@redhat.com/
Signed-off-by: Steve Capper <steve.capper@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220330112543.863-1-steve.capper@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/tlb.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 6661ee1cff47..a0c4b99d2899 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -563,10 +563,14 @@ static inline void tlb_flush_p4d_range(struct mmu_gather *tlb,
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	do {							\
 		unsigned long _sz = huge_page_size(h);		\
-		if (_sz == PMD_SIZE)				\
-			tlb_flush_pmd_range(tlb, address, _sz);	\
-		else if (_sz == PUD_SIZE)			\
+		if (_sz >= P4D_SIZE)				\
+			tlb_flush_p4d_range(tlb, address, _sz);	\
+		else if (_sz >= PUD_SIZE)			\
 			tlb_flush_pud_range(tlb, address, _sz);	\
+		else if (_sz >= PMD_SIZE)			\
+			tlb_flush_pmd_range(tlb, address, _sz);	\
+		else						\
+			tlb_flush_pte_range(tlb, address, _sz);	\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
-- 
2.35.1

