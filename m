Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA2338EE72
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhEXPu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234597AbhEXPrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:47:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2438861574;
        Mon, 24 May 2021 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870636;
        bh=XYh8ezb/IUe1xhaP7Ot2KYhVPApl/pVDN0SGxRPyzC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBjutT8gam+1uxD2f+PiywUUwB7FiFaRRmJp3CNtP6LgE8J+ViNje4Fpv/h/vVKkg
         tRR38GgEwyI018LrbGWTDqhzZFblUtSRUQVTrjNrBRNFXKdjyqGMS8dYBCCWJlvr2y
         r3c5SCRM2xC97irpqR5ATE+h43nhZxDqD9DbwZYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changfeng <Changfeng.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.4 37/71] drm/amdgpu: disable 3DCGCG on picasso/raven1 to avoid compute hang
Date:   Mon, 24 May 2021 17:25:43 +0200
Message-Id: <20210524152327.676498693@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changfeng <Changfeng.Zhu@amd.com>

commit dbd1003d1252db5973dddf20b24bb0106ac52aa2 upstream.

There is problem with 3DCGCG firmware and it will cause compute test
hang on picasso/raven1. It needs to disable 3DCGCG in driver to avoid
compute hang.

Signed-off-by: Changfeng <Changfeng.Zhu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   10 +++++++---
 drivers/gpu/drm/amd/amdgpu/soc15.c    |    2 --
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4661,7 +4661,7 @@ static void gfx_v9_0_update_3d_clock_gat
 	amdgpu_gfx_rlc_enter_safe_mode(adev);
 
 	/* Enable 3D CGCG/CGLS */
-	if (enable && (adev->cg_flags & AMD_CG_SUPPORT_GFX_3D_CGCG)) {
+	if (enable) {
 		/* write cmd to clear cgcg/cgls ov */
 		def = data = RREG32_SOC15(GC, 0, mmRLC_CGTT_MGCG_OVERRIDE);
 		/* unset CGCG override */
@@ -4673,8 +4673,12 @@ static void gfx_v9_0_update_3d_clock_gat
 		/* enable 3Dcgcg FSM(0x0000363f) */
 		def = RREG32_SOC15(GC, 0, mmRLC_CGCG_CGLS_CTRL_3D);
 
-		data = (0x36 << RLC_CGCG_CGLS_CTRL_3D__CGCG_GFX_IDLE_THRESHOLD__SHIFT) |
-			RLC_CGCG_CGLS_CTRL_3D__CGCG_EN_MASK;
+		if (adev->cg_flags & AMD_CG_SUPPORT_GFX_3D_CGCG)
+			data = (0x36 << RLC_CGCG_CGLS_CTRL_3D__CGCG_GFX_IDLE_THRESHOLD__SHIFT) |
+				RLC_CGCG_CGLS_CTRL_3D__CGCG_EN_MASK;
+		else
+			data = 0x0 << RLC_CGCG_CGLS_CTRL_3D__CGCG_GFX_IDLE_THRESHOLD__SHIFT;
+
 		if (adev->cg_flags & AMD_CG_SUPPORT_GFX_3D_CGLS)
 			data |= (0x000F << RLC_CGCG_CGLS_CTRL_3D__CGLS_REP_COMPANSAT_DELAY__SHIFT) |
 				RLC_CGCG_CGLS_CTRL_3D__CGLS_EN_MASK;
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1132,7 +1132,6 @@ static int soc15_common_early_init(void
 			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |
 				AMD_CG_SUPPORT_GFX_MGLS |
 				AMD_CG_SUPPORT_GFX_CP_LS |
-				AMD_CG_SUPPORT_GFX_3D_CGCG |
 				AMD_CG_SUPPORT_GFX_3D_CGLS |
 				AMD_CG_SUPPORT_GFX_CGCG |
 				AMD_CG_SUPPORT_GFX_CGLS |
@@ -1152,7 +1151,6 @@ static int soc15_common_early_init(void
 				AMD_CG_SUPPORT_GFX_MGLS |
 				AMD_CG_SUPPORT_GFX_RLC_LS |
 				AMD_CG_SUPPORT_GFX_CP_LS |
-				AMD_CG_SUPPORT_GFX_3D_CGCG |
 				AMD_CG_SUPPORT_GFX_3D_CGLS |
 				AMD_CG_SUPPORT_GFX_CGCG |
 				AMD_CG_SUPPORT_GFX_CGLS |


