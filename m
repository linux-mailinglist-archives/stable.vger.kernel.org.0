Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6A3AA004
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhFPPoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235471AbhFPPmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F40EB613D3;
        Wed, 16 Jun 2021 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857872;
        bh=RU63UG+hsOXLvJl/eg0xfbdqV+vXBYCf368CdSAr4J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n48jbb9Twm7QgGJfST4klz0yOu2Md/UacSZ8fd4Z16tth+zGcFsQFvy64wulMJkDq
         e0c2719MrIjSJrTKTjqdPcpzAJ47/oKPDP+FYw4Axtt2Dy26S9welaFP87UgKqQg84
         rgsEonVQcKLPklpOwLRoInwBqRqMKaeJs+5dVcPY=
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
Subject: [PATCH 5.12 43/48] drm/amd/display: Fix potential memory leak in DMUB hw_init
Date:   Wed, 16 Jun 2021 17:33:53 +0200
Message-Id: <20210616152838.001993540@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
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
index 69023b4b0a8b..95d5bc2da178 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -871,7 +871,8 @@ static int dm_dmub_hw_init(struct amdgpu_device *adev)
 		abm->dmcu_is_running = dmcu->funcs->is_dmcu_initialized(dmcu);
 	}
 
-	adev->dm.dc->ctx->dmub_srv = dc_dmub_srv_create(adev->dm.dc, dmub_srv);
+	if (!adev->dm.dc->ctx->dmub_srv)
+		adev->dm.dc->ctx->dmub_srv = dc_dmub_srv_create(adev->dm.dc, dmub_srv);
 	if (!adev->dm.dc->ctx->dmub_srv) {
 		DRM_ERROR("Couldn't allocate DC DMUB server!\n");
 		return -ENOMEM;
@@ -1863,7 +1864,6 @@ static int dm_suspend(void *handle)
 
 	amdgpu_dm_irq_suspend(adev);
 
-
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
 
 	return 0;
-- 
2.30.2



