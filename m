Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9B63DF2A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiK3Son (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiK3SoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC9B99F58
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22637B81CA8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810E6C433D6;
        Wed, 30 Nov 2022 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833848;
        bh=gGLteT8K6TxzFC9zMhFubn3DVHcCYF7LsJcYHZfDbXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFfoT9dWuAWuP1hkgDLYmLDsw8jei3ohewsaV5LPkt3FpwF/DF/CyTrBdMoHPdTJO
         1k+NiSgNHlFaXIVHohxHJd17/2YwnoAaYbFkSX+aIsmaZZLOf/xsiBi1QTYRQohwH7
         ++ERDT38nJj/zQpCW7vvvmIXt3DKQQsQw+YRAc4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Asher Song <Asher.Song@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 037/289] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""
Date:   Wed, 30 Nov 2022 19:20:22 +0100
Message-Id: <20221130180544.973962153@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit 30b8e7b8ee3be003e0df85c857c5cd0e0bd58b82 ]

This reverts commit 4545ae2ed3f2f7c3f615a53399c9c8460ee5bca7.

The origin patch "drm/amdgpu: getting fan speed pwm for vega10 properly" works fine.
Test failure is caused by test case self.

Signed-off-by: Asher Song <Asher.Song@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/pm/powerplay/hwmgr/vega10_thermal.c   | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
index dad3e3741a4e..190af79f3236 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -67,22 +67,21 @@ int vega10_fan_ctrl_get_fan_speed_info(struct pp_hwmgr *hwmgr,
 int vega10_fan_ctrl_get_fan_speed_pwm(struct pp_hwmgr *hwmgr,
 		uint32_t *speed)
 {
-	uint32_t current_rpm;
-	uint32_t percent = 0;
-
-	if (hwmgr->thermal_controller.fanInfo.bNoFan)
-		return 0;
+	struct amdgpu_device *adev = hwmgr->adev;
+	uint32_t duty100, duty;
+	uint64_t tmp64;
 
-	if (vega10_get_current_rpm(hwmgr, &current_rpm))
-		return -1;
+	duty100 = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
+				CG_FDO_CTRL1, FMAX_DUTY100);
+	duty = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_THERMAL_STATUS),
+				CG_THERMAL_STATUS, FDO_PWM_DUTY);
 
-	if (hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM != 0)
-		percent = current_rpm * 255 /
-			hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM;
+	if (!duty100)
+		return -EINVAL;
 
-	*speed = MIN(percent, 255);
+	tmp64 = (uint64_t)duty * 255;
+	do_div(tmp64, duty100);
+	*speed = MIN((uint32_t)tmp64, 255);
 
 	return 0;
 }
-- 
2.35.1



