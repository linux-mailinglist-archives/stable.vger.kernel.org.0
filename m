Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030285B70CE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiIMOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbiIMO31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608962AB7;
        Tue, 13 Sep 2022 07:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 370C8B80F3B;
        Tue, 13 Sep 2022 14:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3488C433D6;
        Tue, 13 Sep 2022 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078590;
        bh=DQ3UWc+6JLXRSGG02z9nwZw4w9OJmIdrtpFzqqHqn88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXYwFYztOsBktufwOH5p/X/oDVemUGOmv8HvvmMfA0ogi5WNSwnTh1kezcKXdqTcZ
         AmL4QQN57x72LlFwoolbVbB5HnPCz3vSlxQA+99w3vbRCf3DV3Uhbv6NhyYrYJQJoD
         ebK6Z4MpFeay5V7gi7V41oZ6gviGbTjwScwgfSWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabe Teeger <Gabe.Teeger@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Saaem Rizvi <SyedSaaem.Rizvi@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 192/192] drm/amd/display: Removing assert statements for Linux
Date:   Tue, 13 Sep 2022 16:04:58 +0200
Message-Id: <20220913140419.637634768@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>

commit 149f6d1a6035a7aa6595ac6eeb9c8f566b2103cd upstream.

[WHY]
Assert statements causing several bugs on Linux DM

[HOW]
Removing assert statement for Linux DM
(ASSERT(result == VBIOSSMC_Result_OK)). Also adding
logging statements for setting dcfclk.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216092
Fixes: c1b972a18d05 ("drm/amd/display: Insert pulling smu busy status before sending another request")
Reviewed-by: Gabe Teeger <Gabe.Teeger@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c |    8 ++++++--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c          |    7 ++++++-
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c            |    8 ++++++--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c          |    8 ++++++--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c          |    8 ++++++--
 5 files changed, 30 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
@@ -101,9 +101,9 @@ static int rn_vbios_smu_send_msg_with_pa
 	uint32_t result;
 
 	result = rn_smu_wait_for_response(clk_mgr, 10, 200000);
-	ASSERT(result == VBIOSSMC_Result_OK);
 
-	smu_print("SMU response after wait: %d\n", result);
+	if (result != VBIOSSMC_Result_OK)
+		smu_print("SMU Response was not OK. SMU response after wait received is: %d\n", result);
 
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
@@ -188,6 +188,10 @@ int rn_vbios_smu_set_hard_min_dcfclk(str
 			VBIOSSMC_MSG_SetHardMinDcfclkByFreq,
 			khz_to_mhz_ceil(requested_dcfclk_khz));
 
+#ifdef DBG
+	smu_print("actual_dcfclk_set_mhz %d is set to : %d\n", actual_dcfclk_set_mhz, actual_dcfclk_set_mhz * 1000);
+#endif
+
 	return actual_dcfclk_set_mhz * 1000;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c
@@ -102,7 +102,8 @@ static int dcn301_smu_send_msg_with_para
 
 	result = dcn301_smu_wait_for_response(clk_mgr, 10, 200000);
 
-	smu_print("SMU response after wait: %d\n", result);
+	if (result != VBIOSSMC_Result_OK)
+		smu_print("SMU Response was not OK. SMU response after wait received is: %d\n", result);
 
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
@@ -179,6 +180,10 @@ int dcn301_smu_set_hard_min_dcfclk(struc
 			VBIOSSMC_MSG_SetHardMinDcfclkByFreq,
 			khz_to_mhz_ceil(requested_dcfclk_khz));
 
+#ifdef DBG
+	smu_print("actual_dcfclk_set_mhz %d is set to : %d\n", actual_dcfclk_set_mhz, actual_dcfclk_set_mhz * 1000);
+#endif
+
 	return actual_dcfclk_set_mhz * 1000;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -108,9 +108,9 @@ static int dcn31_smu_send_msg_with_param
 	uint32_t result;
 
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
-	ASSERT(result == VBIOSSMC_Result_OK);
 
-	smu_print("SMU response after wait: %d\n", result);
+	if (result != VBIOSSMC_Result_OK)
+		smu_print("SMU Response was not OK. SMU response after wait received is: %d\n", result);
 
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
@@ -202,6 +202,10 @@ int dcn31_smu_set_hard_min_dcfclk(struct
 			VBIOSSMC_MSG_SetHardMinDcfclkByFreq,
 			khz_to_mhz_ceil(requested_dcfclk_khz));
 
+#ifdef DBG
+	smu_print("actual_dcfclk_set_mhz %d is set to : %d\n", actual_dcfclk_set_mhz, actual_dcfclk_set_mhz * 1000);
+#endif
+
 	return actual_dcfclk_set_mhz * 1000;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c
@@ -136,9 +136,9 @@ static int dcn315_smu_send_msg_with_para
 	uint32_t result;
 
 	result = dcn315_smu_wait_for_response(clk_mgr, 10, 200000);
-	ASSERT(result == VBIOSSMC_Result_OK);
 
-	smu_print("SMU response after wait: %d\n", result);
+	if (result != VBIOSSMC_Result_OK)
+		smu_print("SMU Response was not OK. SMU response after wait received is: %d\n", result);
 
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
@@ -205,6 +205,10 @@ int dcn315_smu_set_hard_min_dcfclk(struc
 			VBIOSSMC_MSG_SetHardMinDcfclkByFreq,
 			khz_to_mhz_ceil(requested_dcfclk_khz));
 
+#ifdef DBG
+	smu_print("actual_dcfclk_set_mhz %d is set to : %d\n", actual_dcfclk_set_mhz, actual_dcfclk_set_mhz * 1000);
+#endif
+
 	return actual_dcfclk_set_mhz * 1000;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c
@@ -124,9 +124,9 @@ static int dcn316_smu_send_msg_with_para
 	uint32_t result;
 
 	result = dcn316_smu_wait_for_response(clk_mgr, 10, 200000);
-	ASSERT(result == VBIOSSMC_Result_OK);
 
-	smu_print("SMU response after wait: %d\n", result);
+	if (result != VBIOSSMC_Result_OK)
+		smu_print("SMU Response was not OK. SMU response after wait received is: %d\n", result);
 
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
@@ -191,6 +191,10 @@ int dcn316_smu_set_hard_min_dcfclk(struc
 			VBIOSSMC_MSG_SetHardMinDcfclkByFreq,
 			khz_to_mhz_ceil(requested_dcfclk_khz));
 
+#ifdef DBG
+	smu_print("actual_dcfclk_set_mhz %d is set to : %d\n", actual_dcfclk_set_mhz, actual_dcfclk_set_mhz * 1000);
+#endif
+
 	return actual_dcfclk_set_mhz * 1000;
 }
 


