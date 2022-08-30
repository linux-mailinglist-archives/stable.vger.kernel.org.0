Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B60A5A6B57
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiH3RyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiH3Rxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90762BB06;
        Tue, 30 Aug 2022 10:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91D1617B0;
        Tue, 30 Aug 2022 17:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8784AC433C1;
        Tue, 30 Aug 2022 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880206;
        bh=Wt1k6YYO7A7x5sNg2MQY+ULG/lmKJp3pfkgomSxsC9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhaW15z2XyzvopnDFnrpymaOvXdkOEg1FOWGa9EcTCypm36O3mg80nhoKzBunnKqc
         hupv0iXXKwYB1ih/Cxrc/22jfJW3G9AzA9rKRDajUx1p8EZjYW7MGlsVffJu5nB5oH
         6PfwD1qnAGIz70OIMkzcKfIUdKJJ293hrb+tKhtXtLfdqEWuYpXTSqdvY2UvzWy9hM
         Fellb5Fta0kI8HIJkO21+yUSvGOWMG7LhDJ4Fp+ePbbH9nhkq0MiJRVS2eONVC8gQU
         FmfHRYsrTSoSazANkw6T0RCs9aQk20d1Bvs4ZKekJ99kHqC7DUECOn9UA1txZNVEm9
         sfAkHITiO36yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffy Chen <jeffy.chen@rock-chips.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        sumit.semwal@linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.10 04/16] drm/gem: Fix GEM handle release errors
Date:   Tue, 30 Aug 2022 13:23:05 -0400
Message-Id: <20220830172317.581397-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172317.581397-1-sashal@kernel.org>
References: <20220830172317.581397-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffy Chen <jeffy.chen@rock-chips.com>

[ Upstream commit ea2aa97ca37a9044ade001aef71dbc06318e8d44 ]

Currently we are assuming a one to one mapping between dmabuf and
GEM handle when releasing GEM handles.

But that is not always true, since we would create extra handles for the
GEM obj in cases like gem_open() and getfb{,2}().

A similar issue was reported at:
https://lore.kernel.org/all/20211105083308.392156-1-jay.xu@rock-chips.com/

Another problem is that the imported dmabuf might not always have
gem_obj->dma_buf set, which would cause leaks in
drm_gem_remove_prime_handles().

Let's fix these for now by using handle to find the exact map to remove.

Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220819072834.17888-1-jeffy.chen@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem.c      | 17 +----------------
 drivers/gpu/drm/drm_internal.h |  4 ++--
 drivers/gpu/drm/drm_prime.c    | 20 ++++++++++++--------
 3 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 5979af230eda0..8b30e8d83fbcf 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -166,21 +166,6 @@ void drm_gem_private_object_init(struct drm_device *dev,
 }
 EXPORT_SYMBOL(drm_gem_private_object_init);
 
-static void
-drm_gem_remove_prime_handles(struct drm_gem_object *obj, struct drm_file *filp)
-{
-	/*
-	 * Note: obj->dma_buf can't disappear as long as we still hold a
-	 * handle reference in obj->handle_count.
-	 */
-	mutex_lock(&filp->prime.lock);
-	if (obj->dma_buf) {
-		drm_prime_remove_buf_handle_locked(&filp->prime,
-						   obj->dma_buf);
-	}
-	mutex_unlock(&filp->prime.lock);
-}
-
 /**
  * drm_gem_object_handle_free - release resources bound to userspace handles
  * @obj: GEM object to clean up.
@@ -254,7 +239,7 @@ drm_gem_object_release_handle(int id, void *ptr, void *data)
 	else if (dev->driver->gem_close_object)
 		dev->driver->gem_close_object(obj, file_priv);
 
-	drm_gem_remove_prime_handles(obj, file_priv);
+	drm_prime_remove_buf_handle(&file_priv->prime, id);
 	drm_vma_node_revoke(&obj->vma_node, file_priv);
 
 	drm_gem_object_handle_put_unlocked(obj);
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index b65865c630b0a..f80e0f28087d1 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -86,8 +86,8 @@ int drm_prime_fd_to_handle_ioctl(struct drm_device *dev, void *data,
 
 void drm_prime_init_file_private(struct drm_prime_file_private *prime_fpriv);
 void drm_prime_destroy_file_private(struct drm_prime_file_private *prime_fpriv);
-void drm_prime_remove_buf_handle_locked(struct drm_prime_file_private *prime_fpriv,
-					struct dma_buf *dma_buf);
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv,
+				 uint32_t handle);
 
 /* drm_drv.c */
 struct drm_minor *drm_minor_acquire(unsigned int minor_id);
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 9f955f2010c25..825499ea3ff59 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -187,29 +187,33 @@ static int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpri
 	return -ENOENT;
 }
 
-void drm_prime_remove_buf_handle_locked(struct drm_prime_file_private *prime_fpriv,
-					struct dma_buf *dma_buf)
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv,
+				 uint32_t handle)
 {
 	struct rb_node *rb;
 
-	rb = prime_fpriv->dmabufs.rb_node;
+	mutex_lock(&prime_fpriv->lock);
+
+	rb = prime_fpriv->handles.rb_node;
 	while (rb) {
 		struct drm_prime_member *member;
 
-		member = rb_entry(rb, struct drm_prime_member, dmabuf_rb);
-		if (member->dma_buf == dma_buf) {
+		member = rb_entry(rb, struct drm_prime_member, handle_rb);
+		if (member->handle == handle) {
 			rb_erase(&member->handle_rb, &prime_fpriv->handles);
 			rb_erase(&member->dmabuf_rb, &prime_fpriv->dmabufs);
 
-			dma_buf_put(dma_buf);
+			dma_buf_put(member->dma_buf);
 			kfree(member);
-			return;
-		} else if (member->dma_buf < dma_buf) {
+			break;
+		} else if (member->handle < handle) {
 			rb = rb->rb_right;
 		} else {
 			rb = rb->rb_left;
 		}
 	}
+
+	mutex_unlock(&prime_fpriv->lock);
 }
 
 void drm_prime_init_file_private(struct drm_prime_file_private *prime_fpriv)
-- 
2.35.1

