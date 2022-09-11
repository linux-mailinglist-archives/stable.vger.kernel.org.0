Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D25B51E1
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 01:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIKXXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 19:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiIKXXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 19:23:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F80A2655C;
        Sun, 11 Sep 2022 16:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB0C661035;
        Sun, 11 Sep 2022 23:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5CDC433D6;
        Sun, 11 Sep 2022 23:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938590;
        bh=au9b+SQHjNH9FxENMrkhGfd5grkei92y/Qq+VMSO4e8=;
        h=Date:To:From:Subject:From;
        b=HafiCVRhW4wEEf3hgzfa+TesublxThdJLbzH9jL3+fTmHmUP0h6+EyXNNnVHI6Reo
         oeKannt9CD+o+hZYn+bOIq+AevMGaqhPSE2A4zgSpyg6gB7J7Nbh8FCO7brDXpIMly
         uryFRI1Qnnk6Z6s2vxKVXwEztz+NUHoEHICMcl7o=
Date:   Sun, 11 Sep 2022 16:23:09 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, stable@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, paulus@ozlabs.org, nadav.amit@gmail.com,
        lyude@redhat.com, logang@deltatee.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jgg@nvidia.com, huang.ying.caritas@gmail.com,
        Felix.Kuehling@amd.com, david@redhat.com, bskeggs@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch removed from -mm tree
Message-Id: <20220911232310.2A5CDC433D6@smtp.kernel.org>
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
     Subject: mm/migrate_device.c: copy pte dirty bit to page
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: copy pte dirty bit to page
Date: Fri, 2 Sep 2022 10:35:53 +1000

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
---

 mm/migrate_device.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-copy-pte-dirty-bit-to-page
+++ a/mm/migrate_device.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <linux/memremap.h>
 #include <linux/migrate.h>
+#include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/oom.h>
@@ -196,7 +197,7 @@ again:
 			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				ptep_clear_flush(vma, addr, ptep);
+				pte = ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
@@ -206,11 +207,15 @@ again:
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
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch
mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

