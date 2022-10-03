Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8B5F294C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJCHRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiJCHQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F06743174;
        Mon,  3 Oct 2022 00:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85E0BB80E6B;
        Mon,  3 Oct 2022 07:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6613C433D6;
        Mon,  3 Oct 2022 07:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781224;
        bh=FO6Ju2lN74Xn8cplvWUTK7Mf2MLEblUMhdcsRMe7v60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYHioe07XpxjvPovpCo52NlXxWB7W0KQNHYuIOJHDFQKXSOs9taMgGywvgNnHWdv5
         aoSr1SLShzS9IfXjXuurFehoMyN0I4QBLEzZ4vAbwq/WjzBhYK0QXpZPunK9DikxXq
         yNnMEYgvo1tTvgyvCU41fH3WQpYRHZGuQ9TINj0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Peter Xu <peterx@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Karol Herbst <kherbst@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Lyude Paul <lyude@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 042/101] mm/migrate_device.c: copy pte dirty bit to page
Date:   Mon,  3 Oct 2022 09:10:38 +0200
Message-Id: <20221003070725.513231234@linuxfoundation.org>
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

From: Alistair Popple <apopple@nvidia.com>

commit fd35ca3d12cc9922d7d9a35f934e72132dbc4853 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
@@ -190,7 +191,7 @@ again:
 			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				ptep_clear_flush(vma, addr, ptep);
+				pte = ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
@@ -200,11 +201,15 @@ again:
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


