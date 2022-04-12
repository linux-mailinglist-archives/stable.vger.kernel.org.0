Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF164FD393
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347943AbiDLH5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359252AbiDLHmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855032A732;
        Tue, 12 Apr 2022 00:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 232AF616B2;
        Tue, 12 Apr 2022 07:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348BAC385A1;
        Tue, 12 Apr 2022 07:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748066;
        bh=McsC9ZufxaUuzydXB9cDgdwI6fwZUeI+va5tpXteTiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOeraF9OU7MskwCcYrGjyfTmC89tk33P+8FQxxECXcLZAPy9XMo3jKa50HtFACUDP
         zrJqeoRgAkrlX7zZSAwQDgizRRS17ayZgFMz3lCoBL8BWwwbPiT/D5vfSIs3HP6kIQ
         qmLLTp4u5Ug6A61YHr+wSQS1WOq26Q+Hupl1JEMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.17 307/343] drm/amdgpu/smu10: fix SoC/fclk units in auto mode
Date:   Tue, 12 Apr 2022 08:32:05 +0200
Message-Id: <20220412063000.184100798@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
@@ -773,13 +773,13 @@ static int smu10_dpm_force_dpm_level(str
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
@@ -792,11 +792,11 @@ static int smu10_dpm_force_dpm_level(str
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


