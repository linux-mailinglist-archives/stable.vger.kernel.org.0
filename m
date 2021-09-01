Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F273FDB96
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245042AbhIAMm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344695AbhIAMkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4704761104;
        Wed,  1 Sep 2021 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499812;
        bh=hGpB3OYXSQsJAMtupy5tEoYQ9i3zYDhIn0ciJMdKmAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txafM0JFbvHWC3EksIhymZcSzwgLMC/jGaJd2YuHN1TSlhTIPVbyYNcjrHkP1RuKu
         dQRAUgs3CMeiw97kN+zgXISzWBTv4ugz6cVnFyu7IZUSEIrHha6iN8nbag3vgQ5yxP
         YSE5AYc7YPGA/X8KohGd53A/w3d1Pu+P+YLOPUxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/103] drm/amd/pm: change the workload type for some cards
Date:   Wed,  1 Sep 2021 14:28:15 +0200
Message-Id: <20210901122302.763926408@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 93c5701b00d50d192ce2247cb10d6c0b3fe25cd8 ]

change the workload type for some cards as it is needed.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index ed4eafc744d3..4dc27ec4d012 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5122,6 +5122,13 @@ static int vega10_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	return size;
 }
 
+static bool vega10_get_power_profile_mode_quirks(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = hwmgr->adev;
+
+	return (adev->pdev->device == 0x6860);
+}
+
 static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, uint32_t size)
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
@@ -5158,9 +5165,15 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	}
 
 out:
-	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
+	if (vega10_get_power_profile_mode_quirks(hwmgr))
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
 						1 << power_profile_mode,
 						NULL);
+	else
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
+						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
+						NULL);
+
 	hwmgr->power_profile_mode = power_profile_mode;
 
 	return 0;
-- 
2.30.2



