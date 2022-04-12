Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42F4FD0E0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbiDLG4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351121AbiDLGwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF142BB00;
        Mon, 11 Apr 2022 23:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ED7A6194F;
        Tue, 12 Apr 2022 06:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC030C385A1;
        Tue, 12 Apr 2022 06:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745602;
        bh=cc8s8qit5LAd78fWU8PWp4ehetundYYwIwOjn+ta9CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7rOm4YpiGRem2D4FLY2zkzyh+PIuFv/PrZEF7yJSizSO/wGBheYREUVc2vxOpvke
         xMsk4rtBVgP8EetEfR46+v2mnK0WROr3ofyzcfA9l3r1chh249SOLMXyfkz6w38xFM
         C/zkjsxTsY8A8H1fZLBpLCiTHYJvaxeyvCGd83v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 152/171] drm/amdgpu/smu10: fix SoC/fclk units in auto mode
Date:   Tue, 12 Apr 2022 08:30:43 +0200
Message-Id: <20220412062932.291669391@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 2f25d8ce09b7ba5d769c132ba3d4eb84a941d2cb upstream.

SMU takes clock limits in Mhz units.  socclk and fclk were
using 10 khz units in some cases.  Switch to Mhz units.
Fixes higher than required SoC clocks.

Fixes: 97cf32996c46d9 ("drm/amd/pm: Removed fixed clock in auto mode DPM")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -709,13 +709,13 @@ static int smu10_dpm_force_dpm_level(str
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinFclkByFreq,
 						hwmgr->display_config->num_display > 3 ?
-						data->clock_vol_info.vdd_dep_on_fclk->entries[0].clk :
+						(data->clock_vol_info.vdd_dep_on_fclk->entries[0].clk / 100) :
 						min_mclk,
 						NULL);
 
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinSocclkByFreq,
-						data->clock_vol_info.vdd_dep_on_socclk->entries[0].clk,
+						data->clock_vol_info.vdd_dep_on_socclk->entries[0].clk / 100,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinVcn,
@@ -728,11 +728,11 @@ static int smu10_dpm_force_dpm_level(str
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxFclkByFreq,
-						data->clock_vol_info.vdd_dep_on_fclk->entries[index_fclk].clk,
+						data->clock_vol_info.vdd_dep_on_fclk->entries[index_fclk].clk / 100,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxSocclkByFreq,
-						data->clock_vol_info.vdd_dep_on_socclk->entries[index_socclk].clk,
+						data->clock_vol_info.vdd_dep_on_socclk->entries[index_socclk].clk / 100,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxVcn,


