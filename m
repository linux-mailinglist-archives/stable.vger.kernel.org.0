Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D223CE4E8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbhGSPqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349294AbhGSPo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9FC61629;
        Mon, 19 Jul 2021 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711863;
        bh=rpDobu1G+F7akFTYlmVyFeM8NUSVwORrKbFMdXzVVOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzVh0eP1Z9YKcoEzP7QkPQ1RqCzEB+1saNYhthrIptU2hVXBGAs0oMeDcn5gvpSSe
         uwd07URoRKpFJfwS482QoZxR/LAw8FWsFjUQDb+CWY81ydxDb9bPqgRWRCwDkfmfvy
         RoimF0JIfO/oXmIB2f1+hYsCP8CR/AFK2m+eO5mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 161/292] drm/amdgpu: fix Navi1x tcp power gating hang when issuing lightweight invalidaiton
Date:   Mon, 19 Jul 2021 16:53:43 +0200
Message-Id: <20210719144947.785514648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 9c26ddb1c5b6e30c6bca48b8ad9205d96efe93d0 ]

Fix TCP hang when a lightweight invalidation happens on Navi1x.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 95 ++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 2342c5d216f9..5c40912b51d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -7744,6 +7744,97 @@ static void gfx_v10_0_update_fine_grain_clock_gating(struct amdgpu_device *adev,
 	}
 }
 
+static void gfx_v10_0_apply_medium_grain_clock_gating_workaround(struct amdgpu_device *adev)
+{
+	uint32_t reg_data = 0;
+	uint32_t reg_idx = 0;
+	uint32_t i;
+
+	const uint32_t tcp_ctrl_regs[] = {
+		mmCGTS_SA0_WGP00_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP00_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP01_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP01_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP02_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP02_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP10_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP10_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP11_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP11_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP12_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP12_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP00_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP00_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP01_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP01_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP02_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP02_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP10_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP10_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP11_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP11_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP12_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP12_CU1_TCP_CTRL_REG
+	};
+
+	const uint32_t tcp_ctrl_regs_nv12[] = {
+		mmCGTS_SA0_WGP00_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP00_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP01_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP01_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP02_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP02_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP10_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP10_CU1_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP11_CU0_TCP_CTRL_REG,
+		mmCGTS_SA0_WGP11_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP00_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP00_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP01_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP01_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP02_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP02_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP10_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP10_CU1_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP11_CU0_TCP_CTRL_REG,
+		mmCGTS_SA1_WGP11_CU1_TCP_CTRL_REG,
+	};
+
+	const uint32_t sm_ctlr_regs[] = {
+		mmCGTS_SA0_QUAD0_SM_CTRL_REG,
+		mmCGTS_SA0_QUAD1_SM_CTRL_REG,
+		mmCGTS_SA1_QUAD0_SM_CTRL_REG,
+		mmCGTS_SA1_QUAD1_SM_CTRL_REG
+	};
+
+	if (adev->asic_type == CHIP_NAVI12) {
+		for (i = 0; i < ARRAY_SIZE(tcp_ctrl_regs_nv12); i++) {
+			reg_idx = adev->reg_offset[GC_HWIP][0][mmCGTS_SA0_WGP00_CU0_TCP_CTRL_REG_BASE_IDX] +
+				  tcp_ctrl_regs_nv12[i];
+			reg_data = RREG32(reg_idx);
+			reg_data |= CGTS_SA0_WGP00_CU0_TCP_CTRL_REG__TCPI_LS_OVERRIDE_MASK;
+			WREG32(reg_idx, reg_data);
+		}
+	} else {
+		for (i = 0; i < ARRAY_SIZE(tcp_ctrl_regs); i++) {
+			reg_idx = adev->reg_offset[GC_HWIP][0][mmCGTS_SA0_WGP00_CU0_TCP_CTRL_REG_BASE_IDX] +
+				  tcp_ctrl_regs[i];
+			reg_data = RREG32(reg_idx);
+			reg_data |= CGTS_SA0_WGP00_CU0_TCP_CTRL_REG__TCPI_LS_OVERRIDE_MASK;
+			WREG32(reg_idx, reg_data);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sm_ctlr_regs); i++) {
+		reg_idx = adev->reg_offset[GC_HWIP][0][mmCGTS_SA0_QUAD0_SM_CTRL_REG_BASE_IDX] +
+			  sm_ctlr_regs[i];
+		reg_data = RREG32(reg_idx);
+		reg_data &= ~CGTS_SA0_QUAD0_SM_CTRL_REG__SM_MODE_MASK;
+		reg_data |= 2 << CGTS_SA0_QUAD0_SM_CTRL_REG__SM_MODE__SHIFT;
+		WREG32(reg_idx, reg_data);
+	}
+}
+
 static int gfx_v10_0_update_gfx_clock_gating(struct amdgpu_device *adev,
 					    bool enable)
 {
@@ -7760,6 +7851,10 @@ static int gfx_v10_0_update_gfx_clock_gating(struct amdgpu_device *adev,
 		gfx_v10_0_update_3d_clock_gating(adev, enable);
 		/* ===  CGCG + CGLS === */
 		gfx_v10_0_update_coarse_grain_clock_gating(adev, enable);
+
+		if ((adev->asic_type >= CHIP_NAVI10) &&
+		     (adev->asic_type <= CHIP_NAVI12))
+			gfx_v10_0_apply_medium_grain_clock_gating_workaround(adev);
 	} else {
 		/* CGCG/CGLS should be disabled before MGCG/MGLS
 		 * ===  CGCG + CGLS ===
-- 
2.30.2



