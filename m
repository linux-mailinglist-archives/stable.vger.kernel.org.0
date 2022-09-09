Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834DE5B418E
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 23:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiIIVlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 17:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiIIVlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 17:41:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D08133A18;
        Fri,  9 Sep 2022 14:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85CAF620F0;
        Fri,  9 Sep 2022 21:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB2C433D7;
        Fri,  9 Sep 2022 21:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759677;
        bh=Loma5kjli1hRx5nh9T5jYPU7tWkgTs9wosoJfDY4NCM=;
        h=Date:To:From:Subject:From;
        b=iG9iUqFJ6RqWxhsVLC2hW31y21CIG/WHkcO7Bt+2qevE1opFq5PTx2HKnkiMFUxmL
         pX/6wC5igWDc/1gXY69g4Vi6kTn3HNXbWlygO+VzduXJRDBZkgEggeirqqMNZDsnoP
         PKhqTjUyFoaYkKtiwFj0iYuOCUyT/h6C+uXuUtgg=
Date:   Fri, 09 Sep 2022 14:41:16 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        stable@vger.kernel.org, kirill.shutemov@linux.intel.com,
        saproj@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bring-back-update_mmu_cache-to-finish_fault.patch added to mm-hotfixes-unstable branch
Message-Id: <20220909214116.DCEB2C433D7@smtp.kernel.org>
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
     Subject: mm: bring back update_mmu_cache() to finish_fault()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-bring-back-update_mmu_cache-to-finish_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bring-back-update_mmu_cache-to-finish_fault.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: mm: bring back update_mmu_cache() to finish_fault()
Date: Thu, 8 Sep 2022 23:48:09 +0300

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
---

 mm/memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-bring-back-update_mmu_cache-to-finish_fault
+++ a/mm/memory.c
@@ -4386,14 +4386,20 @@ vm_fault_t finish_fault(struct vm_fault
 
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
_

Patches currently in -mm which might be from saproj@gmail.com are

mm-bring-back-update_mmu_cache-to-finish_fault.patch

