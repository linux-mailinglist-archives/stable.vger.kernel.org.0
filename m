Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A12D5710F1
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 05:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiGLDnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 23:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLDnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 23:43:16 -0400
X-Greylist: delayed 605 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jul 2022 20:43:10 PDT
Received: from letterbox.kde.org (letterbox.kde.org [46.43.1.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67C8371AE
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 20:43:10 -0700 (PDT)
Received: from vertex.vmware.com (pool-173-49-113-140.phlapa.fios.verizon.net [173.49.113.140])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 42EAF321FA2;
        Tue, 12 Jul 2022 04:33:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1657596782; bh=gyNLcj4ELhzBjDJJ5m7Bz5HfLLbDtYPbkm7RlEy4jFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQNWmH8w4Oz3bzPfr++u++CqT4yLSMRUPtYfTO85x0TLoONvN0yPQ9kLpWcgSqgfC
         VGqbD6v4n6ZWbt/UUfplpf6gUNaUTWkt89IWLuu2Ih3uATCIZOX1UhkVCETC7s8pcy
         6c3FDfzWCy37rz04VebhJ+1Odmkc4/gw1ERo5lycUyR+VKvXET1pepx/jma2jqYPyz
         Ra4JXTZM3nbnVF1nTD4dWzGVEY/llsiHUQ2kKi0AW6pnPsySiYB2YfCnNZJwVPrK3h
         n782gvh3dzWKLJvopHFuDmcQh8J/bymcodU/eWyXw+sHx6OxIwO9hI+OODF/xZUgxf
         4j9L6zWbdsvRg==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com, contact@emersion.fr,
        ppaalanen@gmail.com, Zack Rusin <zackr@vmware.com>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org
Subject: [PATCH v2 1/8] drm: Disable the cursor plane on atomic contexts with virtualized drivers
Date:   Mon, 11 Jul 2022 23:32:39 -0400
Message-Id: <20220712033246.1148476-2-zack@kde.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220712033246.1148476-1-zack@kde.org>
References: <20220712033246.1148476-1-zack@kde.org>
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

Cursor planes on virtualized drivers have special meaning and require
that the clients handle them in specific ways, e.g. the cursor plane
should react to the mouse movement the way a mouse cursor would be
expected to and the client is required to set hotspot properties on it
in order for the mouse events to be routed correctly.

This breaks the contract as specified by the "universal planes". Fix it
by disabling the cursor planes on virtualized drivers while adding
a foundation on top of which it's possible to special case mouse cursor
planes for clients that want it.

Disabling the cursor planes makes some kms compositors which were broken,
e.g. Weston, fallback to software cursor which works fine or at least
better than currently while having no effect on others, e.g. gnome-shell
or kwin, which put virtualized drivers on a deny-list when running in
atomic context to make them fallback to legacy kms and avoid this issue.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 681e7ec73044 ("drm: Allow userspace to ask for universal plane list (v2)")
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Gurchetan Singh <gurchetansingh@chromium.org>
Cc: Chia-I Wu <olvaffe@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: virtualization@lists.linux-foundation.org
Cc: spice-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_plane.c          | 11 +++++++++++
 drivers/gpu/drm/qxl/qxl_drv.c        |  2 +-
 drivers/gpu/drm/vboxvideo/vbox_drv.c |  2 +-
 drivers/gpu/drm/virtio/virtgpu_drv.c |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c  |  2 +-
 include/drm/drm_drv.h                | 10 ++++++++++
 include/drm/drm_file.h               | 12 ++++++++++++
 7 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index 726f2f163c26..e1e2a65c7119 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -667,6 +667,17 @@ int drm_mode_getplane_res(struct drm_device *dev, void *data,
 		    !file_priv->universal_planes)
 			continue;
 
+		/*
+		 * Unless userspace supports virtual cursor plane
+		 * then if we're running on virtual driver do not
+		 * advertise cursor planes because they'll be broken
+		 */
+		if (plane->type == DRM_PLANE_TYPE_CURSOR &&
+		    drm_core_check_feature(dev, DRIVER_VIRTUAL)	&&
+		    file_priv->atomic &&
+		    !file_priv->supports_virtual_cursor_plane)
+			continue;
+
 		if (drm_lease_held(file_priv, plane->base.id)) {
 			if (count < plane_resp->count_planes &&
 			    put_user(plane->base.id, plane_ptr + count))
diff --git a/drivers/gpu/drm/qxl/qxl_drv.c b/drivers/gpu/drm/qxl/qxl_drv.c
index 1cb6f0c224bb..0e4212e05caa 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.c
+++ b/drivers/gpu/drm/qxl/qxl_drv.c
@@ -281,7 +281,7 @@ static const struct drm_ioctl_desc qxl_ioctls[] = {
 };
 
 static struct drm_driver qxl_driver = {
-	.driver_features = DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC,
+	.driver_features = DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC | DRIVER_VIRTUAL,
 
 	.dumb_create = qxl_mode_dumb_create,
 	.dumb_map_offset = drm_gem_ttm_dumb_map_offset,
diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
index f4f2bd79a7cb..84e75bcc3384 100644
--- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
+++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
@@ -176,7 +176,7 @@ DEFINE_DRM_GEM_FOPS(vbox_fops);
 
 static const struct drm_driver driver = {
 	.driver_features =
-	    DRIVER_MODESET | DRIVER_GEM | DRIVER_ATOMIC,
+	    DRIVER_MODESET | DRIVER_GEM | DRIVER_ATOMIC | DRIVER_VIRTUAL,
 
 	.lastclose = drm_fb_helper_lastclose,
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
index 5f25a8d15464..3c5bb006159a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -198,7 +198,8 @@ MODULE_AUTHOR("Alon Levy");
 DEFINE_DRM_GEM_FOPS(virtio_gpu_driver_fops);
 
 static const struct drm_driver driver = {
-	.driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_RENDER | DRIVER_ATOMIC,
+	.driver_features =
+		DRIVER_MODESET | DRIVER_GEM | DRIVER_RENDER | DRIVER_ATOMIC | DRIVER_VIRTUAL,
 	.open = virtio_gpu_driver_open,
 	.postclose = virtio_gpu_driver_postclose,
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 01a5b47e95f9..712f6ad0b014 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1581,7 +1581,7 @@ static const struct file_operations vmwgfx_driver_fops = {
 
 static const struct drm_driver driver = {
 	.driver_features =
-	DRIVER_MODESET | DRIVER_RENDER | DRIVER_ATOMIC | DRIVER_GEM,
+	DRIVER_MODESET | DRIVER_RENDER | DRIVER_ATOMIC | DRIVER_GEM | DRIVER_VIRTUAL,
 	.ioctls = vmw_ioctls,
 	.num_ioctls = ARRAY_SIZE(vmw_ioctls),
 	.master_set = vmw_master_set,
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index f6159acb8856..c4cd7fc350d9 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -94,6 +94,16 @@ enum drm_driver_feature {
 	 * synchronization of command submission.
 	 */
 	DRIVER_SYNCOBJ_TIMELINE         = BIT(6),
+	/**
+	 * @DRIVER_VIRTUAL:
+	 *
+	 * Driver is running on top of virtual hardware. The most significant
+	 * implication of this is a requirement of special handling of the
+	 * cursor plane (e.g. cursor plane has to actually track the mouse
+	 * cursor and the clients are required to set hotspot in order for
+	 * the cursor planes to work correctly).
+	 */
+	DRIVER_VIRTUAL                  = BIT(7),
 
 	/* IMPORTANT: Below are all the legacy flags, add new ones above. */
 
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index e0a73a1e2df7..3e5c36891161 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -223,6 +223,18 @@ struct drm_file {
 	 */
 	bool is_master;
 
+	/**
+	 * @supports_virtual_cursor_plane:
+	 *
+	 * This client is capable of handling the cursor plane with the
+	 * restrictions imposed on it by the virtualized drivers.
+	 *
+	 * The implies that the cursor plane has to behave like a cursor
+	 * i.e. track cursor movement. It also requires setting of the
+	 * hotspot properties by the client on the cursor plane.
+	 */
+	bool supports_virtual_cursor_plane;
+
 	/**
 	 * @master:
 	 *
-- 
2.34.1

