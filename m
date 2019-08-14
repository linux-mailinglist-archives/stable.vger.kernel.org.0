Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923D18E00D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 23:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfHNVnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 17:43:33 -0400
Received: from mail.andi.de1.cc ([85.214.55.253]:56696 "EHLO mail.andi.de1.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbfHNVnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 17:43:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kemnade.info; s=20180802; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rzfhwFa3vGxoAkostceCbIdcn+mpEwU4ARYQbmvuyIk=; b=m4VSz6yPLD1INnQVjkWpFn2qps
        fSyfckhDJhYEai8gy0FwfRSrR9yWrYNcrGnAwnR8TRKT/qAM8CIHuDlTxchGrAP2FWHng2nOcMn+U
        nb2r+79X4T14vNdmx9UzMj0mcOEd6/26DwjRdFYzetfHZlduSC546ugr2LBmLQbnMTlQ=;
Received: from p5dcc3d63.dip0.t-ipconnect.de ([93.204.61.99] helo=aktux)
        by mail.andi.de1.cc with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1hy13F-0002T6-0Y; Wed, 14 Aug 2019 23:43:25 +0200
Received: from andi by aktux with local (Exim 4.92)
        (envelope-from <andreas@kemnade.info>)
        id 1hy13E-0006HI-Mq; Wed, 14 Aug 2019 23:43:24 +0200
From:   Andreas Kemnade <andreas@kemnade.info>
To:     tony@atomide.com, lgirdwood@gmail.com, broonie@kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, sboyd@kernel.org, nm@ti.com,
        vireshk@kernel.org
Cc:     Andreas Kemnade <andreas@kemnade.info>, stable@vger.kernel.org
Subject: [PATCH v2] regulator: twl: voltage lists for vdd1/2 on twl4030
Date:   Wed, 14 Aug 2019 23:43:19 +0200
Message-Id: <20190814214319.24087-1-andreas@kemnade.info>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0 (-)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

_opp_supported_by_regulators() wrongly ignored errors from
regulator_is_supported_voltage(), so it considered errors as
success. Since
commit 498209445124 ("regulator: core: simplify return value on suported_voltage")
regulator_is_supported_voltage() returns a real boolean, so
errors make _opp_supported_by_regulators() return false.

That reveals a problem with the declaration of the VDD1/2
regulators on twl4030.
The VDD1/VDD2 regulators on twl4030 are neither defined with
voltage lists nor with the continuous flag set, so
regulator_is_supported_voltage() returns false and an error
before above mentioned commit (which was considered success)
The result is that after the above mentioned commit cpufreq
does not work properly e.g. dm3730.

[    2.490997] core: _opp_supported_by_regulators: OPP minuV: 1012500 maxuV: 1012500, not supported by regulator
[    2.501617] cpu cpu0: _opp_add: OPP not supported by regulators (300000000)
[    2.509246] core: _opp_supported_by_regulators: OPP minuV: 1200000 maxuV: 1200000, not supported by regulator
[    2.519775] cpu cpu0: _opp_add: OPP not supported by regulators (600000000)
[    2.527313] core: _opp_supported_by_regulators: OPP minuV: 1325000 maxuV: 1325000, not supported by regulator
[    2.537750] cpu cpu0: _opp_add: OPP not supported by regulators (800000000)

The patch fixes declaration of VDD1/2 regulators by
adding proper voltage lists.

Fixes: 498209445124 ("regulator: core: simplify return value on suported_voltage")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
resent because it was rejected by mailing lists, due to technical
issues, sorry for the noise.
changes in v2:
  using a proper voltage list instead of misusing the continuous flag
  subject was regulator: twl: mark vdd1/2 as continuous on twl4030

 drivers/regulator/twl-regulator.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 6fa15b2d6fb3..866b4dd01da9 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -359,6 +359,17 @@ static const u16 VINTANA2_VSEL_table[] = {
 	2500, 2750,
 };
 
+/* 600mV to 1450mV in 12.5 mV steps */
+static const struct regulator_linear_range VDD1_ranges[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 68, 12500)
+};
+
+/* 600mV to 1450mV in 12.5 mV steps, everything above = 1500mV */
+static const struct regulator_linear_range VDD2_ranges[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 68, 12500),
+	REGULATOR_LINEAR_RANGE(1500000, 69, 69, 12500)
+};
+
 static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
@@ -427,6 +438,8 @@ static int twl4030smps_get_voltage(struct regulator_dev *rdev)
 }
 
 static const struct regulator_ops twl4030smps_ops = {
+	.list_voltage   = regulator_list_voltage_linear_range,
+
 	.set_voltage	= twl4030smps_set_voltage,
 	.get_voltage	= twl4030smps_get_voltage,
 };
@@ -466,7 +479,8 @@ static const struct twlreg_info TWL4030_INFO_##label = { \
 		}, \
 	}
 
-#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf) \
+#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf, \
+		n_volt) \
 static const struct twlreg_info TWL4030_INFO_##label = { \
 	.base = offset, \
 	.id = num, \
@@ -479,6 +493,9 @@ static const struct twlreg_info TWL4030_INFO_##label = { \
 		.owner = THIS_MODULE, \
 		.enable_time = turnon_delay, \
 		.of_map_mode = twl4030reg_map_mode, \
+		.n_voltages = n_volt, \
+		.n_linear_ranges = ARRAY_SIZE(label ## _ranges), \
+		.linear_ranges = label ## _ranges, \
 		}, \
 	}
 
@@ -518,8 +535,8 @@ TWL4030_ADJUSTABLE_LDO(VSIM, 0x37, 9, 100, 0x00);
 TWL4030_ADJUSTABLE_LDO(VDAC, 0x3b, 10, 100, 0x08);
 TWL4030_ADJUSTABLE_LDO(VINTANA2, 0x43, 12, 100, 0x08);
 TWL4030_ADJUSTABLE_LDO(VIO, 0x4b, 14, 1000, 0x08);
-TWL4030_ADJUSTABLE_SMPS(VDD1, 0x55, 15, 1000, 0x08);
-TWL4030_ADJUSTABLE_SMPS(VDD2, 0x63, 16, 1000, 0x08);
+TWL4030_ADJUSTABLE_SMPS(VDD1, 0x55, 15, 1000, 0x08, 68);
+TWL4030_ADJUSTABLE_SMPS(VDD2, 0x63, 16, 1000, 0x08, 69);
 /* VUSBCP is managed *only* by the USB subchip */
 TWL4030_FIXED_LDO(VINTANA1, 0x3f, 1500, 11, 100, 0x08);
 TWL4030_FIXED_LDO(VINTDIG, 0x47, 1500, 13, 100, 0x08);
-- 
2.20.1

