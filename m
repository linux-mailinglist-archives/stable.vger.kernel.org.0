Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18397121526
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbfLPSS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731863AbfLPSSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4497C2082E;
        Mon, 16 Dec 2019 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520334;
        bh=WP1uKgwvWNq1jnzgW0Y4vEn/qsU+xo4nO31DIKB2sdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxHqBAntyAw6WqmEpxRCWGcN9p+k5YhRW49ZLBpnGwL1I+NQidXUCiPmv/sQREZPW
         sLTiXXavnqjUU6qQwGk2pMG+oOGwLuu+vR6AXU5k932T07DfroBTMMBVTE+JMRaNkA
         +MWo1eLJfAP2VOS20vSoEMiKzunL60EglJlg7zI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 112/177] drm/panfrost: Open/close the perfcnt BO
Date:   Mon, 16 Dec 2019 18:49:28 +0100
Message-Id: <20191216174842.252334613@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 0a5239985a3bc084738851afdf3fceb7d5651b0c upstream.

Commit a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation")
moved the drm_mm_insert_node_generic() call to the gem->open() hook,
but forgot to update perfcnt accordingly.

Patch the perfcnt logic to call panfrost_gem_open/close() where
appropriate.

Fixes: a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191129135908.2439529-6-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_drv.c     |    2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c     |    4 ++--
 drivers/gpu/drm/panfrost/panfrost_gem.h     |    4 ++++
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c |   23 ++++++++++++++---------
 drivers/gpu/drm/panfrost/panfrost_perfcnt.h |    2 +-
 5 files changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -443,7 +443,7 @@ panfrost_postclose(struct drm_device *de
 {
 	struct panfrost_file_priv *panfrost_priv = file->driver_priv;
 
-	panfrost_perfcnt_close(panfrost_priv);
+	panfrost_perfcnt_close(file);
 	panfrost_job_close(panfrost_priv);
 
 	panfrost_mmu_pgtable_free(panfrost_priv);
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -41,7 +41,7 @@ static void panfrost_gem_free_object(str
 	drm_gem_shmem_free_object(obj);
 }
 
-static int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
+int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
 {
 	int ret;
 	size_t size = obj->size;
@@ -80,7 +80,7 @@ static int panfrost_gem_open(struct drm_
 	return ret;
 }
 
-static void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
+void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
 {
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 	struct panfrost_file_priv *priv = file_priv->driver_priv;
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -45,6 +45,10 @@ panfrost_gem_create_with_handle(struct d
 				u32 flags,
 				uint32_t *handle);
 
+int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv);
+void panfrost_gem_close(struct drm_gem_object *obj,
+			struct drm_file *file_priv);
+
 void panfrost_gem_shrinker_init(struct drm_device *dev);
 void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
 
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -67,9 +67,10 @@ static int panfrost_perfcnt_dump_locked(
 }
 
 static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
-					  struct panfrost_file_priv *user,
+					  struct drm_file *file_priv,
 					  unsigned int counterset)
 {
+	struct panfrost_file_priv *user = file_priv->driver_priv;
 	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
 	struct drm_gem_shmem_object *bo;
 	u32 cfg;
@@ -91,14 +92,14 @@ static int panfrost_perfcnt_enable_locke
 	perfcnt->bo = to_panfrost_bo(&bo->base);
 
 	/* Map the perfcnt buf in the address space attached to file_priv. */
-	ret = panfrost_mmu_map(perfcnt->bo);
+	ret = panfrost_gem_open(&perfcnt->bo->base.base, file_priv);
 	if (ret)
 		goto err_put_bo;
 
 	perfcnt->buf = drm_gem_shmem_vmap(&bo->base);
 	if (IS_ERR(perfcnt->buf)) {
 		ret = PTR_ERR(perfcnt->buf);
-		goto err_put_bo;
+		goto err_close_bo;
 	}
 
 	/*
@@ -157,14 +158,17 @@ static int panfrost_perfcnt_enable_locke
 
 err_vunmap:
 	drm_gem_shmem_vunmap(&perfcnt->bo->base.base, perfcnt->buf);
+err_close_bo:
+	panfrost_gem_close(&perfcnt->bo->base.base, file_priv);
 err_put_bo:
 	drm_gem_object_put_unlocked(&bo->base);
 	return ret;
 }
 
 static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
-					   struct panfrost_file_priv *user)
+					   struct drm_file *file_priv)
 {
+	struct panfrost_file_priv *user = file_priv->driver_priv;
 	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
 
 	if (user != perfcnt->user)
@@ -180,6 +184,7 @@ static int panfrost_perfcnt_disable_lock
 	perfcnt->user = NULL;
 	drm_gem_shmem_vunmap(&perfcnt->bo->base.base, perfcnt->buf);
 	perfcnt->buf = NULL;
+	panfrost_gem_close(&perfcnt->bo->base.base, file_priv);
 	drm_gem_object_put_unlocked(&perfcnt->bo->base.base);
 	perfcnt->bo = NULL;
 	pm_runtime_mark_last_busy(pfdev->dev);
@@ -191,7 +196,6 @@ static int panfrost_perfcnt_disable_lock
 int panfrost_ioctl_perfcnt_enable(struct drm_device *dev, void *data,
 				  struct drm_file *file_priv)
 {
-	struct panfrost_file_priv *pfile = file_priv->driver_priv;
 	struct panfrost_device *pfdev = dev->dev_private;
 	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
 	struct drm_panfrost_perfcnt_enable *req = data;
@@ -207,10 +211,10 @@ int panfrost_ioctl_perfcnt_enable(struct
 
 	mutex_lock(&perfcnt->lock);
 	if (req->enable)
-		ret = panfrost_perfcnt_enable_locked(pfdev, pfile,
+		ret = panfrost_perfcnt_enable_locked(pfdev, file_priv,
 						     req->counterset);
 	else
-		ret = panfrost_perfcnt_disable_locked(pfdev, pfile);
+		ret = panfrost_perfcnt_disable_locked(pfdev, file_priv);
 	mutex_unlock(&perfcnt->lock);
 
 	return ret;
@@ -248,15 +252,16 @@ out:
 	return ret;
 }
 
-void panfrost_perfcnt_close(struct panfrost_file_priv *pfile)
+void panfrost_perfcnt_close(struct drm_file *file_priv)
 {
+	struct panfrost_file_priv *pfile = file_priv->driver_priv;
 	struct panfrost_device *pfdev = pfile->pfdev;
 	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
 
 	pm_runtime_get_sync(pfdev->dev);
 	mutex_lock(&perfcnt->lock);
 	if (perfcnt->user == pfile)
-		panfrost_perfcnt_disable_locked(pfdev, pfile);
+		panfrost_perfcnt_disable_locked(pfdev, file_priv);
 	mutex_unlock(&perfcnt->lock);
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_put_autosuspend(pfdev->dev);
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.h
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.h
@@ -9,7 +9,7 @@ void panfrost_perfcnt_sample_done(struct
 void panfrost_perfcnt_clean_cache_done(struct panfrost_device *pfdev);
 int panfrost_perfcnt_init(struct panfrost_device *pfdev);
 void panfrost_perfcnt_fini(struct panfrost_device *pfdev);
-void panfrost_perfcnt_close(struct panfrost_file_priv *pfile);
+void panfrost_perfcnt_close(struct drm_file *file_priv);
 int panfrost_ioctl_perfcnt_enable(struct drm_device *dev, void *data,
 				  struct drm_file *file_priv);
 int panfrost_ioctl_perfcnt_dump(struct drm_device *dev, void *data,


