Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E575F2286
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 12:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJBKYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 06:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJBKYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 06:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A76303F5
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 03:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FAE1B80D1E
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 10:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60EFC433D6;
        Sun,  2 Oct 2022 10:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664706268;
        bh=v9HShWcWu6eN1tGyFzh7tSUlLhS7yaG6MXweTYlYnnQ=;
        h=Subject:To:Cc:From:Date:From;
        b=gN49Qrwh4vnDQ0jX6CxmObNnBE5EujyRTDvIxPOR0SR2Tr3vVc1b5Q1Yp209caCms
         /qS8850x7MZ1PigzR0C9UDBDm+hMcIsjfajN9ykHWExO2MMZEp/s2wOSt1tD0Gfiko
         lsyT2XIlmLadJXU0u50rplTY4toejEey9waGH398=
Subject: FAILED: patch "[PATCH] mm/migrate_device.c: add missing flush_cache_page()" failed to apply to 5.4-stable tree
To:     apopple@nvidia.com, Felix.Kuehling@amd.com,
        akpm@linux-foundation.org, alex.sierra@amd.com, bskeggs@redhat.com,
        david@redhat.com, huang.ying.caritas@gmail.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kherbst@redhat.com, logang@deltatee.com,
        lyude@redhat.com, nadav.amit@gmail.com, paulus@ozlabs.org,
        peterx@redhat.com, rcampbell@nvidia.com, stable@vger.kernel.org,
        willy@infradead.org, ying.huang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 12:25:02 +0200
Message-ID: <166470630291202@kroah.com>
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

From a3589e1d5fe39c3d9fdd291b111524b93d08bc32 Mon Sep 17 00:00:00 2001
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 2 Sep 2022 10:35:52 +1000
Subject: [PATCH] mm/migrate_device.c: add missing flush_cache_page()

Currently we only call flush_cache_page() for the anon_exclusive case,
however in both cases we clear the pte so should flush the cache.

Link: https://lkml.kernel.org/r/5676f30436ab71d1a587ac73f835ed8bd2113ff5.1662078528.git-series.apopple@nvidia.com
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
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
index 6a5ef9f0da6a..4cc849c3b54c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -193,9 +193,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
 				ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {

