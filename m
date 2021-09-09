Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986BB404AA5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbhIILrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240426AbhIILpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:45:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4421611CE;
        Thu,  9 Sep 2021 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187773;
        bh=WNI+MCurftRnG04/cAAncVCu0T2V7AVRB41i1UNH/r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiN7IlocnQMfOvg2xZoKcjwmX/n1QzGGRVzgr0Q/rBq3YIIoGhkZQatchfCnAC0Rv
         T71orvtkezfW/SeARaBzL88EfwBX4MOyJDhAHCKkKOtI//uWtETFD5TxEIUVs+TmcT
         N/+BmPZfZlfNM2W/D9kSvaXc+ySWi0Hs+2zckfLBWbM+KrDIcxiDDj5Dqhs4/1+gAq
         pGyfa17uQJhx6F6OzRe6Ho5Gf3iy37a7v77TK7REIKW80ZCFwxiMCvNLocHR6oB8CE
         0VA9Pd7rIlCMSkEqp7r5PStpAh7GB2+sLXIO7dAm3GBxI86UN3wc9ZErnrkRQrHTdM
         kp5E+WV0DShuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikita Lipski <mikita.lipski@amd.com>,
        Wood Wyatt <Wyatt.Wood@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 084/252] drm/amd/display: Fix PSR command version
Date:   Thu,  9 Sep 2021 07:38:18 -0400
Message-Id: <20210909114106.141462-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikita Lipski <mikita.lipski@amd.com>

[ Upstream commit af1f2b19fd7d404d299355cc95930efee5b3ed8b ]

[why]
For dual eDP when setting the new settings we need to set
command version to DMUB_CMD_PSR_CONTROL_VERSION_1, otherwise
DMUB will not read panel_inst parameter.
[how]
Instead of PSR_VERSION_1 pass DMUB_CMD_PSR_CONTROL_VERSION_1

Reviewed-by: Wood Wyatt <Wyatt.Wood@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 10d42ae0cffe..3428334c6c57 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -207,7 +207,7 @@ static void dmub_psr_set_level(struct dmub_psr *dmub, uint16_t psr_level, uint8_
 	cmd.psr_set_level.header.sub_type = DMUB_CMD__PSR_SET_LEVEL;
 	cmd.psr_set_level.header.payload_bytes = sizeof(struct dmub_cmd_psr_set_level_data);
 	cmd.psr_set_level.psr_set_level_data.psr_level = psr_level;
-	cmd.psr_set_level.psr_set_level_data.cmd_version = PSR_VERSION_1;
+	cmd.psr_set_level.psr_set_level_data.cmd_version = DMUB_CMD_PSR_CONTROL_VERSION_1;
 	cmd.psr_set_level.psr_set_level_data.panel_inst = panel_inst;
 	dc_dmub_srv_cmd_queue(dc->dmub_srv, &cmd);
 	dc_dmub_srv_cmd_execute(dc->dmub_srv);
@@ -293,7 +293,7 @@ static bool dmub_psr_copy_settings(struct dmub_psr *dmub,
 	copy_settings_data->debug.bitfields.use_hw_lock_mgr		= 1;
 	copy_settings_data->fec_enable_status = (link->fec_state == dc_link_fec_enabled);
 	copy_settings_data->fec_enable_delay_in100us = link->dc->debug.fec_enable_delay_in100us;
-	copy_settings_data->cmd_version =  PSR_VERSION_1;
+	copy_settings_data->cmd_version =  DMUB_CMD_PSR_CONTROL_VERSION_1;
 	copy_settings_data->panel_inst = panel_inst;
 
 	dc_dmub_srv_cmd_queue(dc->dmub_srv, &cmd);
-- 
2.30.2

