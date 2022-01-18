Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FA34917AF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347716AbiARCmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52564 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346090AbiARCfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FFFC61118;
        Tue, 18 Jan 2022 02:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9DBC36AE3;
        Tue, 18 Jan 2022 02:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473323;
        bh=/1KBa/8TsdSXbv2m/7my3HyXTwZFCalhpejCeKTW0rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2rTD759bI5Itz2tj66flQa5MMRZ26gvMtUwZbCmDa3C5tC/j5y4jCCDsN9BsMxV2
         SHcJoCzWbs7UtHzPPZ/R27Zzv5s4pdO6Y5MuPBLAZ5eRxipHs+lpSQvGg1AnNRU8Vs
         FAypPJ8jOiXitPw47Bcxyr68Fto4RHvjvaE24CSWALiHiJAkfZaO4yk7uzrxEm5uVu
         lUrWuCaisP2M5Lw9JjFIBlzEyPhRgMFxfnhtEpbOic3O7E7RJc+EG7fsMcUk/DpO8h
         mgbsb8m3N1kuL3i2enX7p6bW0P/EVl6kz9kGe0pWgUZbfRNZ9DroEJDb6VyCco4aK+
         h1tMtSeRnD7Yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-graphics-maintainer@vmware.com, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 071/188] drm/vmwgfx: Introduce a new placement for MOB page tables
Date:   Mon, 17 Jan 2022 21:29:55 -0500
Message-Id: <20220118023152.1948105-71-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit f6be23264bbac88d1e2bb39658e1b8a397e3f46d ]

For larger (bigger than a page) and noncontiguous mobs we have
to create page tables that allow the host to find the memory.
Those page tables just used regular system memory. Unfortunately
in TTM those BO's are not allowed to be busy thus can't be
fenced and we have to fence those bo's  because we don't want
to destroy the page tables while the host is still executing
the command buffers which might be accessing them.

To solve it we introduce a new placement VMW_PL_SYSTEM which
is very similar to TTM_PL_SYSTEM except that it allows
fencing. This fixes kernel oops'es during unloading of the driver
(and pci hot remove/add) which were caused by busy BO's in
TTM_PL_SYSTEM being present in the delayed deletion list in
TTM (TTM_PL_SYSTEM manager is destroyed before the delayed
deletions are executed)

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211105193845.258816-5-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/Makefile               |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c           | 14 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           | 12 ++-
 .../gpu/drm/vmwgfx/vmwgfx_system_manager.c    | 90 +++++++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c    | 58 ++++++------
 5 files changed, 138 insertions(+), 38 deletions(-)
 create mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_system_manager.c

diff --git a/drivers/gpu/drm/vmwgfx/Makefile b/drivers/gpu/drm/vmwgfx/Makefile
index bc323f7d40321..0188a312c38c2 100644
--- a/drivers/gpu/drm/vmwgfx/Makefile
+++ b/drivers/gpu/drm/vmwgfx/Makefile
@@ -9,7 +9,7 @@ vmwgfx-y := vmwgfx_execbuf.o vmwgfx_gmr.o vmwgfx_kms.o vmwgfx_drv.o \
 	    vmwgfx_cotable.o vmwgfx_so.o vmwgfx_binding.o vmwgfx_msg.o \
 	    vmwgfx_simple_resource.o vmwgfx_va.o vmwgfx_blit.o \
 	    vmwgfx_validation.o vmwgfx_page_dirty.o vmwgfx_streamoutput.o \
-            vmwgfx_devcaps.o ttm_object.o ttm_memory.o
+	    vmwgfx_devcaps.o ttm_object.o ttm_memory.o vmwgfx_system_manager.o
 
 vmwgfx-$(CONFIG_DRM_FBDEV_EMULATION) += vmwgfx_fb.o
 vmwgfx-$(CONFIG_TRANSPARENT_HUGEPAGE) += vmwgfx_thp.o
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 8d0b083ba267f..daf65615308ad 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1071,6 +1071,12 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 				 "3D will be disabled.\n");
 			dev_priv->has_mob = false;
 		}
+		if (vmw_sys_man_init(dev_priv) != 0) {
+			drm_info(&dev_priv->drm,
+				 "No MOB page table memory available. "
+				 "3D will be disabled.\n");
+			dev_priv->has_mob = false;
+		}
 	}
 
 	if (dev_priv->has_mob && (dev_priv->capabilities & SVGA_CAP_DX)) {
@@ -1121,8 +1127,10 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 	vmw_overlay_close(dev_priv);
 	vmw_kms_close(dev_priv);
 out_no_kms:
-	if (dev_priv->has_mob)
+	if (dev_priv->has_mob) {
 		vmw_gmrid_man_fini(dev_priv, VMW_PL_MOB);
+		vmw_sys_man_fini(dev_priv);
+	}
 	if (dev_priv->has_gmr)
 		vmw_gmrid_man_fini(dev_priv, VMW_PL_GMR);
 	vmw_devcaps_destroy(dev_priv);
@@ -1172,8 +1180,10 @@ static void vmw_driver_unload(struct drm_device *dev)
 		vmw_gmrid_man_fini(dev_priv, VMW_PL_GMR);
 
 	vmw_release_device_early(dev_priv);
-	if (dev_priv->has_mob)
+	if (dev_priv->has_mob) {
 		vmw_gmrid_man_fini(dev_priv, VMW_PL_MOB);
+		vmw_sys_man_fini(dev_priv);
+	}
 	vmw_devcaps_destroy(dev_priv);
 	vmw_vram_manager_fini(dev_priv);
 	ttm_device_fini(&dev_priv->bdev);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 858aff99a3fe5..645c18b267e6e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -82,8 +82,9 @@
 			VMWGFX_NUM_GB_SURFACE +\
 			VMWGFX_NUM_GB_SCREEN_TARGET)
 
-#define VMW_PL_GMR (TTM_PL_PRIV + 0)
-#define VMW_PL_MOB (TTM_PL_PRIV + 1)
+#define VMW_PL_GMR      (TTM_PL_PRIV + 0)
+#define VMW_PL_MOB      (TTM_PL_PRIV + 1)
+#define VMW_PL_SYSTEM   (TTM_PL_PRIV + 2)
 
 #define VMW_RES_CONTEXT ttm_driver_type0
 #define VMW_RES_SURFACE ttm_driver_type1
@@ -1039,7 +1040,6 @@ extern struct ttm_placement vmw_vram_placement;
 extern struct ttm_placement vmw_vram_sys_placement;
 extern struct ttm_placement vmw_vram_gmr_placement;
 extern struct ttm_placement vmw_sys_placement;
-extern struct ttm_placement vmw_evictable_placement;
 extern struct ttm_placement vmw_srf_placement;
 extern struct ttm_placement vmw_mob_placement;
 extern struct ttm_placement vmw_nonfixed_placement;
@@ -1251,6 +1251,12 @@ int vmw_overlay_num_free_overlays(struct vmw_private *dev_priv);
 int vmw_gmrid_man_init(struct vmw_private *dev_priv, int type);
 void vmw_gmrid_man_fini(struct vmw_private *dev_priv, int type);
 
+/**
+ * System memory manager
+ */
+int vmw_sys_man_init(struct vmw_private *dev_priv);
+void vmw_sys_man_fini(struct vmw_private *dev_priv);
+
 /**
  * Prime - vmwgfx_prime.c
  */
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_system_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_system_manager.c
new file mode 100644
index 0000000000000..b0005b03a6174
--- /dev/null
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_system_manager.c
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright 2021 VMware, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person
+ * obtaining a copy of this software and associated documentation
+ * files (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy,
+ * modify, merge, publish, distribute, sublicense, and/or sell copies
+ * of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include "vmwgfx_drv.h"
+
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_device.h>
+#include <drm/ttm/ttm_placement.h>
+#include <drm/ttm/ttm_resource.h>
+#include <linux/slab.h>
+
+
+static int vmw_sys_man_alloc(struct ttm_resource_manager *man,
+			     struct ttm_buffer_object *bo,
+			     const struct ttm_place *place,
+			     struct ttm_resource **res)
+{
+	*res = kzalloc(sizeof(**res), GFP_KERNEL);
+	if (!*res)
+		return -ENOMEM;
+
+	ttm_resource_init(bo, place, *res);
+	return 0;
+}
+
+static void vmw_sys_man_free(struct ttm_resource_manager *man,
+			     struct ttm_resource *res)
+{
+	kfree(res);
+}
+
+static const struct ttm_resource_manager_func vmw_sys_manager_func = {
+	.alloc = vmw_sys_man_alloc,
+	.free = vmw_sys_man_free,
+};
+
+int vmw_sys_man_init(struct vmw_private *dev_priv)
+{
+	struct ttm_device *bdev = &dev_priv->bdev;
+	struct ttm_resource_manager *man =
+			kzalloc(sizeof(*man), GFP_KERNEL);
+
+	if (!man)
+		return -ENOMEM;
+
+	man->use_tt = true;
+	man->func = &vmw_sys_manager_func;
+
+	ttm_resource_manager_init(man, 0);
+	ttm_set_driver_manager(bdev, VMW_PL_SYSTEM, man);
+	ttm_resource_manager_set_used(man, true);
+	return 0;
+}
+
+void vmw_sys_man_fini(struct vmw_private *dev_priv)
+{
+	struct ttm_resource_manager *man = ttm_manager_type(&dev_priv->bdev,
+							    VMW_PL_SYSTEM);
+
+	ttm_resource_manager_evict_all(&dev_priv->bdev, man);
+
+	ttm_resource_manager_set_used(man, false);
+	ttm_resource_manager_cleanup(man);
+
+	ttm_set_driver_manager(&dev_priv->bdev, VMW_PL_SYSTEM, NULL);
+	kfree(man);
+}
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
index 8b8991e3ed2d0..450bb1e9626f7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -92,6 +92,13 @@ static const struct ttm_place gmr_vram_placement_flags[] = {
 	}
 };
 
+static const struct ttm_place vmw_sys_placement_flags = {
+	.fpfn = 0,
+	.lpfn = 0,
+	.mem_type = VMW_PL_SYSTEM,
+	.flags = 0
+};
+
 struct ttm_placement vmw_vram_gmr_placement = {
 	.num_placement = 2,
 	.placement = vram_gmr_placement_flags,
@@ -113,28 +120,11 @@ struct ttm_placement vmw_sys_placement = {
 	.busy_placement = &sys_placement_flags
 };
 
-static const struct ttm_place evictable_placement_flags[] = {
-	{
-		.fpfn = 0,
-		.lpfn = 0,
-		.mem_type = TTM_PL_SYSTEM,
-		.flags = 0
-	}, {
-		.fpfn = 0,
-		.lpfn = 0,
-		.mem_type = TTM_PL_VRAM,
-		.flags = 0
-	}, {
-		.fpfn = 0,
-		.lpfn = 0,
-		.mem_type = VMW_PL_GMR,
-		.flags = 0
-	}, {
-		.fpfn = 0,
-		.lpfn = 0,
-		.mem_type = VMW_PL_MOB,
-		.flags = 0
-	}
+struct ttm_placement vmw_pt_sys_placement = {
+	.num_placement = 1,
+	.placement = &vmw_sys_placement_flags,
+	.num_busy_placement = 1,
+	.busy_placement = &vmw_sys_placement_flags
 };
 
 static const struct ttm_place nonfixed_placement_flags[] = {
@@ -156,13 +146,6 @@ static const struct ttm_place nonfixed_placement_flags[] = {
 	}
 };
 
-struct ttm_placement vmw_evictable_placement = {
-	.num_placement = 4,
-	.placement = evictable_placement_flags,
-	.num_busy_placement = 1,
-	.busy_placement = &sys_placement_flags
-};
-
 struct ttm_placement vmw_srf_placement = {
 	.num_placement = 1,
 	.num_busy_placement = 2,
@@ -484,6 +467,9 @@ static int vmw_ttm_bind(struct ttm_device *bdev,
 				    &vmw_be->vsgt, ttm->num_pages,
 				    vmw_be->gmr_id);
 		break;
+	case VMW_PL_SYSTEM:
+		/* Nothing to be done for a system bind */
+		break;
 	default:
 		BUG();
 	}
@@ -507,6 +493,8 @@ static void vmw_ttm_unbind(struct ttm_device *bdev,
 	case VMW_PL_MOB:
 		vmw_mob_unbind(vmw_be->dev_priv, vmw_be->mob);
 		break;
+	case VMW_PL_SYSTEM:
+		break;
 	default:
 		BUG();
 	}
@@ -628,6 +616,7 @@ static int vmw_ttm_io_mem_reserve(struct ttm_device *bdev, struct ttm_resource *
 
 	switch (mem->mem_type) {
 	case TTM_PL_SYSTEM:
+	case VMW_PL_SYSTEM:
 	case VMW_PL_GMR:
 	case VMW_PL_MOB:
 		return 0;
@@ -674,6 +663,11 @@ static void vmw_swap_notify(struct ttm_buffer_object *bo)
 	(void) ttm_bo_wait(bo, false, false);
 }
 
+static bool vmw_memtype_is_system(uint32_t mem_type)
+{
+	return mem_type == TTM_PL_SYSTEM || mem_type == VMW_PL_SYSTEM;
+}
+
 static int vmw_move(struct ttm_buffer_object *bo,
 		    bool evict,
 		    struct ttm_operation_ctx *ctx,
@@ -684,7 +678,7 @@ static int vmw_move(struct ttm_buffer_object *bo,
 	struct ttm_resource_manager *new_man = ttm_manager_type(bo->bdev, new_mem->mem_type);
 	int ret;
 
-	if (new_man->use_tt && new_mem->mem_type != TTM_PL_SYSTEM) {
+	if (new_man->use_tt && !vmw_memtype_is_system(new_mem->mem_type)) {
 		ret = vmw_ttm_bind(bo->bdev, bo->ttm, new_mem);
 		if (ret)
 			return ret;
@@ -693,7 +687,7 @@ static int vmw_move(struct ttm_buffer_object *bo,
 	vmw_move_notify(bo, bo->resource, new_mem);
 
 	if (old_man->use_tt && new_man->use_tt) {
-		if (bo->resource->mem_type == TTM_PL_SYSTEM) {
+		if (vmw_memtype_is_system(bo->resource->mem_type)) {
 			ttm_bo_move_null(bo, new_mem);
 			return 0;
 		}
@@ -740,7 +734,7 @@ int vmw_bo_create_and_populate(struct vmw_private *dev_priv,
 	int ret;
 
 	ret = vmw_bo_create_kernel(dev_priv, bo_size,
-				   &vmw_sys_placement,
+				   &vmw_pt_sys_placement,
 				   &bo);
 	if (unlikely(ret != 0))
 		return ret;
-- 
2.34.1

