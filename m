Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A7493FF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfFQVXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbfFQVXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E95C20673;
        Mon, 17 Jun 2019 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806621;
        bh=MCSRIwxxf+e4jcxgu13bQxXilnsZ9stigFK+KkNydLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWbJwVwL3Tq1eEujaDqyqiHoBeWHPutLjY6GQ9QKzO1SJ9dIUapVcnz3VI1NBQlvs
         fljoIDGsMRf7/zJwqWSgprR0D2C1soJXMYzeMXesp5Ny0bGf158Lt1kFZBomybJuc3
         EnnH+BRsBTg5hMB6XLE0nyfGFdGFWBq5nDxlGNto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 115/115] powerpc/64s: Fix THP PMD collapse serialisation
Date:   Mon, 17 Jun 2019 23:10:15 +0200
Message-Id: <20190617210805.696181884@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 33258a1db165cf43a9e6382587ad06e9b7f8187c upstream.

Commit 1b2443a547f9 ("powerpc/book3s64: Avoid multiple endian
conversion in pte helpers") changed the actual bitwise tests in
pte_access_permitted by using pte_write() and pte_present() helpers
rather than raw bitwise testing _PAGE_WRITE and _PAGE_PRESENT bits.

The pte_present() change now returns true for PTEs which are
!_PAGE_PRESENT and _PAGE_INVALID, which is the combination used by
pmdp_invalidate() to synchronize access from lock-free lookups.
pte_access_permitted() is used by pmd_access_permitted(), so allowing
GUP lock free access to proceed with such PTEs breaks this
synchronisation.

This bug has been observed on a host using the hash page table MMU,
with random crashes and corruption in guests, usually together with
bad PMD messages in the host.

Fix this by adding an explicit check in pmd_access_permitted(), and
documenting the condition explicitly.

The pte_write() change should be okay, and would prevent GUP from
falling back to the slow path when encountering savedwrite PTEs, which
matches what x86 (that does not implement savedwrite) does.

Fixes: 1b2443a547f9 ("powerpc/book3s64: Avoid multiple endian conversion in pte helpers")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/book3s/64/pgtable.h |   30 +++++++++++++++++++++++++++
 arch/powerpc/mm/pgtable-book3s64.c           |    3 ++
 2 files changed, 33 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -875,6 +875,23 @@ static inline int pmd_present(pmd_t pmd)
 	return false;
 }
 
+static inline int pmd_is_serializing(pmd_t pmd)
+{
+	/*
+	 * If the pmd is undergoing a split, the _PAGE_PRESENT bit is clear
+	 * and _PAGE_INVALID is set (see pmd_present, pmdp_invalidate).
+	 *
+	 * This condition may also occur when flushing a pmd while flushing
+	 * it (see ptep_modify_prot_start), so callers must ensure this
+	 * case is fine as well.
+	 */
+	if ((pmd_raw(pmd) & cpu_to_be64(_PAGE_PRESENT | _PAGE_INVALID)) ==
+						cpu_to_be64(_PAGE_INVALID))
+		return true;
+
+	return false;
+}
+
 static inline int pmd_bad(pmd_t pmd)
 {
 	if (radix_enabled())
@@ -1090,6 +1107,19 @@ static inline int pmd_protnone(pmd_t pmd
 #define pmd_access_permitted pmd_access_permitted
 static inline bool pmd_access_permitted(pmd_t pmd, bool write)
 {
+	/*
+	 * pmdp_invalidate sets this combination (which is not caught by
+	 * !pte_present() check in pte_access_permitted), to prevent
+	 * lock-free lookups, as part of the serialize_against_pte_lookup()
+	 * synchronisation.
+	 *
+	 * This also catches the case where the PTE's hardware PRESENT bit is
+	 * cleared while TLB is flushed, which is suboptimal but should not
+	 * be frequent.
+	 */
+	if (pmd_is_serializing(pmd))
+		return false;
+
 	return pte_access_permitted(pmd_pte(pmd), write);
 }
 
--- a/arch/powerpc/mm/pgtable-book3s64.c
+++ b/arch/powerpc/mm/pgtable-book3s64.c
@@ -116,6 +116,9 @@ pmd_t pmdp_invalidate(struct vm_area_str
 	/*
 	 * This ensures that generic code that rely on IRQ disabling
 	 * to prevent a parallel THP split work as expected.
+	 *
+	 * Marking the entry with _PAGE_INVALID && ~_PAGE_PRESENT requires
+	 * a special case check in pmd_access_permitted.
 	 */
 	serialize_against_pte_lookup(vma->vm_mm);
 	return __pmd(old_pmd);


