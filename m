Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9F826B459
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgIOXWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbgIOOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 266D322483;
        Tue, 15 Sep 2020 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180091;
        bh=8kycOnijtKMCdBXwR4QpnHqk7Dod/fZM4Wcf0Qe0JoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMEBsELZfj9bv/DpnyKgKRwR1pGJbbLhl45Flxag4tAyumD4LCVXa14CL/YLU3Wta
         aLKMFK9p9runDGnt0Re1vWL4ljCAI3zd2T7gCyzuQwYF4gTOxVFQ9Mac4XcwAxvjhT
         3S/Ohy81e6lOqcc1gtmcukza6tETroX4ERWKo438=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 105/177] drm/amdgpu: Fix bug in reporting voltage for CIK
Date:   Tue, 15 Sep 2020 16:12:56 +0200
Message-Id: <20200915140658.683379384@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Raghuraman <sandy.8925@gmail.com>

[ Upstream commit d98299885c9ea140c1108545186593deba36c4ac ]

On my R9 390, the voltage was reported as a constant 1000 mV.
This was due to a bug in smu7_hwmgr.c, in the smu7_read_sensor()
function, where some magic constants were used in a condition,
to determine whether the voltage should be read from PLANE2_VID
or PLANE1_VID. The VDDC mask was incorrectly used, instead of
the VDDGFX mask.

This patch changes the code to use the correct defined constants
(and apply the correct bitshift), thus resulting in correct voltage reporting.

Signed-off-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
index 753cb2cf6b77e..3adf9c1dfdbb0 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -3587,7 +3587,8 @@ static int smu7_read_sensor(struct pp_hwmgr *hwmgr, int idx,
 	case AMDGPU_PP_SENSOR_GPU_POWER:
 		return smu7_get_gpu_power(hwmgr, (uint32_t *)value);
 	case AMDGPU_PP_SENSOR_VDDGFX:
-		if ((data->vr_config & 0xff) == 0x2)
+		if ((data->vr_config & VRCONF_VDDGFX_MASK) ==
+		    (VR_SVI2_PLANE_2 << VRCONF_VDDGFX_SHIFT))
 			val_vid = PHM_READ_INDIRECT_FIELD(hwmgr->device,
 					CGS_IND_REG__SMC, PWR_SVI2_STATUS, PLANE2_VID);
 		else
-- 
2.25.1



