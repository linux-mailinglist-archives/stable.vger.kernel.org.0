Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF832CA947
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391046AbfJCQkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392224AbfJCQkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:40:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B2620830;
        Thu,  3 Oct 2019 16:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120799;
        bh=Ln47ydx473W+6KQNzCPk61eWAr9+pKosg4/WQNSro/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrApFRN7NCG5zOEfftoUw8dCm9XUi/8IyGMB6GPOT999u3dcSeaw9lK+0XtozUAz3
         yqV0FW9lwTprJPdO0Ih2pGgzPEMD7d0BzXWkMY2y/ndlG3Jy9m0kzQfacstQl/FN93
         33YYTrPu090Q38OZNc6nW/wQQaP9f5ocRlJXU4RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 043/344] regulator: lm363x: Fix n_voltages setting for lm36274
Date:   Thu,  3 Oct 2019 17:50:08 +0200
Message-Id: <20191003154544.330014106@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 962f170d9344e5d9edb3903971c591f42d55e226 ]

According to the datasheet http://www.ti.com/lit/ds/symlink/lm36274.pdf:
Table 23. VPOS Bias Register Field Descriptions VPOS[5:0]:
VPOS voltage (50-mV steps): VPOS = 4 V + (Code × 50 mV), 6.5 V max
000000 = 4 V
000001 = 4.05 V
:
011110 = 5.5 V (Default)
:
110010 = 6.5 V
110011 to 111111 map to 6.5 V

So the LM36274_LDO_VSEL_MAX should be 0b110010 (0x32).
The valid selectors are 0 ... LM36274_LDO_VSEL_MAX, n_voltages should be
LM36274_LDO_VSEL_MAX + 1. Similarly, the n_voltages should be
LM36274_BOOST_VSEL_MAX + 1 for LM36274_BOOST.

Fixes: bff5e8071533 ("regulator: lm363x: Add support for LM36274")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20190626132632.32629-2-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/lm363x-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/lm363x-regulator.c b/drivers/regulator/lm363x-regulator.c
index e4a27d63bf901..4b9f618b07e97 100644
--- a/drivers/regulator/lm363x-regulator.c
+++ b/drivers/regulator/lm363x-regulator.c
@@ -36,7 +36,7 @@
 
 /* LM36274 */
 #define LM36274_BOOST_VSEL_MAX		0x3f
-#define LM36274_LDO_VSEL_MAX		0x34
+#define LM36274_LDO_VSEL_MAX		0x32
 #define LM36274_VOLTAGE_MIN		4000000
 
 /* Common */
@@ -226,7 +226,7 @@ static const struct regulator_desc lm363x_regulator_desc[] = {
 		.of_match	= "vboost",
 		.id             = LM36274_BOOST,
 		.ops            = &lm363x_boost_voltage_table_ops,
-		.n_voltages     = LM36274_BOOST_VSEL_MAX,
+		.n_voltages     = LM36274_BOOST_VSEL_MAX + 1,
 		.min_uV         = LM36274_VOLTAGE_MIN,
 		.uV_step        = LM363X_STEP_50mV,
 		.type           = REGULATOR_VOLTAGE,
@@ -239,7 +239,7 @@ static const struct regulator_desc lm363x_regulator_desc[] = {
 		.of_match	= "vpos",
 		.id             = LM36274_LDO_POS,
 		.ops            = &lm363x_regulator_voltage_table_ops,
-		.n_voltages     = LM36274_LDO_VSEL_MAX,
+		.n_voltages     = LM36274_LDO_VSEL_MAX + 1,
 		.min_uV         = LM36274_VOLTAGE_MIN,
 		.uV_step        = LM363X_STEP_50mV,
 		.type           = REGULATOR_VOLTAGE,
@@ -254,7 +254,7 @@ static const struct regulator_desc lm363x_regulator_desc[] = {
 		.of_match	= "vneg",
 		.id             = LM36274_LDO_NEG,
 		.ops            = &lm363x_regulator_voltage_table_ops,
-		.n_voltages     = LM36274_LDO_VSEL_MAX,
+		.n_voltages     = LM36274_LDO_VSEL_MAX + 1,
 		.min_uV         = LM36274_VOLTAGE_MIN,
 		.uV_step        = LM363X_STEP_50mV,
 		.type           = REGULATOR_VOLTAGE,
-- 
2.20.1



