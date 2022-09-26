Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48CC5EA3A6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbiIZLaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbiIZL3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F216B8FD;
        Mon, 26 Sep 2022 03:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D520D60A37;
        Mon, 26 Sep 2022 10:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA769C433D6;
        Mon, 26 Sep 2022 10:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188844;
        bh=uqwQ4xFumLZK7vILotRgOAeVPu/TjUochUrYMphEC4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVtBql9Xny+aAQV/emmsj5Za1jV1AyhO67CnWOW82Bcv33FR1HiU/RKKJk2UonTd2
         kUydvM22XA0UYIj5OeFGGY3Tvl5kSKRLZQ6zFXBA9zVlv0D6h9v+Ps7oPysxgK1QGu
         9tIfJKR6IS3YJ0qWAPMxH4Is/jujTI7pj8AlYvjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalil Blaiech <kblaiech@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/148] i2c: mlxbf: Fix frequency calculation
Date:   Mon, 26 Sep 2022 12:12:53 +0200
Message-Id: <20220926100801.432477617@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit 37f071ec327b04c83d47637c5e5c2199b39899ca ]

The i2c-mlxbf.c driver is currently broken because there is a bug
in the calculation of the frequency. core_f, core_r and core_od
are components read from hardware registers and are used to
compute the frequency used to compute different timing parameters.
The shifting mechanism used to get core_f, core_r and core_od is
wrong. Use FIELD_GET to mask and shift the bitfields properly.

Fixes: b5b5b32081cd206b (i2c: mlxbf: I2C SMBus driver for Mellanox BlueField SoC)
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxbf.c | 63 +++++++++++++---------------------
 1 file changed, 23 insertions(+), 40 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index ac93c0ccf53c..ad5efd7497d1 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
@@ -63,13 +64,14 @@
  */
 #define MLXBF_I2C_TYU_PLL_OUT_FREQ  (400 * 1000 * 1000)
 /* Reference clock for Bluefield - 156 MHz. */
-#define MLXBF_I2C_PLL_IN_FREQ       (156 * 1000 * 1000)
+#define MLXBF_I2C_PLL_IN_FREQ       156250000ULL
 
 /* Constant used to determine the PLL frequency. */
-#define MLNXBF_I2C_COREPLL_CONST    16384
+#define MLNXBF_I2C_COREPLL_CONST    16384ULL
+
+#define MLXBF_I2C_FREQUENCY_1GHZ  1000000000ULL
 
 /* PLL registers. */
-#define MLXBF_I2C_CORE_PLL_REG0         0x0
 #define MLXBF_I2C_CORE_PLL_REG1         0x4
 #define MLXBF_I2C_CORE_PLL_REG2         0x8
 
@@ -181,22 +183,15 @@
 #define MLXBF_I2C_COREPLL_FREQ          MLXBF_I2C_TYU_PLL_OUT_FREQ
 
 /* Core PLL TYU configuration. */
-#define MLXBF_I2C_COREPLL_CORE_F_TYU_MASK   GENMASK(12, 0)
-#define MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK  GENMASK(3, 0)
-#define MLXBF_I2C_COREPLL_CORE_R_TYU_MASK   GENMASK(5, 0)
-
-#define MLXBF_I2C_COREPLL_CORE_F_TYU_SHIFT  3
-#define MLXBF_I2C_COREPLL_CORE_OD_TYU_SHIFT 16
-#define MLXBF_I2C_COREPLL_CORE_R_TYU_SHIFT  20
+#define MLXBF_I2C_COREPLL_CORE_F_TYU_MASK   GENMASK(15, 3)
+#define MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK  GENMASK(19, 16)
+#define MLXBF_I2C_COREPLL_CORE_R_TYU_MASK   GENMASK(25, 20)
 
 /* Core PLL YU configuration. */
 #define MLXBF_I2C_COREPLL_CORE_F_YU_MASK    GENMASK(25, 0)
 #define MLXBF_I2C_COREPLL_CORE_OD_YU_MASK   GENMASK(3, 0)
-#define MLXBF_I2C_COREPLL_CORE_R_YU_MASK    GENMASK(5, 0)
+#define MLXBF_I2C_COREPLL_CORE_R_YU_MASK    GENMASK(31, 26)
 
-#define MLXBF_I2C_COREPLL_CORE_F_YU_SHIFT   0
-#define MLXBF_I2C_COREPLL_CORE_OD_YU_SHIFT  1
-#define MLXBF_I2C_COREPLL_CORE_R_YU_SHIFT   26
 
 /* Core PLL frequency. */
 static u64 mlxbf_i2c_corepll_frequency;
@@ -479,8 +474,6 @@ static struct mutex mlxbf_i2c_bus_lock;
 #define MLXBF_I2C_MASK_8    GENMASK(7, 0)
 #define MLXBF_I2C_MASK_16   GENMASK(15, 0)
 
-#define MLXBF_I2C_FREQUENCY_1GHZ  1000000000
-
 /*
  * Function to poll a set of bits at a specific address; it checks whether
  * the bits are equal to zero when eq_zero is set to 'true', and not equal
@@ -1410,24 +1403,19 @@ static int mlxbf_i2c_init_master(struct platform_device *pdev,
 	return 0;
 }
 
-static u64 mlxbf_calculate_freq_from_tyu(struct mlxbf_i2c_resource *corepll_res)
+static u64 mlxbf_i2c_calculate_freq_from_tyu(struct mlxbf_i2c_resource *corepll_res)
 {
-	u64 core_frequency, pad_frequency;
+	u64 core_frequency;
 	u8 core_od, core_r;
 	u32 corepll_val;
 	u16 core_f;
 
-	pad_frequency = MLXBF_I2C_PLL_IN_FREQ;
-
 	corepll_val = readl(corepll_res->io + MLXBF_I2C_CORE_PLL_REG1);
 
 	/* Get Core PLL configuration bits. */
-	core_f = rol32(corepll_val, MLXBF_I2C_COREPLL_CORE_F_TYU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_F_TYU_MASK;
-	core_od = rol32(corepll_val, MLXBF_I2C_COREPLL_CORE_OD_TYU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK;
-	core_r = rol32(corepll_val, MLXBF_I2C_COREPLL_CORE_R_TYU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_R_TYU_MASK;
+	core_f = FIELD_GET(MLXBF_I2C_COREPLL_CORE_F_TYU_MASK, corepll_val);
+	core_od = FIELD_GET(MLXBF_I2C_COREPLL_CORE_OD_TYU_MASK, corepll_val);
+	core_r = FIELD_GET(MLXBF_I2C_COREPLL_CORE_R_TYU_MASK, corepll_val);
 
 	/*
 	 * Compute PLL output frequency as follow:
@@ -1439,31 +1427,26 @@ static u64 mlxbf_calculate_freq_from_tyu(struct mlxbf_i2c_resource *corepll_res)
 	 * Where PLL_OUT_FREQ and PLL_IN_FREQ refer to CoreFrequency
 	 * and PadFrequency, respectively.
 	 */
-	core_frequency = pad_frequency * (++core_f);
+	core_frequency = MLXBF_I2C_PLL_IN_FREQ * (++core_f);
 	core_frequency /= (++core_r) * (++core_od);
 
 	return core_frequency;
 }
 
-static u64 mlxbf_calculate_freq_from_yu(struct mlxbf_i2c_resource *corepll_res)
+static u64 mlxbf_i2c_calculate_freq_from_yu(struct mlxbf_i2c_resource *corepll_res)
 {
 	u32 corepll_reg1_val, corepll_reg2_val;
-	u64 corepll_frequency, pad_frequency;
+	u64 corepll_frequency;
 	u8 core_od, core_r;
 	u32 core_f;
 
-	pad_frequency = MLXBF_I2C_PLL_IN_FREQ;
-
 	corepll_reg1_val = readl(corepll_res->io + MLXBF_I2C_CORE_PLL_REG1);
 	corepll_reg2_val = readl(corepll_res->io + MLXBF_I2C_CORE_PLL_REG2);
 
 	/* Get Core PLL configuration bits */
-	core_f = rol32(corepll_reg1_val, MLXBF_I2C_COREPLL_CORE_F_YU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_F_YU_MASK;
-	core_r = rol32(corepll_reg1_val, MLXBF_I2C_COREPLL_CORE_R_YU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_R_YU_MASK;
-	core_od = rol32(corepll_reg2_val,  MLXBF_I2C_COREPLL_CORE_OD_YU_SHIFT) &
-			MLXBF_I2C_COREPLL_CORE_OD_YU_MASK;
+	core_f = FIELD_GET(MLXBF_I2C_COREPLL_CORE_F_YU_MASK, corepll_reg1_val);
+	core_r = FIELD_GET(MLXBF_I2C_COREPLL_CORE_R_YU_MASK, corepll_reg1_val);
+	core_od = FIELD_GET(MLXBF_I2C_COREPLL_CORE_OD_YU_MASK, corepll_reg2_val);
 
 	/*
 	 * Compute PLL output frequency as follow:
@@ -1475,7 +1458,7 @@ static u64 mlxbf_calculate_freq_from_yu(struct mlxbf_i2c_resource *corepll_res)
 	 * Where PLL_OUT_FREQ and PLL_IN_FREQ refer to CoreFrequency
 	 * and PadFrequency, respectively.
 	 */
-	corepll_frequency = (pad_frequency * core_f) / MLNXBF_I2C_COREPLL_CONST;
+	corepll_frequency = (MLXBF_I2C_PLL_IN_FREQ * core_f) / MLNXBF_I2C_COREPLL_CONST;
 	corepll_frequency /= (++core_r) * (++core_od);
 
 	return corepll_frequency;
@@ -2183,14 +2166,14 @@ static struct mlxbf_i2c_chip_info mlxbf_i2c_chip[] = {
 			[1] = &mlxbf_i2c_corepll_res[MLXBF_I2C_CHIP_TYPE_1],
 			[2] = &mlxbf_i2c_gpio_res[MLXBF_I2C_CHIP_TYPE_1]
 		},
-		.calculate_freq = mlxbf_calculate_freq_from_tyu
+		.calculate_freq = mlxbf_i2c_calculate_freq_from_tyu
 	},
 	[MLXBF_I2C_CHIP_TYPE_2] = {
 		.type = MLXBF_I2C_CHIP_TYPE_2,
 		.shared_res = {
 			[0] = &mlxbf_i2c_corepll_res[MLXBF_I2C_CHIP_TYPE_2]
 		},
-		.calculate_freq = mlxbf_calculate_freq_from_yu
+		.calculate_freq = mlxbf_i2c_calculate_freq_from_yu
 	}
 };
 
-- 
2.35.1



