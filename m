Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC936CC32B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjC1Ovs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbjC1Ov3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D280CD336
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E78B61826
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E322C433D2;
        Tue, 28 Mar 2023 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015073;
        bh=dP8MKAIz+hzlwbkB+IquFyYQGS6Da7JzwgrSPP86ulE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHhAumhC401anInJHDaS7yG/8pO2O2S514I281y7mjMJ7AJMIZa/JB38r39UiUsCH
         kt9kTDojS16x+0hck8ZSRwHQbmeEueqillcmrVssCYYNAz9917S5b8ezVbI9apZ3e+
         jAajCLn/FOWfdFiIqUgZr9tmx8uAWzmgjHDBeTxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavle Kotarac <pavle.kotarac@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Swapnil Patel <Swapnil.Patel@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 156/240] drm/amd/display: Update clock table to include highest clock setting
Date:   Tue, 28 Mar 2023 16:41:59 +0200
Message-Id: <20230328142626.194643913@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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



