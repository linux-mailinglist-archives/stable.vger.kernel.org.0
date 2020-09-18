Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F09926F161
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbgIRCux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgIRCIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A89F4239D1;
        Fri, 18 Sep 2020 02:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394909;
        bh=9bhT+d2wplmQhS13aydpn+rwKaCtCinfXPFFZPyzACM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00HVCMF/9iW68L+fyasIJTLodXY5qDkOMG4GHwsq1awdzYB6WAxNkFlaQNOzFI8IC
         S8TG9koasXtQwzs05hWlmoi+PE+biS5L3kNOyB4/taCd0jF/EojJmeZP/6wgMSY5z8
         /xiOmGpfsDjMgjto0ZsY1vBfInN1St0aOySUz5fE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 022/206] drm/amdgpu/powerplay/smu7: fix AVFS handling with custom powerplay table
Date:   Thu, 17 Sep 2020 22:04:58 -0400
Message-Id: <20200918020802.2065198-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 901245624c7812b6c95d67177bae850e783b5212 ]

When a custom powerplay table is provided, we need to update
the OD VDDC flag to avoid AVFS being enabled when it shouldn't be.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=205393
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
index 219440bebd052..420f7d15511a7 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -3969,6 +3969,13 @@ static int smu7_set_power_state_tasks(struct pp_hwmgr *hwmgr, const void *input)
 			"Failed to populate and upload SCLK MCLK DPM levels!",
 			result = tmp_result);
 
+	/*
+	 * If a custom pp table is loaded, set DPMTABLE_OD_UPDATE_VDDC flag.
+	 * That effectively disables AVFS feature.
+	 */
+	if (hwmgr->hardcode_pp_table != NULL)
+		data->need_update_smu7_dpm_table |= DPMTABLE_OD_UPDATE_VDDC;
+
 	tmp_result = smu7_update_avfs(hwmgr);
 	PP_ASSERT_WITH_CODE((0 == tmp_result),
 			"Failed to update avfs voltages!",
-- 
2.25.1

