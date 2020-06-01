Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9005D1EAA67
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgFASHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgFASHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:07:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563ED20872;
        Mon,  1 Jun 2020 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034858;
        bh=vbnUU0idxcT+ABC4e6dGNm6I028AtsCuHcXNWWXjmZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aXDCCRCJZ/mbdoYpK2iLspepqYaiXj71BpVVcqO/2bK0zaNBvczjedGgxSrQNudn
         nxgye+2Atl0SSopl4keWGYdlR5/o38ruFUQM3F0+x1AGNPvlZdpPXA4e5090lB/g2x
         NuBlcd7rJZmQi2+7Q0h1QffJng7pz5JzohhwiEo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/142] drm/amdgpu: drop unnecessary cancel_delayed_work_sync on PG ungate
Date:   Mon,  1 Jun 2020 19:53:22 +0200
Message-Id: <20200601174042.468195530@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



