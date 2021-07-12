Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080A23C4DAE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbhGLHN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241874AbhGLHMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0568E61156;
        Mon, 12 Jul 2021 07:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073801;
        bh=qpBltZ8Z87hOzwodc13xlA6TPSQkIP+uwMsmtYyXMUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjtbbnOfQANstL9/PRUJbWs/vtNnPhUg1uf2T83QC02Z0LntAdQ8iC3V1yJQWtqGS
         LTSKsd5SG3BtPvnTWo8cfjZzJoSWCB2sKdD3xpc1ASK2QkAjvjLazCQ9T5E8YwhPd5
         LalEXjfhOudkojv2L2FRuW1bYaRJSMVv0KyuUMA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Charmaine Lee <charmainel@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 365/700] drm/vmwgfx: Fix cpu updates of coherent multisample surfaces
Date:   Mon, 12 Jul 2021 08:07:28 +0200
Message-Id: <20210712061015.207982153@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit 88509f698c4e38e287e016e86a0445547824135c ]

In cases where the dirty linear memory range spans multiple sample sheets
in a surface, the dirty surface region is incorrectly computed.
To do this correctly and in an optimized fashion  we would have to compute
the dirty region of each sample sheet and compute the union of those
regions.

But assuming that cpu writing to a multisample surface is rather a corner
case than a common case, just set the dirty region to the full surface.

This fixes OpenGL piglit errors with SVGA_FORCE_COHERENT=1
and the piglit test:

fbo-depthstencil blit default_fb -samples=2 -auto

Fixes: 9ca7d19ff8ba ("drm/vmwgfx: Add surface dirty-tracking callbacks")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Charmaine Lee <charmainel@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210505035740.286923-4-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/vmwgfx/device_include/svga3d_surfacedefs.h  |  8 ++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c             | 13 +++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/device_include/svga3d_surfacedefs.h b/drivers/gpu/drm/vmwgfx/device_include/svga3d_surfacedefs.h
index 4db25bd9fa22..127eaf0a0a58 100644
--- a/drivers/gpu/drm/vmwgfx/device_include/svga3d_surfacedefs.h
+++ b/drivers/gpu/drm/vmwgfx/device_include/svga3d_surfacedefs.h
@@ -1467,6 +1467,7 @@ struct svga3dsurface_cache {
 
 /**
  * struct svga3dsurface_loc - Surface location
+ * @sheet: The multisample sheet.
  * @sub_resource: Surface subresource. Defined as layer * num_mip_levels +
  * mip_level.
  * @x: X coordinate.
@@ -1474,6 +1475,7 @@ struct svga3dsurface_cache {
  * @z: Z coordinate.
  */
 struct svga3dsurface_loc {
+	u32 sheet;
 	u32 sub_resource;
 	u32 x, y, z;
 };
@@ -1566,8 +1568,8 @@ svga3dsurface_get_loc(const struct svga3dsurface_cache *cache,
 	u32 layer;
 	int i;
 
-	if (offset >= cache->sheet_bytes)
-		offset %= cache->sheet_bytes;
+	loc->sheet = offset / cache->sheet_bytes;
+	offset -= loc->sheet * cache->sheet_bytes;
 
 	layer = offset / cache->mip_chain_bytes;
 	offset -= layer * cache->mip_chain_bytes;
@@ -1631,6 +1633,7 @@ svga3dsurface_min_loc(const struct svga3dsurface_cache *cache,
 		      u32 sub_resource,
 		      struct svga3dsurface_loc *loc)
 {
+	loc->sheet = 0;
 	loc->sub_resource = sub_resource;
 	loc->x = loc->y = loc->z = 0;
 }
@@ -1652,6 +1655,7 @@ svga3dsurface_max_loc(const struct svga3dsurface_cache *cache,
 	const struct drm_vmw_size *size;
 	u32 mip;
 
+	loc->sheet = 0;
 	loc->sub_resource = sub_resource + 1;
 	mip = sub_resource % cache->num_mip_levels;
 	size = &cache->mip[mip].size;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index f6cab77075a0..990523217278 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -1801,6 +1801,19 @@ static void vmw_surface_tex_dirty_range_add(struct vmw_resource *res,
 	svga3dsurface_get_loc(cache, &loc2, end - 1);
 	svga3dsurface_inc_loc(cache, &loc2);
 
+	if (loc1.sheet != loc2.sheet) {
+		u32 sub_res;
+
+		/*
+		 * Multiple multisample sheets. To do this in an optimized
+		 * fashion, compute the dirty region for each sheet and the
+		 * resulting union. Since this is not a common case, just dirty
+		 * the whole surface.
+		 */
+		for (sub_res = 0; sub_res < dirty->num_subres; ++sub_res)
+			vmw_subres_dirty_full(dirty, sub_res);
+		return;
+	}
 	if (loc1.sub_resource + 1 == loc2.sub_resource) {
 		/* Dirty range covers a single sub-resource */
 		vmw_subres_dirty_add(dirty, &loc1, &loc2);
-- 
2.30.2



