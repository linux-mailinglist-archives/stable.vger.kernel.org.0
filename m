Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35D810D683
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfK2N7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:59:15 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35222 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfK2N7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:59:14 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id BD65D292577;
        Fri, 29 Nov 2019 13:59:12 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/8] drm/panfrost: Fix a race in panfrost_ioctl_madvise()
Date:   Fri, 29 Nov 2019 14:59:02 +0100
Message-Id: <20191129135908.2439529-3-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129135908.2439529-1-boris.brezillon@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If 2 threads change the MADVISE property of the same BO in parallel we
might end up with an shmem->madv value that's inconsistent with the
presence of the BO in the shrinker list.

The easiest solution to fix that is to protect the
drm_gem_shmem_madvise() call with the shrinker lock.

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index f21bc8a7ee3a..efc0a24d1f4c 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -347,20 +347,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 		return -ENOENT;
 	}
 
+	mutex_lock(&pfdev->shrinker_lock);
 	args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);
 
 	if (args->retained) {
 		struct panfrost_gem_object *bo = to_panfrost_bo(gem_obj);
 
-		mutex_lock(&pfdev->shrinker_lock);
-
 		if (args->madv == PANFROST_MADV_DONTNEED)
-			list_add_tail(&bo->base.madv_list, &pfdev->shrinker_list);
+			list_add_tail(&bo->base.madv_list,
+				      &pfdev->shrinker_list);
 		else if (args->madv == PANFROST_MADV_WILLNEED)
 			list_del_init(&bo->base.madv_list);
-
-		mutex_unlock(&pfdev->shrinker_lock);
 	}
+	mutex_unlock(&pfdev->shrinker_lock);
 
 	drm_gem_object_put_unlocked(gem_obj);
 	return 0;
-- 
2.23.0

