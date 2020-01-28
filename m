Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91914B628
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgA1OC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbgA1OC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99B6C205F4;
        Tue, 28 Jan 2020 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220174;
        bh=phoO5cDKx6RFxQNtV/pvh31BbxSHFOJoC+Jivrl/K54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3ZGujB9/3Ov/yrpeFwna9JOnVCO6MDvWGU9evX9bnPfkwacuA8B5l8H9OSn8fnIr
         1937bzQwZGEOIkrPHoPVuqI9yJdC0y6aXiOBYwHTYIBf+34Hh6+dYkadkO2DQuZW5y
         gP15+r97bZ24w+7g+KEjbkyuaxsrgu4uQXDJTVC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh@kernel.org>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.4 039/104] drm/panfrost: Add the panfrost_gem_mapping concept
Date:   Tue, 28 Jan 2020 15:00:00 +0100
Message-Id: <20200128135822.975056697@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit bdefca2d8dc0f80bbe49e08bf52a717146490706 upstream.

With the introduction of per-FD address space, the same BO can be mapped
in different address space if the BO is globally visible (GEM_FLINK)
and opened in different context or if the dmabuf is self-imported. The
current implementation does not take case into account, and attaches the
mapping directly to the panfrost_gem_object.

Let's create a panfrost_gem_mapping struct and allow multiple mappings
per BO.

The mappings are refcounted which helps solve another problem where
mappings were torn down (GEM handle closed by userspace) while GPU
jobs accessing those BOs were still in-flight. Jobs now keep a
reference on the mappings they use.

v2 (robh):
- Minor review comment clean-ups from Steven
- Use list_is_singular helper
- Just WARN if we add a mapping when madvise state is not WILLNEED.
  With that, drop the use of object_name_lock.

v3 (robh):
- Revert returning list iterator in panfrost_gem_mapping_get()

Fixes: a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation")
Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200116021554.15090-1-robh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_drv.c          |   91 +++++++++++++++-
 drivers/gpu/drm/panfrost/panfrost_gem.c          |  124 ++++++++++++++++++++---
 drivers/gpu/drm/panfrost/panfrost_gem.h          |   41 ++++++-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c |    3 
 drivers/gpu/drm/panfrost/panfrost_job.c          |   13 ++
 drivers/gpu/drm/panfrost/panfrost_job.h          |    1 
 drivers/gpu/drm/panfrost/panfrost_mmu.c          |   61 ++++++-----
 drivers/gpu/drm/panfrost/panfrost_mmu.h          |    6 -
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c      |   34 ++++--
 9 files changed, 300 insertions(+), 74 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -78,8 +78,10 @@ static int panfrost_ioctl_get_param(stru
 static int panfrost_ioctl_create_bo(struct drm_device *dev, void *data,
 		struct drm_file *file)
 {
+	struct panfrost_file_priv *priv = file->driver_priv;
 	struct panfrost_gem_object *bo;
 	struct drm_panfrost_create_bo *args = data;
+	struct panfrost_gem_mapping *mapping;
 
 	if (!args->size || args->pad ||
 	    (args->flags & ~(PANFROST_BO_NOEXEC | PANFROST_BO_HEAP)))
@@ -95,7 +97,14 @@ static int panfrost_ioctl_create_bo(stru
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
-	args->offset = bo->node.start << PAGE_SHIFT;
+	mapping = panfrost_gem_mapping_get(bo, priv);
+	if (!mapping) {
+		drm_gem_object_put_unlocked(&bo->base.base);
+		return -EINVAL;
+	}
+
+	args->offset = mapping->mmnode.start << PAGE_SHIFT;
+	panfrost_gem_mapping_put(mapping);
 
 	return 0;
 }
@@ -119,6 +128,11 @@ panfrost_lookup_bos(struct drm_device *d
 		  struct drm_panfrost_submit *args,
 		  struct panfrost_job *job)
 {
+	struct panfrost_file_priv *priv = file_priv->driver_priv;
+	struct panfrost_gem_object *bo;
+	unsigned int i;
+	int ret;
+
 	job->bo_count = args->bo_handle_count;
 
 	if (!job->bo_count)
@@ -130,9 +144,32 @@ panfrost_lookup_bos(struct drm_device *d
 	if (!job->implicit_fences)
 		return -ENOMEM;
 
-	return drm_gem_objects_lookup(file_priv,
-				      (void __user *)(uintptr_t)args->bo_handles,
-				      job->bo_count, &job->bos);
+	ret = drm_gem_objects_lookup(file_priv,
+				     (void __user *)(uintptr_t)args->bo_handles,
+				     job->bo_count, &job->bos);
+	if (ret)
+		return ret;
+
+	job->mappings = kvmalloc_array(job->bo_count,
+				       sizeof(struct panfrost_gem_mapping *),
+				       GFP_KERNEL | __GFP_ZERO);
+	if (!job->mappings)
+		return -ENOMEM;
+
+	for (i = 0; i < job->bo_count; i++) {
+		struct panfrost_gem_mapping *mapping;
+
+		bo = to_panfrost_bo(job->bos[i]);
+		mapping = panfrost_gem_mapping_get(bo, priv);
+		if (!mapping) {
+			ret = -EINVAL;
+			break;
+		}
+
+		job->mappings[i] = mapping;
+	}
+
+	return ret;
 }
 
 /**
@@ -320,7 +357,9 @@ out:
 static int panfrost_ioctl_get_bo_offset(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv)
 {
+	struct panfrost_file_priv *priv = file_priv->driver_priv;
 	struct drm_panfrost_get_bo_offset *args = data;
+	struct panfrost_gem_mapping *mapping;
 	struct drm_gem_object *gem_obj;
 	struct panfrost_gem_object *bo;
 
@@ -331,18 +370,26 @@ static int panfrost_ioctl_get_bo_offset(
 	}
 	bo = to_panfrost_bo(gem_obj);
 
-	args->offset = bo->node.start << PAGE_SHIFT;
-
+	mapping = panfrost_gem_mapping_get(bo, priv);
 	drm_gem_object_put_unlocked(gem_obj);
+
+	if (!mapping)
+		return -EINVAL;
+
+	args->offset = mapping->mmnode.start << PAGE_SHIFT;
+	panfrost_gem_mapping_put(mapping);
 	return 0;
 }
 
 static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 				  struct drm_file *file_priv)
 {
+	struct panfrost_file_priv *priv = file_priv->driver_priv;
 	struct drm_panfrost_madvise *args = data;
 	struct panfrost_device *pfdev = dev->dev_private;
 	struct drm_gem_object *gem_obj;
+	struct panfrost_gem_object *bo;
+	int ret = 0;
 
 	gem_obj = drm_gem_object_lookup(file_priv, args->handle);
 	if (!gem_obj) {
@@ -350,22 +397,48 @@ static int panfrost_ioctl_madvise(struct
 		return -ENOENT;
 	}
 
+	bo = to_panfrost_bo(gem_obj);
+
 	mutex_lock(&pfdev->shrinker_lock);
+	mutex_lock(&bo->mappings.lock);
+	if (args->madv == PANFROST_MADV_DONTNEED) {
+		struct panfrost_gem_mapping *first;
+
+		first = list_first_entry(&bo->mappings.list,
+					 struct panfrost_gem_mapping,
+					 node);
+
+		/*
+		 * If we want to mark the BO purgeable, there must be only one
+		 * user: the caller FD.
+		 * We could do something smarter and mark the BO purgeable only
+		 * when all its users have marked it purgeable, but globally
+		 * visible/shared BOs are likely to never be marked purgeable
+		 * anyway, so let's not bother.
+		 */
+		if (!list_is_singular(&bo->mappings.list) ||
+		    WARN_ON_ONCE(first->mmu != &priv->mmu)) {
+			ret = -EINVAL;
+			goto out_unlock_mappings;
+		}
+	}
+
 	args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);
 
 	if (args->retained) {
-		struct panfrost_gem_object *bo = to_panfrost_bo(gem_obj);
-
 		if (args->madv == PANFROST_MADV_DONTNEED)
 			list_add_tail(&bo->base.madv_list,
 				      &pfdev->shrinker_list);
 		else if (args->madv == PANFROST_MADV_WILLNEED)
 			list_del_init(&bo->base.madv_list);
 	}
+
+out_unlock_mappings:
+	mutex_unlock(&bo->mappings.lock);
 	mutex_unlock(&pfdev->shrinker_lock);
 
 	drm_gem_object_put_unlocked(gem_obj);
-	return 0;
+	return ret;
 }
 
 int panfrost_unstable_ioctl_check(void)
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -29,6 +29,12 @@ static void panfrost_gem_free_object(str
 	list_del_init(&bo->base.madv_list);
 	mutex_unlock(&pfdev->shrinker_lock);
 
+	/*
+	 * If we still have mappings attached to the BO, there's a problem in
+	 * our refcounting.
+	 */
+	WARN_ON_ONCE(!list_empty(&bo->mappings.list));
+
 	if (bo->sgts) {
 		int i;
 		int n_sgt = bo->base.base.size / SZ_2M;
@@ -46,6 +52,69 @@ static void panfrost_gem_free_object(str
 	drm_gem_shmem_free_object(obj);
 }
 
+struct panfrost_gem_mapping *
+panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
+			 struct panfrost_file_priv *priv)
+{
+	struct panfrost_gem_mapping *iter, *mapping = NULL;
+
+	mutex_lock(&bo->mappings.lock);
+	list_for_each_entry(iter, &bo->mappings.list, node) {
+		if (iter->mmu == &priv->mmu) {
+			kref_get(&iter->refcount);
+			mapping = iter;
+			break;
+		}
+	}
+	mutex_unlock(&bo->mappings.lock);
+
+	return mapping;
+}
+
+static void
+panfrost_gem_teardown_mapping(struct panfrost_gem_mapping *mapping)
+{
+	struct panfrost_file_priv *priv;
+
+	if (mapping->active)
+		panfrost_mmu_unmap(mapping);
+
+	priv = container_of(mapping->mmu, struct panfrost_file_priv, mmu);
+	spin_lock(&priv->mm_lock);
+	if (drm_mm_node_allocated(&mapping->mmnode))
+		drm_mm_remove_node(&mapping->mmnode);
+	spin_unlock(&priv->mm_lock);
+}
+
+static void panfrost_gem_mapping_release(struct kref *kref)
+{
+	struct panfrost_gem_mapping *mapping;
+
+	mapping = container_of(kref, struct panfrost_gem_mapping, refcount);
+
+	panfrost_gem_teardown_mapping(mapping);
+	drm_gem_object_put_unlocked(&mapping->obj->base.base);
+	kfree(mapping);
+}
+
+void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping)
+{
+	if (!mapping)
+		return;
+
+	kref_put(&mapping->refcount, panfrost_gem_mapping_release);
+}
+
+void panfrost_gem_teardown_mappings(struct panfrost_gem_object *bo)
+{
+	struct panfrost_gem_mapping *mapping;
+
+	mutex_lock(&bo->mappings.lock);
+	list_for_each_entry(mapping, &bo->mappings.list, node)
+		panfrost_gem_teardown_mapping(mapping);
+	mutex_unlock(&bo->mappings.lock);
+}
+
 int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
 {
 	int ret;
@@ -54,6 +123,16 @@ int panfrost_gem_open(struct drm_gem_obj
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 	unsigned long color = bo->noexec ? PANFROST_BO_NOEXEC : 0;
 	struct panfrost_file_priv *priv = file_priv->driver_priv;
+	struct panfrost_gem_mapping *mapping;
+
+	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mapping->node);
+	kref_init(&mapping->refcount);
+	drm_gem_object_get(obj);
+	mapping->obj = bo;
 
 	/*
 	 * Executable buffers cannot cross a 16MB boundary as the program
@@ -66,37 +145,48 @@ int panfrost_gem_open(struct drm_gem_obj
 	else
 		align = size >= SZ_2M ? SZ_2M >> PAGE_SHIFT : 0;
 
-	bo->mmu = &priv->mmu;
+	mapping->mmu = &priv->mmu;
 	spin_lock(&priv->mm_lock);
-	ret = drm_mm_insert_node_generic(&priv->mm, &bo->node,
+	ret = drm_mm_insert_node_generic(&priv->mm, &mapping->mmnode,
 					 size >> PAGE_SHIFT, align, color, 0);
 	spin_unlock(&priv->mm_lock);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (!bo->is_heap) {
-		ret = panfrost_mmu_map(bo);
-		if (ret) {
-			spin_lock(&priv->mm_lock);
-			drm_mm_remove_node(&bo->node);
-			spin_unlock(&priv->mm_lock);
-		}
+		ret = panfrost_mmu_map(mapping);
+		if (ret)
+			goto err;
 	}
+
+	mutex_lock(&bo->mappings.lock);
+	WARN_ON(bo->base.madv != PANFROST_MADV_WILLNEED);
+	list_add_tail(&mapping->node, &bo->mappings.list);
+	mutex_unlock(&bo->mappings.lock);
+
+err:
+	if (ret)
+		panfrost_gem_mapping_put(mapping);
 	return ret;
 }
 
 void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
 {
-	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 	struct panfrost_file_priv *priv = file_priv->driver_priv;
+	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
+	struct panfrost_gem_mapping *mapping = NULL, *iter;
 
-	if (bo->is_mapped)
-		panfrost_mmu_unmap(bo);
+	mutex_lock(&bo->mappings.lock);
+	list_for_each_entry(iter, &bo->mappings.list, node) {
+		if (iter->mmu == &priv->mmu) {
+			mapping = iter;
+			list_del(&iter->node);
+			break;
+		}
+	}
+	mutex_unlock(&bo->mappings.lock);
 
-	spin_lock(&priv->mm_lock);
-	if (drm_mm_node_allocated(&bo->node))
-		drm_mm_remove_node(&bo->node);
-	spin_unlock(&priv->mm_lock);
+	panfrost_gem_mapping_put(mapping);
 }
 
 static int panfrost_gem_pin(struct drm_gem_object *obj)
@@ -136,6 +226,8 @@ struct drm_gem_object *panfrost_gem_crea
 	if (!obj)
 		return NULL;
 
+	INIT_LIST_HEAD(&obj->mappings.list);
+	mutex_init(&obj->mappings.lock);
 	obj->base.base.funcs = &panfrost_gem_funcs;
 
 	return &obj->base.base;
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -13,23 +13,46 @@ struct panfrost_gem_object {
 	struct drm_gem_shmem_object base;
 	struct sg_table *sgts;
 
-	struct panfrost_mmu *mmu;
-	struct drm_mm_node node;
-	bool is_mapped		:1;
+	/*
+	 * Use a list for now. If searching a mapping ever becomes the
+	 * bottleneck, we should consider using an RB-tree, or even better,
+	 * let the core store drm_gem_object_mapping entries (where we
+	 * could place driver specific data) instead of drm_gem_object ones
+	 * in its drm_file->object_idr table.
+	 *
+	 * struct drm_gem_object_mapping {
+	 *	struct drm_gem_object *obj;
+	 *	void *driver_priv;
+	 * };
+	 */
+	struct {
+		struct list_head list;
+		struct mutex lock;
+	} mappings;
+
 	bool noexec		:1;
 	bool is_heap		:1;
 };
 
+struct panfrost_gem_mapping {
+	struct list_head node;
+	struct kref refcount;
+	struct panfrost_gem_object *obj;
+	struct drm_mm_node mmnode;
+	struct panfrost_mmu *mmu;
+	bool active		:1;
+};
+
 static inline
 struct  panfrost_gem_object *to_panfrost_bo(struct drm_gem_object *obj)
 {
 	return container_of(to_drm_gem_shmem_obj(obj), struct panfrost_gem_object, base);
 }
 
-static inline
-struct  panfrost_gem_object *drm_mm_node_to_panfrost_bo(struct drm_mm_node *node)
+static inline struct panfrost_gem_mapping *
+drm_mm_node_to_panfrost_mapping(struct drm_mm_node *node)
 {
-	return container_of(node, struct panfrost_gem_object, node);
+	return container_of(node, struct panfrost_gem_mapping, mmnode);
 }
 
 struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t size);
@@ -49,6 +72,12 @@ int panfrost_gem_open(struct drm_gem_obj
 void panfrost_gem_close(struct drm_gem_object *obj,
 			struct drm_file *file_priv);
 
+struct panfrost_gem_mapping *
+panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
+			 struct panfrost_file_priv *priv);
+void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
+void panfrost_gem_teardown_mappings(struct panfrost_gem_object *bo);
+
 void panfrost_gem_shrinker_init(struct drm_device *dev);
 void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
 
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -39,11 +39,12 @@ panfrost_gem_shrinker_count(struct shrin
 static bool panfrost_gem_purge(struct drm_gem_object *obj)
 {
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
+	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 
 	if (!mutex_trylock(&shmem->pages_lock))
 		return false;
 
-	panfrost_mmu_unmap(to_panfrost_bo(obj));
+	panfrost_gem_teardown_mappings(bo);
 	drm_gem_shmem_purge_locked(obj);
 
 	mutex_unlock(&shmem->pages_lock);
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -269,9 +269,20 @@ static void panfrost_job_cleanup(struct
 	dma_fence_put(job->done_fence);
 	dma_fence_put(job->render_done_fence);
 
-	if (job->bos) {
+	if (job->mappings) {
 		for (i = 0; i < job->bo_count; i++)
+			panfrost_gem_mapping_put(job->mappings[i]);
+		kvfree(job->mappings);
+	}
+
+	if (job->bos) {
+		struct panfrost_gem_object *bo;
+
+		for (i = 0; i < job->bo_count; i++) {
+			bo = to_panfrost_bo(job->bos[i]);
 			drm_gem_object_put_unlocked(job->bos[i]);
+		}
+
 		kvfree(job->bos);
 	}
 
--- a/drivers/gpu/drm/panfrost/panfrost_job.h
+++ b/drivers/gpu/drm/panfrost/panfrost_job.h
@@ -32,6 +32,7 @@ struct panfrost_job {
 
 	/* Exclusive fences we have taken from the BOs to wait for */
 	struct dma_fence **implicit_fences;
+	struct panfrost_gem_mapping **mappings;
 	struct drm_gem_object **bos;
 	u32 bo_count;
 
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -269,14 +269,15 @@ static int mmu_map_sg(struct panfrost_de
 	return 0;
 }
 
-int panfrost_mmu_map(struct panfrost_gem_object *bo)
+int panfrost_mmu_map(struct panfrost_gem_mapping *mapping)
 {
+	struct panfrost_gem_object *bo = mapping->obj;
 	struct drm_gem_object *obj = &bo->base.base;
 	struct panfrost_device *pfdev = to_panfrost_device(obj->dev);
 	struct sg_table *sgt;
 	int prot = IOMMU_READ | IOMMU_WRITE;
 
-	if (WARN_ON(bo->is_mapped))
+	if (WARN_ON(mapping->active))
 		return 0;
 
 	if (bo->noexec)
@@ -286,25 +287,28 @@ int panfrost_mmu_map(struct panfrost_gem
 	if (WARN_ON(IS_ERR(sgt)))
 		return PTR_ERR(sgt);
 
-	mmu_map_sg(pfdev, bo->mmu, bo->node.start << PAGE_SHIFT, prot, sgt);
-	bo->is_mapped = true;
+	mmu_map_sg(pfdev, mapping->mmu, mapping->mmnode.start << PAGE_SHIFT,
+		   prot, sgt);
+	mapping->active = true;
 
 	return 0;
 }
 
-void panfrost_mmu_unmap(struct panfrost_gem_object *bo)
+void panfrost_mmu_unmap(struct panfrost_gem_mapping *mapping)
 {
+	struct panfrost_gem_object *bo = mapping->obj;
 	struct drm_gem_object *obj = &bo->base.base;
 	struct panfrost_device *pfdev = to_panfrost_device(obj->dev);
-	struct io_pgtable_ops *ops = bo->mmu->pgtbl_ops;
-	u64 iova = bo->node.start << PAGE_SHIFT;
-	size_t len = bo->node.size << PAGE_SHIFT;
+	struct io_pgtable_ops *ops = mapping->mmu->pgtbl_ops;
+	u64 iova = mapping->mmnode.start << PAGE_SHIFT;
+	size_t len = mapping->mmnode.size << PAGE_SHIFT;
 	size_t unmapped_len = 0;
 
-	if (WARN_ON(!bo->is_mapped))
+	if (WARN_ON(!mapping->active))
 		return;
 
-	dev_dbg(pfdev->dev, "unmap: as=%d, iova=%llx, len=%zx", bo->mmu->as, iova, len);
+	dev_dbg(pfdev->dev, "unmap: as=%d, iova=%llx, len=%zx",
+		mapping->mmu->as, iova, len);
 
 	while (unmapped_len < len) {
 		size_t unmapped_page;
@@ -318,8 +322,9 @@ void panfrost_mmu_unmap(struct panfrost_
 		unmapped_len += pgsize;
 	}
 
-	panfrost_mmu_flush_range(pfdev, bo->mmu, bo->node.start << PAGE_SHIFT, len);
-	bo->is_mapped = false;
+	panfrost_mmu_flush_range(pfdev, mapping->mmu,
+				 mapping->mmnode.start << PAGE_SHIFT, len);
+	mapping->active = false;
 }
 
 static void mmu_tlb_inv_context_s1(void *cookie)
@@ -394,10 +399,10 @@ void panfrost_mmu_pgtable_free(struct pa
 	free_io_pgtable_ops(mmu->pgtbl_ops);
 }
 
-static struct panfrost_gem_object *
-addr_to_drm_mm_node(struct panfrost_device *pfdev, int as, u64 addr)
+static struct panfrost_gem_mapping *
+addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
 {
-	struct panfrost_gem_object *bo = NULL;
+	struct panfrost_gem_mapping *mapping = NULL;
 	struct panfrost_file_priv *priv;
 	struct drm_mm_node *node;
 	u64 offset = addr >> PAGE_SHIFT;
@@ -418,8 +423,9 @@ found_mmu:
 	drm_mm_for_each_node(node, &priv->mm) {
 		if (offset >= node->start &&
 		    offset < (node->start + node->size)) {
-			bo = drm_mm_node_to_panfrost_bo(node);
-			drm_gem_object_get(&bo->base.base);
+			mapping = drm_mm_node_to_panfrost_mapping(node);
+
+			kref_get(&mapping->refcount);
 			break;
 		}
 	}
@@ -427,7 +433,7 @@ found_mmu:
 	spin_unlock(&priv->mm_lock);
 out:
 	spin_unlock(&pfdev->as_lock);
-	return bo;
+	return mapping;
 }
 
 #define NUM_FAULT_PAGES (SZ_2M / PAGE_SIZE)
@@ -436,28 +442,30 @@ static int panfrost_mmu_map_fault_addr(s
 				       u64 addr)
 {
 	int ret, i;
+	struct panfrost_gem_mapping *bomapping;
 	struct panfrost_gem_object *bo;
 	struct address_space *mapping;
 	pgoff_t page_offset;
 	struct sg_table *sgt;
 	struct page **pages;
 
-	bo = addr_to_drm_mm_node(pfdev, as, addr);
-	if (!bo)
+	bomapping = addr_to_mapping(pfdev, as, addr);
+	if (!bomapping)
 		return -ENOENT;
 
+	bo = bomapping->obj;
 	if (!bo->is_heap) {
 		dev_WARN(pfdev->dev, "matching BO is not heap type (GPU VA = %llx)",
-			 bo->node.start << PAGE_SHIFT);
+			 bomapping->mmnode.start << PAGE_SHIFT);
 		ret = -EINVAL;
 		goto err_bo;
 	}
-	WARN_ON(bo->mmu->as != as);
+	WARN_ON(bomapping->mmu->as != as);
 
 	/* Assume 2MB alignment and size multiple */
 	addr &= ~((u64)SZ_2M - 1);
 	page_offset = addr >> PAGE_SHIFT;
-	page_offset -= bo->node.start;
+	page_offset -= bomapping->mmnode.start;
 
 	mutex_lock(&bo->base.pages_lock);
 
@@ -509,13 +517,14 @@ static int panfrost_mmu_map_fault_addr(s
 		goto err_map;
 	}
 
-	mmu_map_sg(pfdev, bo->mmu, addr, IOMMU_WRITE | IOMMU_READ | IOMMU_NOEXEC, sgt);
+	mmu_map_sg(pfdev, bomapping->mmu, addr,
+		   IOMMU_WRITE | IOMMU_READ | IOMMU_NOEXEC, sgt);
 
-	bo->is_mapped = true;
+	bomapping->active = true;
 
 	dev_dbg(pfdev->dev, "mapped page fault @ AS%d %llx", as, addr);
 
-	drm_gem_object_put_unlocked(&bo->base.base);
+	panfrost_gem_mapping_put(bomapping);
 
 	return 0;
 
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.h
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.h
@@ -4,12 +4,12 @@
 #ifndef __PANFROST_MMU_H__
 #define __PANFROST_MMU_H__
 
-struct panfrost_gem_object;
+struct panfrost_gem_mapping;
 struct panfrost_file_priv;
 struct panfrost_mmu;
 
-int panfrost_mmu_map(struct panfrost_gem_object *bo);
-void panfrost_mmu_unmap(struct panfrost_gem_object *bo);
+int panfrost_mmu_map(struct panfrost_gem_mapping *mapping);
+void panfrost_mmu_unmap(struct panfrost_gem_mapping *mapping);
 
 int panfrost_mmu_init(struct panfrost_device *pfdev);
 void panfrost_mmu_fini(struct panfrost_device *pfdev);
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -25,7 +25,7 @@
 #define V4_SHADERS_PER_COREGROUP	4
 
 struct panfrost_perfcnt {
-	struct panfrost_gem_object *bo;
+	struct panfrost_gem_mapping *mapping;
 	size_t bosize;
 	void *buf;
 	struct panfrost_file_priv *user;
@@ -49,7 +49,7 @@ static int panfrost_perfcnt_dump_locked(
 	int ret;
 
 	reinit_completion(&pfdev->perfcnt->dump_comp);
-	gpuva = pfdev->perfcnt->bo->node.start << PAGE_SHIFT;
+	gpuva = pfdev->perfcnt->mapping->mmnode.start << PAGE_SHIFT;
 	gpu_write(pfdev, GPU_PERFCNT_BASE_LO, gpuva);
 	gpu_write(pfdev, GPU_PERFCNT_BASE_HI, gpuva >> 32);
 	gpu_write(pfdev, GPU_INT_CLEAR,
@@ -89,17 +89,22 @@ static int panfrost_perfcnt_enable_locke
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
-	perfcnt->bo = to_panfrost_bo(&bo->base);
-
 	/* Map the perfcnt buf in the address space attached to file_priv. */
-	ret = panfrost_gem_open(&perfcnt->bo->base.base, file_priv);
+	ret = panfrost_gem_open(&bo->base, file_priv);
 	if (ret)
 		goto err_put_bo;
 
+	perfcnt->mapping = panfrost_gem_mapping_get(to_panfrost_bo(&bo->base),
+						    user);
+	if (!perfcnt->mapping) {
+		ret = -EINVAL;
+		goto err_close_bo;
+	}
+
 	perfcnt->buf = drm_gem_shmem_vmap(&bo->base);
 	if (IS_ERR(perfcnt->buf)) {
 		ret = PTR_ERR(perfcnt->buf);
-		goto err_close_bo;
+		goto err_put_mapping;
 	}
 
 	/*
@@ -154,12 +159,17 @@ static int panfrost_perfcnt_enable_locke
 	if (panfrost_has_hw_issue(pfdev, HW_ISSUE_8186))
 		gpu_write(pfdev, GPU_PRFCNT_TILER_EN, 0xffffffff);
 
+	/* The BO ref is retained by the mapping. */
+	drm_gem_object_put_unlocked(&bo->base);
+
 	return 0;
 
 err_vunmap:
-	drm_gem_shmem_vunmap(&perfcnt->bo->base.base, perfcnt->buf);
+	drm_gem_shmem_vunmap(&bo->base, perfcnt->buf);
+err_put_mapping:
+	panfrost_gem_mapping_put(perfcnt->mapping);
 err_close_bo:
-	panfrost_gem_close(&perfcnt->bo->base.base, file_priv);
+	panfrost_gem_close(&bo->base, file_priv);
 err_put_bo:
 	drm_gem_object_put_unlocked(&bo->base);
 	return ret;
@@ -182,11 +192,11 @@ static int panfrost_perfcnt_disable_lock
 		  GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_OFF));
 
 	perfcnt->user = NULL;
-	drm_gem_shmem_vunmap(&perfcnt->bo->base.base, perfcnt->buf);
+	drm_gem_shmem_vunmap(&perfcnt->mapping->obj->base.base, perfcnt->buf);
 	perfcnt->buf = NULL;
-	panfrost_gem_close(&perfcnt->bo->base.base, file_priv);
-	drm_gem_object_put_unlocked(&perfcnt->bo->base.base);
-	perfcnt->bo = NULL;
+	panfrost_gem_close(&perfcnt->mapping->obj->base.base, file_priv);
+	panfrost_gem_mapping_put(perfcnt->mapping);
+	perfcnt->mapping = NULL;
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_put_autosuspend(pfdev->dev);
 


