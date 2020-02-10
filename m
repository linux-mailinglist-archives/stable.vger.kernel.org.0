Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EDA157704
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgBJMla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730000AbgBJMl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 867DC20842;
        Mon, 10 Feb 2020 12:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338488;
        bh=0vq2kS/1aKSZySkCd5fCE2XXIeRVuYok2HKEr1zKOSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+O30vf/hIyAVIAng9MVYcQB3pNXnnEiTHCN+AOV1Np9qbJgvQq3Ex8nzWZhB9RE8
         2WQV0wksZIVaPa0sv94bGh1dYb1i92tKtBI+Ke4kaCiZGMfRkMYpfOj/EzT3KNY/7H
         coMCwisYFEjz0W5G+/Xp7XFqHmiZ5GMdDdkTnFZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 271/367] drm/amdgpu: fetch default VDDC curve voltages (v2)
Date:   Mon, 10 Feb 2020 04:33:04 -0800
Message-Id: <20200210122449.312793604@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 0531aa6eb38bfa9514609e2727558a051da7365f upstream.

Ask the SMU for the default VDDC curve voltage values.  This
properly reports the VDDC values in the OD interface.

v2: only update if the original values are 0

Bug: https://gitlab.freedesktop.org/drm/amd/issues/1020
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.5.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c |   50 ++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -121,6 +121,8 @@ static struct smu_11_0_cmn2aisc_mapping
 	MSG_MAP(ArmD3,			PPSMC_MSG_ArmD3),
 	MSG_MAP(DAL_DISABLE_DUMMY_PSTATE_CHANGE,PPSMC_MSG_DALDisableDummyPstateChange),
 	MSG_MAP(DAL_ENABLE_DUMMY_PSTATE_CHANGE,	PPSMC_MSG_DALEnableDummyPstateChange),
+	MSG_MAP(GetVoltageByDpm,		     PPSMC_MSG_GetVoltageByDpm),
+	MSG_MAP(GetVoltageByDpmOverdrive,	     PPSMC_MSG_GetVoltageByDpmOverdrive),
 };
 
 static struct smu_11_0_cmn2aisc_mapping navi10_clk_map[SMU_CLK_COUNT] = {
@@ -1782,6 +1784,28 @@ static int navi10_od_setting_check_range
 	return 0;
 }
 
+static int navi10_overdrive_get_gfx_clk_base_voltage(struct smu_context *smu,
+						     uint16_t *voltage,
+						     uint32_t freq)
+{
+	uint32_t param = (freq & 0xFFFF) | (PPCLK_GFXCLK << 16);
+	uint32_t value = 0;
+	int ret;
+
+	ret = smu_send_smc_msg_with_param(smu,
+					  SMU_MSG_GetVoltageByDpm,
+					  param);
+	if (ret) {
+		pr_err("[GetBaseVoltage] failed to get GFXCLK AVFS voltage from SMU!");
+		return ret;
+	}
+
+	smu_read_smc_arg(smu, &value);
+	*voltage = (uint16_t)value;
+
+	return 0;
+}
+
 static int navi10_setup_od_limits(struct smu_context *smu) {
 	struct smu_11_0_overdrive_table *overdrive_table = NULL;
 	struct smu_11_0_powerplay_table *powerplay_table = NULL;
@@ -1808,16 +1832,40 @@ static int navi10_set_default_od_setting
 	if (ret)
 		return ret;
 
+	od_table = (OverDriveTable_t *)smu->smu_table.overdrive_table;
 	if (initialize) {
 		ret = navi10_setup_od_limits(smu);
 		if (ret) {
 			pr_err("Failed to retrieve board OD limits\n");
 			return ret;
 		}
+		if (od_table) {
+			if (!od_table->GfxclkVolt1) {
+				ret = navi10_overdrive_get_gfx_clk_base_voltage(smu,
+										&od_table->GfxclkVolt1,
+										od_table->GfxclkFreq1);
+				if (ret)
+					od_table->GfxclkVolt1 = 0;
+			}
+
+			if (!od_table->GfxclkVolt2) {
+				ret = navi10_overdrive_get_gfx_clk_base_voltage(smu,
+										&od_table->GfxclkVolt2,
+										od_table->GfxclkFreq2);
+				if (ret)
+					od_table->GfxclkVolt2 = 0;
+			}
 
+			if (!od_table->GfxclkVolt3) {
+				ret = navi10_overdrive_get_gfx_clk_base_voltage(smu,
+										&od_table->GfxclkVolt3,
+										od_table->GfxclkFreq3);
+				if (ret)
+					od_table->GfxclkVolt3 = 0;
+			}
+		}
 	}
 
-	od_table = (OverDriveTable_t *)smu->smu_table.overdrive_table;
 	if (od_table) {
 		navi10_dump_od_table(od_table);
 	}


