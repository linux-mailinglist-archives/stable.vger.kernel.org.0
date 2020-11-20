Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE9D2BABF9
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgKTOgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgKTOgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 09:36:07 -0500
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C5082236F;
        Fri, 20 Nov 2020 14:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605882966;
        bh=j2dSYypETbDYVNoDBWsVOOyAKJVVu4Ogy3WRiJXmbGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWbZpQUtUGh4S38MxVlOuy+y3ZRHQ+hSU0lessRpwqEV7+WCNXSMp1fUFfrMKd9OH
         TFMKC+MD6wHULTQjMpUVJDiQmSZt9QXpeyxuEaJQ1LAFkfuHqsrtMGoKfOdxlcr2Li
         oJC/N5qg2Ae1eefEiIBLHa8KwMUVOHPqVqRv1oPY=
From:   Will Deacon <will@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yu Zhao <yuzhao@google.com>, Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH 1/6] arm64: pgtable: Fix pte_accessible()
Date:   Fri, 20 Nov 2020 14:35:52 +0000
Message-Id: <20201120143557.6715-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120143557.6715-1-will@kernel.org>
References: <20201120143557.6715-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pte_accessible() is used by ptep_clear_flush() to figure out whether TLB
invalidation is necessary when unmapping pages for reclaim. Although our
implementation is correct according to the architecture, returning true
only for valid, young ptes in the absence of racing page-table
modifications, this is in fact flawed due to lazy invalidation of old
ptes in ptep_clear_flush_young() where we elide the expensive DSB
instruction for completing the TLB invalidation.

Rather than penalise the aging path, adjust pte_accessible() to return
true for any valid pte, even if the access flag is cleared.

Cc: <stable@vger.kernel.org>
Fixes: 76c714be0e5e ("arm64: pgtable: implement pte_accessible()")
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4ff12a7adcfd..1bdf51f01e73 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -115,8 +115,6 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define pte_valid(pte)		(!!(pte_val(pte) & PTE_VALID))
 #define pte_valid_not_user(pte) \
 	((pte_val(pte) & (PTE_VALID | PTE_USER)) == PTE_VALID)
-#define pte_valid_young(pte) \
-	((pte_val(pte) & (PTE_VALID | PTE_AF)) == (PTE_VALID | PTE_AF))
 #define pte_valid_user(pte) \
 	((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER))
 
@@ -126,7 +124,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
  * remapped as PROT_NONE but are yet to be flushed from the TLB.
  */
 #define pte_accessible(mm, pte)	\
-	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid_young(pte))
+	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid(pte))
 
 /*
  * p??_access_permitted() is true for valid user mappings (subject to the
-- 
2.29.2.454.gaff20da3a2-goog

