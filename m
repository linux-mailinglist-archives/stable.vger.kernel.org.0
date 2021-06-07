Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF6339E2A9
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhFGQSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231775AbhFGQQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E66536145A;
        Mon,  7 Jun 2021 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082443;
        bh=2fIwcSbLPYzttkG0EbSC7eMYdbZEukgqXk7iyFFVBHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aY+3EBUfyrkdOCtDNOofQwlFnkqzvr+nm5dUeI5A1B5ix/I1K8bGXruYvtH3TnMiI
         1/5sERh2WJ5zXJNRf+RICUDhft/GY4SCoYRNJVkDMKflFeJP0C6n32gJSGzR4Fg/w0
         ekkymM6F905B3BgEKY1d5mHD7LgiFrBIJv90q96SUYjDMIk57qsEz2q9edrxs9h6DJ
         gOht7LDXzFzN4FZhgum1+OzSWMIhwPBjJghc/F5JNCAiURchWXwUzUfoaV1ycAtAg2
         U3GqZLzgTsqKftEam4QS+IoPg74Lrq0ROLw7y6FLOQeaAgr6OK8fiL8Q6G3YGwiKjw
         IAYB34j+6nD1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <roman.li@amd.com>, Lang Yu <Lang.Yu@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 34/39] drm/amd/display: Fix potential memory leak in DMUB hw_init
Date:   Mon,  7 Jun 2021 12:13:13 -0400
Message-Id: <20210607161318.3583636-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

[ Upstream commit c5699e2d863f58221044efdc3fa712dd32d55cde ]

[Why]
On resume we perform DMUB hw_init which allocates memory:
dm_resume->dm_dmub_hw_init->dc_dmub_srv_create->kzalloc
That results in memory leak in suspend/resume scenarios.

[How]
Allocate memory for the DC wrapper to DMUB only if it was not
allocated before.
No need to reallocate it on suspend/resume.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4792228ed481..13588c46ae8e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -870,7 +870,8 @@ static int dm_dmub_hw_init(struct amdgpu_device *adev)
 		abm->dmcu_is_running = dmcu->funcs->is_dmcu_initialized(dmcu);
 	}
 
-	adev->dm.dc->ctx->dmub_srv = dc_dmub_srv_create(adev->dm.dc, dmub_srv);
+	if (!adev->dm.dc->ctx->dmub_srv)
+		adev->dm.dc->ctx->dmub_srv = dc_dmub_srv_create(adev->dm.dc, dmub_srv);
 	if (!adev->dm.dc->ctx->dmub_srv) {
 		DRM_ERROR("Couldn't allocate DC DMUB server!\n");
 		return -ENOMEM;
@@ -1755,7 +1756,6 @@ static int dm_suspend(void *handle)
 
 	amdgpu_dm_irq_suspend(adev);
 
-
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
 
 	return 0;
-- 
2.30.2

