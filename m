Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08D27CA36
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbgI2MRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730032AbgI2Lg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB3FC23AC4;
        Tue, 29 Sep 2020 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379146;
        bh=QJ2dpRTbPRNUbz7iVhxRcALpzJs8tArsFex247QhvQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/vWFF0vwbKdtc4aALll5+KFA5cPmo9npo4oqDmcz569a2vm6AIpXsxBMuG8kg/5K
         U0A6y0WFZtuE2gNNGFa1b0fmTasWxG3Fm0JrM9odWvL7t7EPa8zJQorV0dWDi3mBM2
         r/ZGLTh4DuwFEGo2BztgVRKzfHJfyUsc1yK42ZLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/388] drm/amdgpu/powerplay: fix AVFS handling with custom powerplay table
Date:   Tue, 29 Sep 2020 12:56:05 +0200
Message-Id: <20200929110012.144241359@linuxfoundation.org>
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

[ Upstream commit 53dbc27ad5a93932ff1892a8e4ef266827d74a0f ]

When a custom powerplay table is provided, we need to update
the OD VDDC flag to avoid AVFS being enabled when it shouldn't be.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=205393
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
index beacfffbdc3eb..ecbc9daea57e0 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
@@ -3691,6 +3691,13 @@ static int vega10_set_power_state_tasks(struct pp_hwmgr *hwmgr,
 	PP_ASSERT_WITH_CODE(!result,
 			"Failed to upload PPtable!", return result);
 
+	/*
+	 * If a custom pp table is loaded, set DPMTABLE_OD_UPDATE_VDDC flag.
+	 * That effectively disables AVFS feature.
+	 */
+	if(hwmgr->hardcode_pp_table != NULL)
+		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_VDDC;
+
 	vega10_update_avfs(hwmgr);
 
 	/*
-- 
2.25.1



