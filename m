Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC5240EBA
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgHJTOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbgHJTOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:14:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC3322CAF;
        Mon, 10 Aug 2020 19:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086890;
        bh=BfPjhQ44U9DE3oZzImTFIZQyBr/WqCe9IVpkANI4hnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvmAKii1siy0HJFqwX1SFK/WzgSG5JyShXidIsvolIB+RjhfUSbyYvj6T9/aEdUq+
         eWMt5EUuh6L5aaqj+4SHuUG8Z5XysbxyF1xu0vO262TgdJ0XwxBsnp6j9tCw1/YXF1
         o2TRpsreYgP2X71rxdGSpDi1QYI3i8dYOe0hG8Ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 04/16] drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync
Date:   Mon, 10 Aug 2020 15:14:31 -0400
Message-Id: <20200810191443.3795581-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191443.3795581-1-sashal@kernel.org>
References: <20200810191443.3795581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 9fb10671011143d15b6b40d6d5fa9c52c57e9d63 ]

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, decrement the
reference count before returning the error.

Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_display.c | 4 +++-
 drivers/gpu/drm/radeon/radeon_drv.c     | 4 +++-
 drivers/gpu/drm/radeon/radeon_kms.c     | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 4572bfba017c5..17c73b8c90e71 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -660,8 +660,10 @@ radeon_crtc_set_config(struct drm_mode_set *set)
 	dev = set->crtc->dev;
 
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return ret;
+	}
 
 	ret = drm_crtc_helper_set_config(set);
 
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 5b6a6f5b3619e..401403a3ea50c 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -527,8 +527,10 @@ long radeon_drm_ioctl(struct file *filp,
 	long ret;
 	dev = file_priv->minor->dev;
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return ret;
+	}
 
 	ret = drm_ioctl(filp, cmd, arg);
 	
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index d290a8a09036e..41caf7da90548 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -631,8 +631,10 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 	file_priv->driver_priv = NULL;
 
 	r = pm_runtime_get_sync(dev->dev);
-	if (r < 0)
+	if (r < 0) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* new gpu have virtual address space support */
 	if (rdev->family >= CHIP_CAYMAN) {
-- 
2.25.1

