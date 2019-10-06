Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525F6CD6DB
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfJFRjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbfJFRje (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D952C20700;
        Sun,  6 Oct 2019 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383573;
        bh=h0E9bDafxlOExbxHUClj/mummCyEFJaSyMZs4q0U54w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMbsf2RxEjuYLkuSamcKANM4CUO0lBR3mk2wKjoOsTDcK6skBj6eu6N69UR6urjCE
         cdN1uEcBUXliD/YMr0hliBN1TntSuMVPH8PFSnfDpQB3ILX9rgUF9yGbF5lS9GLxQ3
         Df+tdzivSS1q0vsvqNpI/SSsX3xNnBeTije5nzNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Shirish S <shirish.s@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 017/166] drm/amdgpu: Fix hard hang for S/G display BOs.
Date:   Sun,  6 Oct 2019 19:19:43 +0200
Message-Id: <20191006171214.597824651@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit e4c4073b0139d055d43a9568690fc560aab4fa5c ]

HW requires for caching to be unset for scanout BO
mappings when the BO placement is in GTT memory.
Usually the flag to unset is passed from user mode
but for FB mode this was missing.

v2:
Keep all BO placement logic in amdgpu_display_supported_domains

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Shirish S <shirish.s@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c  | 7 +++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 3 ++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index eb3569b46c1e1..430c56f9544a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -139,14 +139,14 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 	mode_cmd->pitches[0] = amdgpu_align_pitch(adev, mode_cmd->width, cpp,
 						  fb_tiled);
 	domain = amdgpu_display_supported_domains(adev);
-
 	height = ALIGN(mode_cmd->height, 8);
 	size = mode_cmd->pitches[0] * height;
 	aligned_size = ALIGN(size, PAGE_SIZE);
 	ret = amdgpu_gem_object_create(adev, aligned_size, 0, domain,
 				       AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED |
-				       AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS |
-				       AMDGPU_GEM_CREATE_VRAM_CLEARED,
+				       AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS     |
+				       AMDGPU_GEM_CREATE_VRAM_CLEARED 	     |
+				       AMDGPU_GEM_CREATE_CPU_GTT_USWC,
 				       ttm_bo_type_kernel, NULL, &gobj);
 	if (ret) {
 		pr_err("failed to allocate framebuffer (%d)\n", aligned_size);
@@ -168,7 +168,6 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 			dev_err(adev->dev, "FB failed to set tiling flags\n");
 	}
 
-
 	ret = amdgpu_bo_pin(abo, domain);
 	if (ret) {
 		amdgpu_bo_unreserve(abo);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 939f8305511b8..fb291366d5ade 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -747,7 +747,8 @@ int amdgpu_mode_dumb_create(struct drm_file *file_priv,
 	struct amdgpu_device *adev = dev->dev_private;
 	struct drm_gem_object *gobj;
 	uint32_t handle;
-	u64 flags = AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
+	u64 flags = AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED |
+		    AMDGPU_GEM_CREATE_CPU_GTT_USWC;
 	u32 domain;
 	int r;
 
-- 
2.20.1



