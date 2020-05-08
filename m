Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3CE1CAD74
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEHMvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729601AbgEHMvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:51:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15663218AC;
        Fri,  8 May 2020 12:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942267;
        bh=zTXCidyF3h1FOA71xWqDYf/8fU7YbPSRgGWTDwl3/IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+tw2k3knGKz2n8fiCh7wpwWUp5hr0zO71/4EVzmSsu4tSYsH3whwOD9aRdyfFPs+
         hkCH/uQPmSQ2Y3rdfUBUOjyD92p6hKnkkWFqk0NF+9FKZ7gtPDChu+2nyrDL/1yhNV
         kWbouCsGGW7HGapUWzc4Qya/hM/GiqrzDefWfAL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/32] drm/amdgpu: Correctly initialize thermal controller for GPUs with Powerplay table v0 (e.g Hawaii)
Date:   Fri,  8 May 2020 14:35:23 +0200
Message-Id: <20200508123036.210403530@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Raghuraman <sandy.8925@gmail.com>

[ Upstream commit bbc25dadc7ed19f9d6b2e30980f0eb4c741bb8bf ]

Initialize thermal controller fields in the PowerPlay table for Hawaii
GPUs, so that fan speeds are reported.

Signed-off-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/powerplay/hwmgr/processpptables.c | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c b/drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c
index 925e17104f909..b9e08b06ed5db 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c
@@ -983,6 +983,32 @@ static int init_thermal_controller(
 			struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
+	hwmgr->thermal_controller.ucType =
+			powerplay_table->sThermalController.ucType;
+	hwmgr->thermal_controller.ucI2cLine =
+			powerplay_table->sThermalController.ucI2cLine;
+	hwmgr->thermal_controller.ucI2cAddress =
+			powerplay_table->sThermalController.ucI2cAddress;
+
+	hwmgr->thermal_controller.fanInfo.bNoFan =
+		(0 != (powerplay_table->sThermalController.ucFanParameters &
+			ATOM_PP_FANPARAMETERS_NOFAN));
+
+	hwmgr->thermal_controller.fanInfo.ucTachometerPulsesPerRevolution =
+		powerplay_table->sThermalController.ucFanParameters &
+		ATOM_PP_FANPARAMETERS_TACHOMETER_PULSES_PER_REVOLUTION_MASK;
+
+	hwmgr->thermal_controller.fanInfo.ulMinRPM
+		= powerplay_table->sThermalController.ucFanMinRPM * 100UL;
+	hwmgr->thermal_controller.fanInfo.ulMaxRPM
+		= powerplay_table->sThermalController.ucFanMaxRPM * 100UL;
+
+	set_hw_cap(hwmgr,
+		   ATOM_PP_THERMALCONTROLLER_NONE != hwmgr->thermal_controller.ucType,
+		   PHM_PlatformCaps_ThermalController);
+
+	hwmgr->thermal_controller.use_hw_fan_control = 1;
+
 	return 0;
 }
 
-- 
2.20.1



