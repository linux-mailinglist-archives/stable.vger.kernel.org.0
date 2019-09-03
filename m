Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5442FA6E89
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfICQ0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730669AbfICQ0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E647F23789;
        Tue,  3 Sep 2019 16:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527994;
        bh=99vI5vKcRGeRvP/ZZt4/CfY7lB6MsEgoUTllPFqFQXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dp6fYkyIwKb9eqAotN4S9ZjF3u/UOnXnkQYx8CEwIRlQ4NBV5hESYAsve3r7sA7mW
         /BSJ0hpsHS+ZtWsk2HVaqngz7BLT/GrcUgCjIYTNx7T7PgxiRXMfdWxBovtAIR8fEc
         mlq81XCbAF2u7p8g+M9aaxnQhSGGGJ4oVDx4GVkw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 044/167] drm/amdgpu: validate user pitch alignment
Date:   Tue,  3 Sep 2019 12:23:16 -0400
Message-Id: <20190903162519.7136-44-sashal@kernel.org>
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

[ Upstream commit 89f23b6efef554766177bf51aa754bce14c3e7da ]

Userspace may request pitch alignment that is not supported by GPU.
Some requests 32, but GPU ignores it and uses default 64 when cpp is
4. If GEM object is allocated based on the smaller alignment, GPU
DMA will go out of bound.

Cc: stable@vger.kernel.org # v4.2+
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 686a26de50f91..6e67814d33e29 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -527,6 +527,16 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
 	struct drm_gem_object *obj;
 	struct amdgpu_framebuffer *amdgpu_fb;
 	int ret;
+	struct amdgpu_device *adev = dev->dev_private;
+	int cpp = drm_format_plane_cpp(mode_cmd->pixel_format, 0);
+	int pitch = mode_cmd->pitches[0] / cpp;
+
+	pitch = amdgpu_align_pitch(adev, pitch, cpp, false);
+	if (mode_cmd->pitches[0] != pitch) {
+		DRM_DEBUG_KMS("Invalid pitch: expecting %d but got %d\n",
+			      pitch, mode_cmd->pitches[0]);
+		return ERR_PTR(-EINVAL);
+	}
 
 	obj = drm_gem_object_lookup(file_priv, mode_cmd->handles[0]);
 	if (obj ==  NULL) {
-- 
2.20.1

