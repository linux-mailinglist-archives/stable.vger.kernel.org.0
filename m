Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721C16ECE88
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjDXNd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjDXNdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4525D65A8
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 823BA62379
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938A4C4339B;
        Mon, 24 Apr 2023 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343132;
        bh=kYQEMGjxu/FEgPuLP0Xev4DXrkFx4AcY5DKMExqMsNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQNlaD0b1Rm6j858vtrpRAb5s0yUUnsMMlg99kVuhyT/5FUuRWdcGa5dzRNf2cjxE
         JKQdhYhGd+3XaHLT7NjiLC4Bzqf0sJSUDT0flrPeQBDIrJxGQvyHr9jT5lH6sUBcAX
         ryJ4anyMNpITLxHaA4wNTlCHZxGkyhSAw14oWwCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Potapenko <glider@google.com>,
        Dipanjan Das <mail.dipanjan.das@gmail.com>,
        Marco Elver <elver@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 089/110] mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()
Date:   Mon, 24 Apr 2023 15:17:51 +0200
Message-Id: <20230424131139.850173421@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

commit fdea03e12aa2a44a7bb34144208be97fc25dfd90 upstream.

Similarly to kmsan_vmap_pages_range_noflush(), kmsan_ioremap_page_range()
must also properly handle allocation/mapping failures.  In the case of
such, it must clean up the already created metadata mappings and return an
error code, so that the error can be propagated to ioremap_page_range().
Without doing so, KMSAN may silently fail to bring the metadata for the
page range into a consistent state, which will result in user-visible
crashes when trying to access them.

Link: https://lkml.kernel.org/r/20230413131223.4135168-2-glider@google.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
  Link: https://lore.kernel.org/linux-mm/CANX2M5ZRrRA64k0hOif02TjmY9kbbO2aCBPyq79es34RXZ=cAw@mail.gmail.com/
Reviewed-by: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kmsan.h |   19 +++++++++--------
 mm/kmsan/hooks.c      |   55 ++++++++++++++++++++++++++++++++++++++++++--------
 mm/vmalloc.c          |    4 +--
 3 files changed, 59 insertions(+), 19 deletions(-)

--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -159,11 +159,12 @@ void kmsan_vunmap_range_noflush(unsigned
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
@@ -294,12 +295,12 @@ static inline void kmsan_vunmap_range_no
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
+	return 0;
 }
 
 static inline void kmsan_iounmap_page_range(unsigned long start,
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
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
-		__vmap_pages_range_noflush(
+		if (mapped) {
+			err = mapped;
+			goto ret;
+		}
+		shadow = NULL;
+		mapped = __vmap_pages_range_noflush(
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
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -324,8 +324,8 @@ int ioremap_page_range(unsigned long add
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
 	if (!err)
-		kmsan_ioremap_page_range(addr, end, phys_addr, prot,
-					 ioremap_max_page_shift);
+		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
+					       ioremap_max_page_shift);
 	return err;
 }
 


