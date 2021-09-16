Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1940E761
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347482AbhIPRb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353038AbhIPR3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 332976320E;
        Thu, 16 Sep 2021 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810789;
        bh=WNI+MCurftRnG04/cAAncVCu0T2V7AVRB41i1UNH/r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcYsb6rUBuHP1Qv1aPi0v3ibIA1ry98+76gwm2nz35meZKEenrhB7YVcMdGQf6BGF
         ZU25gc4gBpggWnTB8qXpt+6tdBUpzqz1V2/EoGiXbxBm19hKGm/Wo8OCHwdnAfWw2O
         gvX9CW3lu4Vo8AyjkMt1gdgJTqL1PXLJu408FPuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wood Wyatt <Wyatt.Wood@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 236/432] drm/amd/display: Fix PSR command version
Date:   Thu, 16 Sep 2021 17:59:45 +0200
Message-Id: <20210916155818.839916582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



