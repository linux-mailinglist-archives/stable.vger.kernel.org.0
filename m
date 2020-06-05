Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F981EFA66
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgFEORP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgFEORN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A3A206A2;
        Fri,  5 Jun 2020 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366632;
        bh=3Vm5TjOSQhMNc3SNvzYPdmBcWA0iDVpz8xDLk1V4c00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMnVBKcqJXPHuJmy984J+Da/V0ZHO9N98UI6xPtop2DZvyoBAxyOXAMF1KEt92P8G
         puEun4euMBXqsNHg9ibUu6bA1RtnaeB3vRjlkkC3+7rfCjjI/tEXx7JnjQ8xnpWCBY
         bPqeSUMWjs42AA24t7bghgTWsUk/Ge38Q+ZOuWO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 31/43] mm: Fix mremap not considering huge pmd devmap
Date:   Fri,  5 Jun 2020 16:15:01 +0200
Message-Id: <20200605140154.154168800@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
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
@@ -256,6 +256,7 @@ static inline int pmd_large(pmd_t pte)
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/* NOTE: when predicate huge page, consider also pmd_devmap, or use pmd_large */
 static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -266,7 +266,7 @@ unsigned long move_page_tables(struct vm
 		new_pmd = alloc_new_pmd(vma->vm_mm, vma, new_addr);
 		if (!new_pmd)
 			break;
-		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd)) {
+		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd) || pmd_devmap(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE) {
 				bool moved;
 				/* See comment in move_ptes() */


