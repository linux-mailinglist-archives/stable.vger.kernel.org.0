Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906D1DEAC1
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgEVO42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730875AbgEVOvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48AFC221FA;
        Fri, 22 May 2020 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159060;
        bh=VZJ0swokq0Z7+2sCy6hkjXMh45bZApnh6Xb3qmgCXog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXuk6AMnM8m42+mxbIa+68wTPsH5Dw4w50YxU7xhkFQJETx4i/h+1AwEo86ThiaNL
         eyJvxQLmbqWe/HM4WX/S+C61MvfqAS7RXM7rmz+R7P0jtAbYAiUYj4ErKsGtU5ovp5
         VLelJIWolC9NIP0cEZ8JRnI+iw7VtNxY7N66/QXQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 14/32] drm/amd/powerplay: perform PG ungate prior to CG ungate
Date:   Fri, 22 May 2020 10:50:26 -0400
Message-Id: <20200522145044.434677-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit f4fcfa4282c1a1bf51475ebb0ffda623eebf1191 ]

Since gfxoff should be disabled first before trying to access those
GC registers.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c | 6 +++---
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
index 8bb5fbef7de0..9eb3a0dcd1f2 100644
--- a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
@@ -320,12 +320,12 @@ static void pp_dpm_en_umd_pstate(struct pp_hwmgr  *hwmgr,
 		if (*level & profile_mode_mask) {
 			hwmgr->saved_dpm_level = hwmgr->dpm_level;
 			hwmgr->en_umd_pstate = true;
-			amdgpu_device_ip_set_clockgating_state(hwmgr->adev,
-						AMD_IP_BLOCK_TYPE_GFX,
-						AMD_CG_STATE_UNGATE);
 			amdgpu_device_ip_set_powergating_state(hwmgr->adev,
 					AMD_IP_BLOCK_TYPE_GFX,
 					AMD_PG_STATE_UNGATE);
+			amdgpu_device_ip_set_clockgating_state(hwmgr->adev,
+						AMD_IP_BLOCK_TYPE_GFX,
+						AMD_CG_STATE_UNGATE);
 		}
 	} else {
 		/* exit umd pstate, restore level, enable gfx cg*/
diff --git a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
index a066e9297777..b51a124e505a 100644
--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -1541,12 +1541,12 @@ static int smu_enable_umd_pstate(void *handle,
 		if (*level & profile_mode_mask) {
 			smu_dpm_ctx->saved_dpm_level = smu_dpm_ctx->dpm_level;
 			smu_dpm_ctx->enable_umd_pstate = true;
-			amdgpu_device_ip_set_clockgating_state(smu->adev,
-							       AMD_IP_BLOCK_TYPE_GFX,
-							       AMD_CG_STATE_UNGATE);
 			amdgpu_device_ip_set_powergating_state(smu->adev,
 							       AMD_IP_BLOCK_TYPE_GFX,
 							       AMD_PG_STATE_UNGATE);
+			amdgpu_device_ip_set_clockgating_state(smu->adev,
+							       AMD_IP_BLOCK_TYPE_GFX,
+							       AMD_CG_STATE_UNGATE);
 		}
 	} else {
 		/* exit umd pstate, restore level, enable gfx cg*/
-- 
2.25.1

