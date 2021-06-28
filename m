Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7263B5FD7
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhF1OVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232573AbhF1OU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 353A061C77;
        Mon, 28 Jun 2021 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889913;
        bh=YTP1GqaeeMF6U4dM4uSQCw6iPj7u77R1NkbWS2ts3zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erMCrmo4uAtNbv87/6mdhuOYiKdSVVxzUJTu5Yp7KNw9rPZH219sMjPvTbTQtElK2
         Tsc66zQhp90yVCbH9+QubHA/4na8BEcT5ATzo7YEgOQtr/O1h1xOx5cEPfbDiDzKvp
         PqWcNwAD+BgVx9PUp9DwBR6LUzVfGTPWqTLvpqtMBSeNxzQjLoa6xUu6+xLA00ZUe/
         tIk1uUtGqsLpe5vnk/23OAq5S02WxEivk4VZ3P+6PyFCXN0fZNCA8SvdJcDJ9VZ8cJ
         LzHmcjp2liDVZsjd2ABHduq/CF6jEClGOw2KB9Yf/GheV8Cwv5p/E/OefrxKNV28bo
         4BtupwFpMRRtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 003/110] Revert "drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover full doorbell."
Date:   Mon, 28 Jun 2021 10:16:41 -0400
Message-Id: <20210628141828.31757-4-sashal@kernel.org>
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

commit baacf52a473b24e10322b67757ddb92ab8d86717 upstream.

This reverts commit 1c0b0efd148d5b24c4932ddb3fa03c8edd6097b3.

Reason for revert: Side effect of enlarging CP_MEC_DOORBELL_RANGE may
cause some APUs fail to enter gfxoff in certain user cases.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 72d23651501d..2342c5d216f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6769,12 +6769,8 @@ static int gfx_v10_0_kiq_init_register(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 			(adev->doorbell_index.kiq * 2) << 2);
-		/* If GC has entered CGPG, ringing doorbell > first page doesn't
-		 * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
-		 * this issue.
-		 */
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
-			(adev->doorbell.size - 4));
+			(adev->doorbell_index.userqueue_end * 2) << 2);
 	}
 
 	WREG32_SOC15(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,
-- 
2.30.2

