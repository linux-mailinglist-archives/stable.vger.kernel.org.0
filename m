Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BD6491523
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbiARC0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:26:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38442 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245061AbiARCYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 434C8B8122C;
        Tue, 18 Jan 2022 02:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DB8C36AE3;
        Tue, 18 Jan 2022 02:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472655;
        bh=XqqZhZVVlX5olFQFKA/GsYEKRETBxCwomFV/uenBILs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGVFh2tySH9nEeZYyR+9KsagDxtV+Bd0Q5DPS5eCkZb1EAw960+t7uGZ06cX+p+G+
         RCBchiiu0fyZ/av6QV8Jso1PPlDfJFQj93IsYxN5vu0pqvWH9oAcYdNv7vVfKyFtDJ
         e2Zlxd4XsdQ56z1Wgg6rE5oq17vxcHD3YCF2VMVactKQcRBfuU1LXugR1BdWxJRatb
         ckdGSBltqeJq/866CJ5LGzVuyAvVm1EQkYskzX7G1SmDNfO89EZk+hnIbXTnx+encc
         Oy4+0yoccVGyCNdL2b0uQBBlR12Xi1oL+hH8eJW73j1O6RhlSRWHMSykILk5xUfssw
         dq5R5qOJwnqCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Steven Price <steven.price@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, yuq825@gmail.com,
        robh@kernel.org, tomeu.vizoso@collabora.com, emma@anholt.net,
        kraxel@redhat.com, lee.jones@linaro.org,
        dri-devel@lists.freedesktop.org, lima@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.16 088/217] drm: Return error codes from struct drm_driver.gem_create_object
Date:   Mon, 17 Jan 2022 21:17:31 -0500
Message-Id: <20220118021940.1942199-88-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 4ff22f487f8c26b99cbe1678344595734c001a39 ]

GEM helper libraries use struct drm_driver.gem_create_object to let
drivers override GEM object allocation. On failure, the call returns
NULL.

Change the semantics to make the calls return a pointer-encoded error.
This aligns the callback with its callers. Fixes the ingenic driver,
which already returns an error pointer.

Also update the callers to handle the involved types more strictly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211130095255.26710-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_cma_helper.c    | 17 ++++++++++-------
 drivers/gpu/drm/drm_gem_shmem_helper.c  | 17 ++++++++++-------
 drivers/gpu/drm/drm_gem_vram_helper.c   |  4 ++--
 drivers/gpu/drm/lima/lima_gem.c         |  2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c |  2 +-
 drivers/gpu/drm/v3d/v3d_bo.c            |  4 ++--
 drivers/gpu/drm/vgem/vgem_drv.c         |  2 +-
 drivers/gpu/drm/virtio/virtgpu_object.c |  2 +-
 include/drm/drm_drv.h                   |  5 +++--
 9 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
index 9d05674550a4f..1e7e8cd64cb58 100644
--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -62,18 +62,21 @@ __drm_gem_cma_create(struct drm_device *drm, size_t size, bool private)
 	struct drm_gem_object *gem_obj;
 	int ret = 0;
 
-	if (drm->driver->gem_create_object)
+	if (drm->driver->gem_create_object) {
 		gem_obj = drm->driver->gem_create_object(drm, size);
-	else
-		gem_obj = kzalloc(sizeof(*cma_obj), GFP_KERNEL);
-	if (!gem_obj)
-		return ERR_PTR(-ENOMEM);
+		if (IS_ERR(gem_obj))
+			return ERR_CAST(gem_obj);
+		cma_obj = to_drm_gem_cma_obj(gem_obj);
+	} else {
+		cma_obj = kzalloc(sizeof(*cma_obj), GFP_KERNEL);
+		if (!cma_obj)
+			return ERR_PTR(-ENOMEM);
+		gem_obj = &cma_obj->base;
+	}
 
 	if (!gem_obj->funcs)
 		gem_obj->funcs = &drm_gem_cma_default_funcs;
 
-	cma_obj = container_of(gem_obj, struct drm_gem_cma_object, base);
-
 	if (private) {
 		drm_gem_private_object_init(drm, gem_obj, size);
 
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index bca0de92802ef..fe157bf278347 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -51,14 +51,17 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private)
 
 	size = PAGE_ALIGN(size);
 
-	if (dev->driver->gem_create_object)
+	if (dev->driver->gem_create_object) {
 		obj = dev->driver->gem_create_object(dev, size);
-	else
-		obj = kzalloc(sizeof(*shmem), GFP_KERNEL);
-	if (!obj)
-		return ERR_PTR(-ENOMEM);
-
-	shmem = to_drm_gem_shmem_obj(obj);
+		if (IS_ERR(obj))
+			return ERR_CAST(obj);
+		shmem = to_drm_gem_shmem_obj(obj);
+	} else {
+		shmem = kzalloc(sizeof(*shmem), GFP_KERNEL);
+		if (!shmem)
+			return ERR_PTR(-ENOMEM);
+		obj = &shmem->base;
+	}
 
 	if (!obj->funcs)
 		obj->funcs = &drm_gem_shmem_funcs;
diff --git a/drivers/gpu/drm/drm_gem_vram_helper.c b/drivers/gpu/drm/drm_gem_vram_helper.c
index bfa386b981346..3f00192215d11 100644
--- a/drivers/gpu/drm/drm_gem_vram_helper.c
+++ b/drivers/gpu/drm/drm_gem_vram_helper.c
@@ -197,8 +197,8 @@ struct drm_gem_vram_object *drm_gem_vram_create(struct drm_device *dev,
 
 	if (dev->driver->gem_create_object) {
 		gem = dev->driver->gem_create_object(dev, size);
-		if (!gem)
-			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(gem))
+			return ERR_CAST(gem);
 		gbo = drm_gem_vram_of_gem(gem);
 	} else {
 		gbo = kzalloc(sizeof(*gbo), GFP_KERNEL);
diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima/lima_gem.c
index 640acc060467c..54823bd701a4b 100644
--- a/drivers/gpu/drm/lima/lima_gem.c
+++ b/drivers/gpu/drm/lima/lima_gem.c
@@ -221,7 +221,7 @@ struct drm_gem_object *lima_gem_create_object(struct drm_device *dev, size_t siz
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
 	if (!bo)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&bo->lock);
 	INIT_LIST_HEAD(&bo->va);
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 23377481f4e31..39ac031548954 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -221,7 +221,7 @@ struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (!obj)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&obj->mappings.list);
 	mutex_init(&obj->mappings.lock);
diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
index 6a8731ab9d7d0..9a1a92782524c 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -70,11 +70,11 @@ struct drm_gem_object *v3d_create_object(struct drm_device *dev, size_t size)
 	struct drm_gem_object *obj;
 
 	if (size == 0)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
 	if (!bo)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	obj = &bo->base.base;
 
 	obj->funcs = &v3d_gem_funcs;
diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index a87eafa89e9f4..c5e3e54577377 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -97,7 +97,7 @@ static struct drm_gem_object *vgem_gem_create_object(struct drm_device *dev, siz
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (!obj)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/*
 	 * vgem doesn't have any begin/end cpu access ioctls, therefore must use
diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index f648b0e24447b..4749c9303de05 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -140,7 +140,7 @@ struct drm_gem_object *virtio_gpu_create_object(struct drm_device *dev,
 
 	shmem = kzalloc(sizeof(*shmem), GFP_KERNEL);
 	if (!shmem)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	dshmem = &shmem->base.base;
 	dshmem->base.funcs = &virtio_gpu_shmem_funcs;
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index 0cd95953cdf55..96c264c4be4fe 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -291,8 +291,9 @@ struct drm_driver {
 	/**
 	 * @gem_create_object: constructor for gem objects
 	 *
-	 * Hook for allocating the GEM object struct, for use by the CMA and
-	 * SHMEM GEM helpers.
+	 * Hook for allocating the GEM object struct, for use by the CMA
+	 * and SHMEM GEM helpers. Returns a GEM object on success, or an
+	 * ERR_PTR()-encoded error code otherwise.
 	 */
 	struct drm_gem_object *(*gem_create_object)(struct drm_device *dev,
 						    size_t size);
-- 
2.34.1

