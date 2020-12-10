Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BC82D6025
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391271AbgLJOkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391264AbgLJOkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:01 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boyuan Zhang <boyuan.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 36/75] drm/amdgpu/vcn3.0: remove old DPG workaround
Date:   Thu, 10 Dec 2020 15:27:01 +0100
Message-Id: <20201210142607.841516663@linuxfoundation.org>
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

commit efd6d85a18102241538dd1cc257948a0dbe6fae6 upstream.

Port from VCN2.5
SCRATCH2 is used to keep decode wptr as a workaround
which fix a hardware DPG decode wptr update bug for
vcn2.5 beforehand.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1587,9 +1587,6 @@ static int vcn_v3_0_pause_dpg_mode(struc
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_RPTR2, lower_32_bits(ring->wptr));
 				WREG32_SOC15(VCN, inst_idx, mmUVD_RB_WPTR2, lower_32_bits(ring->wptr));
 
-				WREG32_SOC15(VCN, inst_idx, mmUVD_RBC_RB_WPTR,
-					RREG32_SOC15(VCN, inst_idx, mmUVD_SCRATCH2) & 0x7FFFFFFF);
-
 				/* Unstall DPG */
 				WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS),
 					0, ~UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK);
@@ -1650,10 +1647,6 @@ static void vcn_v3_0_dec_ring_set_wptr(s
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	if (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)
-		WREG32_SOC15(VCN, ring->me, mmUVD_SCRATCH2,
-			lower_32_bits(ring->wptr) | 0x80000000);
-
 	if (ring->use_doorbell) {
 		adev->wb.wb[ring->wptr_offs] = lower_32_bits(ring->wptr);
 		WDOORBELL32(ring->doorbell_index, lower_32_bits(ring->wptr));


