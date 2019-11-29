Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57A10D687
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfK2N7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:59:16 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35262 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfK2N7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:59:15 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id CD2FA29256A;
        Fri, 29 Nov 2019 13:59:13 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 6/8] drm/panfrost: Make sure imported/exported BOs are never purged
Date:   Fri, 29 Nov 2019 14:59:06 +0100
Message-Id: <20191129135908.2439529-7-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129135908.2439529-1-boris.brezillon@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We don't want imported/exported BOs to be purges, as those are shared
with other processes that might still use them. We should also refuse
to export a BO if it's been marked purgeable or has already been purged.

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 19 ++++++++++++++++-
 drivers/gpu/drm/panfrost/panfrost_gem.c | 27 +++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 1c67ac434e10..751df975534f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -343,6 +343,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 	struct drm_panfrost_madvise *args = data;
 	struct panfrost_device *pfdev = dev->dev_private;
 	struct drm_gem_object *gem_obj;
+	int ret;
 
 	gem_obj = drm_gem_object_lookup(file_priv, args->handle);
 	if (!gem_obj) {
@@ -350,6 +351,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 		return -ENOENT;
 	}
 
+	/*
+	 * We don't want to mark exported/imported BOs as purgeable: we're not
+	 * the only owner in that case.
+	 */
+	mutex_lock(&dev->object_name_lock);
+	if (gem_obj->dma_buf)
+		ret = -EINVAL;
+	else
+		ret = 0;
+
+	if (ret)
+		goto out_unlock_object_name;
+
 	mutex_lock(&pfdev->shrinker_lock);
 	args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);
 
@@ -364,8 +378,11 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 	}
 	mutex_unlock(&pfdev->shrinker_lock);
 
+out_unlock_object_name:
+	mutex_unlock(&dev->object_name_lock);
+
 	drm_gem_object_put_unlocked(gem_obj);
-	return 0;
+	return ret;
 }
 
 int panfrost_unstable_ioctl_check(void)
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 92a95210a899..31d6417dd21c 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -99,6 +99,32 @@ void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
 	spin_unlock(&priv->mm_lock);
 }
 
+static struct dma_buf *
+panfrost_gem_export(struct drm_gem_object *obj, int flags)
+{
+	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
+	int ret;
+
+	/*
+	 * We must make sure the BO has not been marked purgeable/purged before
+	 * adding the mapping.
+	 * Note that we don't need to protect this test with a lock because
+	 * &drm_gem_object_funcs.export() is called with
+	 * &drm_device.object_lock held, and panfrost_ioctl_madvise() takes
+	 * this lock before calling drm_gem_shmem_madvise() (the function that
+	 * modifies bo->base.madv).
+	 */
+	if (bo->base.madv == PANFROST_MADV_WILLNEED)
+		ret = -EINVAL;
+	else
+		ret = 0;
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	return drm_gem_prime_export(obj, flags);
+}
+
 static int panfrost_gem_pin(struct drm_gem_object *obj)
 {
 	if (to_panfrost_bo(obj)->is_heap)
@@ -112,6 +138,7 @@ static const struct drm_gem_object_funcs panfrost_gem_funcs = {
 	.open = panfrost_gem_open,
 	.close = panfrost_gem_close,
 	.print_info = drm_gem_shmem_print_info,
+	.export = panfrost_gem_export,
 	.pin = panfrost_gem_pin,
 	.unpin = drm_gem_shmem_unpin,
 	.get_sg_table = drm_gem_shmem_get_sg_table,
-- 
2.23.0

