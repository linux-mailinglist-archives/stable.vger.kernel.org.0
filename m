Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BF4657BEE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiL1P1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiL1P04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9886140E0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 574A9B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F05C433D2;
        Wed, 28 Dec 2022 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241213;
        bh=q58oHnqTAJvcpqhxNBqidEHXhKJKrJZVu61pyeE87N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtDrP2zWjdz7NZxIYOs4Ax+t7WdAnjCO5CYpH0MS0jlKdKfjhRCoH3DCuyHXLlOT7
         /OLX8lpjnVbuvFsJ17mGkDLkXAihWVvyk+ZYlhCaiwCHfuNJOEfTp7ILIYmeG0GPX0
         mjxduVmhks85jKeKDG0/iU4sgurQp2P1C7KQbO6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Asher Song <Asher.Song@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0220/1146] drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly"
Date:   Wed, 28 Dec 2022 15:29:19 +0100
Message-Id: <20221228144336.122160237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asher Song <Asher.Song@amd.com>

[ Upstream commit e5b781c56d46c44c52caa915f1b65064f2f7c1ba ]

This reverts commit 16fb4dca95daa9d8e037201166a58de8284f4268.

Unfortunately, that commit causes fan monitors can't be read and written
properly.

Fixes: 16fb4dca95daa9 ("drm/amdgpu: getting fan speed pwm for vega10 properly")
Signed-off-by: Asher Song <Asher.Song@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/pm/powerplay/hwmgr/vega10_thermal.c   | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
index 190af79f3236..dad3e3741a4e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -67,21 +67,22 @@ int vega10_fan_ctrl_get_fan_speed_info(struct pp_hwmgr *hwmgr,
 int vega10_fan_ctrl_get_fan_speed_pwm(struct pp_hwmgr *hwmgr,
 		uint32_t *speed)
 {
-	struct amdgpu_device *adev = hwmgr->adev;
-	uint32_t duty100, duty;
-	uint64_t tmp64;
+	uint32_t current_rpm;
+	uint32_t percent = 0;
 
-	duty100 = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
-				CG_FDO_CTRL1, FMAX_DUTY100);
-	duty = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_THERMAL_STATUS),
-				CG_THERMAL_STATUS, FDO_PWM_DUTY);
+	if (hwmgr->thermal_controller.fanInfo.bNoFan)
+		return 0;
 
-	if (!duty100)
-		return -EINVAL;
+	if (vega10_get_current_rpm(hwmgr, &current_rpm))
+		return -1;
+
+	if (hwmgr->thermal_controller.
+			advanceFanControlParameters.usMaxFanRPM != 0)
+		percent = current_rpm * 255 /
+			hwmgr->thermal_controller.
+			advanceFanControlParameters.usMaxFanRPM;
 
-	tmp64 = (uint64_t)duty * 255;
-	do_div(tmp64, duty100);
-	*speed = MIN((uint32_t)tmp64, 255);
+	*speed = MIN(percent, 255);
 
 	return 0;
 }
-- 
2.35.1



