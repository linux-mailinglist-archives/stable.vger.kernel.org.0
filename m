Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02416432A3
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiLET11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiLET1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:27:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C05A26AFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:24:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B5D61307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367C8C433D6;
        Mon,  5 Dec 2022 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268251;
        bh=GR+OhvMVB4aCGaABbuTxKm/h4wZG+Co3BDmqdUmG5W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B405BU1DjzkNnR8Wk2EyLSyt0nqnexeySpe/07tY5oNH29uc1an+nQd2gKfLYD6Rs
         JMMvOMNhJLNouYBRnc3BWzsnmW8Hekr2NdtlnXm5ZFSxacPHM0uMCjC9kB32yJr18v
         v06gpW4uZVwEbGB74bjo5bcOvOKXcWNEEhtWv7zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kenneth Feng <kenneth.feng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 007/124] drm/amd/pm: update driver-if header for smu_v13_0_10
Date:   Mon,  5 Dec 2022 20:08:33 +0100
Message-Id: <20221205190808.650196571@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 09aef0258a327409bb2279a5ba8f82ad2ca099ca ]

update driver-if header for smu_v13_0_10 and merge with smu_v13_0_0

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: f2e1aa267f12 ("drm/amd/pm: update driver if header for smu_13_0_7")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../inc/pmfw_if/smu13_driver_if_v13_0_0.h     | 111 +++++++++++++-----
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h  |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c    |   6 +-
 3 files changed, 84 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
index 063f4a737605..b76f0f7e4299 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
@@ -25,7 +25,7 @@
 #define SMU13_DRIVER_IF_V13_0_0_H
 
 //Increment this version if SkuTable_t or BoardTable_t change
-#define PPTABLE_VERSION 0x24
+#define PPTABLE_VERSION 0x26
 
 #define NUM_GFXCLK_DPM_LEVELS    16
 #define NUM_SOCCLK_DPM_LEVELS    8
@@ -109,6 +109,22 @@
 #define FEATURE_SPARE_63_BIT                  63
 #define NUM_FEATURES                          64
 
+#define ALLOWED_FEATURE_CTRL_DEFAULT 0xFFFFFFFFFFFFFFFFULL
+#define ALLOWED_FEATURE_CTRL_SCPM	((1 << FEATURE_DPM_GFXCLK_BIT) | \
+									(1 << FEATURE_DPM_GFX_POWER_OPTIMIZER_BIT) | \
+									(1 << FEATURE_DPM_UCLK_BIT) | \
+									(1 << FEATURE_DPM_FCLK_BIT) | \
+									(1 << FEATURE_DPM_SOCCLK_BIT) | \
+									(1 << FEATURE_DPM_MP0CLK_BIT) | \
+									(1 << FEATURE_DPM_LINK_BIT) | \
+									(1 << FEATURE_DPM_DCN_BIT) | \
+									(1 << FEATURE_DS_GFXCLK_BIT) | \
+									(1 << FEATURE_DS_SOCCLK_BIT) | \
+									(1 << FEATURE_DS_FCLK_BIT) | \
+									(1 << FEATURE_DS_LCLK_BIT) | \
+									(1 << FEATURE_DS_DCFCLK_BIT) | \
+									(1 << FEATURE_DS_UCLK_BIT))
+
 //For use with feature control messages
 typedef enum {
   FEATURE_PWR_ALL,
@@ -133,6 +149,7 @@ typedef enum {
 #define DEBUG_OVERRIDE_DISABLE_DFLL                    0x00000200
 #define DEBUG_OVERRIDE_ENABLE_RLC_VF_BRINGUP_MODE      0x00000400
 #define DEBUG_OVERRIDE_DFLL_MASTER_MODE                0x00000800
+#define DEBUG_OVERRIDE_ENABLE_PROFILING_MODE           0x00001000
 
 // VR Mapping Bit Defines
 #define VR_MAPPING_VR_SELECT_MASK  0x01
@@ -262,15 +279,15 @@ typedef enum {
 } I2cControllerPort_e;
 
 typedef enum {
-  I2C_CONTROLLER_NAME_VR_GFX = 0,
-  I2C_CONTROLLER_NAME_VR_SOC,
-  I2C_CONTROLLER_NAME_VR_VMEMP,
-  I2C_CONTROLLER_NAME_VR_VDDIO,
-  I2C_CONTROLLER_NAME_LIQUID0,
-  I2C_CONTROLLER_NAME_LIQUID1,
-  I2C_CONTROLLER_NAME_PLX,
-  I2C_CONTROLLER_NAME_OTHER,
-  I2C_CONTROLLER_NAME_COUNT,
+	I2C_CONTROLLER_NAME_VR_GFX = 0,
+	I2C_CONTROLLER_NAME_VR_SOC,
+	I2C_CONTROLLER_NAME_VR_VMEMP,
+	I2C_CONTROLLER_NAME_VR_VDDIO,
+	I2C_CONTROLLER_NAME_LIQUID0,
+	I2C_CONTROLLER_NAME_LIQUID1,
+	I2C_CONTROLLER_NAME_PLX,
+	I2C_CONTROLLER_NAME_FAN_INTAKE,
+	I2C_CONTROLLER_NAME_COUNT,
 } I2cControllerName_e;
 
 typedef enum {
@@ -282,16 +299,17 @@ typedef enum {
   I2C_CONTROLLER_THROTTLER_LIQUID0,
   I2C_CONTROLLER_THROTTLER_LIQUID1,
   I2C_CONTROLLER_THROTTLER_PLX,
+  I2C_CONTROLLER_THROTTLER_FAN_INTAKE,
   I2C_CONTROLLER_THROTTLER_INA3221,
   I2C_CONTROLLER_THROTTLER_COUNT,
 } I2cControllerThrottler_e;
 
 typedef enum {
-  I2C_CONTROLLER_PROTOCOL_VR_XPDE132G5,
-  I2C_CONTROLLER_PROTOCOL_VR_IR35217,
-  I2C_CONTROLLER_PROTOCOL_TMP_TMP102A,
-  I2C_CONTROLLER_PROTOCOL_INA3221,
-  I2C_CONTROLLER_PROTOCOL_COUNT,
+	I2C_CONTROLLER_PROTOCOL_VR_XPDE132G5,
+	I2C_CONTROLLER_PROTOCOL_VR_IR35217,
+	I2C_CONTROLLER_PROTOCOL_TMP_MAX31875,
+	I2C_CONTROLLER_PROTOCOL_INA3221,
+	I2C_CONTROLLER_PROTOCOL_COUNT,
 } I2cControllerProtocol_e;
 
 typedef struct {
@@ -658,13 +676,20 @@ typedef struct {
 
 #define PP_NUM_OD_VF_CURVE_POINTS PP_NUM_RTAVFS_PWL_ZONES + 1
 
+typedef enum {
+	FAN_MODE_AUTO = 0,
+	FAN_MODE_MANUAL_LINEAR,
+} FanMode_e;
 
 typedef struct {
   uint32_t FeatureCtrlMask;
 
   //Voltage control
   int16_t                VoltageOffsetPerZoneBoundary[PP_NUM_OD_VF_CURVE_POINTS];
-  uint16_t               reserved[2];
+  uint16_t               VddGfxVmax;         // in mV
+
+  uint8_t                IdlePwrSavingFeaturesCtrl;
+  uint8_t                RuntimePwrSavingFeaturesCtrl;
 
   //Frequency changes
   int16_t                GfxclkFmin;           // MHz
@@ -674,7 +699,7 @@ typedef struct {
 
   //PPT
   int16_t                Ppt;         // %
-  int16_t                reserved1;
+  int16_t                Tdc;
 
   //Fan control
   uint8_t                FanLinearPwmPoints[NUM_OD_FAN_MAX_POINTS];
@@ -701,16 +726,19 @@ typedef struct {
   uint32_t FeatureCtrlMask;
 
   int16_t VoltageOffsetPerZoneBoundary;
-  uint16_t               reserved[2];
+  uint16_t               VddGfxVmax;         // in mV
+
+  uint8_t                IdlePwrSavingFeaturesCtrl;
+  uint8_t                RuntimePwrSavingFeaturesCtrl;
 
-  uint16_t               GfxclkFmin;           // MHz
-  uint16_t               GfxclkFmax;           // MHz
+  int16_t               GfxclkFmin;           // MHz
+  int16_t               GfxclkFmax;           // MHz
   uint16_t               UclkFmin;             // MHz
   uint16_t               UclkFmax;             // MHz
 
   //PPT
   int16_t                Ppt;         // %
-  int16_t                reserved1;
+  int16_t                Tdc;
 
   uint8_t                FanLinearPwmPoints;
   uint8_t                FanLinearTempPoints;
@@ -857,7 +885,8 @@ typedef struct {
   uint16_t  FanStartTempMin;
   uint16_t  FanStartTempMax;
 
-  uint32_t Spare[12];
+  uint16_t  PowerMinPpt0[POWER_SOURCE_COUNT];
+  uint32_t Spare[11];
 
 } MsgLimits_t;
 
@@ -1041,7 +1070,17 @@ typedef struct {
   uint32_t        GfxoffSpare[15];
 
   // GFX GPO
-  uint32_t        GfxGpoSpare[16];
+  uint32_t        DfllBtcMasterScalerM;
+  int32_t         DfllBtcMasterScalerB;
+  uint32_t        DfllBtcSlaveScalerM;
+  int32_t         DfllBtcSlaveScalerB;
+
+  uint32_t        DfllPccAsWaitCtrl; //GDFLL_AS_WAIT_CTRL_PCC register value to be passed to RLC msg
+  uint32_t        DfllPccAsStepCtrl; //GDFLL_AS_STEP_CTRL_PCC register value to be passed to RLC msg
+
+  uint32_t        DfllL2FrequencyBoostM; //Unitless (float)
+  uint32_t        DfllL2FrequencyBoostB; //In MHz (integer)
+  uint32_t        GfxGpoSpare[8];
 
   // GFX DCS
 
@@ -1114,12 +1153,14 @@ typedef struct {
   uint16_t IntakeTempHighIntakeAcousticLimit;
   uint16_t IntakeTempAcouticLimitReleaseRate;
 
-  uint16_t FanStalledTempLimitOffset;
+  int16_t FanAbnormalTempLimitOffset;
   uint16_t FanStalledTriggerRpm;
-  uint16_t FanAbnormalTriggerRpm;
-  uint16_t FanPadding;
+  uint16_t FanAbnormalTriggerRpmCoeff;
+  uint16_t FanAbnormalDetectionEnable;
 
-  uint32_t     FanSpare[14];
+  uint8_t      FanIntakeSensorSupport;
+  uint8_t      FanIntakePadding[3];
+  uint32_t     FanSpare[13];
 
   // SECTION: VDD_GFX AVFS
 
@@ -1198,8 +1239,13 @@ typedef struct {
   int16_t     TotalBoardPowerM;
   int16_t     TotalBoardPowerB;
 
+  //PMFW-11158
+  QuadraticInt_t qFeffCoeffGameClock[POWER_SOURCE_COUNT];
+  QuadraticInt_t qFeffCoeffBaseClock[POWER_SOURCE_COUNT];
+  QuadraticInt_t qFeffCoeffBoostClock[POWER_SOURCE_COUNT];
+
   // SECTION: Sku Reserved
-  uint32_t         Spare[61];
+  uint32_t         Spare[43];
 
   // Padding for MMHUB - do not modify this
   uint32_t     MmHubPadding[8];
@@ -1288,8 +1334,11 @@ typedef struct {
   uint32_t    PostVoltageSetBacoDelay; // in microseconds. Amount of time FW will wait after power good is established or PSI0 command is issued
   uint32_t    BacoEntryDelay; // in milliseconds. Amount of time FW will wait to trigger BACO entry after receiving entry notification from OS
 
+  uint8_t     FuseWritePowerMuxPresent;
+  uint8_t     FuseWritePadding[3];
+
   // SECTION: Board Reserved
-  uint32_t     BoardSpare[64];
+  uint32_t     BoardSpare[63];
 
   // SECTION: Structure Padding
 
@@ -1381,7 +1430,7 @@ typedef struct {
   uint16_t AverageTotalBoardPower;
 
   uint16_t AvgTemperature[TEMP_COUNT];
-  uint16_t TempPadding;
+  uint16_t AvgTemperatureFanIntake;
 
   uint8_t  PcieRate               ;
   uint8_t  PcieWidth              ;
@@ -1550,5 +1599,7 @@ typedef struct {
 #define IH_INTERRUPT_CONTEXT_ID_AUDIO_D0            0x5
 #define IH_INTERRUPT_CONTEXT_ID_AUDIO_D3            0x6
 #define IH_INTERRUPT_CONTEXT_ID_THERMAL_THROTTLING  0x7
+#define IH_INTERRUPT_CONTEXT_ID_FAN_ABNORMAL        0x8
+#define IH_INTERRUPT_CONTEXT_ID_FAN_RECOVERY        0x9
 
 #endif
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index dd5867561068..b7f4569aff2a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -30,7 +30,7 @@
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0 0x30
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x2C
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_10 0x1D
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index e7380aa4f6be..1983e0d29e9d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -288,7 +288,8 @@ int smu_v13_0_check_fw_version(struct smu_context *smu)
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_ALDE;
 		break;
 	case IP_VERSION(13, 0, 0):
-		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0;
+	case IP_VERSION(13, 0, 10):
+		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10;
 		break;
 	case IP_VERSION(13, 0, 7):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_7;
@@ -304,9 +305,6 @@ int smu_v13_0_check_fw_version(struct smu_context *smu)
 	case IP_VERSION(13, 0, 5):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_5;
 		break;
-	case IP_VERSION(13, 0, 10):
-		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_10;
-		break;
 	default:
 		dev_err(adev->dev, "smu unsupported IP version: 0x%x.\n",
 			adev->ip_versions[MP1_HWIP][0]);
-- 
2.35.1



