Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B63B506B54
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 13:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351808AbiDSLs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 07:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351813AbiDSLsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 07:48:23 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13D72AC6C
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 04:45:40 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id b19so22036774wrh.11
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 04:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/v4xkXQk2NzkMQRrPucc85AnOLF2K1bgfZQx94gNmMo=;
        b=lBlHEed1/Gh+YKTKOwqIOPgl72Imd78WcFQ4C/AExpI3iO6GZixez4VVSP5FfPgsjT
         pAUqpDkUKRsbChdOGJDjwrb8UGGelusDBRwmu1Mb7q84hGOqCZQixypp4P6smHijBMzV
         sB7e/avdUZBn1YqLLIYBz0aWYfgaExZ5+/Qx90Up4TeuzB2byFghk8DE1O8+icbIsA7n
         KcZajBlKkIVSxp8brvKaoNWT1tR4vQVZnKqdaWWuhIGQtc62RFsx/MpWVbkj9U+x3Fuo
         fHxkd9zfsqieQJ7Tj+dQA8IA8Mbpp5UTjf9huEwpM1w8hRrEUsPm28tDaLnmlAAbqSbn
         0yAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/v4xkXQk2NzkMQRrPucc85AnOLF2K1bgfZQx94gNmMo=;
        b=AKwyKS8mMHIpjHYEDIRIYF/lBd/IlRaVYbrRhsVyb1uIxewEbNCSYFEG7JXe94O2Yo
         c2j94efx4j0D0PCy3CAVch1eGMmekHQgDH2alDsfFPPsg8Mymaf3Wbax7H80jxZSIlRv
         iLZgFFQ64uXc06pxPuVRZAL4tfnBa88S61EYf8njx5rtHT7wayrVwdatlwNcMHecl3Q0
         eIwtjSCJybsF+R3DjY/6+FsC0UZoq2ulCDxHk5arUYqsN0zr5YaX1vmY/u4Ua/ALapmu
         vtUIVrVAxnMVaqyhZiqF2W9CMNuISpGjET1zNUY8z2twYjSRL87JGl7sx5c19lYMCnUK
         8Uyw==
X-Gm-Message-State: AOAM530tbRRxd7BAB7X9V1moZwaGmwDuP29GtHLUcqdEEPppbJSfatsW
        mNToxDYbQjFyQVNhF3XZHSa7yw==
X-Google-Smtp-Source: ABdhPJxS7LfANxg1V9mgbo/0YnAXlIlBIxwfR7h5Q39iDuYTR6MEGwlXEL5weeETs6mHs9luiB9hOA==
X-Received: by 2002:a5d:4b45:0:b0:207:ab91:edd8 with SMTP id w5-20020a5d4b45000000b00207ab91edd8mr11310729wrs.168.1650368738953;
        Tue, 19 Apr 2022 04:45:38 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:7d9b:e7a5:8aea:d5ae])
        by smtp.gmail.com with ESMTPSA id m8-20020a056000008800b00207b3fa7fc0sm14005264wrx.108.2022.04.19.04.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:45:38 -0700 (PDT)
Date:   Tue, 19 Apr 2022 13:45:32 +0200
From:   Marco Elver <elver@google.com>
To:     gregkh@linuxfoundation.org
Cc:     42.hyeyoo@gmail.com, akpm@linux-foundation.org,
        oliver.sang@intel.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, stable@vger.kernel.org
Subject: [PATCH 5.15.y] mm, kfence: support kmem_dump_obj() for KFENCE objects
Message-ID: <Yl6g3B5/d+uwHal2@elver.google.com>
References: <165027573318316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165027573318316@kroah.com>
User-Agent: Mutt/2.1.4 (2021-12-11)
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[elver@google.com: backport - substitute uses of struct slab with page]
Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/kfence.h | 24 +++++++++++++++++++++
 mm/kfence/core.c       | 21 -------------------
 mm/kfence/kfence.h     | 21 +++++++++++++++++++
 mm/kfence/report.c     | 47 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab.c              |  2 +-
 mm/slab.h              |  2 +-
 mm/slab_common.c       |  9 ++++++++
 mm/slob.c              |  2 +-
 mm/slub.c              |  2 +-
 9 files changed, 105 insertions(+), 25 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 4b5e3679a72c..3c75209a545e 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -202,6 +202,22 @@ static __always_inline __must_check bool kfence_free(void *addr)
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
@@ -219,6 +235,14 @@ static inline bool __must_check kfence_handle_page_fault(unsigned long addr, boo
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
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 51ea9193cecb..86260e8f2830 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -221,27 +221,6 @@ static bool kfence_unprotect(unsigned long addr)
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
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index 2a2d5de9d379..92bf6eff6060 100644
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
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index f93a7b2a338b..37e140e7f201 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -273,3 +273,50 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
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
diff --git a/mm/slab.c b/mm/slab.c
index 03d3074d0bb0..1bd283e98c58 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3658,7 +3658,7 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	struct kmem_cache *cachep;
 	unsigned int objnr;
diff --git a/mm/slab.h b/mm/slab.h
index 56ad7eea3ddf..1ae1bdd485c1 100644
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
diff --git a/mm/slab_common.c b/mm/slab_common.c
index ec2bb0beed75..022319e7deaf 100644
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
diff --git a/mm/slob.c b/mm/slob.c
index 74d3f6e60666..f3fc15df971a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -462,7 +462,7 @@ static void slob_free(void *block, int size)
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	kpp->kp_ptr = object;
 	kpp->kp_page = page;
diff --git a/mm/slub.c b/mm/slub.c
index ca6ba6bdf27b..b75eebc0350e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4299,7 +4299,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
 {
 	void *base;
 	int __maybe_unused i;
-- 
2.36.0.rc0.470.gd361397f0d-goog

