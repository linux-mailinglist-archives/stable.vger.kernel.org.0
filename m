Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBC025951F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbgIAPqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgIAPqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1DD6206EB;
        Tue,  1 Sep 2020 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975209;
        bh=Rptk1Xr/i1mh7PCjNKOz/jMaOofjYdm3n/f8/41ctsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZ5UfMoM43ijvp9DicEb9gG7kLKBrUOOaPqZ2sse3pLJ3+hrY7MWHN5kjE8YING9T
         gobtlSSfiPgcOXpITZuTon6iy9Z8fW8rBolEu+hp9KygJlmqJgt3kpiuT7x7VpfJRK
         fZw8dAXGFaqFlr1Vp2IzuVgu/GQee8V7TIzV7mAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 221/255] drm/amd/pm: correct the thermal alert temperature limit settings
Date:   Tue,  1 Sep 2020 17:11:17 +0200
Message-Id: <20200901151011.294140790@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 28e628645333b7e581c4a7b04d958e4804ea10fe upstream.

Do the maths in celsius degree. This can fix the issues caused
by the changes below:

drm/amd/pm: correct Vega20 swctf limit setting
drm/amd/pm: correct Vega12 swctf limit setting
drm/amd/pm: correct Vega10 swctf limit setting

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c |   15 +++++++--------
 drivers/gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c |   15 +++++++--------
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c |   15 +++++++--------
 3 files changed, 21 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
@@ -367,14 +367,13 @@ static int vega10_thermal_set_temperatur
 		(struct phm_ppt_v2_information *)(hwmgr->pptable);
 	struct phm_tdp_table *tdp_table = pp_table_info->tdp_table;
 	struct amdgpu_device *adev = hwmgr->adev;
-	int low = VEGA10_THERMAL_MINIMUM_ALERT_TEMP *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
-	int high = VEGA10_THERMAL_MAXIMUM_ALERT_TEMP *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+	int low = VEGA10_THERMAL_MINIMUM_ALERT_TEMP;
+	int high = VEGA10_THERMAL_MAXIMUM_ALERT_TEMP;
 	uint32_t val;
 
-	if (low < range->min)
-		low = range->min;
+	/* compare them in unit celsius degree */
+	if (low < range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES)
+		low = range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	if (high > tdp_table->usSoftwareShutdownTemp)
 		high = tdp_table->usSoftwareShutdownTemp;
 
@@ -385,8 +384,8 @@ static int vega10_thermal_set_temperatur
 
 	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, MAX_IH_CREDIT, 5);
 	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, THERM_IH_HW_ENA, 1);
-	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTH, (high / PP_TEMPERATURE_UNITS_PER_CENTIGRADES));
-	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTL, (low / PP_TEMPERATURE_UNITS_PER_CENTIGRADES));
+	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTH, high);
+	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTL, low);
 	val &= (~THM_THERMAL_INT_CTRL__THERM_TRIGGER_MASK_MASK) &
 			(~THM_THERMAL_INT_CTRL__THERM_INTH_MASK_MASK) &
 			(~THM_THERMAL_INT_CTRL__THERM_INTL_MASK_MASK);
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c
@@ -173,14 +173,13 @@ static int vega12_thermal_set_temperatur
 	struct phm_ppt_v3_information *pptable_information =
 		(struct phm_ppt_v3_information *)hwmgr->pptable;
 	struct amdgpu_device *adev = hwmgr->adev;
-	int low = VEGA12_THERMAL_MINIMUM_ALERT_TEMP *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
-	int high = VEGA12_THERMAL_MAXIMUM_ALERT_TEMP *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+	int low = VEGA12_THERMAL_MINIMUM_ALERT_TEMP;
+	int high = VEGA12_THERMAL_MAXIMUM_ALERT_TEMP;
 	uint32_t val;
 
-	if (low < range->min)
-		low = range->min;
+	/* compare them in unit celsius degree */
+	if (low < range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES)
+		low = range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	if (high > pptable_information->us_software_shutdown_temp)
 		high = pptable_information->us_software_shutdown_temp;
 
@@ -191,8 +190,8 @@ static int vega12_thermal_set_temperatur
 
 	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, MAX_IH_CREDIT, 5);
 	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, THERM_IH_HW_ENA, 1);
-	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTH, (high / PP_TEMPERATURE_UNITS_PER_CENTIGRADES));
-	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTL, (low / PP_TEMPERATURE_UNITS_PER_CENTIGRADES));
+	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTH, high);
+	val = REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTL, low);
 	val = val & (~THM_THERMAL_INT_CTRL__THERM_TRIGGER_MASK_MASK);
 
 	WREG32_SOC15(THM, 0, mmTHM_THERMAL_INT_CTRL, val);
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
@@ -243,14 +243,13 @@ static int vega20_thermal_set_temperatur
 	struct phm_ppt_v3_information *pptable_information =
 		(struct phm_ppt_v3_information *)hwmgr->pptable;
 	struct amdgpu_device *adev = hwmgr->adev;
-	int low = VEGA20_THERMAL_MINIMUM_ALERT_TEMP *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
-	int high = VEGA20_THERMAL_MAXIMUM_ALERT_TEMP *
-			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+	int low = VEGA20_THERMAL_MINIMUM_ALERT_TEMP;
+	int high = VEGA20_THERMAL_MAXIMUM_ALERT_TEMP;
 	uint32_t val;
 
-	if (low < range->min)
-		low = range->min;
+	/* compare them in unit celsius degree */
+	if (low < range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES)
+		low = range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	if (high > pptable_information->us_software_shutdown_temp)
 		high = pptable_information->us_software_shutdown_temp;
 
@@ -261,8 +260,8 @@ static int vega20_thermal_set_temperatur
 
 	val = CGS_REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, MAX_IH_CREDIT, 5);
 	val = CGS_REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, THERM_IH_HW_ENA, 1);
-	val = CGS_REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTH, (high / PP_TEMPERATURE_UNITS_PER_CENTIGRADES));
-	val = CGS_REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTL, (low / PP_TEMPERATURE_UNITS_PER_CENTIGRADES));
+	val = CGS_REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTH, high);
+	val = CGS_REG_SET_FIELD(val, THM_THERMAL_INT_CTRL, DIG_THERM_INTL, low);
 	val = val & (~THM_THERMAL_INT_CTRL__THERM_TRIGGER_MASK_MASK);
 
 	WREG32_SOC15(THM, 0, mmTHM_THERMAL_INT_CTRL, val);


