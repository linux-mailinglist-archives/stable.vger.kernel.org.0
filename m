Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CE210D686
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfK2N7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:59:15 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35284 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfK2N7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:59:15 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5A176292794;
        Fri, 29 Nov 2019 13:59:14 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 8/8] drm/panfrost: Make sure the shrinker does not reclaim referenced BOs
Date:   Fri, 29 Nov 2019 14:59:08 +0100
Message-Id: <20191129135908.2439529-9-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129135908.2439529-1-boris.brezillon@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Userspace might tag a BO purgeable while it's still referenced by GPU
jobs. We need to make sure the shrinker does not purge such BOs until
all jobs referencing it are finished.

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c          | 1 +
 drivers/gpu/drm/panfrost/panfrost_gem.h          | 6 ++++++
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c | 2 ++
 drivers/gpu/drm/panfrost/panfrost_job.c          | 7 ++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index b406b5243b40..297c0e7304d2 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -166,6 +166,7 @@ panfrost_lookup_bos(struct drm_device *dev,
 			break;
 		}
 
+		atomic_inc(&bo->gpu_usecount);
 		job->mappings[i] = mapping;
 	}
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index ca1bc9019600..b3517ff9630c 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -30,6 +30,12 @@ struct panfrost_gem_object {
 		struct mutex lock;
 	} mappings;
 
+	/*
+	 * Count the number of jobs referencing this BO so we don't let the
+	 * shrinker reclaim this object prematurely.
+	 */
+	atomic_t gpu_usecount;
+
 	bool noexec		:1;
 	bool is_heap		:1;
 };
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
index b36df326c860..288e46c40673 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -41,6 +41,8 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj)
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 
+	if (atomic_read(&bo->gpu_usecount))
+		return false;
 
 	if (!mutex_trylock(&shmem->pages_lock))
 		return false;
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index c85d45be3b5e..2b12aa87ff32 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -270,8 +270,13 @@ static void panfrost_job_cleanup(struct kref *ref)
 	dma_fence_put(job->render_done_fence);
 
 	if (job->mappings) {
-		for (i = 0; i < job->bo_count; i++)
+		for (i = 0; i < job->bo_count; i++) {
+			if (!job->mappings[i])
+				break;
+
+			atomic_dec(&job->mappings[i]->obj->gpu_usecount);
 			panfrost_gem_mapping_put(job->mappings[i]);
+		}
 		kvfree(job->mappings);
 	}
 
-- 
2.23.0

