Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001E71F45EB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbgFIRrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732151AbgFIRrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E4C2081A;
        Tue,  9 Jun 2020 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724865;
        bh=o0z1CX9zgBwNi/5coVAOQuBt/Vh7tSaDqWRWGlBBG8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4yhKmdiu2tTBRNqsFc/dJshcKPfFIDEzW5mRQnCUadY0I1I+F28XPyA1ojAdMC3U
         TjQfx/oh/0sFbO+H+Y40KYQL8/2SPefxpN32ThZOMFnfzCJj0nM1LSRNxInIPe/TBo
         0aBYspFixYMotTRN3jdeXgNUPdlF39vu2d6hu2yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 13/42] mm: Fix mremap not considering huge pmd devmap
Date:   Tue,  9 Jun 2020 19:44:19 +0200
Message-Id: <20200609174016.911176319@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fan Yang <Fan_Yang@sjtu.edu.cn>

commit 5bfea2d9b17f1034a68147a8b03b9789af5700f9 upstream.

The original code in mm/mremap.c checks huge pmd by:

		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd)) {

However, a DAX mapped nvdimm is mapped as huge page (by default) but it
is not transparent huge page (_PAGE_PSE | PAGE_DEVMAP).  This commit
changes the condition to include the case.

This addresses CVE-2020-10757.

Fixes: 5c7fb56e5e3f ("mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd")
Cc: <stable@vger.kernel.org>
Reported-by: Fan Yang <Fan_Yang@sjtu.edu.cn>
Signed-off-by: Fan Yang <Fan_Yang@sjtu.edu.cn>
Tested-by: Fan Yang <Fan_Yang@sjtu.edu.cn>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/pgtable.h |    1 +
 mm/mremap.c                    |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -203,6 +203,7 @@ static inline int pmd_large(pmd_t pte)
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/* NOTE: when predicate huge page, consider also pmd_devmap, or use pmd_large */
 static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -212,7 +212,7 @@ unsigned long move_page_tables(struct vm
 		new_pmd = alloc_new_pmd(vma->vm_mm, vma, new_addr);
 		if (!new_pmd)
 			break;
-		if (pmd_trans_huge(*old_pmd)) {
+		if (pmd_trans_huge(*old_pmd) || pmd_devmap(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE) {
 				bool moved;
 				/* See comment in move_ptes() */


