Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB6483C4A
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfHFVgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728790AbfHFVgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8570217D9;
        Tue,  6 Aug 2019 21:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127360;
        bh=SNC+6pbju1r7RA/U2WTXMM0vJyegy1aHbOMPtmiYIwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+An9Hoe02cZRogew6gPYXbbx0S3oB5MQ60IN2CTu7Mgnr5CbbQaCx8JW1dQBNsAM
         FgsMpxX2pVB5Vxj8hoAnYFC0IlVXLYFO11gWs8BGZKTVnrZsxnyaP6YYA1jRhaMgSL
         wnb08NIhG8i8cnCJzmytsC13aJ8lEXgyp8sovYhY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 21/32] drm/vgem: fix cache synchronization on arm/arm64
Date:   Tue,  6 Aug 2019 17:35:09 -0400
Message-Id: <20190806213522.19859-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213522.19859-1-sashal@kernel.org>
References: <20190806213522.19859-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 7e9e5ead55beacc11116b3fb90b0de6e7cf55a69 ]

drm_cflush_pages() is no-op on arm/arm64.  But instead we can use
dma_sync API.

Fixes failures w/ vgem_test.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190717211542.30482-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vgem/vgem_drv.c | 130 ++++++++++++++++++++------------
 1 file changed, 83 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index 4709f08f39e49..78c913f163851 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -47,10 +47,16 @@ static struct vgem_device {
 	struct platform_device *platform;
 } *vgem_device;
 
+static void sync_and_unpin(struct drm_vgem_gem_object *bo);
+static struct page **pin_and_sync(struct drm_vgem_gem_object *bo);
+
 static void vgem_gem_free_object(struct drm_gem_object *obj)
 {
 	struct drm_vgem_gem_object *vgem_obj = to_vgem_bo(obj);
 
+	if (!obj->import_attach)
+		sync_and_unpin(vgem_obj);
+
 	kvfree(vgem_obj->pages);
 	mutex_destroy(&vgem_obj->pages_lock);
 
@@ -78,40 +84,15 @@ static vm_fault_t vgem_gem_fault(struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	mutex_lock(&obj->pages_lock);
+	if (!obj->pages)
+		pin_and_sync(obj);
 	if (obj->pages) {
 		get_page(obj->pages[page_offset]);
 		vmf->page = obj->pages[page_offset];
 		ret = 0;
 	}
 	mutex_unlock(&obj->pages_lock);
-	if (ret) {
-		struct page *page;
-
-		page = shmem_read_mapping_page(
-					file_inode(obj->base.filp)->i_mapping,
-					page_offset);
-		if (!IS_ERR(page)) {
-			vmf->page = page;
-			ret = 0;
-		} else switch (PTR_ERR(page)) {
-			case -ENOSPC:
-			case -ENOMEM:
-				ret = VM_FAULT_OOM;
-				break;
-			case -EBUSY:
-				ret = VM_FAULT_RETRY;
-				break;
-			case -EFAULT:
-			case -EINVAL:
-				ret = VM_FAULT_SIGBUS;
-				break;
-			default:
-				WARN_ON(PTR_ERR(page));
-				ret = VM_FAULT_SIGBUS;
-				break;
-		}
 
-	}
 	return ret;
 }
 
@@ -277,32 +258,93 @@ static const struct file_operations vgem_driver_fops = {
 	.release	= drm_release,
 };
 
-static struct page **vgem_pin_pages(struct drm_vgem_gem_object *bo)
+/* Called under pages_lock, except in free path (where it can't race): */
+static void sync_and_unpin(struct drm_vgem_gem_object *bo)
 {
-	mutex_lock(&bo->pages_lock);
-	if (bo->pages_pin_count++ == 0) {
-		struct page **pages;
+	struct drm_device *dev = bo->base.dev;
+
+	if (bo->table) {
+		dma_sync_sg_for_cpu(dev->dev, bo->table->sgl,
+				bo->table->nents, DMA_BIDIRECTIONAL);
+		sg_free_table(bo->table);
+		kfree(bo->table);
+		bo->table = NULL;
+	}
+
+	if (bo->pages) {
+		drm_gem_put_pages(&bo->base, bo->pages, true, true);
+		bo->pages = NULL;
+	}
+}
+
+static struct page **pin_and_sync(struct drm_vgem_gem_object *bo)
+{
+	struct drm_device *dev = bo->base.dev;
+	int npages = bo->base.size >> PAGE_SHIFT;
+	struct page **pages;
+	struct sg_table *sgt;
+
+	WARN_ON(!mutex_is_locked(&bo->pages_lock));
+
+	pages = drm_gem_get_pages(&bo->base);
+	if (IS_ERR(pages)) {
+		bo->pages_pin_count--;
+		mutex_unlock(&bo->pages_lock);
+		return pages;
+	}
 
-		pages = drm_gem_get_pages(&bo->base);
-		if (IS_ERR(pages)) {
-			bo->pages_pin_count--;
-			mutex_unlock(&bo->pages_lock);
-			return pages;
-		}
+	sgt = drm_prime_pages_to_sg(pages, npages);
+	if (IS_ERR(sgt)) {
+		dev_err(dev->dev,
+			"failed to allocate sgt: %ld\n",
+			PTR_ERR(bo->table));
+		drm_gem_put_pages(&bo->base, pages, false, false);
+		mutex_unlock(&bo->pages_lock);
+		return ERR_CAST(bo->table);
+	}
+
+	/*
+	 * Flush the object from the CPU cache so that importers
+	 * can rely on coherent indirect access via the exported
+	 * dma-address.
+	 */
+	dma_sync_sg_for_device(dev->dev, sgt->sgl,
+			sgt->nents, DMA_BIDIRECTIONAL);
+
+	bo->pages = pages;
+	bo->table = sgt;
+
+	return pages;
+}
+
+static struct page **vgem_pin_pages(struct drm_vgem_gem_object *bo)
+{
+	struct page **pages;
 
-		bo->pages = pages;
+	mutex_lock(&bo->pages_lock);
+	if (bo->pages_pin_count++ == 0 && !bo->pages) {
+		pages = pin_and_sync(bo);
+	} else {
+		WARN_ON(!bo->pages);
+		pages = bo->pages;
 	}
 	mutex_unlock(&bo->pages_lock);
 
-	return bo->pages;
+	return pages;
 }
 
 static void vgem_unpin_pages(struct drm_vgem_gem_object *bo)
 {
+	/*
+	 * We shouldn't hit this for imported bo's.. in the import
+	 * case we don't own the scatter-table
+	 */
+	WARN_ON(bo->base.import_attach);
+
 	mutex_lock(&bo->pages_lock);
 	if (--bo->pages_pin_count == 0) {
-		drm_gem_put_pages(&bo->base, bo->pages, true, true);
-		bo->pages = NULL;
+		WARN_ON(!bo->table);
+		sync_and_unpin(bo);
 	}
 	mutex_unlock(&bo->pages_lock);
 }
@@ -310,18 +352,12 @@ static void vgem_unpin_pages(struct drm_vgem_gem_object *bo)
 static int vgem_prime_pin(struct drm_gem_object *obj)
 {
 	struct drm_vgem_gem_object *bo = to_vgem_bo(obj);
-	long n_pages = obj->size >> PAGE_SHIFT;
 	struct page **pages;
 
 	pages = vgem_pin_pages(bo);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
-	/* Flush the object from the CPU cache so that importers can rely
-	 * on coherent indirect access via the exported dma-address.
-	 */
-	drm_clflush_pages(pages, n_pages);
-
 	return 0;
 }
 
-- 
2.20.1

