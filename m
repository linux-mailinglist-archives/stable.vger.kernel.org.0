Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3235A259AB1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbgIAQwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgIAPZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:25:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C53214D8;
        Tue,  1 Sep 2020 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973935;
        bh=k36O4RMLBdcTwR3dWHVSsB8aYcfmLNDLUKpuTHOopcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTOgkEuoBbylOHK/mT2Wig4I/OQGi3wygsluNZTNcz20lIp/xpPldsg0Nfqu7aRDK
         Hsjby+ClKfAZI13V1VBkIe78B7kspXGk2T+k9qc+vunuVAdfK5dQqKBQQRciBk8hrv
         kONA4lXf+io2XfnG9VEkBeF+mFMMvROg+BJZpQyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 106/125] drm/amd/pm: correct Vega10 swctf limit setting
Date:   Tue,  1 Sep 2020 17:11:01 +0200
Message-Id: <20200901150939.809238914@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit b05d71b51078fc428c6b72582126d9d75d3c1f4c upstream.

Correct the Vega10 thermal swctf limit.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1267

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
@@ -362,6 +362,9 @@ int vega10_thermal_get_temperature(struc
 static int vega10_thermal_set_temperature_range(struct pp_hwmgr *hwmgr,
 		struct PP_TemperatureRange *range)
 {
+	struct phm_ppt_v2_information *pp_table_info =
+		(struct phm_ppt_v2_information *)(hwmgr->pptable);
+	struct phm_tdp_table *tdp_table = pp_table_info->tdp_table;
 	struct amdgpu_device *adev = hwmgr->adev;
 	int low = VEGA10_THERMAL_MINIMUM_ALERT_TEMP *
 			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
@@ -371,8 +374,8 @@ static int vega10_thermal_set_temperatur
 
 	if (low < range->min)
 		low = range->min;
-	if (high > range->max)
-		high = range->max;
+	if (high > tdp_table->usSoftwareShutdownTemp)
+		high = tdp_table->usSoftwareShutdownTemp;
 
 	if (low > high)
 		return -EINVAL;


