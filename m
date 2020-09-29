Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467E327CA2C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgI2MRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730040AbgI2LhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB0F23AFA;
        Tue, 29 Sep 2020 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379155;
        bh=s1S85SKamIhAe34DUzJjRHC6BhjlZfVzIf0xrICYwJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuMiMzKczeN1Q0NmPoHs101O4GtVqkPWZzOSanxnAZ7xyQNJBeeThRcSF+h5ZuRQP
         QB4wU973o3dSkGGDWFof5/8Bd4OmpFR4waS0Q9C6vh5Cs5y/TvyDz+T3CX+lQT2u5o
         ge1S2Qzxll4MXdVIbOoywFIBgmwjIlsnfekilWBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/388] drm/amdgpu/powerplay/smu7: fix AVFS handling with custom powerplay table
Date:   Tue, 29 Sep 2020 12:56:09 +0200
Message-Id: <20200929110012.337880060@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3a2a1dc9a786a..1b55f037ba4a7 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -3987,6 +3987,13 @@ static int smu7_set_power_state_tasks(struct pp_hwmgr *hwmgr, const void *input)
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



