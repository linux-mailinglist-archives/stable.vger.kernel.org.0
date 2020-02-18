Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67941631A9
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgBRUB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgBRUB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B1862465D;
        Tue, 18 Feb 2020 20:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056118;
        bh=MsuaI/HgEQAFlCw8QnXlY0IG7Q+77tzdvi9ttefGTN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkOXhjIsraZ1/h03HU5PL9/hLZar3OAG87/+9XeC8Rmr0eH3Cdxdls7tGNp7Gdm+X
         WpmOVIhTkaGZal3fTvxdRELGveTcEIKsmxtMAE50F3ZN0eLdgDU44CALHThfkSBJJj
         wbhVwAEX9rGylRdKurMcJzTmBT/r3av7a7FsV8rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.5 42/80] drm/panfrost: Make sure the shrinker does not reclaim referenced BOs
Date:   Tue, 18 Feb 2020 20:55:03 +0100
Message-Id: <20200218190436.393793164@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 7e0cf7e9936c4358b0863357b90aa12afe6489da upstream.

Userspace might tag a BO purgeable while it's still referenced by GPU
jobs. We need to make sure the shrinker does not purge such BOs until
all jobs referencing it are finished.

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191129135908.2439529-9-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_drv.c          |    1 +
 drivers/gpu/drm/panfrost/panfrost_gem.h          |    6 ++++++
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c |    3 +++
 drivers/gpu/drm/panfrost/panfrost_job.c          |    7 ++++++-
 4 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -166,6 +166,7 @@ panfrost_lookup_bos(struct drm_device *d
 			break;
 		}
 
+		atomic_inc(&bo->gpu_usecount);
 		job->mappings[i] = mapping;
 	}
 
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
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -41,6 +41,9 @@ static bool panfrost_gem_purge(struct dr
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 
+	if (atomic_read(&bo->gpu_usecount))
+		return false;
+
 	if (!mutex_trylock(&shmem->pages_lock))
 		return false;
 
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -269,8 +269,13 @@ static void panfrost_job_cleanup(struct
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
 


