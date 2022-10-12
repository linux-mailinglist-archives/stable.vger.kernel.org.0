Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44E5FCEA5
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 00:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJLW5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 18:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJLW5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 18:57:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283BE11C6FE;
        Wed, 12 Oct 2022 15:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BACB0B819BB;
        Wed, 12 Oct 2022 22:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F861C433D6;
        Wed, 12 Oct 2022 22:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615439;
        bh=BGQoCt6v92VMXJ/4SdRFCZH0IdSAVLlybHH/gzwxFUg=;
        h=Date:To:From:Subject:From;
        b=amejY5gcrKvMmaroygjOoAQHUIpKSRLM0aoMMK+PXjV4ZOvyiOH38Wtd5jhQPuz0l
         kTnhgBDKGjR5/EyHGbYYAuCFD0aAVFsv270AkB0+iVwKeTln/BxXcfrab4tYgIXjmt
         doDqUl0eGTmcR6jYafXDsug9ZPqSwvKc7ocB8ayk=
Date:   Wed, 12 Oct 2022 15:57:18 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+2b9b4f0895be09a6dec3@syzkaller.appspotmail.com,
        stable@vger.kernel.org, mike.kravetz@oracle.com,
        liushixin2@huawei.com, edliaw@google.com, bgeffon@google.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch removed from -mm tree
Message-Id: <20221012225719.4F861C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in
has been removed from the -mm tree.  Its filename was
     mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in
Date: Fri, 30 Sep 2022 20:25:55 -0400

When PTE_MARKER_UFFD_WP not configured, it's still possible to reach pte
marker code and trigger an warning. Add a few CONFIG_PTE_MARKER_UFFD_WP
ifdefs to make sure the code won't be reached when not compiled in.

Link: https://lkml.kernel.org/r/YzeR+R6b4bwBlBHh@x1n
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: <syzbot+2b9b4f0895be09a6dec3@syzkaller.appspotmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Edward Liaw <edliaw@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    4 ++++
 mm/memory.c   |    2 ++
 mm/mprotect.c |    2 ++
 3 files changed, 8 insertions(+)

--- a/mm/hugetlb.c~mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/hugetlb.c
@@ -5096,6 +5096,7 @@ static void __unmap_hugepage_range(struc
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to
@@ -5107,6 +5108,7 @@ static void __unmap_hugepage_range(struc
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 			else
+#endif
 				huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
@@ -5135,11 +5137,13 @@ static void __unmap_hugepage_range(struc
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP));
+#endif
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
 
--- a/mm/memory.c~mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/memory.c
@@ -1393,10 +1393,12 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte,
 			      struct zap_details *details, pte_t pteval)
 {
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	if (zap_drop_file_uffd_wp(details))
 		return;
 
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
+#endif
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
--- a/mm/mprotect.c~mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/mprotect.c
@@ -267,6 +267,7 @@ static unsigned long change_pte_range(st
 		} else {
 			/* It must be an none page, or what else?.. */
 			WARN_ON_ONCE(!pte_none(oldpte));
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			if (unlikely(uffd_wp && !vma_is_anonymous(vma))) {
 				/*
 				 * For file-backed mem, we need to be able to
@@ -278,6 +279,7 @@ static unsigned long change_pte_range(st
 					   make_pte_marker(PTE_MARKER_UFFD_WP));
 				pages++;
 			}
+#endif
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch
mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch
mm-selftest-uffd-explain-the-write-missing-fault-check.patch

