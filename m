Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537F85F228F
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 12:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJBKZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 06:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJBKZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 06:25:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4E322B15
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 03:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FB8B80D20
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 10:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE489C433C1;
        Sun,  2 Oct 2022 10:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664706296;
        bh=pbnr1zTMe8g5uz8OzFyR8vyN2BxIrsrOOnPiroxbwKk=;
        h=Subject:To:Cc:From:Date:From;
        b=Nj4B40tGo1JaUylkvowklrzFHVJswmb+aRG33pMwPHT7Be2ljdht38Osr+bKjf2md
         plGX1691SpWXKgMMZ40SZEJF24GyC2UmVk0BJ6RqWvSKtq7bVZ+p2xDSpn0l+PAF59
         V3NxwJo0kL065WjCjmbXba2cMg/AIipuZGwK1cTE=
Subject: FAILED: patch "[PATCH] mm/migrate_device.c: copy pte dirty bit to page" failed to apply to 5.4-stable tree
To:     apopple@nvidia.com, Felix.Kuehling@amd.com,
        akpm@linux-foundation.org, alex.sierra@amd.com, bskeggs@redhat.com,
        david@redhat.com, huang.ying.caritas@gmail.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kherbst@redhat.com, logang@deltatee.com,
        lyude@redhat.com, nadav.amit@gmail.com, paulus@ozlabs.org,
        peterx@redhat.com, rcampbell@nvidia.com, stable@vger.kernel.org,
        willy@infradead.org, ying.huang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 12:25:31 +0200
Message-ID: <166470633121029@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
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

From fd35ca3d12cc9922d7d9a35f934e72132dbc4853 Mon Sep 17 00:00:00 2001
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 2 Sep 2022 10:35:53 +1000
Subject: [PATCH] mm/migrate_device.c: copy pte dirty bit to page

migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
installs migration entries directly if it can lock the migrating page.
When removing a dirty pte the dirty bit is supposed to be carried over to
the underlying page to prevent it being lost.

Currently migrate_vma_*() can only be used for private anonymous mappings.
That means loss of the dirty bit usually doesn't result in data loss
because these pages are typically not file-backed.  However pages may be
backed by swap storage which can result in data loss if an attempt is made
to migrate a dirty page that doesn't yet have the PageDirty flag set.

In this case migration will fail due to unexpected references but the
dirty pte bit will be lost.  If the page is subsequently reclaimed data
won't be written back to swap storage as it is considered uptodate,
resulting in data loss if the page is subsequently accessed.

Prevent this by copying the dirty bit to the page when removing the pte to
match what try_to_migrate_one() does.

Link: https://lkml.kernel.org/r/dd48e4882ce859c295c1a77612f66d198b0403f9.1662078528.git-series.apopple@nvidia.com
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 4cc849c3b54c..dbf6c7a7a7c9 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <linux/memremap.h>
 #include <linux/migrate.h>
+#include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/oom.h>
@@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				ptep_clear_flush(vma, addr, ptep);
+				pte = ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
@@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					goto next;
 				}
 			} else {
-				ptep_get_and_clear(mm, addr, ptep);
+				pte = ptep_get_and_clear(mm, addr, ptep);
 			}
 
 			migrate->cpages++;
 
+			/* Set the dirty flag on the folio now the pte is gone. */
+			if (pte_dirty(pte))
+				folio_mark_dirty(page_folio(page));
+
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
 				entry = make_writable_migration_entry(

