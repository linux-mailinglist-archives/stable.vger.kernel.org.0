Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018D5F7B9A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfKKShu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbfKKSht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91CA920659;
        Mon, 11 Nov 2019 18:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497467;
        bh=Mm0ZA3LWz7oDhX/RZfH/rHSFlb9+F76BScTso2kUMWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoGrtoxq3bXLAJCPe86B96m3ia3FGyCjvBP4mSOe8P5iG8kVeoCGa3bYJVVx08KFt
         GXNlqaOd3tWkmDJUHE+XvO1qgod9Bq+iBvD0a7EMPazgsAq8Pjm3GPl3AjgyRM0sI9
         9bhVgFEiH9oOPL5fy4Ex2Mf5QQ4EtkTP+J2SlBRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 064/105] lib/scatterlist: Introduce sgl_alloc() and sgl_free()
Date:   Mon, 11 Nov 2019 19:28:34 +0100
Message-Id: <20191111181445.222913711@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bart.vanassche@wdc.com>

commit e80a0af4759a164214f02da157a3800753ce135f upstream.

Many kernel drivers contain code that allocates and frees both a
scatterlist and the pages that populate that scatterlist.
Introduce functions in lib/scatterlist.c that perform these tasks
instead of duplicating this functionality in multiple drivers.
Only include these functions in the build if CONFIG_SGL_ALLOC=y
to avoid that the kernel size increases if this functionality is
not used.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/scatterlist.h |   10 ++++
 lib/Kconfig                 |    4 +
 lib/scatterlist.c           |  105 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)

--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -267,6 +267,16 @@ int sg_alloc_table_from_pages(struct sg_
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
 
+#ifdef CONFIG_SGL_ALLOC
+struct scatterlist *sgl_alloc_order(unsigned long long length,
+				    unsigned int order, bool chainable,
+				    gfp_t gfp, unsigned int *nent_p);
+struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
+			      unsigned int *nent_p);
+void sgl_free_order(struct scatterlist *sgl, int order);
+void sgl_free(struct scatterlist *sgl);
+#endif /* CONFIG_SGL_ALLOC */
+
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 		      size_t buflen, off_t skip, bool to_buffer);
 
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -413,6 +413,10 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config SGL_ALLOC
+	bool
+	default n
+
 config DMA_NOOP_OPS
 	bool
 	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -433,6 +433,111 @@ int sg_alloc_table_from_pages(struct sg_
 }
 EXPORT_SYMBOL(sg_alloc_table_from_pages);
 
+#ifdef CONFIG_SGL_ALLOC
+
+/**
+ * sgl_alloc_order - allocate a scatterlist and its pages
+ * @length: Length in bytes of the scatterlist. Must be at least one
+ * @order: Second argument for alloc_pages()
+ * @chainable: Whether or not to allocate an extra element in the scatterlist
+ *	for scatterlist chaining purposes
+ * @gfp: Memory allocation flags
+ * @nent_p: [out] Number of entries in the scatterlist that have pages
+ *
+ * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
+ */
+struct scatterlist *sgl_alloc_order(unsigned long long length,
+				    unsigned int order, bool chainable,
+				    gfp_t gfp, unsigned int *nent_p)
+{
+	struct scatterlist *sgl, *sg;
+	struct page *page;
+	unsigned int nent, nalloc;
+	u32 elem_len;
+
+	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
+	/* Check for integer overflow */
+	if (length > (nent << (PAGE_SHIFT + order)))
+		return NULL;
+	nalloc = nent;
+	if (chainable) {
+		/* Check for integer overflow */
+		if (nalloc + 1 < nalloc)
+			return NULL;
+		nalloc++;
+	}
+	sgl = kmalloc_array(nalloc, sizeof(struct scatterlist),
+			    (gfp & ~GFP_DMA) | __GFP_ZERO);
+	if (!sgl)
+		return NULL;
+
+	sg_init_table(sgl, nent);
+	sg = sgl;
+	while (length) {
+		elem_len = min_t(u64, length, PAGE_SIZE << order);
+		page = alloc_pages(gfp, order);
+		if (!page) {
+			sgl_free(sgl);
+			return NULL;
+		}
+
+		sg_set_page(sg, page, elem_len, 0);
+		length -= elem_len;
+		sg = sg_next(sg);
+	}
+	WARN_ON_ONCE(sg);
+	if (nent_p)
+		*nent_p = nent;
+	return sgl;
+}
+EXPORT_SYMBOL(sgl_alloc_order);
+
+/**
+ * sgl_alloc - allocate a scatterlist and its pages
+ * @length: Length in bytes of the scatterlist
+ * @gfp: Memory allocation flags
+ * @nent_p: [out] Number of entries in the scatterlist
+ *
+ * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
+ */
+struct scatterlist *sgl_alloc(unsigned long long length, gfp_t gfp,
+			      unsigned int *nent_p)
+{
+	return sgl_alloc_order(length, 0, false, gfp, nent_p);
+}
+EXPORT_SYMBOL(sgl_alloc);
+
+/**
+ * sgl_free_order - free a scatterlist and its pages
+ * @sgl: Scatterlist with one or more elements
+ * @order: Second argument for __free_pages()
+ */
+void sgl_free_order(struct scatterlist *sgl, int order)
+{
+	struct scatterlist *sg;
+	struct page *page;
+
+	for (sg = sgl; sg; sg = sg_next(sg)) {
+		page = sg_page(sg);
+		if (page)
+			__free_pages(page, order);
+	}
+	kfree(sgl);
+}
+EXPORT_SYMBOL(sgl_free_order);
+
+/**
+ * sgl_free - free a scatterlist and its pages
+ * @sgl: Scatterlist with one or more elements
+ */
+void sgl_free(struct scatterlist *sgl)
+{
+	sgl_free_order(sgl, 0);
+}
+EXPORT_SYMBOL(sgl_free);
+
+#endif /* CONFIG_SGL_ALLOC */
+
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset)


