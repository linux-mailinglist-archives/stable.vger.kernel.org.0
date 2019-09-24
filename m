Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671C7BCFA7
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfIXRAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410045AbfIXQp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1855121841;
        Tue, 24 Sep 2019 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343557;
        bh=uD15yigGFhyGR5IIx6WLQqFgjgO0kS+RM+hAcqBqlwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJbygNum0wrODAPypaMOm93yVbJUT0BF1C0DRaoUDPe3zDYMHNUfIDJerhVDhZZZ0
         yn1osRBMGUNlUeFzmVosHHnhLjG1KcPk3uqLvi1/PQnqhnBw+L8V8SqzHtuBSvVPGt
         2yhUdxA6FaVM2ypFDxS+52nOrWScEbSVs+0pp55Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 04/70] drm/kms: Catch mode_object lifetime errors
Date:   Tue, 24 Sep 2019 12:44:43 -0400
Message-Id: <20190924164549.27058-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 4f5368b5541a902f6596558b05f5c21a9770dd32 ]

Only dynamic mode objects, i.e. those which are refcounted and have a free
callback, can be added while the overall drm_device is visible to
userspace. All others must be added before drm_dev_register and
removed after drm_dev_unregister.

Small issue around drivers still using the load/unload callbacks, we
need to make sure we set dev->registered so that load/unload code in
these callbacks doesn't trigger false warnings. Only a small
adjustement in drm_dev_register was needed.

Motivated by some irc discussions about object ids of dynamic objects
like blobs become invalid, and me going on a bit an audit spree.

Reviewed-by: Sean Paul <sean@poorly.run>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190614061723.1173-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c         | 4 ++--
 drivers/gpu/drm/drm_mode_object.c | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 862621494a93e..6a651bf540b3b 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -987,14 +987,14 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto err_minors;
 
-	dev->registered = true;
-
 	if (dev->driver->load) {
 		ret = dev->driver->load(dev, flags);
 		if (ret)
 			goto err_minors;
 	}
 
+	dev->registered = true;
+
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_modeset_register_all(dev);
 
diff --git a/drivers/gpu/drm/drm_mode_object.c b/drivers/gpu/drm/drm_mode_object.c
index f32507e65b794..7f291f88156fc 100644
--- a/drivers/gpu/drm/drm_mode_object.c
+++ b/drivers/gpu/drm/drm_mode_object.c
@@ -37,6 +37,8 @@ int __drm_mode_object_add(struct drm_device *dev, struct drm_mode_object *obj,
 {
 	int ret;
 
+	WARN_ON(dev->registered && !obj_free_cb);
+
 	mutex_lock(&dev->mode_config.idr_mutex);
 	ret = idr_alloc(&dev->mode_config.object_idr, register_obj ? obj : NULL,
 			1, 0, GFP_KERNEL);
@@ -97,6 +99,8 @@ void drm_mode_object_register(struct drm_device *dev,
 void drm_mode_object_unregister(struct drm_device *dev,
 				struct drm_mode_object *object)
 {
+	WARN_ON(dev->registered && !object->free_cb);
+
 	mutex_lock(&dev->mode_config.idr_mutex);
 	if (object->id) {
 		idr_remove(&dev->mode_config.object_idr, object->id);
-- 
2.20.1

