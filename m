Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3F466C485
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjAPP4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjAPPzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C40A22A1D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EB12B81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D002C433D2;
        Mon, 16 Jan 2023 15:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884539;
        bh=Jj6MQ75efzaAgKF++Bh9ywEV5w4ggG4Ie4cDj4Q9DKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KITqnlwrlpsGo34Wf6o30zCpkEYqQ0uGcxVAs3C3JCyTR0o6fQyd+ghjmnJo/KPv0
         rw2yfnmIwJPM9RrUMcPl+yOGIsg5gH6fNbk/NC4+aW+o3EKSVKAQL1pYGvuqnBz6kS
         50BtRSWsEaoidAbq5HBFIJ4emfHAv0ajIMa2j6CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        Yury Zhuravlev <stalkerg@gmail.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Asher Song <Asher.Song@amd.com>
Subject: [PATCH 6.1 037/183] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""
Date:   Mon, 16 Jan 2023 16:49:20 +0100
Message-Id: <20230116154804.941999148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 9ccd11718d76b95c69aa773f2abedef560776037

The original commit 16fb4dca95daa ("drm/amdgpu: getting fan speed pwm for vega10 properly")
was reverted in commit 4545ae2ed3f2 ("drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly"").
but the test that resulted in the revert was wrong and was fixed so the
revert was reverted in commit 30b8e7b8ee3b ("Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""").
That should have been the end of it, but then Sasha picked up the
original revert again and it was committed as 9ccd11718d76.  So drop
that commit so we get back to where we need to be.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org # 6.1.x
Cc: Yury Zhuravlev <stalkerg@gmail.com>
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Asher Song <Asher.Song@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c |   25 +++++++---------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -67,22 +67,21 @@ int vega10_fan_ctrl_get_fan_speed_info(s
 int vega10_fan_ctrl_get_fan_speed_pwm(struct pp_hwmgr *hwmgr,
 		uint32_t *speed)
 {
-	uint32_t current_rpm;
-	uint32_t percent = 0;
+	struct amdgpu_device *adev = hwmgr->adev;
+	uint32_t duty100, duty;
+	uint64_t tmp64;
 
-	if (hwmgr->thermal_controller.fanInfo.bNoFan)
-		return 0;
+	duty100 = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
+				CG_FDO_CTRL1, FMAX_DUTY100);
+	duty = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_THERMAL_STATUS),
+				CG_THERMAL_STATUS, FDO_PWM_DUTY);
 
-	if (vega10_get_current_rpm(hwmgr, &current_rpm))
-		return -1;
+	if (!duty100)
+		return -EINVAL;
 
-	if (hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM != 0)
-		percent = current_rpm * 255 /
-			hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM;
-
-	*speed = MIN(percent, 255);
+	tmp64 = (uint64_t)duty * 255;
+	do_div(tmp64, duty100);
+	*speed = MIN((uint32_t)tmp64, 255);
 
 	return 0;
 }


