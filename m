Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384601DEAC4
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbgEVO4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbgEVOvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4310422249;
        Fri, 22 May 2020 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159059;
        bh=vbnUU0idxcT+ABC4e6dGNm6I028AtsCuHcXNWWXjmZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWXuq03xbq+pL70BqIBW3cgE8C3+k4iuakYfSg89SKAu8c2jmAvLq2q6tk2xlQzle
         BpeJGnXDJzNAqg8WRGeXaBxuAX/3vKOYaPw38DWY8o3LjEM2E6ekai+7c32zi0LZE4
         lY704kRZtCs8PiKTU31lzT0PpudwMu1myxT2QPqQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 13/32] drm/amdgpu: drop unnecessary cancel_delayed_work_sync on PG ungate
Date:   Fri, 22 May 2020 10:50:25 -0400
Message-Id: <20200522145044.434677-13-sashal@kernel.org>
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

[ Upstream commit 1fe48ec08d9f2e26d893a6c05bd6c99a3490f9ef ]

As this is already properly handled in amdgpu_gfx_off_ctrl(). In fact,
this unnecessary cancel_delayed_work_sync may leave a small time window
for race condition and is dangerous.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |  6 +-----
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c  | 12 +++---------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 14417cebe38b..6f118292e40f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4290,11 +4290,7 @@ static int gfx_v10_0_set_powergating_state(void *handle,
 	switch (adev->asic_type) {
 	case CHIP_NAVI10:
 	case CHIP_NAVI14:
-		if (!enable) {
-			amdgpu_gfx_off_ctrl(adev, false);
-			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
-		} else
-			amdgpu_gfx_off_ctrl(adev, true);
+		amdgpu_gfx_off_ctrl(adev, enable);
 		break;
 	default:
 		break;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index c34ddaa65324..6004fdacc866 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4839,10 +4839,9 @@ static int gfx_v9_0_set_powergating_state(void *handle,
 	switch (adev->asic_type) {
 	case CHIP_RAVEN:
 	case CHIP_RENOIR:
-		if (!enable) {
+		if (!enable)
 			amdgpu_gfx_off_ctrl(adev, false);
-			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
-		}
+
 		if (adev->pg_flags & AMD_PG_SUPPORT_RLC_SMU_HS) {
 			gfx_v9_0_enable_sck_slow_down_on_power_up(adev, true);
 			gfx_v9_0_enable_sck_slow_down_on_power_down(adev, true);
@@ -4868,12 +4867,7 @@ static int gfx_v9_0_set_powergating_state(void *handle,
 			amdgpu_gfx_off_ctrl(adev, true);
 		break;
 	case CHIP_VEGA12:
-		if (!enable) {
-			amdgpu_gfx_off_ctrl(adev, false);
-			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
-		} else {
-			amdgpu_gfx_off_ctrl(adev, true);
-		}
+		amdgpu_gfx_off_ctrl(adev, enable);
 		break;
 	default:
 		break;
-- 
2.25.1

