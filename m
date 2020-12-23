Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2392E1764
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgLWDJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgLWCSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3232332A;
        Wed, 23 Dec 2020 02:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689820;
        bh=A8jWh6VXs3eNoGFczwY5tHyt/pPzLelK9IqcsggWE0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gShbQzsEF9zRoHkYA+QPPQyCZyyH/ZFZw6VNYb6okF6MT/K0xMgXac52Q8pLR2cKs
         0FKyKLrgnJiljnmV0N0D/qw12XXS82CxWiNzSitK0m3uo/GZC03+NlJRuXorEaJraT
         F48I2Vr6C9BhR1xNrQZjfOolmKxgavmOKT6h0/ki3cTNB1Qn17EvfFpZaBYoGG/Swx
         nA2NPPlrFP4h66ed545USNeCqGkgBSRLjgA9G3Ig0LrUGLSdOSHMUMG8u3Bel1I/KT
         0noYoh+s4v9D/2KhHXW9Dkr3xgTKUCX1zmlZvwKfzh6DqHkbGQr/J+L1mzq0HmvYcE
         z3Uv4Vb/N9MRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiansong Chen <Jiansong.Chen@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 025/217] drm/amdgpu: disable gfxoff if VCN is busy
Date:   Tue, 22 Dec 2020 21:13:14 -0500
Message-Id: <20201223021626.2790791-25-sashal@kernel.org>
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

From: Jiansong Chen <Jiansong.Chen@amd.com>

[ Upstream commit ef3b2987254035f9b869f70151b4220c34f2f133 ]

Toggle on/off gfxoff during video playback to fix gpu hang.

v2: change sequence to be more compatible with original code.

Signed-off-by: Jiansong Chen <Jiansong.Chen@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index a563328e3daea..ee6a42c81bd99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -345,6 +345,7 @@ static void amdgpu_vcn_idle_work_handler(struct work_struct *work)
 	}
 
 	if (!fences && !atomic_read(&adev->vcn.total_submission_cnt)) {
+		amdgpu_gfx_off_ctrl(adev, true);
 		amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
 		       AMD_PG_STATE_GATE);
 	} else {
@@ -357,7 +358,9 @@ void amdgpu_vcn_ring_begin_use(struct amdgpu_ring *ring)
 	struct amdgpu_device *adev = ring->adev;
 
 	atomic_inc(&adev->vcn.total_submission_cnt);
-	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
+	if (!cancel_delayed_work_sync(&adev->vcn.idle_work))
+		amdgpu_gfx_off_ctrl(adev, false);
 
 	mutex_lock(&adev->vcn.vcn_pg_lock);
 	amdgpu_device_ip_set_powergating_state(adev, AMD_IP_BLOCK_TYPE_VCN,
-- 
2.27.0

