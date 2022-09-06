Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8C5AE9CA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbiIFNgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240601AbiIFNfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BA4785AB;
        Tue,  6 Sep 2022 06:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1C061545;
        Tue,  6 Sep 2022 13:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F573C433C1;
        Tue,  6 Sep 2022 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471247;
        bh=Y41acJnPbIPvCDAOYp8tN09jfsIFrbQaNS7WKC7F12M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsc5OqTS9O+o8v9kirzHC3QKyg25fWKRUqgjSjf4qwRBiQ6jNiOc2g5EoqI/KqQrq
         lZ5k7CG/hPkZBMPDwaDEYxFXEc/FmZpiIIPQC7GXKao/7AdcGMlDabnRk/C0UX0gM9
         +YrUCVr7N8c8TRfNJXyNLoRMGRYqseevToBsie6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Steven Price <steven.price@arm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/80] mm: pagewalk: Fix race between unmap and page walker
Date:   Tue,  6 Sep 2022 15:30:43 +0200
Message-Id: <20220906132818.928764652@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 8782fb61cc848364e1e1599d76d3c9dd58a1cc06 ]

The mmap lock protects the page walker from changes to the page tables
during the walk.  However a read lock is insufficient to protect those
areas which don't have a VMA as munmap() detaches the VMAs before
downgrading to a read lock and actually tearing down PTEs/page tables.

For users of walk_page_range() the solution is to simply call pte_hole()
immediately without checking the actual page tables when a VMA is not
present. We now never call __walk_page_range() without a valid vma.

For walk_page_range_novma() the locking requirements are tightened to
require the mmap write lock to be taken, and then walking the pgd
directly with 'no_vma' set.

This in turn means that all page walkers either have a valid vma, or
it's that special 'novma' case for page table debugging.  As a result,
all the odd '(!walk->vma && !walk->no_vma)' tests can be removed.

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/pageattr.c |  4 ++--
 mm/pagewalk.c            | 21 ++++++++++++---------
 mm/ptdump.c              |  4 ++--
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 19fecb362d815..09f6be19ba7b3 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -118,10 +118,10 @@ static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
 	if (!numpages)
 		return 0;
 
-	mmap_read_lock(&init_mm);
+	mmap_write_lock(&init_mm);
 	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
 				     &masks);
-	mmap_read_unlock(&init_mm);
+	mmap_write_unlock(&init_mm);
 
 	flush_tlb_kernel_range(start, end);
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index e81640d9f1770..371ec21a19899 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -71,7 +71,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	do {
 again:
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) || (!walk->vma && !walk->no_vma)) {
+		if (pmd_none(*pmd)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, depth, walk);
 			if (err)
@@ -129,7 +129,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 	do {
  again:
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud) || (!walk->vma && !walk->no_vma)) {
+		if (pud_none(*pud)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, depth, walk);
 			if (err)
@@ -318,19 +318,19 @@ static int __walk_page_range(unsigned long start, unsigned long end,
 	struct vm_area_struct *vma = walk->vma;
 	const struct mm_walk_ops *ops = walk->ops;
 
-	if (vma && ops->pre_vma) {
+	if (ops->pre_vma) {
 		err = ops->pre_vma(start, end, walk);
 		if (err)
 			return err;
 	}
 
-	if (vma && is_vm_hugetlb_page(vma)) {
+	if (is_vm_hugetlb_page(vma)) {
 		if (ops->hugetlb_entry)
 			err = walk_hugetlb_range(start, end, walk);
 	} else
 		err = walk_pgd_range(start, end, walk);
 
-	if (vma && ops->post_vma)
+	if (ops->post_vma)
 		ops->post_vma(walk);
 
 	return err;
@@ -402,9 +402,13 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 		if (!vma) { /* after the last vma */
 			walk.vma = NULL;
 			next = end;
+			if (ops->pte_hole)
+				err = ops->pte_hole(start, next, -1, &walk);
 		} else if (start < vma->vm_start) { /* outside vma */
 			walk.vma = NULL;
 			next = min(end, vma->vm_start);
+			if (ops->pte_hole)
+				err = ops->pte_hole(start, next, -1, &walk);
 		} else { /* inside vma */
 			walk.vma = vma;
 			next = min(end, vma->vm_end);
@@ -422,9 +426,8 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 			}
 			if (err < 0)
 				break;
-		}
-		if (walk.vma || walk.ops->pte_hole)
 			err = __walk_page_range(start, next, &walk);
+		}
 		if (err)
 			break;
 	} while (start = next, start < end);
@@ -453,9 +456,9 @@ int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 
-	mmap_assert_locked(walk.mm);
+	mmap_assert_write_locked(walk.mm);
 
-	return __walk_page_range(start, end, &walk);
+	return walk_pgd_range(start, end, &walk);
 }
 
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 93f2f63dc52dc..a917bf55c61ea 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -141,13 +141,13 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 {
 	const struct ptdump_range *range = st->range;
 
-	mmap_read_lock(mm);
+	mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
-	mmap_read_unlock(mm);
+	mmap_write_unlock(mm);
 
 	/* Flush out the last page */
 	st->note_page(st, 0, -1, 0);
-- 
2.35.1



