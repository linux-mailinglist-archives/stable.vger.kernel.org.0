Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26743BCD92
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhGFLWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhGFLUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5324A61CC3;
        Tue,  6 Jul 2021 11:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570247;
        bh=+gJwqH3qnoQPAxy9N5oXl0R72nGKihjj2Ere3lD/uGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c96PTx90zQu2iIZsfxotCuXhno1bl6k4tYzcCrxodzq+VhCAxWiXNvCOBesZehdtN
         1vMZEsYpLzgXey0r57aYd0pfwPqZ/wx0MB3xh3FeKoCSW4Q1kIGB9iHe9dMC6RbPdr
         QN5o6WJBWkMQwDIb9eSF4m9yzP/St+wC5F4+TrZjnY0tTv1JuwmAbv2ujQUYONY1Wt
         xv5+3N90q6qCpoABuPwLjT6FFFjqGxd4twgRbpHbhsJsJdU6iK5GIcFm6pChE7duWc
         m3XBmnu3HE71ytT8utvgQJBbG2pfuX9t4laFOAgUMxRdoq0lxTg7Mrku+Iq26dCXjy
         L/Xemd9T8g/zQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 146/189] Revert "drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue."
Date:   Tue,  6 Jul 2021 07:13:26 -0400
Message-Id: <20210706111409.2058071-146-sashal@kernel.org>
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

[ Upstream commit 962f2f1ae273399e357a3192d5413ca57f9b4885 ]

This reverts commit 631003101c516ea29a74aee59666708857b9a805.

Reason for revert: side effect of enlarging CP_MEC_DOORBELL_RANGE may
cause some APUs fail to enter gfxoff in certain user cases.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index c09225d065c2..516467e962b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3673,12 +3673,8 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 					(adev->doorbell_index.kiq * 2) << 2);
-		/* If GC has entered CGPG, ringing doorbell > first page doesn't
-		 * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
-		 * this issue.
-		 */
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
-					(adev->doorbell.size - 4));
+					(adev->doorbell_index.userqueue_end * 2) << 2);
 	}
 
 	WREG32_SOC15_RLC(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,
-- 
2.30.2

