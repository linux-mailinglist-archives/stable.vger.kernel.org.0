Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535835F2292
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 12:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJBKZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 06:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJBKZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 06:25:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647A134701
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 03:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F764B80D24
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 10:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DC7C433D7;
        Sun,  2 Oct 2022 10:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664706334;
        bh=u5x4K6yKp9DuHCiSDv6/c5BbETLGFjocP8avscZpaBI=;
        h=Subject:To:Cc:From:Date:From;
        b=gC5Aj4AI8naAyauz74XpkNmjIiYJTEYjHobKcuvAXk3HX2AR1INsRsfJyLcj6fuVl
         s1y0whaMNNYaiYCCUsprCHbMIDi5njq5bHUmLu3OgKvCONVfw74T38pRECCWh46WPA
         FOsTzFHrCKKOrf0Mt/E9acfU5BFZgcNG9PM+xNno=
Subject: FAILED: patch "[PATCH] mm: bring back update_mmu_cache() to finish_fault()" failed to apply to 5.15-stable tree
To:     saproj@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 12:26:12 +0200
Message-ID: <166470637251232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

70427f6e9ecf ("mm: bring back update_mmu_cache() to finish_fault()")
f46f2adecdcc ("mm: check against orig_pte for finish_fault()")
c89357e27f20 ("mm: support GUP-triggered unsharing of anonymous pages")
6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
6c54dc6c7437 ("mm/rmap: use page_move_anon_rmap() when reusing a mapped PageAnon() page exclusively")
28c5209dfd5f ("mm/rmap: pass rmap flags to hugepage_add_anon_rmap()")
f1e2db12e45b ("mm/rmap: remove do_page_add_anon_rmap()")
14f9135d5470 ("mm/rmap: convert RMAP flags to a proper distinct rmap_t type")
fb3d824d1a46 ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()")
b51ad4f8679e ("mm/memory: slightly simplify copy_present_pte()")
623a1ddfeb23 ("mm/hugetlb: take src_mm->write_protect_seq in copy_hugetlb_page_range()")
3bff7e3f1f16 ("mm/huge_memory: streamline COW logic in do_huge_pmd_wp_page()")
c145e0b47c77 ("mm: streamline COW logic in do_swap_page()")
84d60fdd3733 ("mm: slightly clarify KSM logic in do_swap_page()")
53a05ad9f21d ("mm: optimize do_wp_page() for exclusive pages in the swapcache")
9030fb0bb9d6 ("Merge tag 'folio-5.18c' of git://git.infradead.org/users/willy/pagecache")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 70427f6e9ecfc8c5f977b21dd9f846b3bda02500 Mon Sep 17 00:00:00 2001
From: Sergei Antonov <saproj@gmail.com>
Date: Thu, 8 Sep 2022 23:48:09 +0300
Subject: [PATCH] mm: bring back update_mmu_cache() to finish_fault()

Running this test program on ARMv4 a few times (sometimes just once)
reproduces the bug.

int main()
{
        unsigned i;
        char paragon[SIZE];
        void* ptr;

        memset(paragon, 0xAA, SIZE);
        ptr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
                   MAP_ANON | MAP_SHARED, -1, 0);
        if (ptr == MAP_FAILED) return 1;
        printf("ptr = %p\n", ptr);
        for (i=0;i<10000;i++){
                memset(ptr, 0xAA, SIZE);
                if (memcmp(ptr, paragon, SIZE)) {
                        printf("Unexpected bytes on iteration %u!!!\n", i);
                        break;
                }
        }
        munmap(ptr, SIZE);
}

In the "ptr" buffer there appear runs of zero bytes which are aligned
by 16 and their lengths are multiple of 16.

Linux v5.11 does not have the bug, "git bisect" finds the first bad commit:
f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")

Before the commit update_mmu_cache() was called during a call to
filemap_map_pages() as well as finish_fault(). After the commit
finish_fault() lacks it.

Bring back update_mmu_cache() to finish_fault() to fix the bug.
Also call update_mmu_tlb() only when returning VM_FAULT_NOPAGE to more
closely reproduce the code of alloc_set_pte() function that existed before
the commit.

On many platforms update_mmu_cache() is nop:
 x86, see arch/x86/include/asm/pgtable
 ARMv6+, see arch/arm/include/asm/tlbflush.h
So, it seems, few users ran into this bug.

Link: https://lkml.kernel.org/r/20220908204809.2012451-1-saproj@gmail.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/memory.c b/mm/memory.c
index 4ba73f5aa8bb..a78814413ac0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4386,14 +4386,20 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
-	ret = 0;
+
 	/* Re-check under ptl */
-	if (likely(!vmf_pte_changed(vmf)))
+	if (likely(!vmf_pte_changed(vmf))) {
 		do_set_pte(vmf, page, vmf->address);
-	else
+
+		/* no need to invalidate: a not-present page won't be cached */
+		update_mmu_cache(vma, vmf->address, vmf->pte);
+
+		ret = 0;
+	} else {
+		update_mmu_tlb(vma, vmf->address, vmf->pte);
 		ret = VM_FAULT_NOPAGE;
+	}
 
-	update_mmu_tlb(vma, vmf->address, vmf->pte);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 }

