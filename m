Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4541664836
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbjAJSKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbjAJSJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE9C14D3B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E06096182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3456C433D2;
        Tue, 10 Jan 2023 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374020;
        bh=kK2Z4HkYXIJ15m3SZkX8uCrmptpQd6JBxmfvXknrE0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZumE52h4BKl404PJVNdhUJWfVlihhGvZnZgP6v0YU3vTL4gBWN9h9BUb2fcULmYB
         NEufllzdZ1HzOAQEiudKY17lgXa8utkR04pZEHxjoQ2f+UFk2hzNpZYyAHqfSjwD59
         N315kGXqzN7EaJYErQZqd0xihLP2+VujbBu4gCQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Steven Price <steven.price@arm.com>,
        Rob Clark <robdclark@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 015/148] drm/panfrost: Fix GEM handle creation ref-counting
Date:   Tue, 10 Jan 2023 19:01:59 +0100
Message-Id: <20230110180017.672055637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Steven Price <steven.price@arm.com>

[ Upstream commit 4217c6ac817451d5116687f3cc6286220dc43d49 ]

panfrost_gem_create_with_handle() previously returned a BO but with the
only reference being from the handle, which user space could in theory
guess and release, causing a use-after-free. Additionally if the call to
panfrost_gem_mapping_get() in panfrost_ioctl_create_bo() failed then
a(nother) reference on the BO was dropped.

The _create_with_handle() is a problematic pattern, so ditch it and
instead create the handle in panfrost_ioctl_create_bo(). If the call to
panfrost_gem_mapping_get() fails then this means that user space has
indeed gone behind our back and freed the handle. In which case just
return an error code.

Reported-by: Rob Clark <robdclark@chromium.org>
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221219140130.410578-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 27 ++++++++++++++++---------
 drivers/gpu/drm/panfrost/panfrost_gem.c | 16 +--------------
 drivers/gpu/drm/panfrost/panfrost_gem.h |  5 +----
 3 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 2fa5afe21288..919e6cc04982 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -82,6 +82,7 @@ static int panfrost_ioctl_create_bo(struct drm_device *dev, void *data,
 	struct panfrost_gem_object *bo;
 	struct drm_panfrost_create_bo *args = data;
 	struct panfrost_gem_mapping *mapping;
+	int ret;
 
 	if (!args->size || args->pad ||
 	    (args->flags & ~(PANFROST_BO_NOEXEC | PANFROST_BO_HEAP)))
@@ -92,21 +93,29 @@ static int panfrost_ioctl_create_bo(struct drm_device *dev, void *data,
 	    !(args->flags & PANFROST_BO_NOEXEC))
 		return -EINVAL;
 
-	bo = panfrost_gem_create_with_handle(file, dev, args->size, args->flags,
-					     &args->handle);
+	bo = panfrost_gem_create(dev, args->size, args->flags);
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
+	ret = drm_gem_handle_create(file, &bo->base.base, &args->handle);
+	if (ret)
+		goto out;
+
 	mapping = panfrost_gem_mapping_get(bo, priv);
-	if (!mapping) {
-		drm_gem_object_put(&bo->base.base);
-		return -EINVAL;
+	if (mapping) {
+		args->offset = mapping->mmnode.start << PAGE_SHIFT;
+		panfrost_gem_mapping_put(mapping);
+	} else {
+		/* This can only happen if the handle from
+		 * drm_gem_handle_create() has already been guessed and freed
+		 * by user space
+		 */
+		ret = -EINVAL;
 	}
 
-	args->offset = mapping->mmnode.start << PAGE_SHIFT;
-	panfrost_gem_mapping_put(mapping);
-
-	return 0;
+out:
+	drm_gem_object_put(&bo->base.base);
+	return ret;
 }
 
 /**
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 293e799e2fe8..3c812fbd126f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -235,12 +235,8 @@ struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t
 }
 
 struct panfrost_gem_object *
-panfrost_gem_create_with_handle(struct drm_file *file_priv,
-				struct drm_device *dev, size_t size,
-				u32 flags,
-				uint32_t *handle)
+panfrost_gem_create(struct drm_device *dev, size_t size, u32 flags)
 {
-	int ret;
 	struct drm_gem_shmem_object *shmem;
 	struct panfrost_gem_object *bo;
 
@@ -256,16 +252,6 @@ panfrost_gem_create_with_handle(struct drm_file *file_priv,
 	bo->noexec = !!(flags & PANFROST_BO_NOEXEC);
 	bo->is_heap = !!(flags & PANFROST_BO_HEAP);
 
-	/*
-	 * Allocate an id of idr table where the obj is registered
-	 * and handle has the id what user can see.
-	 */
-	ret = drm_gem_handle_create(file_priv, &shmem->base, handle);
-	/* drop reference from allocate - handle holds it now. */
-	drm_gem_object_put(&shmem->base);
-	if (ret)
-		return ERR_PTR(ret);
-
 	return bo;
 }
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index 8088d5fd8480..ad2877eeeccd 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -69,10 +69,7 @@ panfrost_gem_prime_import_sg_table(struct drm_device *dev,
 				   struct sg_table *sgt);
 
 struct panfrost_gem_object *
-panfrost_gem_create_with_handle(struct drm_file *file_priv,
-				struct drm_device *dev, size_t size,
-				u32 flags,
-				uint32_t *handle);
+panfrost_gem_create(struct drm_device *dev, size_t size, u32 flags);
 
 int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv);
 void panfrost_gem_close(struct drm_gem_object *obj,
-- 
2.35.1



