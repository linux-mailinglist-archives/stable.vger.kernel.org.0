Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00DE499535
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392425AbiAXUvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37962 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389973AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 220EE60916;
        Mon, 24 Jan 2022 20:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEF1C340E5;
        Mon, 24 Jan 2022 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057081;
        bh=wxZq9oTaGqilA11OlATDIroEGM8Are41LNXDV3VNAsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huD8dDlTbUo4LPzWtj/yx1SU/IDx++AgT642n2YejURadDRN9JPkpIMeAB8Hw9RjX
         4IR68kcnb9wVtMoBQSsdl8N45YWyCl+485+oVOlQ0h93IEQQFuVuj7jcz2+FKUNKXV
         2vp3y/bSBYppO7x8MpHLNKwMzsG11IdmpNYk23W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 696/846] powerpc/64s/radix: Fix huge vmap false positive
Date:   Mon, 24 Jan 2022 19:43:33 +0100
Message-Id: <20220124184125.068440562@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 467ba14e1660b52a2f9338b484704c461bd23019 upstream.

pmd_huge() is defined to false when HUGETLB_PAGE is not configured, but
the vmap code still installs huge PMDs. This leads to false bad PMD
errors when vunmapping because it is not seen as a huge PTE, and the bad
PMD check catches it. The end result may not be much more serious than
some bad pmd warning messages, because the pmd_none_or_clear_bad() does
what we wanted and clears the huge PTE anyway.

Fix this by checking pmd_is_leaf(), which checks for a PTE regardless of
config options. The whole huge/large/leaf stuff is a tangled mess but
that's kernel-wide and not something we can improve much in arch/powerpc
code.

pmd_page(), pud_page(), etc., called by vmalloc_to_page() on huge vmaps
can similarly trigger a false VM_BUG_ON when CONFIG_HUGETLB_PAGE=n, so
those checks are adjusted. The checks were added by commit d6eacedd1f0e
("powerpc/book3s: Use config independent helpers for page table walk"),
while implementing a similar fix for other page table walking functions.

Fixes: d909f9109c30 ("powerpc/64s/radix: Enable HAVE_ARCH_HUGE_VMAP")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211216103342.609192-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |    4 ++--
 arch/powerpc/mm/pgtable_64.c             |   14 +++++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1093,7 +1093,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 
 int pud_clear_huge(pud_t *pud)
 {
-	if (pud_huge(*pud)) {
+	if (pud_is_leaf(*pud)) {
 		pud_clear(pud);
 		return 1;
 	}
@@ -1140,7 +1140,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 
 int pmd_clear_huge(pmd_t *pmd)
 {
-	if (pmd_huge(*pmd)) {
+	if (pmd_is_leaf(*pmd)) {
 		pmd_clear(pmd);
 		return 1;
 	}
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -102,7 +102,8 @@ EXPORT_SYMBOL(__pte_frag_size_shift);
 struct page *p4d_page(p4d_t p4d)
 {
 	if (p4d_is_leaf(p4d)) {
-		VM_WARN_ON(!p4d_huge(p4d));
+		if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+			VM_WARN_ON(!p4d_huge(p4d));
 		return pte_page(p4d_pte(p4d));
 	}
 	return virt_to_page(p4d_pgtable(p4d));
@@ -112,7 +113,8 @@ struct page *p4d_page(p4d_t p4d)
 struct page *pud_page(pud_t pud)
 {
 	if (pud_is_leaf(pud)) {
-		VM_WARN_ON(!pud_huge(pud));
+		if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+			VM_WARN_ON(!pud_huge(pud));
 		return pte_page(pud_pte(pud));
 	}
 	return virt_to_page(pud_pgtable(pud));
@@ -125,7 +127,13 @@ struct page *pud_page(pud_t pud)
 struct page *pmd_page(pmd_t pmd)
 {
 	if (pmd_is_leaf(pmd)) {
-		VM_WARN_ON(!(pmd_large(pmd) || pmd_huge(pmd)));
+		/*
+		 * vmalloc_to_page may be called on any vmap address (not only
+		 * vmalloc), and it uses pmd_page() etc., when huge vmap is
+		 * enabled so these checks can't be used.
+		 */
+		if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+			VM_WARN_ON(!(pmd_large(pmd) || pmd_huge(pmd)));
 		return pte_page(pmd_pte(pmd));
 	}
 	return virt_to_page(pmd_page_vaddr(pmd));


