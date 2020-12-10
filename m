Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3609F2D5E1B
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391277AbgLJOkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391262AbgLJOj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boyuan Zhang <boyuan.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 35/75] drm/amdgpu/vcn3.0: stall DPG when WPTR/RPTR reset
Date:   Thu, 10 Dec 2020 15:27:00 +0100
Message-Id: <20201210142607.790023229@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit ac2db9488cf21de0be7899c1e5963e5ac0ff351f upstream.

Port from VCN2.5
Add vcn dpg harware synchronization to fix race condition
issue between vcn driver and hardware.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1011,6 +1011,11 @@ static int vcn_v3_0_start_dpg_mode(struc
 	tmp = REG_SET_FIELD(tmp, UVD_RBC_RB_CNTL, RB_RPTR_WR_EN, 1);
 	WREG32_SOC15(VCN, inst_idx, mmUVD_RBC_RB_CNTL, tmp);
 
+	/* Stall DPG before WPTR/RPTR reset */
+	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS),
+		UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK,
+		~UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK);
+
 	/* set the write pointer delay */
 	WREG32_SOC15(VCN, inst_idx, mmUVD_RBC_RB_WPTR_CNTL, 0);
 
@@ -1033,6 +1038,10 @@ static int vcn_v3_0_start_dpg_mode(struc
 	WREG32_SOC15(VCN, inst_idx, mmUVD_RBC_RB_WPTR,
 		lower_32_bits(ring->wptr));
 
+	/* Unstall DPG */
+	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS),
+		0, ~UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK);
+
 	return 0;
 }
 
@@ -1556,8 +1565,14 @@ static int vcn_v3_0_pause_dpg_mode(struc
 					UVD_DPG_PAUSE__NJ_PAUSE_DPG_ACK_MASK,
 					UVD_DPG_PAUSE__NJ_PAUSE_DPG_ACK_MASK);
 
+				/* Stall DPG before WPTR/RPTR reset */
+				WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS),
+					UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK,
+					~UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK);
+
 				/* Restore */
 				ring = &adev->vcn.inst[inst_idx].ring_enc[0];
+				ring->wptr = 0;
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_BASE_LO, ring->gpu_addr);
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_BASE_HI, upper_32_bits(ring->gpu_addr));
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_SIZE, ring->ring_size / 4);
@@ -1565,6 +1580,7 @@ static int vcn_v3_0_pause_dpg_mode(struc
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_WPTR, lower_32_bits(ring->wptr));
 
 				ring = &adev->vcn.inst[inst_idx].ring_enc[1];
+				ring->wptr = 0;
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_BASE_LO2, ring->gpu_addr);
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_BASE_HI2, upper_32_bits(ring->gpu_addr));
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_SIZE2, ring->ring_size / 4);
@@ -1574,6 +1590,10 @@ static int vcn_v3_0_pause_dpg_mode(struc
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RBC_RB_WPTR,
 					RREG32_SOC15(VCN, inst_idx, mmUVD_SCRATCH2) & 0x7FFFFFFF);
 
+				/* Unstall DPG */
+				WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS),
+					0, ~UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK);
+
 				SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS,
 					UVD_PGFSM_CONFIG__UVDM_UVDU_PWR_ON, UVD_POWER_STATUS__UVD_POWER_STATUS_MASK);
 			}


