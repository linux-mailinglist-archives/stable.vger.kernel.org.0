Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296621AC85E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439712AbgDPPHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392378AbgDPNvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE9220732;
        Thu, 16 Apr 2020 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045094;
        bh=aAgtDJfouiR+lyQpEyW4ul/VAJiRI3p/7EDAKDsDfLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuaHn/oGBIMiHskix+pDjSN0j2NCczEIKw4HDsl79g78YDULEeLvxTh1vgGdYBry7
         rk0cRDA489KkLWcjIhsrd2dqJ30U1zdLuER99GHiLr9iKETF7S6I1vYnN42PXpfYnr
         TIP8DergtyzTeE3mpQs/RpnqiPbkF6uRQx9AmpgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Mengbing Wang <Mengbing.Wang@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/232] drm/amdgpu: fix gfx hang during suspend with video playback (v2)
Date:   Thu, 16 Apr 2020 15:25:22 +0200
Message-Id: <20200416131344.027336225@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 ]

The system will be hang up during S3 suspend because of SMU is pending
for GC not respose the register CP_HQD_ACTIVE access request.This issue
root cause of accessing the GC register under enter GFX CGGPG and can
be fixed by disable GFX CGPG before perform suspend.

v2: Use disable the GFX CGPG instead of RLC safe mode guard.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 13694d5eba474..f423b53847051 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2176,8 +2176,6 @@ static int amdgpu_device_ip_suspend_phase1(struct amdgpu_device *adev)
 {
 	int i, r;
 
-	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
-	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
 		if (!adev->ip_blocks[i].status.valid)
@@ -3070,6 +3068,9 @@ int amdgpu_device_suspend(struct drm_device *dev, bool suspend, bool fbcon)
 		}
 	}
 
+	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
+	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
+
 	amdgpu_amdkfd_suspend(adev);
 
 	amdgpu_ras_suspend(adev);
-- 
2.20.1



