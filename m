Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ABC49F2AE
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 05:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbiA1E4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 23:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiA1E4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 23:56:37 -0500
X-Greylist: delayed 115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Jan 2022 20:56:37 PST
Received: from letterbox.kde.org (letterbox.kde.org [IPv6:2001:41c9:1:41e::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E41DC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 20:56:37 -0800 (PST)
Received: from vertex.localdomain (pool-108-36-85-85.phlapa.fios.verizon.net [108.36.85.85])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 2F23728229C
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 04:56:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1643345796; bh=e/M0jfEvMxfDQB3GqSa84bZDpFJ/rNjVRR+L6UDvzUY=;
        h=From:To:Subject:Date:From;
        b=APVgtWPt24FuzLmrkQwQzU6eJa3yx2EyuFbmkqakXcRLahfFFnUdoT4o9d1k7q0SW
         lIbrn3GZrKw71OmfsDuINZ1xtrIaEYyt4RsId5UBIBxfrZLJjWdwnRDxDOQOkrozRg
         bE34XZz9x4hg7804Vl1yBR8Ua/kbsm67k1y1LSdlPvprA9BDwWptEA6+u9pS2lfovq
         IOM9VQ6drYJ5LSLKJPuP7xHHVle12BSz6uDYlUJKVvQIdBikGuOYCcMadTPSQYnIVo
         0uHUgdHShyl1yJyj/Tc0OJ2TsKpgrJMr5ReL/yiMDTsQt6ffJu1oICMG59xsyh/15k
         Td+MqIHf5G+iQ==
From:   Zack Rusin <zack@kde.org>
To:     stable@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Fix stale file descriptors on failed usercopy
Date:   Thu, 27 Jan 2022 23:56:35 -0500
Message-Id: <20220128045635.430551-1-zack@kde.org>
X-Mailer: git-send-email 2.32.0
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

commit a0f90c8815706981c483a652a6aefca51a5e191c upstream.

A failing usercopy of the fence_rep object will lead to a stale entry in
the file descriptor table as put_unused_fd() won't release it. This
enables userland to refer to a dangling 'file' object through that still
valid file descriptor, leading to all kinds of use-after-free
exploitation scenarios.

Fix this by deferring the call to fd_install() until after the usercopy
has succeeded.

Fixes: c906965dee22 ("drm/vmwgfx: Add export fence to file descriptor support")
[mks: backport to v4.19 and older]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Cc: <stable@vger.kernel.org> # v4.14, v4.19
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |  5 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 34 ++++++++++++-------------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |  2 +-
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 1abe21758b0d..bca0b8980c0e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -855,15 +855,14 @@ extern int vmw_execbuf_fence_commands(struct drm_file *file_priv,
 				      struct vmw_private *dev_priv,
 				      struct vmw_fence_obj **p_fence,
 				      uint32_t *p_handle);
-extern void vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
+extern int vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 					struct vmw_fpriv *vmw_fp,
 					int ret,
 					struct drm_vmw_fence_rep __user
 					*user_fence_rep,
 					struct vmw_fence_obj *fence,
 					uint32_t fence_handle,
-					int32_t out_fence_fd,
-					struct sync_file *sync_file);
+					int32_t out_fence_fd);
 extern int vmw_validate_single_buffer(struct vmw_private *dev_priv,
 				      struct ttm_buffer_object *bo,
 				      bool interruptible,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index f0ab6b2313bb..4c2fc669238c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3868,20 +3868,19 @@ int vmw_execbuf_fence_commands(struct drm_file *file_priv,
  * object so we wait for it immediately, and then unreference the
  * user-space reference.
  */
-void
+int
 vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 			    struct vmw_fpriv *vmw_fp,
 			    int ret,
 			    struct drm_vmw_fence_rep __user *user_fence_rep,
 			    struct vmw_fence_obj *fence,
 			    uint32_t fence_handle,
-			    int32_t out_fence_fd,
-			    struct sync_file *sync_file)
+			    int32_t out_fence_fd)
 {
 	struct drm_vmw_fence_rep fence_rep;
 
 	if (user_fence_rep == NULL)
-		return;
+		return 0;
 
 	memset(&fence_rep, 0, sizeof(fence_rep));
 
@@ -3909,20 +3908,14 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 	 * and unreference the handle.
 	 */
 	if (unlikely(ret != 0) && (fence_rep.error == 0)) {
-		if (sync_file)
-			fput(sync_file->file);
-
-		if (fence_rep.fd != -1) {
-			put_unused_fd(fence_rep.fd);
-			fence_rep.fd = -1;
-		}
-
 		ttm_ref_object_base_unref(vmw_fp->tfile,
 					  fence_handle, TTM_REF_USAGE);
 		DRM_ERROR("Fence copy error. Syncing.\n");
 		(void) vmw_fence_obj_wait(fence, false, false,
 					  VMW_FENCE_WAIT_TIMEOUT);
 	}
+
+	return ret ? -EFAULT : 0;
 }
 
 /**
@@ -4282,16 +4275,23 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 
 			(void) vmw_fence_obj_wait(fence, false, false,
 						  VMW_FENCE_WAIT_TIMEOUT);
+		}
+	}
+
+	ret = vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
+				    user_fence_rep, fence, handle, out_fence_fd);
+
+	if (sync_file) {
+		if (ret) {
+			/* usercopy of fence failed, put the file object */
+			fput(sync_file->file);
+			put_unused_fd(out_fence_fd);
 		} else {
 			/* Link the fence with the FD created earlier */
 			fd_install(out_fence_fd, sync_file->file);
 		}
 	}
 
-	vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
-				    user_fence_rep, fence, handle,
-				    out_fence_fd, sync_file);
-
 	/* Don't unreference when handing fence out */
 	if (unlikely(out_fence != NULL)) {
 		*out_fence = fence;
@@ -4310,7 +4310,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	 */
 	vmw_resource_list_unreference(sw_context, &resource_list);
 
-	return 0;
+	return ret;
 
 out_unlock_binding:
 	mutex_unlock(&dev_priv->binding_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 3d546d409334..72a75316d472 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1169,7 +1169,7 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 	}
 
 	vmw_execbuf_copy_fence_user(dev_priv, vmw_fp, 0, user_fence_rep, fence,
-				    handle, -1, NULL);
+				    handle, -1);
 	vmw_fence_obj_unreference(&fence);
 	return 0;
 out_no_create:
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 6a712a8d59e9..248d92c85cf6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2662,7 +2662,7 @@ void vmw_kms_helper_buffer_finish(struct vmw_private *dev_priv,
 	if (file_priv)
 		vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv),
 					    ret, user_fence_rep, fence,
-					    handle, -1, NULL);
+					    handle, -1);
 	if (out_fence)
 		*out_fence = fence;
 	else
-- 
2.32.0

