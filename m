Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650E21199A7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfLJVJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfLJVJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED99F246A5;
        Tue, 10 Dec 2019 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012152;
        bh=tuAaTuL8euIcbGtYBkcietDdMq711xgJAVedFgWRTR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pEo0erx/FZPIVgCRRxr+b5XY38Qh+/f9bcyZBgkKfasVuvtUJwJYZQA3Hol7uj5d
         ziS24lXub72Lbadix4sYcGNmt/pHPgvsghGWYfwoysAVAG2Hxf838klw+jMyoxTvlm
         ltAJT8o750VCwaTj7+9dKzlErapqizuxLoodV6SQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Le Ma <le.ma@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 115/350] drm/amd/powerplay: avoid disabling ECC if RAS is enabled for VEGA20
Date:   Tue, 10 Dec 2019 16:03:40 -0500
Message-Id: <20191210210735.9077-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Le Ma <le.ma@amd.com>

[ Upstream commit df9331e561dab0a451cbd6a679ee88a95f306fd6 ]

Program THM_BACO_CNTL.SOC_DOMAIN_IDLE=1 will tell VBIOS to disable ECC when
BACO exit. This can save BACO exit time by PSP on none-ECC SKU. Drop the setting
for ECC supported SKU.

Signed-off-by: Le Ma <le.ma@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c
index df6ff92524011..b068d1c7b44d2 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c
@@ -29,7 +29,7 @@
 #include "vega20_baco.h"
 #include "vega20_smumgr.h"
 
-
+#include "amdgpu_ras.h"
 
 static const struct soc15_baco_cmd_entry clean_baco_tbl[] =
 {
@@ -74,6 +74,7 @@ int vega20_baco_get_state(struct pp_hwmgr *hwmgr, enum BACO_STATE *state)
 int vega20_baco_set_state(struct pp_hwmgr *hwmgr, enum BACO_STATE state)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)(hwmgr->adev);
+	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);
 	enum BACO_STATE cur_state;
 	uint32_t data;
 
@@ -84,10 +85,11 @@ int vega20_baco_set_state(struct pp_hwmgr *hwmgr, enum BACO_STATE state)
 		return 0;
 
 	if (state == BACO_STATE_IN) {
-		data = RREG32_SOC15(THM, 0, mmTHM_BACO_CNTL);
-		data |= 0x80000000;
-		WREG32_SOC15(THM, 0, mmTHM_BACO_CNTL, data);
-
+		if (!ras || !ras->supported) {
+			data = RREG32_SOC15(THM, 0, mmTHM_BACO_CNTL);
+			data |= 0x80000000;
+			WREG32_SOC15(THM, 0, mmTHM_BACO_CNTL, data);
+		}
 
 		if(smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_EnterBaco, 0))
 			return -EINVAL;
-- 
2.20.1

