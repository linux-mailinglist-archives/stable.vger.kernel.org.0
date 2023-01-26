Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7617B67D961
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 00:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjAZXFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 18:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbjAZXFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 18:05:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B34564BF;
        Thu, 26 Jan 2023 15:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7F0B81F2F;
        Thu, 26 Jan 2023 23:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFCCC433D2;
        Thu, 26 Jan 2023 23:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674774260;
        bh=bNRIn/ZA0jHDon4cl/MSRknolOPglCa66cEnDB+ygTU=;
        h=Date:To:From:Subject:From;
        b=GumhB+z72hdVwN4CLXMJanI6Akavif1pmC1VbkJqKR2QYXy5VyNbCt2Nhu0wIfSEK
         5YSAV2c8uEmfDya+6H+ER/uIoSZwtN2nNK/OYkVvpqrU0ZBjAAD/WjpntUblBeLD5T
         IF1JeS9y3sJYkW+xUFepAEIP14hBT1HOg6uafwfQ=
Date:   Thu, 26 Jan 2023 15:04:20 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tony.luck@intel.com, tglx@linutronix.de, stable@vger.kernel.org,
        keescook@chromium.org, ira.weiny@intel.com, glider@google.com,
        fmdefrancesco@gmail.com, dsterba@suse.com, deller@gmx.de,
        bigeasy@linutronix.de, bagasdotme@gmail.com, andreyknvl@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-round-down-the-address-passed-to-kunmap_flush_on_unmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20230126230420.CDFCCC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: highmem: round down the address passed to kunmap_flush_on_unmap()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     highmem-round-down-the-address-passed-to-kunmap_flush_on_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-round-down-the-address-passed-to-kunmap_flush_on_unmap.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: round down the address passed to kunmap_flush_on_unmap()
Date: Thu, 26 Jan 2023 20:07:27 +0000

We already round down the address in kunmap_local_indexed() which is the
other implementation of __kunmap_local().  The only implementation of
kunmap_flush_on_unmap() is PA-RISC which is expecting a page-aligned
address.  This may be causing PA-RISC to be flushing the wrong addresses
currently.

Link: https://lkml.kernel.org/r/20230126200727.1680362-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*")
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Sterba <dsterba@suse.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem-internal.h~highmem-round-down-the-address-passed-to-kunmap_flush_on_unmap
+++ a/include/linux/highmem-internal.h
@@ -200,7 +200,7 @@ static inline void *kmap_local_pfn(unsig
 static inline void __kunmap_local(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 }
 
@@ -227,7 +227,7 @@ static inline void *kmap_atomic_pfn(unsi
 static inline void __kunmap_atomic(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 	pagefault_enable();
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
_

Patches currently in -mm which might be from willy@infradead.org are

highmem-round-down-the-address-passed-to-kunmap_flush_on_unmap.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch
mm-add-memcpy_from_file_folio.patch
fs-convert-writepage_t-callback-to-pass-a-folio.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

