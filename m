Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAEA3F6398
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhHXQ5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234047AbhHXQ5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 589AA613AD;
        Tue, 24 Aug 2021 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824184;
        bh=zSsqLqs9NEQ84a3pOoD9Txi9qHD9cKc7nLGQi+AM+kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWiefn9rt/oaUuxnj2ljqXelMWEBSEmUobUi49X4ul70vB2EQGoqGyTDNncyg55CI
         HAOFB7CqNUwXY9vtTycQIu9Sa7wuFmFwUB7fcvNlzqqNQ57Ww+I36Gj1Fmj4By+xYX
         waQ9VT20JddGZEneuvstN7RUIaul0aptE/mBQIBpks+wFPL1trIPIofJ2J7I7MWT3c
         CzMg0lCbo7R3f0uW9ZeCA0rXaL/5ul1eBLdzn2wROBXq8BXqABeZVnA27nDnPzoKw7
         9SkqqBRo84f+8cg/oJWs5PUTpsSHsSoG18e6g9Ia4KPNzNx1TcJPqdFrBTf9BBLUuI
         RyWHVuKnWsRiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 016/127] drm/amdgpu: fix the doorbell missing when in CGPG issue for renoir.
Date:   Tue, 24 Aug 2021 12:54:16 -0400
Message-Id: <20210824165607.709387-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 1c0539a6fc8a4a4b77278e35d763073890de96b9 ]

If GC has entered CGPG, ringing doorbell > first page doesn't wakeup GC.
Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround this issue.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 516467e962b7..3a476b86485e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1293,6 +1293,16 @@ static bool is_raven_kicker(struct amdgpu_device *adev)
 		return false;
 }
 
+static bool check_if_enlarge_doorbell_range(struct amdgpu_device *adev)
+{
+	if ((adev->asic_type == CHIP_RENOIR) &&
+	    (adev->gfx.me_fw_version >= 0x000000a5) &&
+	    (adev->gfx.me_feature_version >= 52))
+		return true;
+	else
+		return false;
+}
+
 static void gfx_v9_0_check_if_need_gfxoff(struct amdgpu_device *adev)
 {
 	if (gfx_v9_0_should_disable_gfxoff(adev->pdev))
@@ -3673,7 +3683,16 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 					(adev->doorbell_index.kiq * 2) << 2);
-		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
+		/* If GC has entered CGPG, ringing doorbell > first page
+		 * doesn't wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to
+		 * workaround this issue. And this change has to align with firmware
+		 * update.
+		 */
+		if (check_if_enlarge_doorbell_range(adev))
+			WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
+					(adev->doorbell.size - 4));
+		else
+			WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
 					(adev->doorbell_index.userqueue_end * 2) << 2);
 	}
 
-- 
2.30.2

