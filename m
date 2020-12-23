Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C772E11C6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgLWCRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgLWCRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D85122248;
        Wed, 23 Dec 2020 02:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689793;
        bh=lJ5yxKRFM+bJLKd/Ns3NYPBSkBeHsGXFVHnerk6Oihg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dcuoejv8CnujBKhiMVRWD5JFfzEIPKeUf19INm35+dEaC5jeWI+iR/sT56GAuZf0C
         EMjsns7dHOcFbsmuGoxDDosqJpSjDcY8ISYpdlzctl8bG2bE4QYTFR+ooHY8ZYTSsP
         322mHjL3rRkgQ7+yU64WXt9Klc1zae51q4DjLXNrg+sp6pT8lpiOarhvhaQ4eU+l6o
         XXn81hazqPcRIfhQF8b5LzjcMEh3pS9NEqU7UnEVPtTPCt6KvjwzB8gwKKssziqN8F
         VEjSwHBPqkJtDlJfVRlqf7XDDMZUfMvvKRG5sDmTMLvF6ZrWhbu8fsBnzqS+iegPdu
         ovtyNyIZI7lVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Matt Coffin <mcoffin13@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Roman Li <Roman.Li@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 005/217] drm/amd/display: Fix the display corruption issue on Navi10
Date:   Tue, 22 Dec 2020 21:12:54 -0500
Message-Id: <20201223021626.2790791-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 0b08c54bb7a37047a3a006e36c2270ebc62fef7d ]

[Why]
Screen corruption on Navi10 card

[How]
Set system context in DCN only on Renoir

Tested-by: Matt Coffin <mcoffin13@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 547928cf284b5..96907707fdd94 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1085,10 +1085,14 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	dc_hardware_init(adev->dm.dc);
 
-	mmhub_read_system_context(adev, &pa_config);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	if (adev->asic_type == CHIP_RENOIR) {
+		mmhub_read_system_context(adev, &pa_config);
 
-	// Call the DC init_memory func
-	dc_setup_system_context(adev->dm.dc, &pa_config);
+		// Call the DC init_memory func
+		dc_setup_system_context(adev->dm.dc, &pa_config);
+	}
+#endif
 
 	adev->dm.freesync_module = mod_freesync_create(adev->dm.dc);
 	if (!adev->dm.freesync_module) {
-- 
2.27.0

