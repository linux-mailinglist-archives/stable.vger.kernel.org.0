Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2928457744B
	for <lists+stable@lfdr.de>; Sun, 17 Jul 2022 06:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiGQEho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 00:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGQEhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 00:37:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD932183A;
        Sat, 16 Jul 2022 21:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF94060FAD;
        Sun, 17 Jul 2022 04:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD69C341C0;
        Sun, 17 Jul 2022 04:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032660;
        bh=g+TH/ezThdO+ZUxOPkbP7szduzuheuHOtaQ1HZ+X2IU=;
        h=Date:To:From:Subject:From;
        b=g7FZsDHGT1HWk4TZj6zNBZGMzIID+NTalTCXFs+W3wxCxK4GOYjQFiUfrSHSdP9xh
         g3jTCRX0KZ9+4RID6ZD548HNbIRnFZTps33A3+0d+EinFqJR7vqrLWnYMWX05mQNez
         hHSTgsE33MFV9fRrHnthS5yMtYJimq03Hy7goYYA=
Date:   Sat, 16 Jul 2022 21:37:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, anshuman.khandual@arm.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch removed from -mm tree
Message-Id: <20220717043740.2CD69C341C0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte
Date: Sat, 9 Jul 2022 17:26:29 +0800

When alloc_huge_page fails, *pagep is set to NULL without put_page first.
So the hugepage indicated by *pagep is leaked.

Link: https://lkml.kernel.org/r/20220709092629.54291-1-linmiaohe@huawei.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte
+++ a/mm/hugetlb.c
@@ -5952,6 +5952,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
 		if (IS_ERR(page)) {
+			put_page(*pagep);
 			ret = -ENOMEM;
 			*pagep = NULL;
 			goto out;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd.patch
mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch
mm-huge_memory-fix-comment-of-__pud_trans_huge_lock.patch
mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch
mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch
mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd.patch
mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid.patch
mm-huge_memory-use-helper-macro-__attr_rw.patch
mm-huge_memory-fix-comment-in-zap_huge_pud.patch
mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd.patch
mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible.patch
mm-huge_memory-minor-cleanup-for-split_huge_pages_all.patch
mm-huge_memory-fix-comment-of-page_deferred_list.patch
mm-huge_memory-correct-comment-of-prep_transhuge_page.patch
mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch
mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid.patch
mm-page_vma_mappedc-use-helper-function-huge_pte_lock.patch
mm-mmap-fix-obsolete-comment-of-find_extend_vma.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

