Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE06657C7F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiL1PdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiL1PdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A5415FE1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D2161344
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842B6C433D2;
        Wed, 28 Dec 2022 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241580;
        bh=HCilaHHvMoj3jCVSqG6Ck9BTNbw24/3HuLFMZ5FkpZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJSJJkx8doLTr16P5ag5nbV+r8r6fpjZv7pUzZege764LdJMVvLJHg3nAU3aqkK5z
         2aWpPhOJmVGp0+z0ojepUw2HYne8Q77H0rssUXoZrPluWTDbml3uzmlM4Xr2HkKXjH
         d8mrmVyHH34XDOCm4KZ5TMz9+lmspMP+Wk0e0ujs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nirmoy Das <nirmoy.das@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0263/1146] drm/i915: Refactor ttm ghost obj detection
Date:   Wed, 28 Dec 2022 15:30:02 +0100
Message-Id: <20221228144337.281279718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 6667d78a1123d237d66e34923754ebca97d06d39 ]

Currently i915_ttm_to_gem() returns NULL for ttm ghost
object which makes it unclear when we should add a NULL
check for a caller of i915_ttm_to_gem() as ttm ghost
objects are expected behaviour for certain cases.

Create a separate function to detect ttm ghost object and
use that in places where we expect a ghost obj from ttm.

Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221014131427.21102-1-nirmoy.das@intel.com
Stable-dep-of: 1cacd6894d5f ("drm/i915/dgfx: Grab wakeref at i915_ttm_unmap_virtual")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c      | 21 ++++++++++----------
 drivers/gpu/drm/i915/gem/i915_gem_ttm.h      | 18 ++++++++++++-----
 drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c |  2 +-
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index 0d6d640225fc..e08351081375 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -279,7 +279,7 @@ static struct ttm_tt *i915_ttm_tt_create(struct ttm_buffer_object *bo,
 	struct i915_ttm_tt *i915_tt;
 	int ret;
 
-	if (!obj)
+	if (i915_ttm_is_ghost_object(bo))
 		return NULL;
 
 	i915_tt = kzalloc(sizeof(*i915_tt), GFP_KERNEL);
@@ -362,7 +362,7 @@ static bool i915_ttm_eviction_valuable(struct ttm_buffer_object *bo,
 {
 	struct drm_i915_gem_object *obj = i915_ttm_to_gem(bo);
 
-	if (!obj)
+	if (i915_ttm_is_ghost_object(bo))
 		return false;
 
 	/*
@@ -511,7 +511,7 @@ static void i915_ttm_delete_mem_notify(struct ttm_buffer_object *bo)
 	struct drm_i915_gem_object *obj = i915_ttm_to_gem(bo);
 	intel_wakeref_t wakeref = 0;
 
-	if (bo->resource && likely(obj)) {
+	if (bo->resource && !i915_ttm_is_ghost_object(bo)) {
 		/* ttm_bo_release() already has dma_resv_lock */
 		if (i915_ttm_cpu_maps_iomem(bo->resource))
 			wakeref = intel_runtime_pm_get(&to_i915(obj->base.dev)->runtime_pm);
@@ -628,7 +628,7 @@ static void i915_ttm_swap_notify(struct ttm_buffer_object *bo)
 	struct drm_i915_gem_object *obj = i915_ttm_to_gem(bo);
 	int ret;
 
-	if (!obj)
+	if (i915_ttm_is_ghost_object(bo))
 		return;
 
 	ret = i915_ttm_move_notify(bo);
@@ -661,7 +661,7 @@ static int i915_ttm_io_mem_reserve(struct ttm_device *bdev, struct ttm_resource
 	struct drm_i915_gem_object *obj = i915_ttm_to_gem(mem->bo);
 	bool unknown_state;
 
-	if (!obj)
+	if (i915_ttm_is_ghost_object(mem->bo))
 		return -EINVAL;
 
 	if (!kref_get_unless_zero(&obj->base.refcount))
@@ -694,7 +694,7 @@ static unsigned long i915_ttm_io_mem_pfn(struct ttm_buffer_object *bo,
 	unsigned long base;
 	unsigned int ofs;
 
-	GEM_BUG_ON(!obj);
+	GEM_BUG_ON(i915_ttm_is_ghost_object(bo));
 	GEM_WARN_ON(bo->ttm);
 
 	base = obj->mm.region->iomap.base - obj->mm.region->region.start;
@@ -994,13 +994,12 @@ static vm_fault_t vm_fault_ttm(struct vm_fault *vmf)
 	struct vm_area_struct *area = vmf->vma;
 	struct ttm_buffer_object *bo = area->vm_private_data;
 	struct drm_device *dev = bo->base.dev;
-	struct drm_i915_gem_object *obj;
+	struct drm_i915_gem_object *obj = i915_ttm_to_gem(bo);
 	intel_wakeref_t wakeref = 0;
 	vm_fault_t ret;
 	int idx;
 
-	obj = i915_ttm_to_gem(bo);
-	if (!obj)
+	if (i915_ttm_is_ghost_object(bo))
 		return VM_FAULT_SIGBUS;
 
 	/* Sanity check that we allow writing into this object */
@@ -1098,7 +1097,7 @@ static void ttm_vm_open(struct vm_area_struct *vma)
 	struct drm_i915_gem_object *obj =
 		i915_ttm_to_gem(vma->vm_private_data);
 
-	GEM_BUG_ON(!obj);
+	GEM_BUG_ON(i915_ttm_is_ghost_object(vma->vm_private_data));
 	i915_gem_object_get(obj);
 }
 
@@ -1107,7 +1106,7 @@ static void ttm_vm_close(struct vm_area_struct *vma)
 	struct drm_i915_gem_object *obj =
 		i915_ttm_to_gem(vma->vm_private_data);
 
-	GEM_BUG_ON(!obj);
+	GEM_BUG_ON(i915_ttm_is_ghost_object(vma->vm_private_data));
 	i915_gem_object_put(obj);
 }
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.h b/drivers/gpu/drm/i915/gem/i915_gem_ttm.h
index e4842b4296fc..2a94a99ef76b 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.h
@@ -27,19 +27,27 @@ i915_gem_to_ttm(struct drm_i915_gem_object *obj)
  */
 void i915_ttm_bo_destroy(struct ttm_buffer_object *bo);
 
+/**
+ * i915_ttm_is_ghost_object - Check if the ttm bo is a ghost object.
+ * @bo: Pointer to the ttm buffer object
+ *
+ * Return: True if the ttm bo is not a i915 object but a ghost ttm object,
+ * False otherwise.
+ */
+static inline bool i915_ttm_is_ghost_object(struct ttm_buffer_object *bo)
+{
+	return bo->destroy != i915_ttm_bo_destroy;
+}
+
 /**
  * i915_ttm_to_gem - Convert a struct ttm_buffer_object to an embedding
  * struct drm_i915_gem_object.
  *
- * Return: Pointer to the embedding struct ttm_buffer_object, or NULL
- * if the object was not an i915 ttm object.
+ * Return: Pointer to the embedding struct ttm_buffer_object.
  */
 static inline struct drm_i915_gem_object *
 i915_ttm_to_gem(struct ttm_buffer_object *bo)
 {
-	if (bo->destroy != i915_ttm_bo_destroy)
-		return NULL;
-
 	return container_of(bo, struct drm_i915_gem_object, __do_not_access);
 }
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
index 9a7e50534b84..f59f812dc6d2 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm_move.c
@@ -560,7 +560,7 @@ int i915_ttm_move(struct ttm_buffer_object *bo, bool evict,
 	bool clear;
 	int ret;
 
-	if (GEM_WARN_ON(!obj)) {
+	if (GEM_WARN_ON(i915_ttm_is_ghost_object(bo))) {
 		ttm_bo_move_null(bo, dst_mem);
 		return 0;
 	}
-- 
2.35.1



