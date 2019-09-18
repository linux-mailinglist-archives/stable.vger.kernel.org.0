Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B04B5CA7
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfIRG1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730517AbfIRG1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6AF218AF;
        Wed, 18 Sep 2019 06:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788043;
        bh=NElYCYZtG7ndIFLE/NKXMfydXZ+MIdGYUXPQCEkD1Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VipZztlDM8+nTtFv+n/7PFph16xE6AqWEjP+N61A6mHea5SwrysaAcr1PbjAfpXZZ
         OJXnKmQ0WrJZfgsZ7yzf20kMAY6ptfdDLsTu1hD1wDZmyFbHySHF0c7N4NxOk5ilGd
         2R9rJza0m8JpX8spf05ZH4kISEDzZc6OhuNT34xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>, Adam Ford <aford173@gmail.com>
Subject: [PATCH 5.2 42/85] regulator: twl: voltage lists for vdd1/2 on twl4030
Date:   Wed, 18 Sep 2019 08:19:00 +0200
Message-Id: <20190918061235.470837048@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

commit 3829100a63724f6dbf264b2a7f06e7f638ed952d upstream.

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
Tested-by: Adam Ford <aford173@gmail.com> #logicpd-torpedo-37xx-devkit
Link: https://lore.kernel.org/r/20190814214319.24087-1-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/twl-regulator.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -359,6 +359,17 @@ static const u16 VINTANA2_VSEL_table[] =
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
@@ -427,6 +438,8 @@ static int twl4030smps_get_voltage(struc
 }
 
 static const struct regulator_ops twl4030smps_ops = {
+	.list_voltage   = regulator_list_voltage_linear_range,
+
 	.set_voltage	= twl4030smps_set_voltage,
 	.get_voltage	= twl4030smps_get_voltage,
 };
@@ -466,7 +479,8 @@ static const struct twlreg_info TWL4030_
 		}, \
 	}
 
-#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf) \
+#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf, \
+		n_volt) \
 static const struct twlreg_info TWL4030_INFO_##label = { \
 	.base = offset, \
 	.id = num, \
@@ -479,6 +493,9 @@ static const struct twlreg_info TWL4030_
 		.owner = THIS_MODULE, \
 		.enable_time = turnon_delay, \
 		.of_map_mode = twl4030reg_map_mode, \
+		.n_voltages = n_volt, \
+		.n_linear_ranges = ARRAY_SIZE(label ## _ranges), \
+		.linear_ranges = label ## _ranges, \
 		}, \
 	}
 
@@ -518,8 +535,8 @@ TWL4030_ADJUSTABLE_LDO(VSIM, 0x37, 9, 10
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


