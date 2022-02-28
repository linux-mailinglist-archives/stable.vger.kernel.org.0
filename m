Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486BB4C7707
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiB1SLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241390AbiB1SJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB1B3E5E;
        Mon, 28 Feb 2022 09:49:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A8BE60F8F;
        Mon, 28 Feb 2022 17:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEBCC340F9;
        Mon, 28 Feb 2022 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070554;
        bh=OY596WIL6683eNLWVDikS943L4hwUNIJ4UVKz0FbyRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jF2LFTlfkc6i1N/+LjlIWCxkYOixsxtY+Jv061jFFFEueNYYtAaW5tR6h+2IAdIfM
         mRriXxSyM+Jxskgp4zf57NkJWkQ431WblABXv9mJ7dEKkCm/3SJrdbZSkFJwGqPPtX
         ox5QUh/eDkJrJIa9Opadp41Y7KahwesKx0wtNzd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 152/164] mm/hugetlb: fix kernel crash with hugetlb mremap
Date:   Mon, 28 Feb 2022 18:25:14 +0100
Message-Id: <20220228172413.566529308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit db110a99d3367936058727ff4798e3a39c707969 upstream.

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
    move_hugetlb_page_tables+0x4e4/0x5b0 (link register)
    move_hugetlb_page_tables+0x22c/0x5b0 (unreliable)
    move_page_tables+0xdbc/0x1010
    move_vma+0x254/0x5f0
    sys_mremap+0x7c0/0x900
    system_call_exception+0x160/0x2c0

the kernel can't use huge_pte_offset before it set the pte entry because
a page table lookup check for huge PTE bit in the page table to
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 61895cc01d09..e57650a9404f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4851,14 +4851,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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
 
@@ -4917,7 +4916,7 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 		if (!dst_pte)
 			break;
 
-		move_huge_pte(vma, old_addr, new_addr, src_pte);
+		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte);
 	}
 	flush_tlb_range(vma, old_end - len, old_end);
 	mmu_notifier_invalidate_range_end(&range);
-- 
2.35.1



