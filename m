Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C1570BBD
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 22:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiGKU2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 16:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiGKU2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 16:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27160814A0;
        Mon, 11 Jul 2022 13:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E6116160E;
        Mon, 11 Jul 2022 20:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95ECC341C0;
        Mon, 11 Jul 2022 20:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657571186;
        bh=MsUPYVM2OliJqD7tBhTdBbemW3qATIT+p1+8SDLV5ck=;
        h=Date:To:From:Subject:From;
        b=DRZHydq1Z/pa15YhjoMpHHXiWD+coEOyg6r2pkbu+HxuqWvRNfrffNELXDnNxCpEG
         BbfF9zSfadzGDx/b2MJoWiShJ0FXDqPgDxNEsrMhkascs8iBSNZP9oRQTmf0BNYV5M
         9NdCQsmRdB00AWOFSbyMm4FvfoL0SAgMEww3K5NQ=
Date:   Mon, 11 Jul 2022 13:26:24 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch added to mm-hotfixes-unstable branch
Message-Id: <20220711202625.E95ECC341C0@smtp.kernel.org>
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
     Subject: hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte
Date: Sat, 9 Jul 2022 17:26:29 +0800

When alloc_huge_page fails, *pagep is set to NULL without put_page first.
So the hugepage indicated by *pagep is leaked.

Link: https://lkml.kernel.org/r/20220709092629.54291-1-linmiaohe@huawei.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

hugetlb-fix-memoryleak-in-hugetlb_mcopy_atomic_pte.patch
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

