Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B2438EBC1
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhEXPHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233735AbhEXPDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4696161477;
        Mon, 24 May 2021 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867838;
        bh=seJzjGs9sZ6zHofGNTUjuqpT4Swidg4xyrcoyTpbhH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCd5AturtuDd/gnYJBC4GcRDuqDCYs8DmcywDX75d9ab2dhY00JkZH1UU6eGxHJGC
         MpHzwOcAUfJTvNXc5sH51/LUAvPrwcooAQShbgjVUafR6/5biVkmSuiWAp0ny3Z14c
         CwbJUGBkjL5E4mTfjWt92tqBl4qfjA5C8BAvj1gviCDGd/D33wns2RyuJpnYcT0mSo
         UApwqa+pA1nZ+OK6FYrGXNgd5Xzi10CCP0ELKPHrT+9q1U2aqt4lXR794LD68qSGAz
         jIHdyIDk9MSBgXea0qztajtz7v7ANH9/Di4zFxk0JoGnNTYKdctqGfAd6y+Bkgf74E
         gCKLNnsA8qSfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 24/25] drm/amd/amdgpu: fix refcount leak
Date:   Mon, 24 May 2021 10:50:07 -0400
Message-Id: <20210524145008.2499049-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
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
index 69c5d22f29bd..d55ff59584c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -297,10 +297,13 @@ static int amdgpufb_create(struct drm_fb_helper *helper,
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

