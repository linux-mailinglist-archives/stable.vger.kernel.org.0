Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A2A15F3C1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394156AbgBNSO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730936AbgBNPwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9E62465D;
        Fri, 14 Feb 2020 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695529;
        bh=AUo48LgyP8RWnDvSGBmcafXJf9lcho+MKL72AlZgYbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueRx3/bJqCzz8uvcAFi90fkiFjd1IiZOKvH3MiUOPdPEh8Amip0Drui1Ugw22/kAS
         1ylqe898Ne1m8+Pe2pLPiqQJb5ks+JXPBTKs9MJZEzx4S4joIZye3T4FFT91dMUpi0
         Mz/g7gFxH1O5RSqK60W6k0UTbLiZXvswXPB2Pqus=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 150/542] drm/amd/powerplay: remove set but not used variable 'us_mvdd'
Date:   Fri, 14 Feb 2020 10:42:22 -0500
Message-Id: <20200214154854.6746-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 472b36a2ab67880e89d6b0cd0e243830e8cb75e1 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c: In
function ‘vegam_populate_smc_acpi_level’:
drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c:1117:11:
warning: variable 'us_mvdd' set but not used [-Wunused-but-set-variable]

It is never used, so can be removed.

Fixes: ac7822b0026f ("drm/amd/powerplay: add smumgr support for VEGAM (v2)")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
index ae18fbcb26fb1..2068eb00d2f8d 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
@@ -1114,7 +1114,6 @@ static int vegam_populate_smc_acpi_level(struct pp_hwmgr *hwmgr,
 			(struct phm_ppt_v1_information *)(hwmgr->pptable);
 	SMIO_Pattern vol_level;
 	uint32_t mvdd;
-	uint16_t us_mvdd;
 
 	table->ACPILevel.Flags &= ~PPSMC_SWSTATE_FLAG_DC;
 
@@ -1168,17 +1167,6 @@ static int vegam_populate_smc_acpi_level(struct pp_hwmgr *hwmgr,
 			"in Clock Dependency Table",
 			);
 
-	us_mvdd = 0;
-	if ((SMU7_VOLTAGE_CONTROL_NONE == data->mvdd_control) ||
-			(data->mclk_dpm_key_disabled))
-		us_mvdd = data->vbios_boot_state.mvdd_bootup_value;
-	else {
-		if (!vegam_populate_mvdd_value(hwmgr,
-				data->dpm_table.mclk_table.dpm_levels[0].value,
-				&vol_level))
-			us_mvdd = vol_level.Voltage;
-	}
-
 	if (!vegam_populate_mvdd_value(hwmgr, 0, &vol_level))
 		table->MemoryACPILevel.MinMvdd = PP_HOST_TO_SMC_UL(vol_level.Voltage);
 	else
-- 
2.20.1

