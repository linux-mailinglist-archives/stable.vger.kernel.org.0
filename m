Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D2E3A6447
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhFNLWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236102AbhFNLUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8272461466;
        Mon, 14 Jun 2021 10:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667909;
        bh=m/z4NCzBVNnu9gE2TcAg+9IsY7y1E/UfVr9f9PZL5HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMAC71qRj71h27R4Z9ZqYOFm/Zc05CT5QoNX5oZcrk1LnJw2Di2vTcnfrfWEh67+Y
         pEB82AIh2QsJ2GIB8b3gSCO2aOldMgO0CrNgA/x03IEovSgO6SdHD8MQMcVMezYtvI
         EPQ91xHEEi8BTX+hzPFDNgu4sIB5ej8jhWFVPdco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 121/173] regulator: atc260x: Fix n_voltages and min_sel for pickable linear ranges
Date:   Mon, 14 Jun 2021 12:27:33 +0200
Message-Id: <20210614102702.193125021@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 1963fa67d78674a110bc9b2a8b1e226967692f05 upstream.

The .n_voltages was missed for pickable linear ranges, fix it.
The min_sel for each pickable range should be starting from 0.
Also fix atc260x_ldo_voltage_range_sel setting (bit 5 - LDO<N>_VOL_SEL
in datasheet).

Fixes: 3b15ccac161a ("regulator: Add regulator driver for ATC260x PMICs")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Link: https://lore.kernel.org/r/20210528230147.363974-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/atc260x-regulator.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/regulator/atc260x-regulator.c
+++ b/drivers/regulator/atc260x-regulator.c
@@ -28,16 +28,16 @@ static const struct linear_range atc2609
 
 static const struct linear_range atc2609a_ldo_voltage_ranges0[] = {
 	REGULATOR_LINEAR_RANGE(700000, 0, 15, 100000),
-	REGULATOR_LINEAR_RANGE(2100000, 16, 28, 100000),
+	REGULATOR_LINEAR_RANGE(2100000, 0, 12, 100000),
 };
 
 static const struct linear_range atc2609a_ldo_voltage_ranges1[] = {
 	REGULATOR_LINEAR_RANGE(850000, 0, 15, 100000),
-	REGULATOR_LINEAR_RANGE(2100000, 16, 27, 100000),
+	REGULATOR_LINEAR_RANGE(2100000, 0, 11, 100000),
 };
 
 static const unsigned int atc260x_ldo_voltage_range_sel[] = {
-	0x0, 0x1,
+	0x0, 0x20,
 };
 
 static int atc260x_dcdc_set_voltage_time_sel(struct regulator_dev *rdev,
@@ -411,7 +411,7 @@ enum atc2609a_reg_ids {
 	.owner = THIS_MODULE, \
 }
 
-#define atc2609a_reg_desc_ldo_range_pick(num, n_range) { \
+#define atc2609a_reg_desc_ldo_range_pick(num, n_range, n_volt) { \
 	.name = "LDO"#num, \
 	.supply_name = "ldo"#num, \
 	.of_match = of_match_ptr("ldo"#num), \
@@ -421,6 +421,7 @@ enum atc2609a_reg_ids {
 	.type = REGULATOR_VOLTAGE, \
 	.linear_ranges = atc2609a_ldo_voltage_ranges##n_range, \
 	.n_linear_ranges = ARRAY_SIZE(atc2609a_ldo_voltage_ranges##n_range), \
+	.n_voltages = n_volt, \
 	.vsel_reg = ATC2609A_PMU_LDO##num##_CTL0, \
 	.vsel_mask = GENMASK(4, 1), \
 	.vsel_range_reg = ATC2609A_PMU_LDO##num##_CTL0, \
@@ -458,12 +459,12 @@ static const struct regulator_desc atc26
 	atc2609a_reg_desc_ldo_bypass(0),
 	atc2609a_reg_desc_ldo_bypass(1),
 	atc2609a_reg_desc_ldo_bypass(2),
-	atc2609a_reg_desc_ldo_range_pick(3, 0),
-	atc2609a_reg_desc_ldo_range_pick(4, 0),
+	atc2609a_reg_desc_ldo_range_pick(3, 0, 29),
+	atc2609a_reg_desc_ldo_range_pick(4, 0, 29),
 	atc2609a_reg_desc_ldo(5),
-	atc2609a_reg_desc_ldo_range_pick(6, 1),
-	atc2609a_reg_desc_ldo_range_pick(7, 0),
-	atc2609a_reg_desc_ldo_range_pick(8, 0),
+	atc2609a_reg_desc_ldo_range_pick(6, 1, 28),
+	atc2609a_reg_desc_ldo_range_pick(7, 0, 29),
+	atc2609a_reg_desc_ldo_range_pick(8, 0, 29),
 	atc2609a_reg_desc_ldo_fixed(9),
 };
 


