Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E474112C964
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731573AbfL2SHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731522AbfL2RtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D7EC21D7E;
        Sun, 29 Dec 2019 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641739;
        bh=hJItlzR6r1zQpzAUfVdeiYUkKcPcdYJDurcZKr2/nW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nABFooWhyK+9sjOJZ72levMRVakq1yhVkDqNU3hdPhFmClKrQRKJmYPIQmPQWQxWA
         nhsJccqmxreyiU6Znp1ncc8RBS4JLu5bYLUkRj80amT+HM59vwLFw/Xv6YHk1CUwHZ
         bLRUyBS+UWydj4TMmqQuk12sG9r02WqlCtBZ/V1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Le Ma <le.ma@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/434] drm/amd/powerplay: avoid disabling ECC if RAS is enabled for VEGA20
Date:   Sun, 29 Dec 2019 18:23:23 +0100
Message-Id: <20191229172711.717520140@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df6ff9252401..b068d1c7b44d 100644
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



