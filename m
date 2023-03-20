Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0126C077A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCTA6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCTA5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:57:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085EAC673;
        Sun, 19 Mar 2023 17:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06FFDCE1020;
        Mon, 20 Mar 2023 00:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2511C433D2;
        Mon, 20 Mar 2023 00:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273638;
        bh=dP8MKAIz+hzlwbkB+IquFyYQGS6Da7JzwgrSPP86ulE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjZeHF2CWiDuoZG0G138jmDSV9T64wduzOTZ/o79B9OZKIZRgmluLbJoux/sMjgMW
         EyGh1a37McLk7A4Y9uKLSRpbZpQ/J+Ug2dhN6/t/OVbxI1OQIx7ujwAGYm5pUXcm2F
         +vW1lHBJP5ve/hrdZLIggTPMEbt8iYRhqzE0GtDtszBQuqhezEZU25KWBPXuBdClkg
         bQzJ0zU0qp3FzXDafYUTsm2YAthjRciUW60gsY31IMeDXTwtFQoQhPm474DRsfqvyj
         +wvbUZHkHUzuf1PpkFMNipgjbVk2yiecjwOqBX+R1y8iaTwnmadGacqM0SgdUfOeV8
         UUBZfhyG7d6mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Swapnil Patel <Swapnil.Patel@amd.com>,
        Pavle Kotarac <pavle.kotarac@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, oliver.logush@amd.com, mwen@igalia.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 27/30] drm/amd/display: Update clock table to include highest clock setting
Date:   Sun, 19 Mar 2023 20:52:52 -0400
Message-Id: <20230320005258.1428043-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swapnil Patel <Swapnil.Patel@amd.com>

[ Upstream commit 2d99a7ec25cf456cd3680eb314d6454138e5aa64 ]

[Why]
Currently, the clk manager matches SocVoltage with voltage from
fused settings (dfPstate clock table). And then corresponding clocks
are selected.

However in certain situations, this leads to clk manager not
including at least one entry with highest supported clock setting.

[How]
Update the clk manager to include at least one entry with highest
supported clock setting.

Reviewed-by: Pavle Kotarac <pavle.kotarac@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Swapnil Patel <Swapnil.Patel@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn301/vg_clk_mgr.c    | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 24715ca2fa944..01383aac6b419 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -529,6 +529,19 @@ static struct clk_bw_params vg_bw_params = {
 
 };
 
+static uint32_t find_max_clk_value(const uint32_t clocks[], uint32_t num_clocks)
+{
+	uint32_t max = 0;
+	int i;
+
+	for (i = 0; i < num_clocks; ++i) {
+		if (clocks[i] > max)
+			max = clocks[i];
+	}
+
+	return max;
+}
+
 static unsigned int find_dcfclk_for_voltage(const struct vg_dpm_clocks *clock_table,
 		unsigned int voltage)
 {
@@ -572,12 +585,16 @@ static void vg_clk_mgr_helper_populate_bw_params(
 
 	bw_params->clk_table.num_entries = j + 1;
 
-	for (i = 0; i < bw_params->clk_table.num_entries; i++, j--) {
+	for (i = 0; i < bw_params->clk_table.num_entries - 1; i++, j--) {
 		bw_params->clk_table.entries[i].fclk_mhz = clock_table->DfPstateTable[j].fclk;
 		bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
 		bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
 		bw_params->clk_table.entries[i].dcfclk_mhz = find_dcfclk_for_voltage(clock_table, clock_table->DfPstateTable[j].voltage);
 	}
+	bw_params->clk_table.entries[i].fclk_mhz = clock_table->DfPstateTable[j].fclk;
+	bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
+	bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
+	bw_params->clk_table.entries[i].dcfclk_mhz = find_max_clk_value(clock_table->DcfClocks, VG_NUM_DCFCLK_DPM_LEVELS);
 
 	bw_params->vram_type = bios_info->memory_type;
 	bw_params->num_channels = bios_info->ma_channel_number;
-- 
2.39.2

