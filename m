Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4267AA702E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfICQ0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbfICQ0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 933CF238C7;
        Tue,  3 Sep 2019 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527997;
        bh=iMc28nEHo4LwcU2m4S1Z3UyNfivaugakbuC8bbOlxuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4IVzicSxrtGse5+0+iqgN3MbGIqlNjux/jQ6/1O6W4IeMBDn0J3XM9kkgKYghIkr
         8vn3nOW85xRAevJoNC+U8taw9O/QTkHRsjbkzTl7jJiHNr4ghDrUV23cbTM1Wh+e9U
         84UlSh6CHDxU1dPuxQzAJb4e3nfKbxrtGU2008zM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 045/167] drm/amdgpu: validate user GEM object size
Date:   Tue,  3 Sep 2019 12:23:17 -0400
Message-Id: <20190903162519.7136-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>

[ Upstream commit c4a32b266da7bb702e60381ca0c35eaddbc89a6c ]

When creating frame buffer, userspace may request to attach to a
previously allocated GEM object that is smaller than what GPU
requires. Validation must be done to prevent out-of-bound DMA,
otherwise it could be exploited to reveal sensitive data.

This fix is not done in a common code path because individual
driver might have different requirement.

Cc: stable@vger.kernel.org # v4.2+
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 6e67814d33e29..1035a47f81c9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -527,6 +527,7 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
 	struct drm_gem_object *obj;
 	struct amdgpu_framebuffer *amdgpu_fb;
 	int ret;
+	int height;
 	struct amdgpu_device *adev = dev->dev_private;
 	int cpp = drm_format_plane_cpp(mode_cmd->pixel_format, 0);
 	int pitch = mode_cmd->pitches[0] / cpp;
@@ -551,6 +552,13 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
+	height = ALIGN(mode_cmd->height, 8);
+	if (obj->size < pitch * height) {
+		DRM_DEBUG_KMS("Invalid GEM size: expecting >= %d but got %zu\n",
+			      pitch * height, obj->size);
+		return ERR_PTR(-EINVAL);
+	}
+
 	amdgpu_fb = kzalloc(sizeof(*amdgpu_fb), GFP_KERNEL);
 	if (amdgpu_fb == NULL) {
 		drm_gem_object_put_unlocked(obj);
-- 
2.20.1

