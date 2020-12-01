Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183062C9AFB
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388723AbgLAJDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388717AbgLAJDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D41D221EB;
        Tue,  1 Dec 2020 09:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813382;
        bh=smWrW7jtuEGxhavobo93b5wPppjfIIUm9uSE0B+0cYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBeect+oikRIKr45xegeN0s4QX839JjucDvZbdyHDLXSKDW4UBkrLIzUoIXhhsSiQ
         v/dgV+ztfg9XY6Gv2eBCFJhteYuZMCu2MyH8GWdR8USUXE08UcX+cohIV1qpZL5Ad1
         jcdCr5tXXJELrP8fHzjBdknlZXAdpwkOGsTaJtuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 20/98] arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()
Date:   Tue,  1 Dec 2020 09:52:57 +0100
Message-Id: <20201201084655.262207086@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit ff1712f953e27f0b0718762ec17d0adb15c9fd0b upstream.

With hardware dirty bit management, calling pte_wrprotect() on a writable,
dirty PTE will lose the dirty state and return a read-only, clean entry.

Move the logic from ptep_set_wrprotect() into pte_wrprotect() to ensure that
the dirty bit is preserved for writable entries, as this is required for
soft-dirty bit management if we enable it in the future.

Cc: <stable@vger.kernel.org>
Fixes: 2f4b829c625e ("arm64: Add support for hardware updates of the access and dirty pte bits")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20201120143557.6715-3-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -136,13 +136,6 @@ static inline pte_t set_pte_bit(pte_t pt
 	return pte;
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
@@ -168,6 +161,20 @@ static inline pte_t pte_mkdirty(pte_t pt
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
@@ -783,12 +790,6 @@ static inline void ptep_set_wrprotect(st
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


