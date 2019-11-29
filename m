Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F08810D684
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfK2N7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:59:15 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35242 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfK2N7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:59:15 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5297C29257A;
        Fri, 29 Nov 2019 13:59:13 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/8] drm/panfrost: Fix a race in panfrost_gem_free_object()
Date:   Fri, 29 Nov 2019 14:59:04 +0100
Message-Id: <20191129135908.2439529-5-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129135908.2439529-1-boris.brezillon@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

panfrost_gem_shrinker_scan() might purge a BO (release the sgt and
kill the GPU mapping) that's being freed by panfrost_gem_free_object()
if we don't remove the BO from the shrinker list at the beginning of
panfrost_gem_free_object().

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_gem.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index acb07fe06580..daf4c55a2863 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -19,6 +19,16 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 	struct panfrost_device *pfdev = obj->dev->dev_private;
 
+	/*
+	 * Make sure the BO is no longer inserted in the shrinker list before
+	 * taking care of the destruction itself. If we don't do that we have a
+	 * race condition between this function and what's done in
+	 * panfrost_gem_shrinker_scan().
+	 */
+	mutex_lock(&pfdev->shrinker_lock);
+	list_del_init(&bo->base.madv_list);
+	mutex_unlock(&pfdev->shrinker_lock);
+
 	if (bo->sgts) {
 		int i;
 		int n_sgt = bo->base.base.size / SZ_2M;
@@ -33,11 +43,6 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
 		kfree(bo->sgts);
 	}
 
-	mutex_lock(&pfdev->shrinker_lock);
-	if (!list_empty(&bo->base.madv_list))
-		list_del(&bo->base.madv_list);
-	mutex_unlock(&pfdev->shrinker_lock);
-
 	drm_gem_shmem_free_object(obj);
 }
 
-- 
2.23.0

