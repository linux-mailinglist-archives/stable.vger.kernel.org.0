Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC3E2C9A78
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgLAI55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729010AbgLAI54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:57:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C5C321D46;
        Tue,  1 Dec 2020 08:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813035;
        bh=mdF5RWOCXgRrMfxT6cZOQxcvA9sSPpgSjyfnh1bXSyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwuc+vlEQts73Tfd3xmb6o1y1HrYJ9x/cj5sPLeVOVumDsAqBzcqOyo4C3v/T1Hs2
         LV2oXYxuMAL4oPwD+lg2FN3361LAk5mB7TkBwMEwkGYV3FBk5axSbj0DUz8sEZNmmx
         FjA/tH+xmv5TcPF+nsKhTbFxgafAkxF/0NxBlgPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 11/50] arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()
Date:   Tue,  1 Dec 2020 09:53:10 +0100
Message-Id: <20201201084646.314139386@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
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
@@ -130,13 +130,6 @@ static inline pte_t set_pte_bit(pte_t pt
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
@@ -162,6 +155,20 @@ static inline pte_t pte_mkdirty(pte_t pt
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
@@ -643,12 +650,6 @@ static inline void ptep_set_wrprotect(st
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


