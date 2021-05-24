Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0980138EB72
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhEXPDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234684AbhEXPA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C11E61476;
        Mon, 24 May 2021 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867804;
        bh=TTnz5OriA+p5HLPpRS8J0Z2C4CzA/KCLw6QSdGxXHc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndOlsglaSWEJowZnPcQDoOJQIViE4tupPTve0ILwC54H1/ZLh76uKec5EzMwAKm9i
         4PxgRIuCrJyoPwJcDE7h+JjJ05ah5w58F1i/z0dFYMShXlZmYaWR+ooPzuNmItyO39
         1gNUtOkecB6nfQnHEoF2XGVdjX1U3Kvs7dnaPypzutiy0TmtNsnmKthkX/yeYcAI/B
         MUdxetWYtFeotmQIdCqFQElY32W/62e3kuyUxGEdskGrHUgGZGRWm6/jF8IFLB/IMl
         VvS1rjUPLkBSQZiLRZA3iLIvAo51WW+ENYf3pJkEBWwAcyIRF86R4+OFzGW9ZIIGqP
         R5KpZvchD0ayw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 50/52] drm/amd/amdgpu: fix refcount leak
Date:   Mon, 24 May 2021 10:49:00 -0400
Message-Id: <20210524144903.2498518-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingwen Chen <Jingwen.Chen2@amd.com>

[ Upstream commit fa7e6abc75f3d491bc561734312d065dc9dc2a77 ]

[Why]
the gem object rfb->base.obj[0] is get according to num_planes
in amdgpufb_create, but is not put according to num_planes

[How]
put rfb->base.obj[0] in amdgpu_fbdev_destroy according to num_planes

Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index fd94a17fb2c6..46522804c7d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -289,10 +289,13 @@ static int amdgpufb_create(struct drm_fb_helper *helper,
 static int amdgpu_fbdev_destroy(struct drm_device *dev, struct amdgpu_fbdev *rfbdev)
 {
 	struct amdgpu_framebuffer *rfb = &rfbdev->rfb;
+	int i;
 
 	drm_fb_helper_unregister_fbi(&rfbdev->helper);
 
 	if (rfb->base.obj[0]) {
+		for (i = 0; i < rfb->base.format->num_planes; i++)
+			drm_gem_object_put(rfb->base.obj[0]);
 		amdgpufb_destroy_pinned_object(rfb->base.obj[0]);
 		rfb->base.obj[0] = NULL;
 		drm_framebuffer_unregister_private(&rfb->base);
-- 
2.30.2

