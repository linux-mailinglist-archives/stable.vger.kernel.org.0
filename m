Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9102218C39
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbgGHPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:49:16 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:49198 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730114AbgGHPtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:49:16 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21754493-1500050 
        for multiple; Wed, 08 Jul 2020 16:49:14 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()
Date:   Wed,  8 Jul 2020 16:49:11 +0100
Message-Id: <20200708154911.21236-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708150527.1302305-1-chris@chris-wilson.co.uk>
References: <20200708150527.1302305-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drm_gem_dumb_map_offset() now exists and does everything
vgem_gem_dump_map does and *ought* to do.

In particular, vgem_gem_dumb_map() was trying to reject mmapping an
imported dmabuf by checking the existence of obj->filp. Unfortunately,
we always allocated an obj->filp, even if unused for an imported dmabuf.
Instead, the drm_gem_dumb_map_offset(), since 90378e589192 ("drm/gem:
drm_gem_dumb_map_offset(): reject dma-buf"), uses the obj->import_attach
to reject such invalid mmaps.

This prevents vgem from allowing userspace mmapping the dumb handle and
attempting to incorrectly fault in remote pages belonging to another
device, where there may not even be a struct page.

v2: Use the default drm_gem_dumb_map_offset() callback

Fixes: af33a9190d02 ("drm/vgem: Enable dmabuf import interfaces")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v4.13+
---
 drivers/gpu/drm/vgem/vgem_drv.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index e4dc7b267a0b..a775feda1cc7 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -230,32 +230,6 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 	return 0;
 }
 
-static int vgem_gem_dumb_map(struct drm_file *file, struct drm_device *dev,
-			     uint32_t handle, uint64_t *offset)
-{
-	struct drm_gem_object *obj;
-	int ret;
-
-	obj = drm_gem_object_lookup(file, handle);
-	if (!obj)
-		return -ENOENT;
-
-	if (!obj->filp) {
-		ret = -EINVAL;
-		goto unref;
-	}
-
-	ret = drm_gem_create_mmap_offset(obj);
-	if (ret)
-		goto unref;
-
-	*offset = drm_vma_node_offset_addr(&obj->vma_node);
-unref:
-	drm_gem_object_put(obj);
-
-	return ret;
-}
-
 static struct drm_ioctl_desc vgem_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(VGEM_FENCE_ATTACH, vgem_fence_attach_ioctl, DRM_RENDER_ALLOW),
 	DRM_IOCTL_DEF_DRV(VGEM_FENCE_SIGNAL, vgem_fence_signal_ioctl, DRM_RENDER_ALLOW),
@@ -446,7 +420,6 @@ static struct drm_driver vgem_driver = {
 	.fops				= &vgem_driver_fops,
 
 	.dumb_create			= vgem_gem_dumb_create,
-	.dumb_map_offset		= vgem_gem_dumb_map,
 
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
-- 
2.20.1

