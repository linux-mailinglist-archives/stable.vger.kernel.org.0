Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB876E007A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 23:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDLVGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 17:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDLVGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 17:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D877ABF;
        Wed, 12 Apr 2023 14:06:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FEB36393F;
        Wed, 12 Apr 2023 21:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98980C433D2;
        Wed, 12 Apr 2023 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681333588;
        bh=kMbrZQ6f1G7D6PsqV32AmWukQOTDek7V4b+xiS+UG6g=;
        h=Date:To:From:Subject:From;
        b=EUmSNEn1gkiaSqqh0drt85M9iqX6ViPaJHljVG4iWLzCFOOWo8piGcT077llxHz1h
         wtbigGtzQtVzScNSxZnhTL/PXMRV01Eub7AJWi0vivjS3rkW+fuvqEQ9I7FIWDjRKU
         rqwC7QjUyjE2RYaCz4ulCZap4Fm8R+87VyCCLwdE=
Date:   Wed, 12 Apr 2023 14:06:28 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stable@vger.kernel.org, mail.dipanjan.das@gmail.com,
        hch@infradead.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20230412210628.98980C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()
Date: Wed, 12 Apr 2023 16:53:00 +0200

kmsan's allocation of shadow or origin memory in
kmsan_vmap_pages_range_noflush() fails silently due to fault injection
(FI).  KMSAN sort of swallows the allocation failure, and moves on.  When
either of them is later accessed while updating the metadata, there are no
checks to test the validity of the respective pointers, which results in a
page fault.

Similarly to kmsan_vmap_pages_range_noflush(), kmsan_ioremap_page_range()
must also properly handle allocation/mapping failures.  In the case of
such, it must clean up the already created metadata mappings and return an
error code, so that the failure can be propagated to ioremap_page_range().

Link: https://lkml.kernel.org/r/20230412145300.3651840-2-glider@google.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
  Link: https://lore.kernel.org/linux-mm/CANX2M5ZRrRA64k0hOif02TjmY9kbbO2aCBPyq79es34RXZ=cAw@mail.gmail.com/
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h |   18 ++++++-------
 mm/kmsan/hooks.c      |   53 ++++++++++++++++++++++++++++++++++------
 mm/vmalloc.c          |    4 +--
 3 files changed, 57 insertions(+), 18 deletions(-)

--- a/include/linux/kmsan.h~mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range
+++ a/include/linux/kmsan.h
@@ -160,11 +160,12 @@ void kmsan_vunmap_range_noflush(unsigned
  * @page_shift:	page_shift argument passed to vmap_range_noflush().
  *
  * KMSAN creates new metadata pages for the physical pages mapped into the
- * virtual memory.
+ * virtual memory. Returns 0 on success, callers must check for non-zero return
+ * value.
  */
-void kmsan_ioremap_page_range(unsigned long addr, unsigned long end,
-			      phys_addr_t phys_addr, pgprot_t prot,
-			      unsigned int page_shift);
+int kmsan_ioremap_page_range(unsigned long addr, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot,
+			     unsigned int page_shift);
 
 /**
  * kmsan_iounmap_page_range() - Notify KMSAN about a iounmap_page_range() call.
@@ -295,11 +296,10 @@ static inline void kmsan_vunmap_range_no
 {
 }
 
-static inline void kmsan_ioremap_page_range(unsigned long start,
-					    unsigned long end,
-					    phys_addr_t phys_addr,
-					    pgprot_t prot,
-					    unsigned int page_shift)
+static inline int kmsan_ioremap_page_range(unsigned long start,
+					   unsigned long end,
+					   phys_addr_t phys_addr, pgprot_t prot,
+					   unsigned int page_shift)
 {
 }
 
--- a/mm/kmsan/hooks.c~mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range
+++ a/mm/kmsan/hooks.c
@@ -148,35 +148,74 @@ void kmsan_vunmap_range_noflush(unsigned
  * into the virtual memory. If those physical pages already had shadow/origin,
  * those are ignored.
  */
-void kmsan_ioremap_page_range(unsigned long start, unsigned long end,
-			      phys_addr_t phys_addr, pgprot_t prot,
-			      unsigned int page_shift)
+int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot,
+			     unsigned int page_shift)
 {
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_ZERO;
 	struct page *shadow, *origin;
 	unsigned long off = 0;
-	int nr;
+	int nr, err = 0, clean = 0, mapped;
 
 	if (!kmsan_enabled || kmsan_in_runtime())
-		return;
+		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
 	kmsan_enter_runtime();
-	for (int i = 0; i < nr; i++, off += PAGE_SIZE) {
+	for (int i = 0; i < nr; i++, off += PAGE_SIZE, clean = i) {
 		shadow = alloc_pages(gfp_mask, 1);
 		origin = alloc_pages(gfp_mask, 1);
-		__vmap_pages_range_noflush(
+		if (!shadow || !origin) {
+			err = -ENOMEM;
+			goto ret;
+		}
+		mapped = __vmap_pages_range_noflush(
 			vmalloc_shadow(start + off),
 			vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
 			PAGE_SHIFT);
+		if (mapped) {
+			err = mapped;
+			goto ret;
+		}
+		shadow = NULL;
 		__vmap_pages_range_noflush(
 			vmalloc_origin(start + off),
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
 			PAGE_SHIFT);
+		if (mapped) {
+			__vunmap_range_noflush(
+				vmalloc_shadow(start + off),
+				vmalloc_shadow(start + off + PAGE_SIZE));
+			err = mapped;
+			goto ret;
+		}
+		origin = NULL;
+	}
+	/* Page mapping loop finished normally, nothing to clean up. */
+	clean = 0;
+
+ret:
+	if (clean > 0) {
+		/*
+		 * Something went wrong. Clean up shadow/origin pages allocated
+		 * on the last loop iteration, then delete mappings created
+		 * during the previous iterations.
+		 */
+		if (shadow)
+			__free_pages(shadow, 1);
+		if (origin)
+			__free_pages(origin, 1);
+		__vunmap_range_noflush(
+			vmalloc_shadow(start),
+			vmalloc_shadow(start + clean * PAGE_SIZE));
+		__vunmap_range_noflush(
+			vmalloc_origin(start),
+			vmalloc_origin(start + clean * PAGE_SIZE));
 	}
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 	kmsan_leave_runtime();
+	return err;
 }
 
 void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
--- a/mm/vmalloc.c~mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range
+++ a/mm/vmalloc.c
@@ -313,8 +313,8 @@ int ioremap_page_range(unsigned long add
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
 	if (!err)
-		kmsan_ioremap_page_range(addr, end, phys_addr, prot,
-					 ioremap_max_page_shift);
+		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
+					       ioremap_max_page_shift);
 	return err;
 }
 
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-handle-alloc-failures-in-kmsan_vmap_pages_range_noflush.patch
mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range.patch

