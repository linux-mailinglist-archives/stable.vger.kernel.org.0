Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126685883C
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0RYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 13:24:20 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47720 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0RYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 13:24:20 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 77399287B22;
        Thu, 27 Jun 2019 18:24:18 +0100 (BST)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/panfrost: Fix a double-free error
Date:   Thu, 27 Jun 2019 19:24:14 +0200
Message-Id: <20190627172414.27231-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drm_gem_shmem_create_with_handle() returns a GEM object and attach a
handle to it. When the user closes the DRM FD, the core releases all
GEM handles along with their backing GEM objs, which can lead to a
double-free issue if panfrost_ioctl_create_bo() failed and went
through the err_free path where drm_gem_object_put_unlocked() is
called without deleting the associate handle.

Replace this drm_gem_object_put_unlocked() call by a
drm_gem_handle_delete() one to fix that.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
Reproduced for real when BO mapping fails because we ran out of
memory.
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 07b01eb3d136..cb43ff4ebf4a 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -67,7 +67,7 @@ static int panfrost_ioctl_create_bo(struct drm_device *dev, void *data,
 	return 0;
 
 err_free:
-	drm_gem_object_put_unlocked(&shmem->base);
+	drm_gem_handle_delete(file, args->handle);
 	return ret;
 }
 
-- 
2.21.0

