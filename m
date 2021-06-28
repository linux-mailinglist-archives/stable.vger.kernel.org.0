Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1BB3B5FD5
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhF1OU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232489AbhF1OU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB4F61C79;
        Mon, 28 Jun 2021 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889912;
        bh=EaF8pptw/9qNBl3aNp0mFMnO1KcILbZDrsA5hj3J2Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvFq1q4C8pxvYGc6jfFLC2cElV3fVZTGb8VgPisPGQlFKDN/LpB6ZHlBTuRQCarTW
         eo6buAKKWJC5ZXyDvYlEFoEFlCmDIPzsJ0OwANTwyzsGGy/wa0f8yCU9krTYKl9DEm
         kq8If4HTI8WyQI8hr4wSxgeArZKIYDliTfYi/JElTPn4YB3DPFN0AGt5Xi7nR7jeyp
         A1oCgxbZ7PCKGZET8u2v+RXZLkV+wVp2grzuAJS1oJekQhfYBWiAaoB8PHSAqsfJSx
         EL4Zod7t2lxgAJ+AWoXq5KE5iFXk4UJyxfWfFEN5EkAEmphbW/xPX+WkmNTmIDOIMM
         YG299zfw2FHIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 002/110] Revert "drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue."
Date:   Mon, 28 Jun 2021 10:16:40 -0400
Message-Id: <20210628141828.31757-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 1fdfb7783404..d2c020a91c0b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3623,12 +3623,8 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
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

