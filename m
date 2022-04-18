Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD35050BD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbiDRM3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239866AbiDRM3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E367422B20;
        Mon, 18 Apr 2022 05:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E6CB60F01;
        Mon, 18 Apr 2022 12:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602ECC385A1;
        Mon, 18 Apr 2022 12:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284564;
        bh=k0wSfYR0ig7xQ4rb/4er1kpUOZcttmdGmeX4lBcM9V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ka0mtetC+Gt9mujAUWqefhBFET7MGnXYoNuESNnx/6AGmE6FuLbHEzxl8OSq8riq3
         Ef/NZQsYdymeS7NGsVB0cYCRmrIPOOTiljsbYP4GdDt2j4YUX6KkbnGCggdKwTXFjq
         DGxmX7gc7r7UINlMhtkveCEy2GEco0/5iaZ6xUns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steve Capper <steve.capper@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 156/219] tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry
Date:   Mon, 18 Apr 2022 14:12:05 +0200
Message-Id: <20220418121211.251947230@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2c68a545ffa7..71942a1c642d 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -565,10 +565,14 @@ static inline void tlb_flush_p4d_range(struct mmu_gather *tlb,
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



