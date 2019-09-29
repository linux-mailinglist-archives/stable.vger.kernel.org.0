Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27AEEC15A7
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfI2N7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbfI2N7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C697821882;
        Sun, 29 Sep 2019 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765563;
        bh=D637BfuFhvKzDJBqTN3H+D/yVwkIDylpZHe7eDje37I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1q7rwG+wuhTbMT+xzAwtzhTJZVkfVc6p+pYCBWd3KJ+9ra9dpVIuAiDQG1ONDJ9u
         7FVPoTs5Tpzcty3wUjcA0MQO1kIlnw5WKRaiizGxFLwpyTzxDGxENG9kwGPDB3pGmo
         YfMzrfXmmyr7b4y8aHgtrsf4npqOOp9os+KRGe9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        suresh guttula <suresh.guttula@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/63] Revert "drm/amd/powerplay: Enable/Disable NBPSTATE on On/OFF of UVD"
Date:   Sun, 29 Sep 2019 15:54:14 +0200
Message-Id: <20190929135039.083030953@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <shirish.s@amd.com>

[ Upstream commit 00fedbe629bfc0a51c07b6e665265ce31d8b6f3c ]

This reverts commit dbd8299c32f6f413f6cfe322fe0308f3cfc577e8.

Reason for revert:
This patch sends  msg PPSMC_MSG_DisableLowMemoryPstate(0x002e)
in wrong of sequence to SMU which is before PPSMC_MSG_UVDPowerON (0x0008).
This leads to SMU failing to service the request as it is
dependent on UVD to be powered ON, since it accesses UVD
registers.

This msg should ideally be sent only when the UVD is about to decode
a 4k video.

Signed-off-by: Shirish S <shirish.s@amd.com>
Signed-off-by: suresh guttula <suresh.guttula@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c
index c9a15baf2c10f..0adfc5392cd37 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu8_hwmgr.c
@@ -1222,17 +1222,14 @@ static int smu8_dpm_force_dpm_level(struct pp_hwmgr *hwmgr,
 
 static int smu8_dpm_powerdown_uvd(struct pp_hwmgr *hwmgr)
 {
-	if (PP_CAP(PHM_PlatformCaps_UVDPowerGating)) {
-		smu8_nbdpm_pstate_enable_disable(hwmgr, true, true);
+	if (PP_CAP(PHM_PlatformCaps_UVDPowerGating))
 		return smum_send_msg_to_smc(hwmgr, PPSMC_MSG_UVDPowerOFF);
-	}
 	return 0;
 }
 
 static int smu8_dpm_powerup_uvd(struct pp_hwmgr *hwmgr)
 {
 	if (PP_CAP(PHM_PlatformCaps_UVDPowerGating)) {
-		smu8_nbdpm_pstate_enable_disable(hwmgr, false, true);
 		return smum_send_msg_to_smc_with_parameter(
 			hwmgr,
 			PPSMC_MSG_UVDPowerON,
-- 
2.20.1



