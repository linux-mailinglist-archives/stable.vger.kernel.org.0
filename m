Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E426D38EAC5
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhEXO5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234304AbhEXOzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C704961436;
        Mon, 24 May 2021 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867733;
        bh=2j2wS4jLwunQgKp8uCz0/fUYW0whooKMAeCGQGEo/MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fza88v8TWRCQLCbccQvoWykGHU4n2KNc+X3JzABvQfhRxbsEmT4+skhkKmCd3T3o5
         wDKwVoAiiuZ6H/AFHvHUBvfaI1hHuXQQCAPkqHQOev2vBvJbWPipVhT7Q9VEAA/uLL
         4UTAb4Hvse/UkTgJ+DDF/FVBnx1NGOvAy69vNsvxLatUrv25fjyrYt6SxYfFLCgS4g
         s6v4HIxol5D3ysZx7Z2nmBRcuapn0c8m336UljfAN2IiGQKgsIMwGNi9qzHQNrfPh6
         0J4A/qDi0EtukPw9is2CBwEv/WTRC1RK4VkxpAM+ghk0J0TAZRELBm17sOeuPlgqJ/
         3jX9JP4nNtVkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 56/62] drm/amd/amdgpu: fix refcount leak
Date:   Mon, 24 May 2021 10:47:37 -0400
Message-Id: <20210524144744.2497894-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index 1ea8af48ae2f..43f29ee0e3b0 100644
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

