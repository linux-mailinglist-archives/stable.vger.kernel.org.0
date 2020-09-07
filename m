Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69147260144
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgIGRCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgIGQdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D34921973;
        Mon,  7 Sep 2020 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496404;
        bh=8kycOnijtKMCdBXwR4QpnHqk7Dod/fZM4Wcf0Qe0JoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnWtiEb1rhYq082a7KvVqdpAHo6aqnYgZ/zkdFX7xEyJ3koQnwFB37GbxOVco6syW
         eXJ5Q962l9KOw/xqUwRjGOC7GoJhqbC3yYJ2qc10QztFgJ/a8ebM7GJo/K2swzkoFJ
         ZYVp7Lq4nrc6k3NwlKJWQnA/rNNPmqg4A6+iUyPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 50/53] drm/amdgpu: Fix bug in reporting voltage for CIK
Date:   Mon,  7 Sep 2020 12:32:16 -0400
Message-Id: <20200907163220.1280412-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

