Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12D45EB117
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIZTPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiIZTPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92A74B0C8;
        Mon, 26 Sep 2022 12:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 824306126D;
        Mon, 26 Sep 2022 19:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A75C433D7;
        Mon, 26 Sep 2022 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219737;
        bh=9vsBVAObZKhaOauFi5FWHH4K1Rty2b6my4mz5BM+HEA=;
        h=Date:To:From:Subject:From;
        b=b48Mrb/u7hKwPltvCfkSsGpUjOsohZH+po51lLfZYKQYlXYQdB7+yzCU9rIZXHF7J
         6yJIJ+eXccp4mFRi9aWh5To/IlQIwKBZN8wlrHKzKwlV0A143OKpOdZqfOzNKBF/2u
         4hpHR4ctLWu74z+OkRxSICvZChdy3pN8Ue0UeBUg=
Date:   Mon, 26 Sep 2022 12:15:37 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        stable@vger.kernel.org, kirill.shutemov@linux.intel.com,
        saproj@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-bring-back-update_mmu_cache-to-finish_fault.patch removed from -mm tree
Message-Id: <20220926191537.D4A75C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: bring back update_mmu_cache() to finish_fault()
has been removed from the -mm tree.  Its filename was
     mm-bring-back-update_mmu_cache-to-finish_fault.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


