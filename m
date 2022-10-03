Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E45F5F2952
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiJCHRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiJCHQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ED146602;
        Mon,  3 Oct 2022 00:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1484B80E6B;
        Mon,  3 Oct 2022 07:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BD9C433C1;
        Mon,  3 Oct 2022 07:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781229;
        bh=X1Hz+u9FsRDHqr1BOnIwNn2OeuPOmZB0yb2KcNknYag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLPblokSRcXIAQUS3uyFOW5IyMUoSpYhbUk7FjSKj/A07iSPqqg+0miWdSMsVYHhn
         WV6UYzJiVjajSYi/0My1FobfraaWtoo+f5ZqO5WBLszZmBX/1hak/dBZ+H9KNlKPHH
         LjW1FKOTWymYPyIKiidKB/PReQvzUeQJ3G9fg1UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 044/101] mm: bring back update_mmu_cache() to finish_fault()
Date:   Mon,  3 Oct 2022 09:10:40 +0200
Message-Id: <20221003070725.558888398@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Antonov <saproj@gmail.com>

commit 70427f6e9ecfc8c5f977b21dd9f846b3bda02500 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4378,14 +4378,20 @@ vm_fault_t finish_fault(struct vm_fault
 
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


