Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4733349F29F
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 05:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346115AbiA1Eyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 23:54:45 -0500
Received: from letterbox.kde.org ([46.43.1.242]:46832 "EHLO letterbox.kde.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346111AbiA1Eyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 23:54:44 -0500
Received: from vertex.localdomain (pool-108-36-85-85.phlapa.fios.verizon.net [108.36.85.85])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 5833828229C
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 04:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1643345678; bh=lVtYzx9+/ejYKTJ1WXkwg4OMpzs5s1Ims2lhOgn510c=;
        h=From:To:Subject:Date:From;
        b=mOyrGyOy0gM4pKxsqxwi/tP5nr5Q/3rFJJ1ZxhnHgQdM0tzDTtf8HKmhhLgovd4Nv
         8vVd4vH7Eo743mlqLPnC5XsC6rL1hdRN+0rQo4t1Gs11rgRU5DQ9ZAuy+whvjAIZHK
         /5suArosbJVB1bv+xICapd1pdCanxi8xwMmI59aI1gP5XTlE1Dq72UPYbLtEPZAOiI
         RQVb2SyRyMsSkebsgry9Nlq20vwyo+J2cpbafQG1nWFb8I9wchJnLD5jTZIr8JU2Bp
         f5DMEpxCX1lFHSfjF6MxLe++gVBCPWnGfI24YZ+VZC/mL+1EJge70kgNjoPpj/2lDS
         WPsRV0scfLREw==
From:   Zack Rusin <zack@kde.org>
To:     stable@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Fix stale file descriptors on failed usercopy
Date:   Thu, 27 Jan 2022 23:54:37 -0500
Message-Id: <20220128045437.429936-1-zack@kde.org>
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
[mks: backport to v5.16 and older]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h     |  5 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 33 +++++++++++++------------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |  2 +-
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index a833751099b5..38704f2af8b9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1115,15 +1115,14 @@ extern int vmw_execbuf_fence_commands(struct drm_file *file_priv,
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
 bool vmw_cmd_describe(const void *buf, u32 *size, char const **cmd);
 
 /**
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 5f2ffa9de5c8..9144e8f88c81 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3823,17 +3823,17 @@ int vmw_execbuf_fence_commands(struct drm_file *file_priv,
  * Also if copying fails, user-space will be unable to signal the fence object
  * so we wait for it immediately, and then unreference the user-space reference.
  */
-void
+int
 vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 			    struct vmw_fpriv *vmw_fp, int ret,
 			    struct drm_vmw_fence_rep __user *user_fence_rep,
 			    struct vmw_fence_obj *fence, uint32_t fence_handle,
-			    int32_t out_fence_fd, struct sync_file *sync_file)
+			    int32_t out_fence_fd)
 {
 	struct drm_vmw_fence_rep fence_rep;
 
 	if (user_fence_rep == NULL)
-		return;
+		return 0;
 
 	memset(&fence_rep, 0, sizeof(fence_rep));
 
@@ -3861,20 +3861,14 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 	 * handle.
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
 		ttm_ref_object_base_unref(vmw_fp->tfile, fence_handle,
 					  TTM_REF_USAGE);
 		VMW_DEBUG_USER("Fence copy error. Syncing.\n");
 		(void) vmw_fence_obj_wait(fence, false, false,
 					  VMW_FENCE_WAIT_TIMEOUT);
 	}
+
+	return ret ? -EFAULT : 0;
 }
 
 /**
@@ -4212,16 +4206,23 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 
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
-				    user_fence_rep, fence, handle, out_fence_fd,
-				    sync_file);
-
 	/* Don't unreference when handing fence out */
 	if (unlikely(out_fence != NULL)) {
 		*out_fence = fence;
@@ -4239,7 +4240,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	 */
 	vmw_validation_unref_lists(&val_ctx);
 
-	return 0;
+	return ret;
 
 out_unlock_binding:
 	mutex_unlock(&dev_priv->binding_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 9fe12329a4d5..b4d9d7258a54 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1159,7 +1159,7 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 	}
 
 	vmw_execbuf_copy_fence_user(dev_priv, vmw_fp, 0, user_fence_rep, fence,
-				    handle, -1, NULL);
+				    handle, -1);
 	vmw_fence_obj_unreference(&fence);
 	return 0;
 out_no_create:
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 74fa41909213..14e8f665b13b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2516,7 +2516,7 @@ void vmw_kms_helper_validation_finish(struct vmw_private *dev_priv,
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

