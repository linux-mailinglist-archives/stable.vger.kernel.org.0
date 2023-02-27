Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BD96A38C9
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjB0ChW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjB0ChD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:37:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CB8A5C4;
        Sun, 26 Feb 2023 18:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12A2DB80CAD;
        Mon, 27 Feb 2023 02:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A81C4339C;
        Mon, 27 Feb 2023 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463780;
        bh=PmZIcR3rnG+GkjF4hrNTBOCL305GGNhBAfTgxL7vco0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ogick6YzYEgT6QlhMWu9ZTELkkV3qWDL1Q7Elvl6azINJae+zbXQPCHorHsKy5Y4Q
         KOz9fnhKt296VCl5U5BcABpmk+0TbQ+Yd7/fqSWODNE59dhqvnJUy81AabfAN/3iBW
         g87oE2HgZj3Vq7zED7oMxip1lpsNMlPBBWyTVP7MSEomHCb0KwzcReaz8J9bJTpO/n
         lOIr7lf1q1kKd9KTM+hq/jkK0+VvVU2aRxpoh74fmOQB4WyxIO8xkjA5C3+geFOKzV
         tBlkVT15irNgBwAkkvcudl/JpepmlEbg8dgz5RYKvkGe3qWZbJYBt7SHChTzETBTzk
         QoQTUQwEAzSAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 15/25] regulator: max77802: Bounds check regulator id against opmode
Date:   Sun, 26 Feb 2023 21:08:38 -0500
Message-Id: <20230227020855.1051605-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4fd8bcec5fd7c0d586206fa2f42bd67b06cdaa7e ]

Explicitly bounds-check the id before accessing the opmode array. Seen
with GCC 13:

../drivers/regulator/max77802-regulator.c: In function 'max77802_enable':
../drivers/regulator/max77802-regulator.c:217:29: warning: array subscript [0, 41] is outside array bounds of 'unsigned int[42]' [-Warray-bounds=]
  217 |         if (max77802->opmode[id] == MAX77802_OFF_PWRREQ)
      |             ~~~~~~~~~~~~~~~~^~~~
../drivers/regulator/max77802-regulator.c:62:22: note: while referencing 'opmode'
   62 |         unsigned int opmode[MAX77802_REG_MAX];
      |                      ^~~~~~

Cc: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20230127225203.never.864-kees@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max77802-regulator.c | 34 ++++++++++++++++++--------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/max77802-regulator.c b/drivers/regulator/max77802-regulator.c
index 21e0eb0f43f94..befe5f319819b 100644
--- a/drivers/regulator/max77802-regulator.c
+++ b/drivers/regulator/max77802-regulator.c
@@ -94,9 +94,11 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val = MAX77802_OFF_PWRREQ;
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	int shift = max77802_get_opmode_shift(id);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -110,7 +112,7 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
@@ -127,6 +129,9 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -135,8 +140,10 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 static unsigned max77802_get_mode(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	return max77802_map_mode(max77802->opmode[id]);
 }
 
@@ -160,10 +167,13 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	/*
 	 * If the regulator has been disabled for suspend
 	 * then is invalid to try setting a suspend mode.
@@ -209,9 +219,11 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 static int max77802_enable(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	int shift = max77802_get_opmode_shift(id);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	if (max77802->opmode[id] == MAX77802_OFF_PWRREQ)
 		max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
 
@@ -495,7 +507,7 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = regulators[i].id;
+		unsigned int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 		int ret;
 
@@ -513,10 +525,12 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		 * the hardware reports OFF as the regulator operating mode.
 		 * Default to operating mode NORMAL in that case.
 		 */
-		if (val == MAX77802_STATUS_OFF)
-			max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
-		else
-			max77802->opmode[id] = val;
+		if (id < ARRAY_SIZE(max77802->opmode)) {
+			if (val == MAX77802_STATUS_OFF)
+				max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
+			else
+				max77802->opmode[id] = val;
+		}
 
 		rdev = devm_regulator_register(&pdev->dev,
 					       &regulators[i], &config);
-- 
2.39.0

