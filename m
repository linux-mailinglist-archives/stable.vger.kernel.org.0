Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2993A15E84C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404122AbgBNQ7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388995AbgBNQQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:16:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB03F24685;
        Fri, 14 Feb 2020 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697015;
        bh=kpxSpiOredmCdN9Q0Stfhh2Dls3j079H4/egN8JsXU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ+zg4YzJyBbH86kvsn/w24tXyfsCMqTecuS0FSvZ4Be0Fv1D+DpiZEslTGVMU1i3
         /oQy6pHaFXTiQKEoFEUSVIVb4stiQY7/rgJHCCb00aI09dlRPu16gDo5pS8cyMMyz1
         pTv1yLzZKd63fpBSVQnWcj4lYLJ+YJiXFINtqURY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 245/252] drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency
Date:   Fri, 14 Feb 2020 11:11:40 -0500
Message-Id: <20200214161147.15842-245-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4d0a72b66065dd7e274bad6aa450196d42fd8f84 ]

Only send non-0 clocks to DC for validation.  This mirrors
what the windows driver does.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/963
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
index 1546bc49004f8..3fa6e8123b8eb 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
@@ -994,12 +994,15 @@ static int smu10_get_clock_by_type_with_latency(struct pp_hwmgr *hwmgr,
 
 	clocks->num_levels = 0;
 	for (i = 0; i < pclk_vol_table->count; i++) {
-		clocks->data[i].clocks_in_khz = pclk_vol_table->entries[i].clk * 10;
-		clocks->data[i].latency_in_us = latency_required ?
-						smu10_get_mem_latency(hwmgr,
-						pclk_vol_table->entries[i].clk) :
-						0;
-		clocks->num_levels++;
+		if (pclk_vol_table->entries[i].clk) {
+			clocks->data[clocks->num_levels].clocks_in_khz =
+				pclk_vol_table->entries[i].clk * 10;
+			clocks->data[clocks->num_levels].latency_in_us = latency_required ?
+				smu10_get_mem_latency(hwmgr,
+						      pclk_vol_table->entries[i].clk) :
+				0;
+			clocks->num_levels++;
+		}
 	}
 
 	return 0;
-- 
2.20.1

