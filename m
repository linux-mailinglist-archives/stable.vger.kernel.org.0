Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDF668114A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbjA3OLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbjA3OLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F2A3B67F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16684B8117B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6D5C433EF;
        Mon, 30 Jan 2023 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087897;
        bh=r8cYJJteDgct7mExJTUuVRYwKVoig31XXj7RoH02RtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kls7Wcho7+NzpM2nXAeio9+0e12+wM/zQPlAABJ7cx4B3t590hkDeDrSsfWJBCh29
         yrkDeH0iTm+p3rzlxf+EsHxfrebrwDUJNdV1QfW9hRKqORw4Ed5SqvSQYH8lRtc4+L
         RxMuQ5HQ3XGdbWQsMMsxKkzzGcuChokSuNT+4MZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/204] pinctrl/rockchip: add error handling for pull/drive register getters
Date:   Mon, 30 Jan 2023 14:50:12 +0100
Message-Id: <20230130134318.389286011@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 42573ab3b9f94fbeba8b84e142703ea551624f6d ]

Add error handling for the pull and driver register getters in preparation
for RK3588 support.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Heiko Stübner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20220422170920.401914-13-sebastian.reichel@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 31b62a98de42 ("pinctrl: rockchip: fix reading pull type on rk3568")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 168 ++++++++++++++++++-----------
 drivers/pinctrl/pinctrl-rockchip.h |   4 +-
 2 files changed, 109 insertions(+), 63 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index fcff8e7798b3..4888840dfc33 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1039,9 +1039,9 @@ static int rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 #define PX30_PULL_PINS_PER_REG		8
 #define PX30_PULL_BANK_STRIDE		16
 
-static void px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				       int pin_num, struct regmap **regmap,
-				       int *reg, u8 *bit)
+static int px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+				      int pin_num, struct regmap **regmap,
+				      int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1061,6 +1061,8 @@ static void px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / PX30_PULL_PINS_PER_REG) * 4);
 	*bit = (pin_num % PX30_PULL_PINS_PER_REG);
 	*bit *= PX30_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define PX30_DRV_PMU_OFFSET		0x20
@@ -1069,9 +1071,9 @@ static void px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define PX30_DRV_PINS_PER_REG		8
 #define PX30_DRV_BANK_STRIDE		16
 
-static void px30_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				      int pin_num, struct regmap **regmap,
-				      int *reg, u8 *bit)
+static int px30_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				     int pin_num, struct regmap **regmap,
+				     int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1091,6 +1093,8 @@ static void px30_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / PX30_DRV_PINS_PER_REG) * 4);
 	*bit = (pin_num % PX30_DRV_PINS_PER_REG);
 	*bit *= PX30_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define PX30_SCHMITT_PMU_OFFSET			0x38
@@ -1130,9 +1134,9 @@ static int px30_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RV1108_PULL_BITS_PER_PIN	2
 #define RV1108_PULL_BANK_STRIDE		16
 
-static void rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1151,6 +1155,8 @@ static void rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / RV1108_PULL_PINS_PER_REG) * 4);
 	*bit = (pin_num % RV1108_PULL_PINS_PER_REG);
 	*bit *= RV1108_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RV1108_DRV_PMU_OFFSET		0x20
@@ -1159,9 +1165,9 @@ static void rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RV1108_DRV_PINS_PER_REG		8
 #define RV1108_DRV_BANK_STRIDE		16
 
-static void rv1108_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-					int pin_num, struct regmap **regmap,
-					int *reg, u8 *bit)
+static int rv1108_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1181,6 +1187,8 @@ static void rv1108_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / RV1108_DRV_PINS_PER_REG) * 4);
 	*bit = pin_num % RV1108_DRV_PINS_PER_REG;
 	*bit *= RV1108_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RV1108_SCHMITT_PMU_OFFSET		0x30
@@ -1237,9 +1245,9 @@ static int rk3308_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK2928_PULL_PINS_PER_REG	16
 #define RK2928_PULL_BANK_STRIDE		8
 
-static void rk2928_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk2928_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1249,13 +1257,15 @@ static void rk2928_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += (pin_num / RK2928_PULL_PINS_PER_REG) * 4;
 
 	*bit = pin_num % RK2928_PULL_PINS_PER_REG;
+
+	return 0;
 };
 
 #define RK3128_PULL_OFFSET	0x118
 
-static void rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1265,6 +1275,8 @@ static void rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / RK2928_PULL_PINS_PER_REG) * 4);
 
 	*bit = pin_num % RK2928_PULL_PINS_PER_REG;
+
+	return 0;
 }
 
 #define RK3188_PULL_OFFSET		0x164
@@ -1273,9 +1285,9 @@ static void rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3188_PULL_BANK_STRIDE		16
 #define RK3188_PULL_PMU_OFFSET		0x64
 
-static void rk3188_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3188_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1305,12 +1317,14 @@ static void rk3188_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = 7 - (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3288_PULL_OFFSET		0x140
-static void rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1334,6 +1348,8 @@ static void rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3288_DRV_PMU_OFFSET		0x70
@@ -1342,9 +1358,9 @@ static void rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3288_DRV_PINS_PER_REG		8
 #define RK3288_DRV_BANK_STRIDE		16
 
-static void rk3288_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3288_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1368,13 +1384,15 @@ static void rk3288_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 		*bit *= RK3288_DRV_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3228_PULL_OFFSET		0x100
 
-static void rk3228_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3228_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1385,13 +1403,15 @@ static void rk3228_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 	*bit *= RK3188_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3228_DRV_GRF_OFFSET		0x200
 
-static void rk3228_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3228_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1402,13 +1422,15 @@ static void rk3228_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 	*bit *= RK3288_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3308_PULL_OFFSET		0xa0
 
-static void rk3308_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3308_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1419,13 +1441,15 @@ static void rk3308_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 	*bit *= RK3188_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3308_DRV_GRF_OFFSET		0x100
 
-static void rk3308_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3308_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1436,14 +1460,16 @@ static void rk3308_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 	*bit *= RK3288_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3368_PULL_GRF_OFFSET		0x100
 #define RK3368_PULL_PMU_OFFSET		0x10
 
-static void rk3368_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3368_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1467,14 +1493,16 @@ static void rk3368_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3368_DRV_PMU_OFFSET		0x20
 #define RK3368_DRV_GRF_OFFSET		0x200
 
-static void rk3368_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3368_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1498,15 +1526,17 @@ static void rk3368_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 		*bit *= RK3288_DRV_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3399_PULL_GRF_OFFSET		0xe040
 #define RK3399_PULL_PMU_OFFSET		0x40
 #define RK3399_DRV_3BITS_PER_PIN	3
 
-static void rk3399_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rk3399_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1532,11 +1562,13 @@ static void rk3399_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
-static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-					int pin_num, struct regmap **regmap,
-					int *reg, u8 *bit)
+static int rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	int drv_num = (pin_num / 8);
@@ -1553,6 +1585,8 @@ static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % 8) * 3;
 	else
 		*bit = (pin_num % 8) * 2;
+
+	return 0;
 }
 
 #define RK3568_PULL_PMU_OFFSET		0x20
@@ -1561,9 +1595,9 @@ static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3568_PULL_PINS_PER_REG	8
 #define RK3568_PULL_BANK_STRIDE		0x10
 
-static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1584,6 +1618,8 @@ static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3568_PULL_PINS_PER_REG);
 		*bit *= RK3568_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3568_DRV_PMU_OFFSET		0x70
@@ -1592,9 +1628,9 @@ static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3568_DRV_PINS_PER_REG		2
 #define RK3568_DRV_BANK_STRIDE		0x40
 
-static void rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-					int pin_num, struct regmap **regmap,
-					int *reg, u8 *bit)
+static int rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1615,6 +1651,8 @@ static void rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3568_DRV_PINS_PER_REG);
 		*bit *= RK3568_DRV_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 static int rockchip_perpin_drv_list[DRV_TYPE_MAX][8] = {
@@ -1637,7 +1675,9 @@ static int rockchip_get_drive_perpin(struct rockchip_pin_bank *bank,
 	u8 bit;
 	int drv_type = bank->drv[pin_num / 8].drv_type;
 
-	ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 
 	switch (drv_type) {
 	case DRV_TYPE_IO_1V8_3V0_AUTO:
@@ -1717,7 +1757,9 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 	dev_dbg(dev, "setting drive of GPIO%d-%d to %d\n",
 		bank->bank_num, pin_num, strength);
 
-	ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 	if (ctrl->type == RK3568) {
 		rmask_bits = RK3568_DRV_BITS_PER_PIN;
 		ret = (1 << (strength + 1)) - 1;
@@ -1830,7 +1872,9 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	if (ctrl->type == RK3066B)
 		return PIN_CONFIG_BIAS_DISABLE;
 
-	ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 
 	ret = regmap_read(regmap, reg, &data);
 	if (ret)
@@ -1877,7 +1921,9 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	if (ctrl->type == RK3066B)
 		return pull ? -EINVAL : 0;
 
-	ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 
 	switch (ctrl->type) {
 	case RK2928:
diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
index 98a01a616da6..59116e13758d 100644
--- a/drivers/pinctrl/pinctrl-rockchip.h
+++ b/drivers/pinctrl/pinctrl-rockchip.h
@@ -230,10 +230,10 @@ struct rockchip_pin_ctrl {
 	struct rockchip_mux_route_data *iomux_routes;
 	u32				niomux_routes;
 
-	void	(*pull_calc_reg)(struct rockchip_pin_bank *bank,
+	int	(*pull_calc_reg)(struct rockchip_pin_bank *bank,
 				    int pin_num, struct regmap **regmap,
 				    int *reg, u8 *bit);
-	void	(*drv_calc_reg)(struct rockchip_pin_bank *bank,
+	int	(*drv_calc_reg)(struct rockchip_pin_bank *bank,
 				    int pin_num, struct regmap **regmap,
 				    int *reg, u8 *bit);
 	int	(*schmitt_calc_reg)(struct rockchip_pin_bank *bank,
-- 
2.39.0



