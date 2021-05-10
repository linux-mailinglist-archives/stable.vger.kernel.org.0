Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FF73788AC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhEJLWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237052AbhEJLLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0728610A0;
        Mon, 10 May 2021 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644800;
        bh=rbzHGteRRXA+HYT6QScnhUlW7tlUz+0AaOJknEJ07EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgr5kNunDLBzW4EjNM/DKONMmQHhutNAfDJaAygm3DHe2x1/yX9WQjgIcOAwYY/UE
         Jmssl0g75/6eLyD5ovlJ+oS7lGOofDGPgwmJAo2CPesnKz/Xpm6mjtQj8PrXOjT6ZO
         QFPN4bw9jM00mCSG1o/IFz5W+SlJH+4mzSAOwr3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 194/384] drm/amd/display: Fix potential memory leak
Date:   Mon, 10 May 2021 12:19:43 +0200
Message-Id: <20210510102021.274134040@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit 51ba691206e35464fd7ec33dd519d141c80b5dff ]

[Why]
vblank_workqueue is never released.

[How]
Free it upon dm finish.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 167e04ab9d5b..9c243f66867a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1191,6 +1191,15 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 	if (adev->dm.dc)
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
+
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	if (adev->dm.vblank_workqueue) {
+		adev->dm.vblank_workqueue->dm = NULL;
+		kfree(adev->dm.vblank_workqueue);
+		adev->dm.vblank_workqueue = NULL;
+	}
+#endif
+
 	if (adev->dm.dc->ctx->dmub_srv) {
 		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
 		adev->dm.dc->ctx->dmub_srv = NULL;
-- 
2.30.2



