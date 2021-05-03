Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE00371A31
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhECQjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhECQh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6B5613C6;
        Mon,  3 May 2021 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059788;
        bh=WtgBg4aqoSGF1AHZavDT1Gbq04vx8og/vxKkPVDIwTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBLxvZEmEIoKIbSio2Wn7XFQQeDkrxq6pdhUDf2nVEh9VeQBIdQEtTEcTy6kNsXUT
         +0q05F3xW6c2TMg90dXCBYEiN7sFKTQvbxFK7nxV2OjvSw02THVu515kX1C3NiGPll
         Rvy1eRLu8XgoB21VUjzIMqY41rWlPJ4K9crS+zUHfotqIo+zdk4c0zy4g+n8CjVqXw
         Aew4Xir5cX7s41a22+uqXZ1Lyv9wFPkmNxHb1ou1cW/cTCt9e4FA5ErB5o6KSXy6/+
         aTeb4VTfjcM8N//a4+Svh7+oLrI9pJDcQBx1VJgaUXZ4P+xzxnat1H+49+iBMRV6Ti
         F4LF3rcS3z9/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Sierra <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 048/134] drm/amdgpu: enable 48-bit IH timestamp counter
Date:   Mon,  3 May 2021 12:33:47 -0400
Message-Id: <20210503163513.2851510-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit 9a9c59a8f4f4478d5951eb0bded1d17b936aad6e ]

By default this timestamp is 32 bit counter. It gets
overflowed in around 10 minutes.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index 75b06e1964ab..86dcf448e0c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -104,6 +104,8 @@ static int vega20_ih_toggle_ring_interrupts(struct amdgpu_device *adev,
 
 	tmp = RREG32(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_ENABLE, (enable ? 1 : 0));
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_GPU_TS_ENABLE, 1);
+
 	/* enable_intr field is only valid in ring0 */
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
-- 
2.30.2

