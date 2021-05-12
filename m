Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80B437CD42
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhELQxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243732AbhELQl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7045461CF2;
        Wed, 12 May 2021 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835572;
        bh=hTibNLwkN+P8FUOPENYEas2Z//XVgyjCmovOXXblGkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwVLP74x2hSAMteBdQEhY1M5MJeF1Z3ryeSl6tAPAn02mWmyhU9gTyPtqEf9WalZo
         OlfGdeMRG/PunYgCx+B3/LxSJYc3fZD02bS7l1SvwlzUD2tfPWQekYoGzSEiTsuno8
         POQYwlY/nmtrl96XSYF47LIpVrx/dFpOEiirw2jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 398/677] drm/msm: Fix debugfs deadlock
Date:   Wed, 12 May 2021 16:47:24 +0200
Message-Id: <20210512144850.558882351@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 6ed0897cd800c38b92a33d335d9086c7b092eb15 ]

In normal cases the gem obj lock is acquired first before mm_lock.  The
exception is iterating the various object lists.  In the shrinker path,
deadlock is avoided by using msm_gem_trylock() and skipping over objects
that cannot be locked.  But for debugfs the straightforward thing is to
split things out into a separate list of all objects protected by it's
own lock.

Fixes: d984457b31c4 ("drm/msm: Add priv->mm_lock to protect active/inactive lists")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20210401012722.527712-4-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_debugfs.c | 14 +++-----------
 drivers/gpu/drm/msm/msm_drv.c     |  3 +++
 drivers/gpu/drm/msm/msm_drv.h     |  9 ++++++++-
 drivers/gpu/drm/msm/msm_gem.c     | 14 +++++++++++++-
 drivers/gpu/drm/msm/msm_gem.h     | 12 ++++++++++--
 5 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_debugfs.c b/drivers/gpu/drm/msm/msm_debugfs.c
index 85ad0babc326..d611cc8e54a4 100644
--- a/drivers/gpu/drm/msm/msm_debugfs.c
+++ b/drivers/gpu/drm/msm/msm_debugfs.c
@@ -111,23 +111,15 @@ static const struct file_operations msm_gpu_fops = {
 static int msm_gem_show(struct drm_device *dev, struct seq_file *m)
 {
 	struct msm_drm_private *priv = dev->dev_private;
-	struct msm_gpu *gpu = priv->gpu;
 	int ret;
 
-	ret = mutex_lock_interruptible(&priv->mm_lock);
+	ret = mutex_lock_interruptible(&priv->obj_lock);
 	if (ret)
 		return ret;
 
-	if (gpu) {
-		seq_printf(m, "Active Objects (%s):\n", gpu->name);
-		msm_gem_describe_objects(&gpu->active_list, m);
-	}
-
-	seq_printf(m, "Inactive Objects:\n");
-	msm_gem_describe_objects(&priv->inactive_dontneed, m);
-	msm_gem_describe_objects(&priv->inactive_willneed, m);
+	msm_gem_describe_objects(&priv->objects, m);
 
-	mutex_unlock(&priv->mm_lock);
+	mutex_unlock(&priv->obj_lock);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 196907689c82..18ea1c66de71 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -446,6 +446,9 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 
 	priv->wq = alloc_ordered_workqueue("msm", 0);
 
+	INIT_LIST_HEAD(&priv->objects);
+	mutex_init(&priv->obj_lock);
+
 	INIT_LIST_HEAD(&priv->inactive_willneed);
 	INIT_LIST_HEAD(&priv->inactive_dontneed);
 	mutex_init(&priv->mm_lock);
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 591c47a654e8..6b58e49754cb 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -174,7 +174,14 @@ struct msm_drm_private {
 	struct msm_rd_state *hangrd;   /* debugfs to dump hanging submits */
 	struct msm_perf_state *perf;
 
-	/*
+	/**
+	 * List of all GEM objects (mainly for debugfs, protected by obj_lock
+	 * (acquire before per GEM object lock)
+	 */
+	struct list_head objects;
+	struct mutex obj_lock;
+
+	/**
 	 * Lists of inactive GEM objects.  Every bo is either in one of the
 	 * inactive lists (depending on whether or not it is shrinkable) or
 	 * gpu->active_list (for the gpu it is active on[1])
diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index f091c1e164fa..aeba3eb8ce46 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -951,7 +951,7 @@ void msm_gem_describe_objects(struct list_head *list, struct seq_file *m)
 	size_t size = 0;
 
 	seq_puts(m, "   flags       id ref  offset   kaddr            size     madv      name\n");
-	list_for_each_entry(msm_obj, list, mm_list) {
+	list_for_each_entry(msm_obj, list, node) {
 		struct drm_gem_object *obj = &msm_obj->base;
 		seq_puts(m, "   ");
 		msm_gem_describe(obj, m);
@@ -970,6 +970,10 @@ void msm_gem_free_object(struct drm_gem_object *obj)
 	struct drm_device *dev = obj->dev;
 	struct msm_drm_private *priv = dev->dev_private;
 
+	mutex_lock(&priv->obj_lock);
+	list_del(&msm_obj->node);
+	mutex_unlock(&priv->obj_lock);
+
 	mutex_lock(&priv->mm_lock);
 	list_del(&msm_obj->mm_list);
 	mutex_unlock(&priv->mm_lock);
@@ -1157,6 +1161,10 @@ static struct drm_gem_object *_msm_gem_new(struct drm_device *dev,
 	list_add_tail(&msm_obj->mm_list, &priv->inactive_willneed);
 	mutex_unlock(&priv->mm_lock);
 
+	mutex_lock(&priv->obj_lock);
+	list_add_tail(&msm_obj->node, &priv->objects);
+	mutex_unlock(&priv->obj_lock);
+
 	return obj;
 
 fail:
@@ -1227,6 +1235,10 @@ struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 	list_add_tail(&msm_obj->mm_list, &priv->inactive_willneed);
 	mutex_unlock(&priv->mm_lock);
 
+	mutex_lock(&priv->obj_lock);
+	list_add_tail(&msm_obj->node, &priv->objects);
+	mutex_unlock(&priv->obj_lock);
+
 	return obj;
 
 fail:
diff --git a/drivers/gpu/drm/msm/msm_gem.h b/drivers/gpu/drm/msm/msm_gem.h
index b3a0a880cbab..99d4c0e9465e 100644
--- a/drivers/gpu/drm/msm/msm_gem.h
+++ b/drivers/gpu/drm/msm/msm_gem.h
@@ -55,8 +55,16 @@ struct msm_gem_object {
 	 */
 	uint8_t vmap_count;
 
-	/* And object is either:
-	 *  inactive - on priv->inactive_list
+	/**
+	 * Node in list of all objects (mainly for debugfs, protected by
+	 * priv->obj_lock
+	 */
+	struct list_head node;
+
+	/**
+	 * An object is either:
+	 *  inactive - on priv->inactive_dontneed or priv->inactive_willneed
+	 *     (depending on purgability status)
 	 *  active   - on one one of the gpu's active_list..  well, at
 	 *     least for now we don't have (I don't think) hw sync between
 	 *     2d and 3d one devices which have both, meaning we need to
-- 
2.30.2



