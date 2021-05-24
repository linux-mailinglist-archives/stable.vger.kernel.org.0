Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF87E38E9E6
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhEXOvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhEXOte (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5DFD613F3;
        Mon, 24 May 2021 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867654;
        bh=sF/LgMQrUi3z4U4HKIyteDD4Zwlh0WG77H/iii+lxyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7NVI2S4j9aY+RVZSBuEvuGePOPQx4OXbPLHPWSANw+ePI6FGW0WfIoqgJQTtN2EF
         kv37JjP/OMYYTt0djipB83LkUoyOwPOsxWyD1+FRf4tQ1Efl8yD0QEQhsOgywIgtS7
         svDfe+Hvm1+tWAM8gEZIpeNBKbEt6LzOUNj+4fVV+CHjdasN7wrlAXtdv/XVLpQcIE
         cxkuPdF87y/SN8t9j54u1sq57sOn936v68ZY8hUtVsPIdgtnnVam0RU9uqL0ckmCiv
         sEApmS5l3rF+j0DQ7JxKpOgic/cEyh6y68ZVUCIrjWJ+7OyLWMisk21VO7W3XH9XR3
         uzEIs9v+1q5Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 57/63] drm/amd/amdgpu: fix refcount leak
Date:   Mon, 24 May 2021 10:46:14 -0400
Message-Id: <20210524144620.2497249-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 24010cacf7d0..813b96e233ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -290,10 +290,13 @@ static int amdgpufb_create(struct drm_fb_helper *helper,
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

