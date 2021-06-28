Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074CB3B610E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhF1Obk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233978AbhF1O2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74FD661C7F;
        Mon, 28 Jun 2021 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890372;
        bh=G6owhmpqhIdSJhUhchnGygkNEtP/ReN23zl88rAl/y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+4iaHClI3e6sEVC1YBocxfLuMhLfVQ0RNb+SNZt2kBRUnb7gne7gzPjiStSy3/co
         xlx9BqEo1oDZWn4pyEwkgmMvnuT5E4eGqOb6U8N373zrHUa/YqwHlqBMYYICypw5gd
         CyVnYsgdgIJ92XjaQbmnbVE8eGUCqHt3cb1uTWQVo30CmaDh9xCx5rPE9BQB/1d3X8
         uzx86DOnldyxE9XKSrktV/xP47yU2IO1zZwJnujn78RdztvMEKmShHUoGSP3An/LuH
         dn6q/sG4WYZSfjId+e1MzNvmWBYJh3br+E//GUju0MdoJu+UfcyybIwOGuJlp2eIvH
         rHUirtcZBW66A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 002/101] Revert "drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue."
Date:   Mon, 28 Jun 2021 10:24:28 -0400
Message-Id: <20210628142607.32218-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit ee5468b9f1d3bf48082eed351dace14598e8ca39 upstream.

This reverts commit 4cbbe34807938e6e494e535a68d5ff64edac3f20.

Reason for revert: side effect of enlarging CP_MEC_DOORBELL_RANGE may
cause some APUs fail to enter gfxoff in certain user cases.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 1859d293ef71..fb15e8b5af32 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3619,12 +3619,8 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
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

