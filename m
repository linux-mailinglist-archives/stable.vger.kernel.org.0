Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8EC3AFE6D
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 09:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFVH4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 03:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFVH4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 03:56:32 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C76C061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 00:54:17 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d11so20091436wrm.0
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 00:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LhH8oe/P3I1pzGmmehyVUQA+j57rQxFhoVV75MXvrbE=;
        b=iMYkmuMmAuc7zCSmFtjhahXRlmloWJjVkF/yHNExxDjbBJPt3xiwKtj9qr9Iqq3cBd
         GKjNg+bmnWoDpyJhSL8AklbZkYxHv7pu4AiebKBhnlyKv5Zm4UfmKUp7mRy9ZwwDSPQH
         9Z+cl/OM7FFHdXLOMqHJbuaz4ApyMUDbFSGWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LhH8oe/P3I1pzGmmehyVUQA+j57rQxFhoVV75MXvrbE=;
        b=sNmFCBQ2156g8Ex7jVCoFB1hcdJ7vPAG9wG8QxS5VxC5djXX+Ov7hdVGoMowyXKr7R
         N+5KmebJQur6NWDT5XWReszstd+cK9K7rSObgndOTjEkC6mdhW0d52j0Ut7Y/VIMCfZa
         lU0IidGxfZh6VYSI38KMLcOuDeaFUmt59aC7K4KkMnV4e06cPQwN9JYelu98yntjRTbr
         7Ir8ItxVBta28Y09iQDaQowQ4rwkhwLOLc/QCQ2r4ew9QuVkYucSNsmjOLUNElS13GjA
         6vx19P5H5hdcqnndj2N5EcI1JFHCUyRu2Ku0VMGgqLc6Dwj5L39V6+kkgeZJ/JAjBrkv
         pwIA==
X-Gm-Message-State: AOAM531oI/IKLSqLz9AF0upDoJxYYm9Aib66Plqb5IpS+C2dgQEBs8qb
        hcR83v4B5jg05YkjXQjZPfsGFQ==
X-Google-Smtp-Source: ABdhPJxQCH5xUKVEpxaBsZxWEb9pvwGN+FqzCFhxrWDsS+CTUL0E7qjy4lEy4pSUTFUm+EvaPXXXmA==
X-Received: by 2002:adf:e2cf:: with SMTP id d15mr3084891wrj.48.1624348455854;
        Tue, 22 Jun 2021 00:54:15 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v16sm20949920wrr.6.2021.06.22.00.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 00:54:15 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH] Revert "drm: add a locked version of drm_is_current_master"
Date:   Tue, 22 Jun 2021 09:54:09 +0200
Message-Id: <20210622075409.2673805-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.32.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 1815d9c86e3090477fbde066ff314a7e9721ee0f.

Unfortunately this inverts the locking hierarchy, so back to the
drawing board. Full lockdep splat below:

======================================================
WARNING: possible circular locking dependency detected
5.13.0-rc7-CI-CI_DRM_10254+ #1 Not tainted
------------------------------------------------------
kms_frontbuffer/1087 is trying to acquire lock:
ffff88810dcd01a8 (&dev->master_mutex){+.+.}-{3:3}, at: drm_is_current_master+0x1b/0x40
but task is already holding lock:
ffff88810dcd0488 (&dev->mode_config.mutex){+.+.}-{3:3}, at: drm_mode_getconnector+0x1c6/0x4a0
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #2 (&dev->mode_config.mutex){+.+.}-{3:3}:
       __mutex_lock+0xab/0x970
       drm_client_modeset_probe+0x22e/0xca0
       __drm_fb_helper_initial_config_and_unlock+0x42/0x540
       intel_fbdev_initial_config+0xf/0x20 [i915]
       async_run_entry_fn+0x28/0x130
       process_one_work+0x26d/0x5c0
       worker_thread+0x37/0x380
       kthread+0x144/0x170
       ret_from_fork+0x1f/0x30
-> #1 (&client->modeset_mutex){+.+.}-{3:3}:
       __mutex_lock+0xab/0x970
       drm_client_modeset_commit_locked+0x1c/0x180
       drm_client_modeset_commit+0x1c/0x40
       __drm_fb_helper_restore_fbdev_mode_unlocked+0x88/0xb0
       drm_fb_helper_set_par+0x34/0x40
       intel_fbdev_set_par+0x11/0x40 [i915]
       fbcon_init+0x270/0x4f0
       visual_init+0xc6/0x130
       do_bind_con_driver+0x1e5/0x2d0
       do_take_over_console+0x10e/0x180
       do_fbcon_takeover+0x53/0xb0
       register_framebuffer+0x22d/0x310
       __drm_fb_helper_initial_config_and_unlock+0x36c/0x540
       intel_fbdev_initial_config+0xf/0x20 [i915]
       async_run_entry_fn+0x28/0x130
       process_one_work+0x26d/0x5c0
       worker_thread+0x37/0x380
       kthread+0x144/0x170
       ret_from_fork+0x1f/0x30
-> #0 (&dev->master_mutex){+.+.}-{3:3}:
       __lock_acquire+0x151e/0x2590
       lock_acquire+0xd1/0x3d0
       __mutex_lock+0xab/0x970
       drm_is_current_master+0x1b/0x40
       drm_mode_getconnector+0x37e/0x4a0
       drm_ioctl_kernel+0xa8/0xf0
       drm_ioctl+0x1e8/0x390
       __x64_sys_ioctl+0x6a/0xa0
       do_syscall_64+0x39/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xae
other info that might help us debug this:
Chain exists of: &dev->master_mutex --> &client->modeset_mutex --> &dev->mode_config.mutex
 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&dev->mode_config.mutex);
                               lock(&client->modeset_mutex);
                               lock(&dev->mode_config.mutex);
  lock(&dev->master_mutex);
*** DEADLOCK ***
1 lock held by kms_frontbuffer/1087:
 #0: ffff88810dcd0488 (&dev->mode_config.mutex){+.+.}-{3:3}, at: drm_mode_getconnector+0x1c6/0x4a0
stack backtrace:
CPU: 7 PID: 1087 Comm: kms_frontbuffer Not tainted 5.13.0-rc7-CI-CI_DRM_10254+ #1
Hardware name: Intel Corporation Ice Lake Client Platform/IceLake U DDR4 SODIMM PD RVP TLC, BIOS ICLSFWR1.R00.3234.A01.1906141750 06/14/2019
Call Trace:
 dump_stack+0x7f/0xad
 check_noncircular+0x12e/0x150
 __lock_acquire+0x151e/0x2590
 lock_acquire+0xd1/0x3d0
 __mutex_lock+0xab/0x970
 drm_is_current_master+0x1b/0x40
 drm_mode_getconnector+0x37e/0x4a0
 drm_ioctl_kernel+0xa8/0xf0
 drm_ioctl+0x1e8/0x390
 __x64_sys_ioctl+0x6a/0xa0
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

daniel@phenom:~/linux/drm-misc-fixes$ dim fixes 1815d9c86e3090477fbde066ff314a7e9721ee0f
Fixes: 1815d9c86e30 ("drm: add a locked version of drm_is_current_master")
Cc: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
---
 drivers/gpu/drm/drm_auth.c | 51 ++++++++++++++------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 86d4b72e95cb..232abbba3686 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -61,35 +61,6 @@
  * trusted clients.
  */
 
-static bool drm_is_current_master_locked(struct drm_file *fpriv)
-{
-	lockdep_assert_held_once(&fpriv->master->dev->master_mutex);
-
-	return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
-}
-
-/**
- * drm_is_current_master - checks whether @priv is the current master
- * @fpriv: DRM file private
- *
- * Checks whether @fpriv is current master on its device. This decides whether a
- * client is allowed to run DRM_MASTER IOCTLs.
- *
- * Most of the modern IOCTL which require DRM_MASTER are for kernel modesetting
- * - the current master is assumed to own the non-shareable display hardware.
- */
-bool drm_is_current_master(struct drm_file *fpriv)
-{
-	bool ret;
-
-	mutex_lock(&fpriv->master->dev->master_mutex);
-	ret = drm_is_current_master_locked(fpriv);
-	mutex_unlock(&fpriv->master->dev->master_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(drm_is_current_master);
-
 int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	struct drm_auth *auth = data;
@@ -252,7 +223,7 @@ int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 	if (ret)
 		goto out_unlock;
 
-	if (drm_is_current_master_locked(file_priv))
+	if (drm_is_current_master(file_priv))
 		goto out_unlock;
 
 	if (dev->master) {
@@ -301,7 +272,7 @@ int drm_dropmaster_ioctl(struct drm_device *dev, void *data,
 	if (ret)
 		goto out_unlock;
 
-	if (!drm_is_current_master_locked(file_priv)) {
+	if (!drm_is_current_master(file_priv)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -350,7 +321,7 @@ void drm_master_release(struct drm_file *file_priv)
 	if (file_priv->magic)
 		idr_remove(&file_priv->master->magic_map, file_priv->magic);
 
-	if (!drm_is_current_master_locked(file_priv))
+	if (!drm_is_current_master(file_priv))
 		goto out;
 
 	drm_legacy_lock_master_cleanup(dev, master);
@@ -371,6 +342,22 @@ void drm_master_release(struct drm_file *file_priv)
 	mutex_unlock(&dev->master_mutex);
 }
 
+/**
+ * drm_is_current_master - checks whether @priv is the current master
+ * @fpriv: DRM file private
+ *
+ * Checks whether @fpriv is current master on its device. This decides whether a
+ * client is allowed to run DRM_MASTER IOCTLs.
+ *
+ * Most of the modern IOCTL which require DRM_MASTER are for kernel modesetting
+ * - the current master is assumed to own the non-shareable display hardware.
+ */
+bool drm_is_current_master(struct drm_file *fpriv)
+{
+	return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
+}
+EXPORT_SYMBOL(drm_is_current_master);
+
 /**
  * drm_master_get - reference a master pointer
  * @master: &struct drm_master
-- 
2.32.0.rc2

