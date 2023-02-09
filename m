Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC85690905
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 13:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBIMiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 07:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBIMiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 07:38:12 -0500
Received: from letterbox.kde.org (letterbox.kde.org [46.43.1.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FAD5C4A9
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 04:37:44 -0800 (PST)
Received: from vertex.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net [173.49.113.140])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 2C1FF3249AD;
        Thu,  9 Feb 2023 12:37:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1675946254; bh=3DMnXlDngm4Z8DLUUZqryTbqaWS55Y9iV4V6Wa9G3uU=;
        h=From:To:Cc:Subject:Date:From;
        b=H54syAsn9tPgYlWOlp3bN+GNg1cg1ieWQcSLxecmhQQLxXFhS8ktvY2LaaHkqjP/v
         iAP1SosRUpdBqnAWjw+WIq0HN/ed1SOcnI27c9ANCvsoRs4vN93W5NGGfYRh0VYUG+
         XK6eoIfJCh6rD4azpv46uQZ0zI02OiwSZOab3DRcW2hO9/uNYxiYJRm1x4wPqA7eQU
         j2Ug1CCddyvoQRBbvpvLxtpIhhuh8469THxSpeJXvdI19lfNdD159r3qXQ8swIu4AR
         hscZeTf+jn9QlYGVxf6uzsFRceJna+mOOJ4Pe0sioEoRwAIZCCozgpOPt9LyZGJJ5n
         84ZhPlzXfbs8A==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com, banackm@vmware.com,
        Zack Rusin <zackr@vmware.com>, stable@vger.kernel.org
Subject: [PATCH v2] drm/vmwgfx: Do not drop the reference to the handle too soon
Date:   Thu,  9 Feb 2023 07:37:31 -0500
Message-Id: <20230209123731.2137787-1-zack@kde.org>
X-Mailer: git-send-email 2.38.1
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

v2: Update the commit message to include note describing why the second
usag of vmw_gem_object_create_with_handle in vmwgfx_surface.c wasn't
changed

It is possible for userspace to predict the next buffer handle and
to destroy the buffer while it's still used by the kernel. Delay
dropping the internal reference on the buffers until kernel is done
with them.

Also fixes the second usage of vmw_gem_object_create_with_handle in
vmwgfx_surface.c which wasn't grabbing an explicit reference
to the gem object which could have been destroyed by the userspace
on the owning surface at any point.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
Cc: <stable@vger.kernel.org> # v5.17+
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      | 3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     | 4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 1 -
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index 43ffa5c7acbd..65bd88c8fef9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -708,7 +708,8 @@ int vmw_dumb_create(struct drm_file *file_priv,
 	ret = vmw_gem_object_create_with_handle(dev_priv, file_priv,
 						args->size, &args->handle,
 						&vbo);
-
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->tbo.base);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
index 51bd1f8c5cc4..d6baf73a6458 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -133,8 +133,6 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
 	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
 
 	ret = drm_gem_handle_create(filp, &(*p_vbo)->tbo.base, handle);
-	/* drop reference from allocate - handle holds it now */
-	drm_gem_object_put(&(*p_vbo)->tbo.base);
 out_no_bo:
 	return ret;
 }
@@ -161,6 +159,8 @@ int vmw_gem_object_create_ioctl(struct drm_device *dev, void *data,
 	rep->map_handle = drm_vma_node_offset_addr(&vbo->tbo.base.vma_node);
 	rep->cur_gmr_id = handle;
 	rep->cur_gmr_offset = 0;
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->tbo.base);
 out_no_bo:
 	return ret;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 9d4ae9623a00..d18fec953fa7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -867,7 +867,6 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 			goto out_unlock;
 		}
 		vmw_bo_reference(res->guest_memory_bo);
-		drm_gem_object_get(&res->guest_memory_bo->tbo.base);
 	}
 
 	tmp = vmw_resource_reference(&srf->res);
-- 
2.38.1

