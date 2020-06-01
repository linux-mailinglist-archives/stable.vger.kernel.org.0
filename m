Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9965A1EAC9A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgFASNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbgFASNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6074F2068D;
        Mon,  1 Jun 2020 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035217;
        bh=Va4bxQT4rSos0RV3A0bab4uHESC1vcR9w9aXywjzpWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYeFy2QlCgygDO4nl57nj7S+cVjELTkeAczQt7NIF0K52FsYLtraze6Z+X+3qwj9g
         TKLJSysGU4PtvZoQ0Rc2LW2C3HuPrLp5THiX/4tkfnalsfpGIxd3Q6qNvDub914hhK
         SkRmEnyMHx5gj8XuW8gXPeFidn5VXoymy4pn+Bno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 061/177] drm/amd/powerplay: perform PG ungate prior to CG ungate
Date:   Mon,  1 Jun 2020 19:53:19 +0200
Message-Id: <20200601174054.054389464@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e4e5a53b2b4e..8e2acb4df860 100644
--- a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
@@ -319,12 +319,12 @@ static void pp_dpm_en_umd_pstate(struct pp_hwmgr  *hwmgr,
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
index 96e81c7bc266..e2565967db07 100644
--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -1675,12 +1675,12 @@ static int smu_enable_umd_pstate(void *handle,
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



