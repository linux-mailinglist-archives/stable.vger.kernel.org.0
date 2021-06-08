Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C53A03D6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhFHTWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237540AbhFHTSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63EAA61968;
        Tue,  8 Jun 2021 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178325;
        bh=vf4g9+7pLkPtd5fZZBgWPVzXF/IPo59BxxDUlb+KKNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkccb+kwCPYGSyv30VqEi1crbJihAQTqs3R5R8n/5IDG/R5mCfQjyE3qjJxD2x+s9
         7KSPqVsJvT2XgGLeYN4Ov1j+NptxodwMTBWjLiz2+vpqKezzdZc/hDCjy6EV7g+4OG
         QOV96IQ0j8MZjeBuNfqBOociWA5mJ4GG1eVAAk6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 127/161] mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()
Date:   Tue,  8 Jun 2021 20:27:37 +0200
Message-Id: <20210608175949.738173938@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 04f7ce3f07ce39b1a3ca03a56b238a53acc52cfd upstream.

In pmd/pud_advanced_tests(), the vaddr is aligned up to the next pmd/pud
entry, and so it does not match the given pmdp/pudp and (aligned down)
pfn any more.

For s390, this results in memory corruption, because the IDTE
instruction used e.g.  in xxx_get_and_clear() will take the vaddr for
some calculations, in combination with the given pmdp.  It will then end
up with a wrong table origin, ending on ...ff8, and some of those
wrongly set low-order bits will also select a wrong pagetable level for
the index addition.  IDTE could therefore invalidate (or 0x20) something
outside of the page tables, depending on the wrongly picked index, which
in turn depends on the random vaddr.

As result, we sometimes see "BUG task_struct (Not tainted): Padding
overwritten" on s390, where one 0x5a padding value got overwritten with
0x7a.

Fix this by aligning down, similar to how the pmd/pud_aligned pfns are
calculated.

Link: https://lkml.kernel.org/r/20210525130043.186290-2-gerald.schaefer@linux.ibm.com
Fixes: a5c3b9ffb0f40 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/debug_vm_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -192,7 +192,7 @@ static void __init pmd_advanced_tests(st
 
 	pr_debug("Validating PMD advanced\n");
 	/* Align the address wrt HPAGE_PMD_SIZE */
-	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
+	vaddr &= HPAGE_PMD_MASK;
 
 	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
 
@@ -330,7 +330,7 @@ static void __init pud_advanced_tests(st
 
 	pr_debug("Validating PUD advanced\n");
 	/* Align the address wrt HPAGE_PUD_SIZE */
-	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
+	vaddr &= HPAGE_PUD_MASK;
 
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_set_wrprotect(mm, vaddr, pudp);


