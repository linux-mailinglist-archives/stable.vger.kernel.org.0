Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F2B2B64DE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733268AbgKQNu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731849AbgKQNch (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE3E621534;
        Tue, 17 Nov 2020 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619956;
        bh=TtG8PTcSMbodycPdWFhTPm49W+ZPjFYcro/5mLaoErk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duAjtj5rAqf2ZOxHyQiG12xb/jh5OJoLtRIkn4VNC8MCPMBTIm8FiztbaT/gIpqKa
         HoUpjBTvfkl6TxWq7YjptZKwcWwzFhgV/QEHFwd0fMXiLK4tEy01+oxbrqUu1TiDZ3
         /aks2EXftDTRHkHSwullOQ+6qF8IiQRovzZt53Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 030/255] drm/vc4: bo: Add a managed action to cleanup the cache
Date:   Tue, 17 Nov 2020 14:02:50 +0100
Message-Id: <20201117122140.411872312@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 1c80be48c70a2198f7cf04a546b3805b92293ac6 ]

The BO cache needs to be cleaned up using vc4_bo_cache_destroy, but it's
not used consistently (vc4_drv's bind calls it in its error path, but
doesn't in unbind), and we can make that automatic through a managed
action. Let's remove the requirement to call vc4_bo_cache_destroy.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201029190104.2181730-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c  | 5 +++--
 drivers/gpu/drm/vc4/vc4_drv.c | 1 -
 drivers/gpu/drm/vc4/vc4_drv.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 74ceebd62fbce..073b528f33337 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1005,6 +1005,7 @@ int vc4_get_tiling_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
+static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused);
 int vc4_bo_cache_init(struct drm_device *dev)
 {
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
@@ -1033,10 +1034,10 @@ int vc4_bo_cache_init(struct drm_device *dev)
 	INIT_WORK(&vc4->bo_cache.time_work, vc4_bo_cache_time_work);
 	timer_setup(&vc4->bo_cache.time_timer, vc4_bo_cache_time_timer, 0);
 
-	return 0;
+	return drmm_add_action_or_reset(dev, vc4_bo_cache_destroy, NULL);
 }
 
-void vc4_bo_cache_destroy(struct drm_device *dev)
+static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 {
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	int i;
diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index f6995e7f6eb6e..c7aeaba3fabe8 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -311,7 +311,6 @@ unbind_all:
 gem_destroy:
 	vc4_gem_destroy(drm);
 	drm_mode_config_cleanup(drm);
-	vc4_bo_cache_destroy(drm);
 dev_put:
 	drm_dev_put(drm);
 	return ret;
diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index fa19160c801f8..528c28895a8e0 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -14,6 +14,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_encoder.h>
 #include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_mm.h>
 #include <drm/drm_modeset_lock.h>
 
@@ -786,7 +787,6 @@ struct drm_gem_object *vc4_prime_import_sg_table(struct drm_device *dev,
 						 struct sg_table *sgt);
 void *vc4_prime_vmap(struct drm_gem_object *obj);
 int vc4_bo_cache_init(struct drm_device *dev);
-void vc4_bo_cache_destroy(struct drm_device *dev);
 int vc4_bo_inc_usecnt(struct vc4_bo *bo);
 void vc4_bo_dec_usecnt(struct vc4_bo *bo);
 void vc4_bo_add_to_purgeable_pool(struct vc4_bo *bo);
-- 
2.27.0



