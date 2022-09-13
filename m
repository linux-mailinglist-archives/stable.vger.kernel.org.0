Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D9C5B708C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiIMO3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiIMO2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F03569F62;
        Tue, 13 Sep 2022 07:18:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B33614D0;
        Tue, 13 Sep 2022 14:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA60C4314C;
        Tue, 13 Sep 2022 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078587;
        bh=sEi3vH+/9vLyRKoZP3BAKNloMFh0QlP+mu32YyKXYy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNkhk+FGgIUa2B3zl7z4SDiM55W/jBvuHgXmYSVVv2qMSgI/ZNX7uWn4DfASIMXpE
         ezsnAjW4YOSNkPK8bgBRRLvl5HlK7cAlOtLa/dAuJ408bUedpNXFW2DmEFxYRMot1M
         E0P3+lKIh3RlbrfZxi+CZr7s9rSM1rQQKw/Y0OuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Saaem Rizvi <SyedSaaem.Rizvi@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 191/192] drm/amd/display: Add SMU logging code
Date:   Tue, 13 Sep 2022 16:04:57 +0200
Message-Id: <20220913140419.587035997@linuxfoundation.org>
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

commit 4b33b5ffcf68de3a43e7dddc91c5dc86e6ed8587 upstream.

[WHY]
Logging for SMU response value after the wait allows us to know
immediately what the response value was. Makes it easier to debug should
the value be anything other than OK.

[HOW]
Using the the already available DC SMU logging functions.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c |   12 ++++++++++
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c          |   12 ++++++++++
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c            |    8 ++++++
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c          |    8 ++++++
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c          |    8 ++++++
 5 files changed, 48 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c
@@ -41,6 +41,12 @@
 #define FN(reg_name, field) \
 	FD(reg_name##__##field)
 
+#include "logger_types.h"
+#undef DC_LOGGER
+#define DC_LOGGER \
+	CTX->logger
+#define smu_print(str, ...) {DC_LOG_SMU(str, ##__VA_ARGS__); }
+
 #define VBIOSSMC_MSG_TestMessage                  0x1
 #define VBIOSSMC_MSG_GetSmuVersion                0x2
 #define VBIOSSMC_MSG_PowerUpGfx                   0x3
@@ -97,6 +103,12 @@ static int rn_vbios_smu_send_msg_with_pa
 	result = rn_smu_wait_for_response(clk_mgr, 10, 200000);
 	ASSERT(result == VBIOSSMC_Result_OK);
 
+	smu_print("SMU response after wait: %d\n", result);
+
+	if (result == VBIOSSMC_Status_BUSY) {
+		return -1;
+	}
+
 	/* First clear response register */
 	REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Status_BUSY);
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c
@@ -41,6 +41,12 @@
 #define FN(reg_name, field) \
 	FD(reg_name##__##field)
 
+#include "logger_types.h"
+#undef DC_LOGGER
+#define DC_LOGGER \
+	CTX->logger
+#define smu_print(str, ...) {DC_LOG_SMU(str, ##__VA_ARGS__); }
+
 #define VBIOSSMC_MSG_GetSmuVersion                0x2
 #define VBIOSSMC_MSG_SetDispclkFreq               0x4
 #define VBIOSSMC_MSG_SetDprefclkFreq              0x5
@@ -96,6 +102,12 @@ static int dcn301_smu_send_msg_with_para
 
 	result = dcn301_smu_wait_for_response(clk_mgr, 10, 200000);
 
+	smu_print("SMU response after wait: %d\n", result);
+
+	if (result == VBIOSSMC_Status_BUSY) {
+		return -1;
+	}
+
 	/* First clear response register */
 	REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Status_BUSY);
 
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -40,6 +40,12 @@
 #define FN(reg_name, field) \
 	FD(reg_name##__##field)
 
+#include "logger_types.h"
+#undef DC_LOGGER
+#define DC_LOGGER \
+	CTX->logger
+#define smu_print(str, ...) {DC_LOG_SMU(str, ##__VA_ARGS__); }
+
 #define VBIOSSMC_MSG_TestMessage                  0x1
 #define VBIOSSMC_MSG_GetSmuVersion                0x2
 #define VBIOSSMC_MSG_PowerUpGfx                   0x3
@@ -104,6 +110,8 @@ static int dcn31_smu_send_msg_with_param
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
 	ASSERT(result == VBIOSSMC_Result_OK);
 
+	smu_print("SMU response after wait: %d\n", result);
+
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
 	}
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c
@@ -70,6 +70,12 @@ static const struct IP_BASE NBIO_BASE =
 #define REG_NBIO(reg_name) \
 	(NBIO_BASE.instance[0].segment[regBIF_BX_PF2_ ## reg_name ## _BASE_IDX] + regBIF_BX_PF2_ ## reg_name)
 
+#include "logger_types.h"
+#undef DC_LOGGER
+#define DC_LOGGER \
+	CTX->logger
+#define smu_print(str, ...) {DC_LOG_SMU(str, ##__VA_ARGS__); }
+
 #define mmMP1_C2PMSG_3                            0x3B1050C
 
 #define VBIOSSMC_MSG_TestMessage                  0x01 ///< To check if PMFW is alive and responding. Requirement specified by PMFW team
@@ -132,6 +138,8 @@ static int dcn315_smu_send_msg_with_para
 	result = dcn315_smu_wait_for_response(clk_mgr, 10, 200000);
 	ASSERT(result == VBIOSSMC_Result_OK);
 
+	smu_print("SMU response after wait: %d\n", result);
+
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
 	}
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c
@@ -58,6 +58,12 @@ static const struct IP_BASE MP0_BASE = {
 #define FN(reg_name, field) \
 	FD(reg_name##__##field)
 
+#include "logger_types.h"
+#undef DC_LOGGER
+#define DC_LOGGER \
+	CTX->logger
+#define smu_print(str, ...) {DC_LOG_SMU(str, ##__VA_ARGS__); }
+
 #define VBIOSSMC_MSG_TestMessage                  0x01 ///< To check if PMFW is alive and responding. Requirement specified by PMFW team
 #define VBIOSSMC_MSG_GetPmfwVersion               0x02 ///< Get PMFW version
 #define VBIOSSMC_MSG_Spare0                       0x03 ///< Spare0
@@ -120,6 +126,8 @@ static int dcn316_smu_send_msg_with_para
 	result = dcn316_smu_wait_for_response(clk_mgr, 10, 200000);
 	ASSERT(result == VBIOSSMC_Result_OK);
 
+	smu_print("SMU response after wait: %d\n", result);
+
 	if (result == VBIOSSMC_Status_BUSY) {
 		return -1;
 	}


