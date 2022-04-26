Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE7A50F5C0
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiDZIsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346887AbiDZIp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96692640D;
        Tue, 26 Apr 2022 01:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23191618E2;
        Tue, 26 Apr 2022 08:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111E2C385AC;
        Tue, 26 Apr 2022 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962174;
        bh=m38+S31AT0qFPX+C8nJQY1fTvKs4CLg/Y+zPDFrfRqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2JhBPMx4li7Qu4r7S5uXHGJ39iOHVlX4779E6zfO7E2g/QshVAuwEz1v9ByHhBRA
         pElWfMDdnTryMqZZehekWgvGnPuM74rO/WPIYVxVb0rduqU9JsrzN8NfZF+bVVCJI5
         1AJnxl92DyZnhd/UyyFZUUwNcaCa40ULfRiXd0R4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.15 011/124] mm, kfence: support kmem_dump_obj() for KFENCE objects
Date:   Tue, 26 Apr 2022 10:20:12 +0200
Message-Id: <20220426081747.619716067@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 2dfe63e61cc31ee59ce951672b0850b5229cd5b0 upstream.

Calling kmem_obj_info() via kmem_dump_obj() on KFENCE objects has been
producing garbage data due to the object not actually being maintained
by SLAB or SLUB.

Fix this by implementing __kfence_obj_info() that copies relevant
information to struct kmem_obj_info when the object was allocated by
KFENCE; this is called by a common kmem_obj_info(), which also calls the
slab/slub/slob specific variant now called __kmem_obj_info().

For completeness, kmem_dump_obj() now displays if the object was
allocated by KFENCE.

Link: https://lore.kernel.org/all/20220323090520.GG16885@xsang-OptiPlex-9020/
Link: https://lkml.kernel.org/r/20220406131558.3558585-1-elver@google.com
Fixes: b89fb5ef0ce6 ("mm, kfence: insert KFENCE hooks for SLUB")
Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>	[slab]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kfence.h |   24 ++++++++++++++++++++++++
 mm/kfence/core.c       |   21 ---------------------
 mm/kfence/kfence.h     |   21 +++++++++++++++++++++
 mm/kfence/report.c     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/slab.c              |    2 +-
 mm/slab.h              |    2 +-
 mm/slab_common.c       |    9 +++++++++
 mm/slob.c              |    2 +-
 mm/slub.c              |    2 +-
 9 files changed, 105 insertions(+), 25 deletions(-)

--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -202,6 +202,22 @@ static __always_inline __must_check bool
  */
 bool __must_check kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs *regs);
 
+#ifdef CONFIG_PRINTK
+struct kmem_obj_info;
+/**
+ * __kfence_obj_info() - fill kmem_obj_info struct
+ * @kpp: kmem_obj_info to be filled
+ * @object: the object
+ *
+ * Return:
+ * * false - not a KFENCE object
+ * * true - a KFENCE object, filled @kpp
+ *
+ * Copies information to @kpp for KFENCE objects.
+ */
+bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
+#endif
+
 #else /* CONFIG_KFENCE */
 
 static inline bool is_kfence_address(const void *addr) { return false; }
@@ -219,6 +235,14 @@ static inline bool __must_check kfence_h
 	return false;
 }
 
+#ifdef CONFIG_PRINTK
+struct kmem_obj_info;
+static inline bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+{
+	return false;
+}
+#endif
+
 #endif
 
 #endif /* _LINUX_KFENCE_H */
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -221,27 +221,6 @@ static bool kfence_unprotect(unsigned lo
 	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), false));
 }
 
-static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
-{
-	long index;
-
-	/* The checks do not affect performance; only called from slow-paths. */
-
-	if (!is_kfence_address((void *)addr))
-		return NULL;
-
-	/*
-	 * May be an invalid index if called with an address at the edge of
-	 * __kfence_pool, in which case we would report an "invalid access"
-	 * error.
-	 */
-	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
-	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
-		return NULL;
-
-	return &kfence_metadata[index];
-}
-
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -93,6 +93,27 @@ struct kfence_metadata {
 
 extern struct kfence_metadata kfence_metadata[CONFIG_KFENCE_NUM_OBJECTS];
 
+static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
+{
+	long index;
+
+	/* The checks do not affect performance; only called from slow-paths. */
+
+	if (!is_kfence_address((void *)addr))
+		return NULL;
+
+	/*
+	 * May be an invalid index if called with an address at the edge of
+	 * __kfence_pool, in which case we would report an "invalid access"
+	 * error.
+	 */
+	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
+	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
+		return NULL;
+
+	return &kfence_metadata[index];
+}
+
 /* KFENCE error types for report generation. */
 enum kfence_error_type {
 	KFENCE_ERROR_OOB,		/* Detected a out-of-bounds access. */
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -273,3 +273,50 @@ void kfence_report_error(unsigned long a
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
 }
+
+#ifdef CONFIG_PRINTK
+static void kfence_to_kp_stack(const struct kfence_track *track, void **kp_stack)
+{
+	int i, j;
+
+	i = get_stack_skipnr(track->stack_entries, track->num_stack_entries, NULL);
+	for (j = 0; i < track->num_stack_entries && j < KS_ADDRS_COUNT; ++i, ++j)
+		kp_stack[j] = (void *)track->stack_entries[i];
+	if (j < KS_ADDRS_COUNT)
+		kp_stack[j] = NULL;
+}
+
+bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+{
+	struct kfence_metadata *meta = addr_to_metadata((unsigned long)object);
+	unsigned long flags;
+
+	if (!meta)
+		return false;
+
+	/*
+	 * If state is UNUSED at least show the pointer requested; the rest
+	 * would be garbage data.
+	 */
+	kpp->kp_ptr = object;
+
+	/* Requesting info an a never-used object is almost certainly a bug. */
+	if (WARN_ON(meta->state == KFENCE_OBJECT_UNUSED))
+		return true;
+
+	raw_spin_lock_irqsave(&meta->lock, flags);
+
+	kpp->kp_page = page;
+	kpp->kp_slab_cache = meta->cache;
+	kpp->kp_objp = (void *)meta->addr;
+	kfence_to_kp_stack(&meta->alloc_track, kpp->kp_stack);
+	if (meta->state == KFENCE_OBJECT_FREED)
+		kfence_to_kp_stack(&meta->free_track, kpp->kp_free_stack);
+	/* get_stack_skipnr() ensures the first entry is outside allocator. */
+	kpp->kp_ret = kpp->kp_stack[0];
+
+	raw_spin_unlock_irqrestore(&meta->lock, flags);
+
+	return true;
+}
+#endif
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3658,7 +3658,7 @@ EXPORT_SYMBOL(__kmalloc_node_track_calle
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	struct kmem_cache *cachep;
 	unsigned int objnr;
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -643,7 +643,7 @@ struct kmem_obj_info {
 	void *kp_stack[KS_ADDRS_COUNT];
 	void *kp_free_stack[KS_ADDRS_COUNT];
 };
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
 #endif
 
 #endif /* MM_SLAB_H */
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -568,6 +568,13 @@ bool kmem_valid_obj(void *object)
 }
 EXPORT_SYMBOL_GPL(kmem_valid_obj);
 
+static void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+{
+	if (__kfence_obj_info(kpp, object, page))
+		return;
+	__kmem_obj_info(kpp, object, page);
+}
+
 /**
  * kmem_dump_obj - Print available slab provenance information
  * @object: slab object for which to find provenance information.
@@ -603,6 +610,8 @@ void kmem_dump_obj(void *object)
 		pr_cont(" slab%s %s", cp, kp.kp_slab_cache->name);
 	else
 		pr_cont(" slab%s", cp);
+	if (is_kfence_address(object))
+		pr_cont(" (kfence)");
 	if (kp.kp_objp)
 		pr_cont(" start %px", kp.kp_objp);
 	if (kp.kp_data_offset)
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -462,7 +462,7 @@ out:
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	kpp->kp_ptr = object;
 	kpp->kp_page = page;
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4299,7 +4299,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	void *base;
 	int __maybe_unused i;


