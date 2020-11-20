Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325442BABFB
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgKTOgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgKTOgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 09:36:10 -0500
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E341822403;
        Fri, 20 Nov 2020 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605882969;
        bh=5+VLlS1UUO/TI2Fp+RDt7LnIJ1HNEXVw/xMX/rGfLQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPCA9JlQU8QGFpdcEWLoYhJojlk4qHNZfH3K7ZHQreYPLhy7IDyvsPJuzXJKkloFt
         XB4RJF7DC3c1CsG5sP2y4Hsq0DuBMmjhDDSOjbH0H1hm84YDFuLwpLGdsQyWOJIkSr
         Ad0byF1KCrj5mPq5P5e+ftrx4wfGjw85zDyts/Yk=
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
Subject: [PATCH 2/6] arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()
Date:   Fri, 20 Nov 2020 14:35:53 +0000
Message-Id: <20201120143557.6715-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120143557.6715-1-will@kernel.org>
References: <20201120143557.6715-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With hardware dirty bit management, calling pte_wrprotect() on a writable,
dirty PTE will lose the dirty state and return a read-only, clean entry.

Move the logic from ptep_set_wrprotect() into pte_wrprotect() to ensure that
the dirty bit is preserved for writable entries, as this is required for
soft-dirty bit management if we enable it in the future.

Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1bdf51f01e73..a155551863c9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -162,13 +162,6 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
 	return pmd;
 }
 
-static inline pte_t pte_wrprotect(pte_t pte)
-{
-	pte = clear_pte_bit(pte, __pgprot(PTE_WRITE));
-	pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
-	return pte;
-}
-
 static inline pte_t pte_mkwrite(pte_t pte)
 {
 	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
@@ -194,6 +187,20 @@ static inline pte_t pte_mkdirty(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	/*
+	 * If hardware-dirty (PTE_WRITE/DBM bit set and PTE_RDONLY
+	 * clear), set the PTE_DIRTY bit.
+	 */
+	if (pte_hw_dirty(pte))
+		pte = pte_mkdirty(pte);
+
+	pte = clear_pte_bit(pte, __pgprot(PTE_WRITE));
+	pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
+	return pte;
+}
+
 static inline pte_t pte_mkold(pte_t pte)
 {
 	return clear_pte_bit(pte, __pgprot(PTE_AF));
@@ -843,12 +850,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 	pte = READ_ONCE(*ptep);
 	do {
 		old_pte = pte;
-		/*
-		 * If hardware-dirty (PTE_WRITE/DBM bit set and PTE_RDONLY
-		 * clear), set the PTE_DIRTY bit.
-		 */
-		if (pte_hw_dirty(pte))
-			pte = pte_mkdirty(pte);
 		pte = pte_wrprotect(pte);
 		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
-- 
2.29.2.454.gaff20da3a2-goog

