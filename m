Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A62B156666
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBHSeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:34:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34168 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003fy-1D; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CPn-HF; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Sat, 08 Feb 2020 18:20:18 +0000
Message-ID: <lsq.1581185940.369779697@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 079/148] ARM: ux500: remove unused regulator data
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 37dc78d9b17c971479f742d6d08f38d8f2beb688 upstream.

Most of the board-mop500-regulators.c file is never referenced and
can simply be removed.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[bwh: Backported to 3.16 as dependency of commit 99c4f70df3a6
 "regulator: ab8500: Remove AB8505 USB regulator"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-ux500/board-mop500-regulators.c | 600 ------------------
 arch/arm/mach-ux500/board-mop500-regulators.h |   8 -
 2 files changed, 608 deletions(-)

--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -13,46 +13,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 #include "board-mop500-regulators.h"
-#include "id.h"
-
-static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
-       REGULATOR_SUPPLY("vdd33a", "smsc911x.0"),
-};
-
-struct regulator_init_data gpio_en_3v3_regulator = {
-       .constraints = {
-               .name = "EN-3V3",
-               .min_uV = 3300000,
-               .max_uV = 3300000,
-               .valid_ops_mask = REGULATOR_CHANGE_STATUS,
-       },
-       .num_consumer_supplies = ARRAY_SIZE(gpio_en_3v3_consumers),
-       .consumer_supplies = gpio_en_3v3_consumers,
-};
-
-/*
- * TPS61052 regulator
- */
-static struct regulator_consumer_supply tps61052_vaudio_consumers[] = {
-	/*
-	 * Boost converter supply to raise voltage on audio speaker, this
-	 * is actually connected to three pins, VInVhfL (left amplifier)
-	 * VInVhfR (right amplifier) and VIntDClassInt - all three must
-	 * be connected to the same voltage.
-	 */
-	REGULATOR_SUPPLY("vintdclassint", "ab8500-codec.0"),
-};
-
-struct regulator_init_data tps61052_regulator = {
-	.constraints = {
-		.name = "vaudio-hf",
-		.min_uV = 4500000,
-		.max_uV = 4500000,
-		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies = ARRAY_SIZE(tps61052_vaudio_consumers),
-	.consumer_supplies = tps61052_vaudio_consumers,
-};
 
 static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 	/* Main display, u8500 R3 uib */
@@ -107,27 +67,6 @@ static struct regulator_consumer_supply
 	REGULATOR_SUPPLY("vmmc", "sdi0"),
 };
 
-static struct regulator_consumer_supply ab8505_vaux4_consumers[] = {
-};
-
-static struct regulator_consumer_supply ab8505_vaux5_consumers[] = {
-};
-
-static struct regulator_consumer_supply ab8505_vaux6_consumers[] = {
-};
-
-static struct regulator_consumer_supply ab8505_vaux8_consumers[] = {
-	/* AB8500 audio codec device */
-	REGULATOR_SUPPLY("v-aux8", NULL),
-};
-
-static struct regulator_consumer_supply ab8505_vadc_consumers[] = {
-	/* Internal general-purpose ADC */
-	REGULATOR_SUPPLY("vddadc", "ab8500-gpadc.0"),
-	/* ADC for charger */
-	REGULATOR_SUPPLY("vddadc", "ab8500-charger.0"),
-};
-
 static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 	/* TV-out DENC supply */
 	REGULATOR_SUPPLY("vtvout", "ab8500-denc.0"),
@@ -168,11 +107,6 @@ static struct regulator_consumer_supply
 	REGULATOR_SUPPLY("v-intcore", "abx500-clk.0"),
 };
 
-static struct regulator_consumer_supply ab8505_usb_consumers[] = {
-	/* HS USB OTG physical interface */
-	REGULATOR_SUPPLY("v-ape", NULL),
-};
-
 static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 	/* DB8500 DSI */
 	REGULATOR_SUPPLY("vdddsi1v2", "mcde"),
@@ -483,11 +417,6 @@ static struct regulator_consumer_supply
 	REGULATOR_SUPPLY("vinvsim", "sim-detect.0"),
 };
 
-/* extended configuration for VextSupply2, only used for HREFP_V20 boards */
-static struct ab8500_ext_regulator_cfg ab8500_ext_supply2 = {
-	.hwreq = true,
-};
-
 /*
  * AB8500 external regulators
  */
@@ -526,456 +455,6 @@ static struct regulator_init_data ab8500
 	},
 };
 
-/* ab8505 regulator register initialization */
-static struct ab8500_regulator_reg_init ab8505_reg_init[] = {
-	/*
-	 * VarmRequestCtrl
-	 * VsmpsCRequestCtrl
-	 * VsmpsARequestCtrl
-	 * VsmpsBRequestCtrl
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL1,       0x00, 0x00),
-	/*
-	 * VsafeRequestCtrl
-	 * VpllRequestCtrl
-	 * VanaRequestCtrl          = HP/LP depending on VxRequest
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL2,       0x30, 0x00),
-	/*
-	 * Vaux1RequestCtrl         = HP/LP depending on VxRequest
-	 * Vaux2RequestCtrl         = HP/LP depending on VxRequest
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL3,       0xf0, 0x00),
-	/*
-	 * Vaux3RequestCtrl         = HP/LP depending on VxRequest
-	 * SwHPReq                  = Control through SWValid disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUREQUESTCTRL4,       0x07, 0x00),
-	/*
-	 * VsmpsASysClkReq1HPValid
-	 * VsmpsBSysClkReq1HPValid
-	 * VsafeSysClkReq1HPValid
-	 * VanaSysClkReq1HPValid    = disabled
-	 * VpllSysClkReq1HPValid
-	 * Vaux1SysClkReq1HPValid   = disabled
-	 * Vaux2SysClkReq1HPValid   = disabled
-	 * Vaux3SysClkReq1HPValid   = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQ1HPVALID1, 0xe8, 0x00),
-	/*
-	 * VsmpsCSysClkReq1HPValid
-	 * VarmSysClkReq1HPValid
-	 * VbbSysClkReq1HPValid
-	 * VsmpsMSysClkReq1HPValid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQ1HPVALID2, 0x00, 0x00),
-	/*
-	 * VsmpsAHwHPReq1Valid
-	 * VsmpsBHwHPReq1Valid
-	 * VsafeHwHPReq1Valid
-	 * VanaHwHPReq1Valid        = disabled
-	 * VpllHwHPReq1Valid
-	 * Vaux1HwHPreq1Valid       = disabled
-	 * Vaux2HwHPReq1Valid       = disabled
-	 * Vaux3HwHPReqValid        = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ1VALID1,     0xe8, 0x00),
-	/*
-	 * VsmpsMHwHPReq1Valid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ1VALID2,     0x00, 0x00),
-	/*
-	 * VsmpsAHwHPReq2Valid
-	 * VsmpsBHwHPReq2Valid
-	 * VsafeHwHPReq2Valid
-	 * VanaHwHPReq2Valid        = disabled
-	 * VpllHwHPReq2Valid
-	 * Vaux1HwHPReq2Valid       = disabled
-	 * Vaux2HwHPReq2Valid       = disabled
-	 * Vaux3HwHPReq2Valid       = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ2VALID1,     0xe8, 0x00),
-	/*
-	 * VsmpsMHwHPReq2Valid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUHWHPREQ2VALID2,     0x00, 0x00),
-	/**
-	 * VsmpsCSwHPReqValid
-	 * VarmSwHPReqValid
-	 * VsmpsASwHPReqValid
-	 * VsmpsBSwHPReqValid
-	 * VsafeSwHPReqValid
-	 * VanaSwHPReqValid
-	 * VanaSwHPReqValid         = disabled
-	 * VpllSwHPReqValid
-	 * Vaux1SwHPReqValid        = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSWHPREQVALID1,      0xa0, 0x00),
-	/*
-	 * Vaux2SwHPReqValid        = disabled
-	 * Vaux3SwHPReqValid        = disabled
-	 * VsmpsMSwHPReqValid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSWHPREQVALID2,      0x03, 0x00),
-	/*
-	 * SysClkReq2Valid1         = SysClkReq2 controlled
-	 * SysClkReq3Valid1         = disabled
-	 * SysClkReq4Valid1         = SysClkReq4 controlled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQVALID1,    0x0e, 0x0a),
-	/*
-	 * SysClkReq2Valid2         = disabled
-	 * SysClkReq3Valid2         = disabled
-	 * SysClkReq4Valid2         = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUSYSCLKREQVALID2,    0x0e, 0x00),
-	/*
-	 * Vaux4SwHPReqValid
-	 * Vaux4HwHPReq2Valid
-	 * Vaux4HwHPReq1Valid
-	 * Vaux4SysClkReq1HPValid
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUVAUX4REQVALID,    0x00, 0x00),
-	/*
-	 * VadcEna                  = disabled
-	 * VintCore12Ena            = disabled
-	 * VintCore12Sel            = 1.25 V
-	 * VintCore12LP             = inactive (HP)
-	 * VadcLP                   = inactive (HP)
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUMISC1,              0xfe, 0x10),
-	/*
-	 * VaudioEna                = disabled
-	 * Vaux8Ena                 = disabled
-	 * Vamic1Ena                = disabled
-	 * Vamic2Ena                = disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUDIOSUPPLY,           0x1e, 0x00),
-	/*
-	 * Vamic1_dzout             = high-Z when Vamic1 is disabled
-	 * Vamic2_dzout             = high-Z when Vamic2 is disabled
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRL1VAMIC,         0x03, 0x00),
-	/*
-	 * VsmpsARegu
-	 * VsmpsASelCtrl
-	 * VsmpsAAutoMode
-	 * VsmpsAPWMMode
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSAREGU,    0x00, 0x00),
-	/*
-	 * VsmpsBRegu
-	 * VsmpsBSelCtrl
-	 * VsmpsBAutoMode
-	 * VsmpsBPWMMode
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBREGU,    0x00, 0x00),
-	/*
-	 * VsafeRegu
-	 * VsafeSelCtrl
-	 * VsafeAutoMode
-	 * VsafePWMMode
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFEREGU,    0x00, 0x00),
-	/*
-	 * VPll                     = Hw controlled (NOTE! PRCMU bits)
-	 * VanaRegu                 = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VPLLVANAREGU,           0x0f, 0x02),
-	/*
-	 * VextSupply1Regu          = force OFF (OTP_ExtSupply12LPnPolarity 1)
-	 * VextSupply2Regu          = force OFF (OTP_ExtSupply12LPnPolarity 1)
-	 * VextSupply3Regu          = force OFF (OTP_ExtSupply3LPnPolarity 0)
-	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
-	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_EXTSUPPLYREGU,          0xff, 0x30),
-	/*
-	 * Vaux1Regu                = force HP
-	 * Vaux2Regu                = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX12REGU,             0x0f, 0x01),
-	/*
-	 * Vaux3Regu                = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VRF1VAUX3REGU,          0x03, 0x00),
-	/*
-	 * VsmpsASel1
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL1,    0x00, 0x00),
-	/*
-	 * VsmpsASel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL2,    0x00, 0x00),
-	/*
-	 * VsmpsASel3
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSASEL3,    0x00, 0x00),
-	/*
-	 * VsmpsBSel1
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL1,    0x00, 0x00),
-	/*
-	 * VsmpsBSel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL2,    0x00, 0x00),
-	/*
-	 * VsmpsBSel3
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSMPSBSEL3,    0x00, 0x00),
-	/*
-	 * VsafeSel1
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL1,    0x00, 0x00),
-	/*
-	 * VsafeSel2
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL2,    0x00, 0x00),
-	/*
-	 * VsafeSel3
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VSAFESEL3,    0x00, 0x00),
-	/*
-	 * Vaux1Sel                 = 2.8 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX1SEL,               0x0f, 0x0C),
-	/*
-	 * Vaux2Sel                 = 2.9 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX2SEL,               0x0f, 0x0d),
-	/*
-	 * Vaux3Sel                 = 2.91 V
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VRF1VAUX3SEL,           0x07, 0x07),
-	/*
-	 * Vaux4RequestCtrl
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX4REQCTRL,    0x00, 0x00),
-	/*
-	 * Vaux4Regu
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX4REGU,    0x00, 0x00),
-	/*
-	 * Vaux4Sel
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_VAUX4SEL,    0x00, 0x00),
-	/*
-	 * Vaux1Disch               = short discharge time
-	 * Vaux2Disch               = short discharge time
-	 * Vaux3Disch               = short discharge time
-	 * Vintcore12Disch          = short discharge time
-	 * VTVoutDisch              = short discharge time
-	 * VaudioDisch              = short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH,          0xfc, 0x00),
-	/*
-	 * VanaDisch                = short discharge time
-	 * Vaux8PullDownEna         = pulldown disabled when Vaux8 is disabled
-	 * Vaux8Disch               = short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH2,         0x16, 0x00),
-	/*
-	 * Vaux4Disch               = short discharge time
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_REGUCTRLDISCH3,         0x01, 0x00),
-	/*
-	 * Vaux5Sel
-	 * Vaux5LP
-	 * Vaux5Ena
-	 * Vaux5Disch
-	 * Vaux5DisSfst
-	 * Vaux5DisPulld
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX5,              0x00, 0x00),
-	/*
-	 * Vaux6Sel
-	 * Vaux6LP
-	 * Vaux6Ena
-	 * Vaux6DisPulld
-	 */
-	INIT_REGULATOR_REGISTER(AB8505_CTRLVAUX6,              0x00, 0x00),
-};
-
-struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
-	/* supplies to the display/camera */
-	[AB8505_LDO_AUX1] = {
-		.constraints = {
-			.name = "V-DISPLAY",
-			.min_uV = 2800000,
-			.max_uV = 3300000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS,
-			.boot_on = 1, /* display is on at boot */
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
-		.consumer_supplies = ab8500_vaux1_consumers,
-	},
-	/* supplies to the on-board eMMC */
-	[AB8505_LDO_AUX2] = {
-		.constraints = {
-			.name = "V-eMMC1",
-			.min_uV = 1100000,
-			.max_uV = 3300000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux2_consumers),
-		.consumer_supplies = ab8500_vaux2_consumers,
-	},
-	/* supply for VAUX3, supplies to SDcard slots */
-	[AB8505_LDO_AUX3] = {
-		.constraints = {
-			.name = "V-MMC-SD",
-			.min_uV = 1100000,
-			.max_uV = 3300000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux3_consumers),
-		.consumer_supplies = ab8500_vaux3_consumers,
-	},
-	/* supply for VAUX4, supplies to NFC and standalone secure element */
-	[AB8505_LDO_AUX4] = {
-		.constraints = {
-			.name = "V-NFC-SE",
-			.min_uV = 1100000,
-			.max_uV = 3300000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux4_consumers),
-		.consumer_supplies = ab8505_vaux4_consumers,
-	},
-	/* supply for VAUX5, supplies to TBD */
-	[AB8505_LDO_AUX5] = {
-		.constraints = {
-			.name = "V-AUX5",
-			.min_uV = 1050000,
-			.max_uV = 2790000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux5_consumers),
-		.consumer_supplies = ab8505_vaux5_consumers,
-	},
-	/* supply for VAUX6, supplies to TBD */
-	[AB8505_LDO_AUX6] = {
-		.constraints = {
-			.name = "V-AUX6",
-			.min_uV = 1050000,
-			.max_uV = 2790000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux6_consumers),
-		.consumer_supplies = ab8505_vaux6_consumers,
-	},
-	/* supply for gpadc, ADC LDO */
-	[AB8505_LDO_ADC] = {
-		.constraints = {
-			.name = "V-ADC",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8505_vadc_consumers),
-		.consumer_supplies = ab8505_vadc_consumers,
-	},
-	/* supply for ab8500-vaudio, VAUDIO LDO */
-	[AB8505_LDO_AUDIO] = {
-		.constraints = {
-			.name = "V-AUD",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vaud_consumers),
-		.consumer_supplies = ab8500_vaud_consumers,
-	},
-	/* supply for v-anamic1 VAMic1-LDO */
-	[AB8505_LDO_ANAMIC1] = {
-		.constraints = {
-			.name = "V-AMIC1",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic1_consumers),
-		.consumer_supplies = ab8500_vamic1_consumers,
-	},
-	/* supply for v-amic2, VAMIC2 LDO, reuse constants for AMIC1 */
-	[AB8505_LDO_ANAMIC2] = {
-		.constraints = {
-			.name = "V-AMIC2",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vamic2_consumers),
-		.consumer_supplies = ab8500_vamic2_consumers,
-	},
-	/* supply for v-aux8, VAUX8 LDO */
-	[AB8505_LDO_AUX8] = {
-		.constraints = {
-			.name = "V-AUX8",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8505_vaux8_consumers),
-		.consumer_supplies = ab8505_vaux8_consumers,
-	},
-	/* supply for v-intcore12, VINTCORE12 LDO */
-	[AB8505_LDO_INTCORE] = {
-		.constraints = {
-			.name = "V-INTCORE",
-			.min_uV = 1250000,
-			.max_uV = 1350000,
-			.input_uV = 1800000,
-			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
-					  REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE |
-					  REGULATOR_CHANGE_DRMS,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
-		.consumer_supplies = ab8500_vintcore_consumers,
-	},
-	/* supply for LDO USB */
-	[AB8505_LDO_USB] = {
-		.constraints = {
-			.name = "V-USB",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
-					  REGULATOR_CHANGE_MODE,
-			.valid_modes_mask = REGULATOR_MODE_NORMAL |
-					    REGULATOR_MODE_IDLE,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8505_usb_consumers),
-		.consumer_supplies = ab8505_usb_consumers,
-	},
-	/* supply for U8500 CSI-DSI, VANA LDO */
-	[AB8505_LDO_ANA] = {
-		.constraints = {
-			.name = "V-CSI-DSI",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
-		},
-		.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
-		.consumer_supplies = ab8500_vana_consumers,
-	},
-};
-
 struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.reg_init               = ab8500_reg_init,
 	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
@@ -984,82 +463,3 @@ struct ab8500_regulator_platform_data ab
 	.ext_regulator          = ab8500_ext_regulators,
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
-
-struct ab8500_regulator_platform_data ab8505_regulator_plat_data = {
-	.reg_init               = ab8505_reg_init,
-	.num_reg_init           = ARRAY_SIZE(ab8505_reg_init),
-	.regulator              = ab8505_regulators,
-	.num_regulator          = ARRAY_SIZE(ab8505_regulators),
-};
-
-static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
-{
-	int i;
-
-	if (cpu_is_u8520()) {
-		for (i = ARRAY_SIZE(ab8505_reg_init) - 1; i >= 0; i--) {
-			if (ab8505_reg_init[i].id == id) {
-				u8 initval = ab8505_reg_init[i].value;
-				initval = (initval & ~mask) | (value & mask);
-				ab8505_reg_init[i].value = initval;
-
-				BUG_ON(mask & ~ab8505_reg_init[i].mask);
-				return;
-			}
-		}
-	} else {
-		for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
-			if (ab8500_reg_init[i].id == id) {
-				u8 initval = ab8500_reg_init[i].value;
-				initval = (initval & ~mask) | (value & mask);
-				ab8500_reg_init[i].value = initval;
-
-				BUG_ON(mask & ~ab8500_reg_init[i].mask);
-				return;
-			}
-		}
-	}
-
-	BUG_ON(1);
-}
-
-void mop500_regulator_init(void)
-{
-	struct regulator_init_data *regulator;
-
-	/*
-	 * Temporarily turn on Vaux2 on 8520 machine
-	 */
-	if (cpu_is_u8520()) {
-		/* Vaux2 initialized to be on */
-		ab8500_modify_reg_init(AB8505_VAUX12REGU, 0x0f, 0x05);
-	}
-
-	/*
-	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
-	 * all HREFP_V20 boards)
-	 */
-	if (cpu_is_u8500v20()) {
-		/* VextSupply2RequestCtrl =  HP/OFF depending on VxRequest */
-		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
-
-		/* VextSupply2SysClkReq1HPValid = SysClkReq1 controlled */
-		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
-			0x20, 0x20);
-
-		/* VextSupply2 = force HP at initialization */
-		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
-
-		/* enable VextSupply2 during platform active */
-		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
-		regulator->constraints.always_on = 1;
-
-		/* disable VextSupply2 in suspend */
-		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
-		regulator->constraints.state_mem.disabled = 1;
-		regulator->constraints.state_standby.disabled = 1;
-
-		/* enable VextSupply2 HW control (used in suspend) */
-		regulator->driver_data = (void *)&ab8500_ext_supply2;
-	}
-}
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -11,14 +11,6 @@
 #ifndef __BOARD_MOP500_REGULATORS_H
 #define __BOARD_MOP500_REGULATORS_H
 
-#include <linux/regulator/machine.h>
-#include <linux/regulator/ab8500.h>
-
 extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
-extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
-extern struct regulator_init_data tps61052_regulator;
-extern struct regulator_init_data gpio_en_3v3_regulator;
-
-void mop500_regulator_init(void);
 
 #endif

