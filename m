Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAF20DBB9
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbgF2UJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbgF2TaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A1325253;
        Mon, 29 Jun 2020 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444965;
        bh=g5GMusCJAl+kxwQXLRfhojISqOeZ1LeALycbFAuhyU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpCWMayGXukkhsVVGc9V4Fp8GSYSJa59TkGMVy/XkwTrLtU1zwkSDjEzKEmqu82WC
         /jFzuaK9hvDKSEBT8PRRyNjfEKLV4ne2slV6pNqRpk57iIr4XSl3pIsfzQTDoYXV6R
         8J6p0do1vIGlrEjNcir4m81nOpjgpi829bBFcK78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Gong <yibin.gong@nxp.com>,
        Christophe Meynard <Christophe.Meynard@ign.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/131] regualtor: pfuze100: correct sw1a/sw2 on pfuze3000
Date:   Mon, 29 Jun 2020 11:33:55 -0400
Message-Id: <20200629153502.2494656-65-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit 6f1cf5257acc6e6242ddf2f52bc7912aed77b79f ]

PFUZE100_SWB_REG is not proper for sw1a/sw2, because enable_mask/enable_reg
is not correct. On PFUZE3000, sw1a/sw2 should be the same as sw1a/sw2 on
pfuze100 except that voltages are not linear, so add new PFUZE3000_SW_REG
and pfuze3000_sw_regulator_ops which like the non-linear PFUZE100_SW_REG
and pfuze100_sw_regulator_ops.

Fixes: 1dced996ee70 ("regulator: pfuze100: update voltage setting for pfuze3000 sw1a")
Reported-by: Christophe Meynard <Christophe.Meynard@ign.fr>
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Link: https://lore.kernel.org/r/1592171648-8752-1-git-send-email-yibin.gong@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pfuze100-regulator.c | 60 +++++++++++++++++---------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 69a377ab26041..30e92a9cc97e9 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -196,6 +196,19 @@ static const struct regulator_ops pfuze100_swb_regulator_ops = {
 
 };
 
+static const struct regulator_ops pfuze3000_sw_regulator_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_time_sel = regulator_set_voltage_time_sel,
+	.set_ramp_delay = pfuze100_set_ramp_delay,
+
+};
+
 #define PFUZE100_FIXED_REG(_chip, _name, base, voltage)	\
 	[_chip ## _ ## _name] = {	\
 		.desc = {	\
@@ -305,23 +318,28 @@ static const struct regulator_ops pfuze100_swb_regulator_ops = {
 	.stby_mask = 0x20,	\
 }
 
-
-#define PFUZE3000_SW2_REG(_chip, _name, base, min, max, step)	{	\
-	.desc = {	\
-		.name = #_name,\
-		.n_voltages = ((max) - (min)) / (step) + 1,	\
-		.ops = &pfuze100_sw_regulator_ops,	\
-		.type = REGULATOR_VOLTAGE,	\
-		.id = _chip ## _ ## _name,	\
-		.owner = THIS_MODULE,	\
-		.min_uV = (min),	\
-		.uV_step = (step),	\
-		.vsel_reg = (base) + PFUZE100_VOL_OFFSET,	\
-		.vsel_mask = 0x7,	\
-	},	\
-	.stby_reg = (base) + PFUZE100_STANDBY_OFFSET,	\
-	.stby_mask = 0x7,	\
-}
+/* No linar case for the some switches of PFUZE3000 */
+#define PFUZE3000_SW_REG(_chip, _name, base, mask, voltages)	\
+	[_chip ## _ ##  _name] = {	\
+		.desc = {	\
+			.name = #_name,	\
+			.n_voltages = ARRAY_SIZE(voltages),	\
+			.ops = &pfuze3000_sw_regulator_ops,	\
+			.type = REGULATOR_VOLTAGE,	\
+			.id = _chip ## _ ## _name,	\
+			.owner = THIS_MODULE,	\
+			.volt_table = voltages,	\
+			.vsel_reg = (base) + PFUZE100_VOL_OFFSET,	\
+			.vsel_mask = (mask),	\
+			.enable_reg = (base) + PFUZE100_MODE_OFFSET,	\
+			.enable_mask = 0xf,	\
+			.enable_val = 0x8,	\
+			.enable_time = 500,	\
+		},	\
+		.stby_reg = (base) + PFUZE100_STANDBY_OFFSET,	\
+		.stby_mask = (mask),	\
+		.sw_reg = true,		\
+	}
 
 #define PFUZE3000_SW3_REG(_chip, _name, base, min, max, step)	{	\
 	.desc = {	\
@@ -377,9 +395,9 @@ static struct pfuze_regulator pfuze200_regulators[] = {
 };
 
 static struct pfuze_regulator pfuze3000_regulators[] = {
-	PFUZE100_SWB_REG(PFUZE3000, SW1A, PFUZE100_SW1ABVOL, 0x1f, pfuze3000_sw1a),
+	PFUZE3000_SW_REG(PFUZE3000, SW1A, PFUZE100_SW1ABVOL, 0x1f, pfuze3000_sw1a),
 	PFUZE100_SW_REG(PFUZE3000, SW1B, PFUZE100_SW1CVOL, 700000, 1475000, 25000),
-	PFUZE100_SWB_REG(PFUZE3000, SW2, PFUZE100_SW2VOL, 0x7, pfuze3000_sw2lo),
+	PFUZE3000_SW_REG(PFUZE3000, SW2, PFUZE100_SW2VOL, 0x7, pfuze3000_sw2lo),
 	PFUZE3000_SW3_REG(PFUZE3000, SW3, PFUZE100_SW3AVOL, 900000, 1650000, 50000),
 	PFUZE100_SWB_REG(PFUZE3000, SWBST, PFUZE100_SWBSTCON1, 0x3, pfuze100_swbst),
 	PFUZE100_SWB_REG(PFUZE3000, VSNVS, PFUZE100_VSNVSVOL, 0x7, pfuze100_vsnvs),
@@ -393,8 +411,8 @@ static struct pfuze_regulator pfuze3000_regulators[] = {
 };
 
 static struct pfuze_regulator pfuze3001_regulators[] = {
-	PFUZE100_SWB_REG(PFUZE3001, SW1, PFUZE100_SW1ABVOL, 0x1f, pfuze3000_sw1a),
-	PFUZE100_SWB_REG(PFUZE3001, SW2, PFUZE100_SW2VOL, 0x7, pfuze3000_sw2lo),
+	PFUZE3000_SW_REG(PFUZE3001, SW1, PFUZE100_SW1ABVOL, 0x1f, pfuze3000_sw1a),
+	PFUZE3000_SW_REG(PFUZE3001, SW2, PFUZE100_SW2VOL, 0x7, pfuze3000_sw2lo),
 	PFUZE3000_SW3_REG(PFUZE3001, SW3, PFUZE100_SW3AVOL, 900000, 1650000, 50000),
 	PFUZE100_SWB_REG(PFUZE3001, VSNVS, PFUZE100_VSNVSVOL, 0x7, pfuze100_vsnvs),
 	PFUZE100_VGEN_REG(PFUZE3001, VLDO1, PFUZE100_VGEN1VOL, 1800000, 3300000, 100000),
-- 
2.25.1

