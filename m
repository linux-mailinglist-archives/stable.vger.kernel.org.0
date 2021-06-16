Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE7B3A9FA1
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhFPPjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234939AbhFPPiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E4CB613C7;
        Wed, 16 Jun 2021 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857770;
        bh=2fIwcSbLPYzttkG0EbSC7eMYdbZEukgqXk7iyFFVBHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbVosPmx9//SMA0fs5uM7WW7aSJKgmhVmRgw2dH9cbCG3A8qlPbhyoQK3w9zL+QnJ
         XRYv8p7XWYGngQI0orWUp9Cuv0rwga3rhltREAdXrOSqJ5Zu9AuqIty/REF5LFUXRK
         yilLzYTbEo6T6rD1DGISfFj1CXFawr7iQGww7ynU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <Lang.Yu@amd.com>,
        Roman Li <roman.li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/38] drm/amd/display: Fix potential memory leak in DMUB hw_init
Date:   Wed, 16 Jun 2021 17:33:42 +0200
Message-Id: <20210616152836.440158760@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



