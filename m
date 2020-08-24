Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C568724F40C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgHXIcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgHXIcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F54206F0;
        Mon, 24 Aug 2020 08:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257921;
        bh=inssUxI9u6yoaM1nMnlL+6eUDyxeBT/Nj9LiQOoCQkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAb1AnP1hfpK18SudMHiF76ILZ8apZXlvMY22loLXEIdnEICvblQeqcGATawJmchF
         +L67Sy6kimGLXWce8Xdy8MkfrG5uZ4fLf6jyLxWFUwlmBctITlvBCM+tusDSBPUrjQ
         ievkVgJafVdVvYBFm6+QvH7NH5cKNuM1XCcIU5ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 001/148] drm/vgem: Replace opencoded version of drm_gem_dumb_map_offset()
Date:   Mon, 24 Aug 2020 10:28:19 +0200
Message-Id: <20200824082413.982210601@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 119c53d2d4044c59c450c4f5a568d80b9d861856 ]

drm_gem_dumb_map_offset() now exists and does everything
vgem_gem_dump_map does and *ought* to do.

In particular, vgem_gem_dumb_map() was trying to reject mmapping an
imported dmabuf by checking the existence of obj->filp. Unfortunately,
we always allocated an obj->filp, even if unused for an imported dmabuf.
Instead, the drm_gem_dumb_map_offset(), since commit 90378e589192
("drm/gem: drm_gem_dumb_map_offset(): reject dma-buf"), uses the
obj->import_attach to reject such invalid mmaps.

This prevents vgem from allowing userspace mmapping the dumb handle and
attempting to incorrectly fault in remote pages belonging to another
device, where there may not even be a struct page.

v2: Use the default drm_gem_dumb_map_offset() callback

Fixes: af33a9190d02 ("drm/vgem: Enable dmabuf import interfaces")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v4.13+
Link: https://patchwork.freedesktop.org/patch/msgid/20200708154911.21236-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vgem/vgem_drv.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index ec1a8ebb6f1bf..fa39d140adc6c 100644
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
-	drm_gem_object_put_unlocked(obj);
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
2.25.1



