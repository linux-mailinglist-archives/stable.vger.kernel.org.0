Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A74564A5A
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 00:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiGCWnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 18:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiGCWnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 18:43:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0711D0;
        Sun,  3 Jul 2022 15:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822D761230;
        Sun,  3 Jul 2022 22:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD677C341CA;
        Sun,  3 Jul 2022 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888227;
        bh=IQMXyxNM4abdWZZR5gbOtEBVM8W9XbSHb2PLmyPyrtU=;
        h=Date:To:From:Subject:From;
        b=VY/p/UoYiyvTi4pWXorKZNEftM5NvTlyK+JUUm3KKmTRQErIJR5p3lIq62lA9/4eF
         QRsYSzS84DCpmxsR9LMzxTymrWXcdlhSPw6DPBhnfuUj1pyqRXwgUUfRUTEknXwI4b
         IvJSZMuQnEP6go/w378pI/e0Mz/9sXgXOLVetNJE=
Date:   Sun, 03 Jul 2022 15:43:47 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-sparsemem-fix-missing-higher-order-allocation-splitting.patch removed from -mm tree
Message-Id: <20220703224347.CD677C341CA@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: sparsemem: fix missing higher order allocation splitting
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-fix-missing-higher-order-allocation-splitting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: sparsemem: fix missing higher order allocation splitting
Date: Mon, 20 Jun 2022 10:30:19 +0800

Higher order allocations for vmemmap pages from buddy allocator must be
able to be treated as indepdenent small pages as they can be freed
individually by the caller.  There is no problem for higher order vmemmap
pages allocated at boot time since each individual small page will be
initialized at boot time.  However, it will be an issue for memory hotplug
case since those higher order vmemmap pages are allocated from buddy
allocator without initializing each individual small page's refcount.  The
system will panic in put_page_testzero() when CONFIG_DEBUG_VM is enabled
if the vmemmap page is freed.

Link: https://lkml.kernel.org/r/20220620023019.94257-1-songmuchun@bytedance.com
Fixes: d8d55f5616cf ("mm: sparsemem: use page table lock to protect kernel pmd operations")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/sparse-vmemmap.c~mm-sparsemem-fix-missing-higher-order-allocation-splitting
+++ a/mm/sparse-vmemmap.c
@@ -78,6 +78,14 @@ static int __split_vmemmap_huge_pmd(pmd_
 
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pmd_leaf(*pmd))) {
+		/*
+		 * Higher order allocations from buddy allocator must be able to
+		 * be treated as indepdenent small pages (as they can be freed
+		 * individually).
+		 */
+		if (!PageReserved(page))
+			split_page(page, get_order(PMD_SIZE));
+
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

