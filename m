Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ACB395CC6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhEaNhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232006AbhEaNfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A0F561442;
        Mon, 31 May 2021 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467515;
        bh=ELrSf7ipyOGhnwcsBgG+KpJ2zLw5e3XoUzLD75AMy1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDV4Q3oazJtiFGJ+8hInd/2wl2+EaeGG9yx1989m565XwNzZcZftb/hY+ukZNFsca
         uUklFvhqwlu5WC+JF3v9IXHLOYuRFTnEyOYrR+c2JM3L8SX0EfGz6Avy+ZysR5dFo1
         4LV6NdlqxfNqrn+MkMaOi0H7xXdL38AF7m8WoOpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingwen Chen <Jingwen.Chen2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/116] drm/amd/amdgpu: fix refcount leak
Date:   Mon, 31 May 2021 15:14:30 +0200
Message-Id: <20210531130643.323804707@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 69c5d22f29bd..d55ff59584c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -297,10 +297,13 @@ out:
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



