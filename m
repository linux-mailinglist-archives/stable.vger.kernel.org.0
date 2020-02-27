Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6088171DB4
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgB0OWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:22:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389420AbgB0OQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:16:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F219B2468F;
        Thu, 27 Feb 2020 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812965;
        bh=Hb1/AglAj2BfkkYCvaqrB7kZ5dbo0m6QXAnpIjHn07w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POxiS6NLDeGWEe+k6HVWzKmxAd1MXRZp3BE2BNoSGY09eQzaBQJznGjoy9S2DyM8y
         E1AiXn8E3gdqPs+RNkICCz6OoHIsD/2u8p61PM47YjU7KtszLKaL+gKYPBAu3ltVFM
         zGsUVfKVeHDfLhOC7dwlnUlh7GQikh+LBss19a7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 084/150] drm/i915: Wean off drm_pci_alloc/drm_pci_free
Date:   Thu, 27 Feb 2020 14:37:01 +0100
Message-Id: <20200227132245.262707944@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit aa3146193ae25d0fe4b96d815169a135db2e8f01 upstream.

drm_pci_alloc and drm_pci_free are just very thin wrappers around
dma_alloc_coherent, with a note that we should be removing them.
Furthermore since

commit de09d31dd38a50fdce106c15abd68432eebbd014
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Fri Jan 15 16:51:42 2016 -0800

    page-flags: define PG_reserved behavior on compound pages

    As far as I can see there's no users of PG_reserved on compound pages.
    Let's use PF_NO_COMPOUND here.

drm_pci_alloc has been declared broken since it mixes GFP_COMP and
SetPageReserved. Avoid this conflict by weaning ourselves off using the
abstraction and using the dma functions directly.

Reported-by: Taketo Kabe
Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202153934.3899472-1-chris@chris-wilson.co.uk
(cherry picked from commit c6790dc22312f592c1434577258b31c48c72d52a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c     |    2 
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |    3 
 drivers/gpu/drm/i915/gem/i915_gem_phys.c         |   98 +++++++++++------------
 drivers/gpu/drm/i915/i915_gem.c                  |    8 -
 4 files changed, 55 insertions(+), 56 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -10731,7 +10731,7 @@ static u32 intel_cursor_base(const struc
 	u32 base;
 
 	if (INTEL_INFO(dev_priv)->display.cursor_needs_physical)
-		base = obj->phys_handle->busaddr;
+		base = sg_dma_address(obj->mm.pages->sgl);
 	else
 		base = intel_plane_ggtt_offset(plane_state);
 
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -260,9 +260,6 @@ struct drm_i915_gem_object {
 
 		void *gvt_info;
 	};
-
-	/** for phys allocated objects */
-	struct drm_dma_handle *phys_handle;
 };
 
 static inline struct drm_i915_gem_object *
--- a/drivers/gpu/drm/i915/gem/i915_gem_phys.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
@@ -22,88 +22,87 @@
 static int i915_gem_object_get_pages_phys(struct drm_i915_gem_object *obj)
 {
 	struct address_space *mapping = obj->base.filp->f_mapping;
-	struct drm_dma_handle *phys;
-	struct sg_table *st;
 	struct scatterlist *sg;
-	char *vaddr;
+	struct sg_table *st;
+	dma_addr_t dma;
+	void *vaddr;
+	void *dst;
 	int i;
-	int err;
 
 	if (WARN_ON(i915_gem_object_needs_bit17_swizzle(obj)))
 		return -EINVAL;
 
-	/* Always aligning to the object size, allows a single allocation
+	/*
+	 * Always aligning to the object size, allows a single allocation
 	 * to handle all possible callers, and given typical object sizes,
 	 * the alignment of the buddy allocation will naturally match.
 	 */
-	phys = drm_pci_alloc(obj->base.dev,
-			     roundup_pow_of_two(obj->base.size),
-			     roundup_pow_of_two(obj->base.size));
-	if (!phys)
+	vaddr = dma_alloc_coherent(&obj->base.dev->pdev->dev,
+				   roundup_pow_of_two(obj->base.size),
+				   &dma, GFP_KERNEL);
+	if (!vaddr)
 		return -ENOMEM;
 
-	vaddr = phys->vaddr;
+	st = kmalloc(sizeof(*st), GFP_KERNEL);
+	if (!st)
+		goto err_pci;
+
+	if (sg_alloc_table(st, 1, GFP_KERNEL))
+		goto err_st;
+
+	sg = st->sgl;
+	sg->offset = 0;
+	sg->length = obj->base.size;
+
+	sg_assign_page(sg, (struct page *)vaddr);
+	sg_dma_address(sg) = dma;
+	sg_dma_len(sg) = obj->base.size;
+
+	dst = vaddr;
 	for (i = 0; i < obj->base.size / PAGE_SIZE; i++) {
 		struct page *page;
-		char *src;
+		void *src;
 
 		page = shmem_read_mapping_page(mapping, i);
-		if (IS_ERR(page)) {
-			err = PTR_ERR(page);
-			goto err_phys;
-		}
+		if (IS_ERR(page))
+			goto err_st;
 
 		src = kmap_atomic(page);
-		memcpy(vaddr, src, PAGE_SIZE);
-		drm_clflush_virt_range(vaddr, PAGE_SIZE);
+		memcpy(dst, src, PAGE_SIZE);
+		drm_clflush_virt_range(dst, PAGE_SIZE);
 		kunmap_atomic(src);
 
 		put_page(page);
-		vaddr += PAGE_SIZE;
+		dst += PAGE_SIZE;
 	}
 
 	intel_gt_chipset_flush(&to_i915(obj->base.dev)->gt);
 
-	st = kmalloc(sizeof(*st), GFP_KERNEL);
-	if (!st) {
-		err = -ENOMEM;
-		goto err_phys;
-	}
-
-	if (sg_alloc_table(st, 1, GFP_KERNEL)) {
-		kfree(st);
-		err = -ENOMEM;
-		goto err_phys;
-	}
-
-	sg = st->sgl;
-	sg->offset = 0;
-	sg->length = obj->base.size;
-
-	sg_dma_address(sg) = phys->busaddr;
-	sg_dma_len(sg) = obj->base.size;
-
-	obj->phys_handle = phys;
-
 	__i915_gem_object_set_pages(obj, st, sg->length);
 
 	return 0;
 
-err_phys:
-	drm_pci_free(obj->base.dev, phys);
-
-	return err;
+err_st:
+	kfree(st);
+err_pci:
+	dma_free_coherent(&obj->base.dev->pdev->dev,
+			  roundup_pow_of_two(obj->base.size),
+			  vaddr, dma);
+	return -ENOMEM;
 }
 
 static void
 i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
 			       struct sg_table *pages)
 {
+	dma_addr_t dma = sg_dma_address(pages->sgl);
+	void *vaddr = sg_page(pages->sgl);
+
 	__i915_gem_object_release_shmem(obj, pages, false);
 
 	if (obj->mm.dirty) {
 		struct address_space *mapping = obj->base.filp->f_mapping;
-		char *vaddr = obj->phys_handle->vaddr;
+		void *src = vaddr;
 		int i;
 
 		for (i = 0; i < obj->base.size / PAGE_SIZE; i++) {
@@ -115,15 +114,16 @@ i915_gem_object_put_pages_phys(struct dr
 				continue;
 
 			dst = kmap_atomic(page);
-			drm_clflush_virt_range(vaddr, PAGE_SIZE);
-			memcpy(dst, vaddr, PAGE_SIZE);
+			drm_clflush_virt_range(src, PAGE_SIZE);
+			memcpy(dst, src, PAGE_SIZE);
 			kunmap_atomic(dst);
 
 			set_page_dirty(page);
 			if (obj->mm.madv == I915_MADV_WILLNEED)
 				mark_page_accessed(page);
 			put_page(page);
-			vaddr += PAGE_SIZE;
+
+			src += PAGE_SIZE;
 		}
 		obj->mm.dirty = false;
 	}
@@ -131,7 +131,9 @@ i915_gem_object_put_pages_phys(struct dr
 	sg_free_table(pages);
 	kfree(pages);
 
-	drm_pci_free(obj->base.dev, obj->phys_handle);
+	dma_free_coherent(&obj->base.dev->pdev->dev,
+			  roundup_pow_of_two(obj->base.size),
+			  vaddr, dma);
 }
 
 static void phys_release(struct drm_i915_gem_object *obj)
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -154,7 +154,7 @@ i915_gem_phys_pwrite(struct drm_i915_gem
 		     struct drm_i915_gem_pwrite *args,
 		     struct drm_file *file)
 {
-	void *vaddr = obj->phys_handle->vaddr + args->offset;
+	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 
 	/*
@@ -800,10 +800,10 @@ i915_gem_pwrite_ioctl(struct drm_device
 		ret = i915_gem_gtt_pwrite_fast(obj, args);
 
 	if (ret == -EFAULT || ret == -ENOSPC) {
-		if (obj->phys_handle)
-			ret = i915_gem_phys_pwrite(obj, args, file);
-		else
+		if (i915_gem_object_has_struct_page(obj))
 			ret = i915_gem_shmem_pwrite(obj, args);
+		else
+			ret = i915_gem_phys_pwrite(obj, args, file);
 	}
 
 	i915_gem_object_unpin_pages(obj);


