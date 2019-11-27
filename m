Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1566110BDA4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfK0Uzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730654AbfK0Uzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68A720862;
        Wed, 27 Nov 2019 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888134;
        bh=ocDDI6UNN/IZnta24ouw3SRUvHXXUlZZoHZJyZBfJQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skyNc9WX+1tmjgIwkw+er6UvUTKp2g54ypsDA7hU0iZR2ToVYNOpIoFHNDpljOHnv
         9mGQNHhN8qqJw39ls/PPxSANRe3fM1wDO6zGZVXA5W0ZyPe/RlKBmi3G12SYdqBU+z
         +oWfGkXprFCI74qlc67FESCfHKMUIwF+R+SniOy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 018/306] drm/amd/powerplay: issue no PPSMC_MSG_GetCurrPkgPwr on unsupported ASICs
Date:   Wed, 27 Nov 2019 21:27:48 +0100
Message-Id: <20191127203116.029122590@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 355d991cb6ff6ae76b5e28b8edae144124c730e4 upstream.

Otherwise, the error message prompted will confuse user.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -3472,18 +3472,31 @@ static int smu7_get_pp_table_entry(struc
 
 static int smu7_get_gpu_power(struct pp_hwmgr *hwmgr, u32 *query)
 {
+	struct amdgpu_device *adev = hwmgr->adev;
 	int i;
 	u32 tmp = 0;
 
 	if (!query)
 		return -EINVAL;
 
-	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_GetCurrPkgPwr, 0);
-	tmp = cgs_read_register(hwmgr->device, mmSMC_MSG_ARG_0);
-	*query = tmp;
+	/*
+	 * PPSMC_MSG_GetCurrPkgPwr is not supported on:
+	 *  - Hawaii
+	 *  - Bonaire
+	 *  - Fiji
+	 *  - Tonga
+	 */
+	if ((adev->asic_type != CHIP_HAWAII) &&
+	    (adev->asic_type != CHIP_BONAIRE) &&
+	    (adev->asic_type != CHIP_FIJI) &&
+	    (adev->asic_type != CHIP_TONGA)) {
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_GetCurrPkgPwr, 0);
+		tmp = cgs_read_register(hwmgr->device, mmSMC_MSG_ARG_0);
+		*query = tmp;
 
-	if (tmp != 0)
-		return 0;
+		if (tmp != 0)
+			return 0;
+	}
 
 	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_PmStatusLogStart);
 	cgs_write_ind_register(hwmgr->device, CGS_IND_REG__SMC,


