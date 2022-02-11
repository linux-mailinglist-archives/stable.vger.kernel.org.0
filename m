Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A504B2041
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiBKIhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:37:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346945AbiBKIhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:37:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB5FE5B;
        Fri, 11 Feb 2022 00:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47EA9B828B0;
        Fri, 11 Feb 2022 08:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF0CC340E9;
        Fri, 11 Feb 2022 08:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644568655;
        bh=5c6KBaaLTHrMX1kA30FbMcSSSlzks4MU7Z7WSXf9qG4=;
        h=Date:To:From:Subject:From;
        b=Z8L6EPOmclxffQLAp9tVs7/e/xkfxT92+KCkLGIVa0HtTHYqAvtfqXD6ny+OPVrcE
         vjindQr17pvb9AxIu033pmcOzJjXULuSvJWm7GvUSaBfwo2DnZfEnrX4EOzWhmUBtj
         gPJfK1rlDUhQxf21BmTLfO9wUB0+diLXMRCsf7OI=
Date:   Fri, 11 Feb 2022 00:37:35 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, almasrymina@google.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-kernel-crash-with-hugetlb-mremap.patch added to -mm tree
Message-Id: <20220211083735.CAF0CC340E9@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix kernel crash with hugetlb mremap
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-kernel-crash-with-hugetlb-mremap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/hugetlb: fix kernel crash with hugetlb mremap

This fixes the below crash:

kernel BUG at include/linux/mm.h:2373!
cpu 0x5d: Vector: 700 (Program Check) at [c00000003c6e76e0]
    pc: c000000000581a54: pmd_to_page+0x54/0x80
    lr: c00000000058d184: move_hugetlb_page_tables+0x4e4/0x5b0
    sp: c00000003c6e7980
   msr: 9000000000029033
  current = 0xc00000003bd8d980
  paca    = 0xc000200fff610100   irqmask: 0x03   irq_happened: 0x01
    pid   = 9349, comm = hugepage-mremap
kernel BUG at include/linux/mm.h:2373!
[link register   ] c00000000058d184 move_hugetlb_page_tables+0x4e4/0x5b0
[c00000003c6e7980] c00000000058cecc move_hugetlb_page_tables+0x22c/0x5b0 (unreliable)
[c00000003c6e7a90] c00000000053b78c move_page_tables+0xdbc/0x1010
[c00000003c6e7bd0] c00000000053bc34 move_vma+0x254/0x5f0
[c00000003c6e7c90] c00000000053c790 sys_mremap+0x7c0/0x900
[c00000003c6e7db0] c00000000002c450 system_call_exception+0x160/0x2c0

the kernel can't use huge_pte_offset before it set the pte entry because a
page table lookup check for huge PTE bit in the page table to
differentiate between a huge pte entry and a pointer to pte page.  A
huge_pte_alloc won't mark the page table entry huge and hence kernel
should not use huge_pte_offset after a huge_pte_alloc.

Link: https://lkml.kernel.org/r/20220211063221.99293-1-aneesh.kumar@linux.ibm.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-fix-kernel-crash-with-hugetlb-mremap
+++ a/mm/hugetlb.c
@@ -4851,14 +4851,13 @@ again:
 }
 
 static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
-			  unsigned long new_addr, pte_t *src_pte)
+			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
-	pte_t *dst_pte, pte;
 	spinlock_t *src_ptl, *dst_ptl;
+	pte_t pte;
 
-	dst_pte = huge_pte_offset(mm, new_addr, huge_page_size(h));
 	dst_ptl = huge_pte_lock(h, mm, dst_pte);
 	src_ptl = huge_pte_lockptr(h, mm, src_pte);
 
@@ -4917,7 +4916,7 @@ int move_hugetlb_page_tables(struct vm_a
 		if (!dst_pte)
 			break;
 
-		move_huge_pte(vma, old_addr, new_addr, src_pte);
+		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte);
 	}
 	flush_tlb_range(vma, old_end - len, old_end);
 	mmu_notifier_invalidate_range_end(&range);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugetlb-fix-kernel-crash-with-hugetlb-mremap.patch

