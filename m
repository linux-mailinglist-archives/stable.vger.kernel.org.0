Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07510694843
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBMOjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjBMOjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:39:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D86E83E3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB9926108F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF03C433A1;
        Mon, 13 Feb 2023 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299192;
        bh=t+mkesOYPk5COWd/iwUd82ieCZhr4uKtrGINnmHBY1Y=;
        h=Subject:To:Cc:From:Date:From;
        b=cbz8WL6fpJB6CTeewlgu8IkOZ6OkJIzPFqDkgpoaL7rz9K2uoO8ccuuteiRJOWPNP
         L6GgvHKSDwvrV6hT0WXlzK9VzZp66M6FGa9b2VfqZH0slLYssCTZKKrUQt/wlr26+j
         i69CufoPha5kJWeymLcweUOCu0icWj3ita0BwXW8=
Subject: FAILED: patch "[PATCH] drm/client: fix circular reference counting issue" failed to apply to 5.4-stable tree
To:     christian.koenig@amd.com, stable@vger.kernel.org,
        tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 15:39:44 +0100
Message-ID: <1676299184230171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

85e26dd5100a ("drm/client: fix circular reference counting issue")
444bbba708e8 ("drm/client: Prevent NULL dereference in drm_client_buffer_delete()")
27b2ae654370 ("drm/client: Switch drm_client_buffer_delete() to unlocked drm_gem_vunmap")
a85955568939 ("drm/gem: Store client buffer mappings as struct dma_buf_map")
a745fb1c26d3 ("drm/gem: Update internal GEM vmap/vunmap interfaces to use struct dma_buf_map")
49a3f51dfeee ("drm/gem: Use struct dma_buf_map in GEM vmap ops and convert GEM backends")
1fc90559fdd5 ("drm/etnaviv: Remove empty etnaviv_gem_prime_vunmap()")
823efa922102 ("drm/cma-helper: Remove empty drm_gem_cma_prime_vunmap()")
1086db71a1db ("drm/vram-helper: Remove invariant parameters from internal kmap function")
488c888ae1d4 ("drm/vkms: Switch to shmem helpers")
20e76f1a7059 ("dma-buf: Use struct dma_buf_map in dma_buf_vunmap() interfaces")
6619ccf1bb1d ("dma-buf: Use struct dma_buf_map in dma_buf_vmap() interfaces")
01fd30da0474 ("dma-buf: Add struct dma-buf-map for storing struct dma_buf.vaddr_ptr")
d693def4fd1c ("drm: Remove obsolete GEM and PRIME callbacks from struct drm_driver")
b76b85b7c2e2 ("drm/vkms: Introduce GEM object functions")
dd60202237a0 ("drm/vc4: Introduce GEM object functions")
552f9d60f6cc ("drm/radeon: Introduce GEM object functions")
ed853f6c3fbc ("drm/nouveau: Introduce GEM object functions")
a77306278f2c ("drm/etnaviv: Introduce GEM object functions")
246cb7e49a70 ("drm/amdgpu: Introduce GEM object functions")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85e26dd5100a182bf8448050427539c0a66ab793 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Date: Thu, 26 Jan 2023 10:24:26 +0100
Subject: [PATCH] drm/client: fix circular reference counting issue
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We reference dump buffers both by their handle as well as their
object. The problem is now that when anybody iterates over the DRM
framebuffers and exports the underlying GEM objects through DMA-buf
we run into a circular reference count situation.

The result is that the fbdev handling holds the GEM handle preventing
the DMA-buf in the GEM object to be released. This DMA-buf in turn
holds a reference to the driver module which on unload would release
the fbdev.

Break that loop by releasing the handle as soon as the DRM
framebuffer object is created. The DRM framebuffer and the DRM client
buffer structure still hold a reference to the underlying GEM object
preventing its destruction.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: c76f0f7cb546 ("drm: Begin an API for in-kernel clients")
Cc: <stable@vger.kernel.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230126102814.8722-1-christian.koenig@amd.com

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index fd67efe37c63..056ab9d5f313 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -233,21 +233,17 @@ void drm_client_dev_restore(struct drm_device *dev)
 
 static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 {
-	struct drm_device *dev = buffer->client->dev;
-
 	if (buffer->gem) {
 		drm_gem_vunmap_unlocked(buffer->gem, &buffer->map);
 		drm_gem_object_put(buffer->gem);
 	}
 
-	if (buffer->handle)
-		drm_mode_destroy_dumb(dev, buffer->handle, buffer->client->file);
-
 	kfree(buffer);
 }
 
 static struct drm_client_buffer *
-drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
+drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
+			 u32 format, u32 *handle)
 {
 	const struct drm_format_info *info = drm_format_info(format);
 	struct drm_mode_create_dumb dumb_args = { };
@@ -269,16 +265,15 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u
 	if (ret)
 		goto err_delete;
 
-	buffer->handle = dumb_args.handle;
-	buffer->pitch = dumb_args.pitch;
-
 	obj = drm_gem_object_lookup(client->file, dumb_args.handle);
 	if (!obj)  {
 		ret = -ENOENT;
 		goto err_delete;
 	}
 
+	buffer->pitch = dumb_args.pitch;
 	buffer->gem = obj;
+	*handle = dumb_args.handle;
 
 	return buffer;
 
@@ -365,7 +360,8 @@ static void drm_client_buffer_rmfb(struct drm_client_buffer *buffer)
 }
 
 static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
-				   u32 width, u32 height, u32 format)
+				   u32 width, u32 height, u32 format,
+				   u32 handle)
 {
 	struct drm_client_dev *client = buffer->client;
 	struct drm_mode_fb_cmd fb_req = { };
@@ -377,7 +373,7 @@ static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
 	fb_req.depth = info->depth;
 	fb_req.width = width;
 	fb_req.height = height;
-	fb_req.handle = buffer->handle;
+	fb_req.handle = handle;
 	fb_req.pitch = buffer->pitch;
 
 	ret = drm_mode_addfb(client->dev, &fb_req, client->file);
@@ -414,13 +410,24 @@ struct drm_client_buffer *
 drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
 {
 	struct drm_client_buffer *buffer;
+	u32 handle;
 	int ret;
 
-	buffer = drm_client_buffer_create(client, width, height, format);
+	buffer = drm_client_buffer_create(client, width, height, format,
+					  &handle);
 	if (IS_ERR(buffer))
 		return buffer;
 
-	ret = drm_client_buffer_addfb(buffer, width, height, format);
+	ret = drm_client_buffer_addfb(buffer, width, height, format, handle);
+
+	/*
+	 * The handle is only needed for creating the framebuffer, destroy it
+	 * again to solve a circular dependency should anybody export the GEM
+	 * object as DMA-buf. The framebuffer and our buffer structure are still
+	 * holding references to the GEM object to prevent its destruction.
+	 */
+	drm_mode_destroy_dumb(client->dev, handle, client->file);
+
 	if (ret) {
 		drm_client_buffer_delete(buffer);
 		return ERR_PTR(ret);
diff --git a/include/drm/drm_client.h b/include/drm/drm_client.h
index 4fc8018eddda..1220d185c776 100644
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -126,11 +126,6 @@ struct drm_client_buffer {
 	 */
 	struct drm_client_dev *client;
 
-	/**
-	 * @handle: Buffer handle
-	 */
-	u32 handle;
-
 	/**
 	 * @pitch: Buffer pitch
 	 */

