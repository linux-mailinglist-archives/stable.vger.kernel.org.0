Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022583BCCF7
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhGFLUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232638AbhGFLTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F1361C58;
        Tue,  6 Jul 2021 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570201;
        bh=qcYdnbqkX9V0lWhi62Ku1uDrc46cJ69E55kxUBiy394=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvhzsNq59158lU8hjv26N13OwPj1/8cCm4Z14/Pxl+U77orvoaTjc6aewRhqH6JTq
         H8YMiHAPjhk3vZgN4Y7/cxx8bEo6JDi94GB2oqb2OxxpuTO6G0cwdzzk5bla+Wdfox
         kcKFX2sACNE3jFT8TE2g+Cho2hDh4cyKVWU/3I1N4vz4OnUgvJgPr1y5A1fTcFOOEL
         YMH3AZU+gVTR/SrD/Dp19xzFP8NCAuFuAnEbsXAjD3cHzsdgryO6UmqheA8MqugJ6l
         FSaGLAn2TdztYbLh/Dkag3o4qsmNz1zqX8emBciDZVjXo6hHE7jl8L8Nvzabqai8Pb
         YWhuH/bRRAN7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 113/189] drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue.
Date:   Tue,  6 Jul 2021 07:12:53 -0400
Message-Id: <20210706111409.2058071-113-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 631003101c516ea29a74aee59666708857b9a805 ]

If GC has entered CGPG, ringing doorbell > first page doesn't wakeup GC.
Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround this issue.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 516467e962b7..c09225d065c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3673,8 +3673,12 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 					(adev->doorbell_index.kiq * 2) << 2);
+		/* If GC has entered CGPG, ringing doorbell > first page doesn't
+		 * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
+		 * this issue.
+		 */
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
-					(adev->doorbell_index.userqueue_end * 2) << 2);
+					(adev->doorbell.size - 4));
 	}
 
 	WREG32_SOC15_RLC(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,
-- 
2.30.2

