Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434BB6A37FF
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjB0CNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjB0CNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:13:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23B91B578;
        Sun, 26 Feb 2023 18:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22E4C60DD5;
        Mon, 27 Feb 2023 02:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45EAC4339B;
        Mon, 27 Feb 2023 02:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463858;
        bh=z8dvXzQ7Krty2ZU/mU0kRCuIel0noyEHBv1WYVhtrpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urqmdZy67ieh3Wr8e/as3yToXiRHeKR3XhJ44h8cYtTZG6gS59nZ+TzBvnaANY5bn
         dx+u2pG5sDYuFanxX/IifEdTBrvVrdutCENL1uZB5htGzLOKFv0hNje9BKPJy97Obz
         2QyAINN120vWmbszxB3SomZ5Bn6hn8Dy9uwi/xkpuZ/uGabNoAQqeEcWLcxexUWFXI
         jBd33zvO/Ei8Cqe85CrY5PJO0IKgkipvn6j517C7D8c+uSGAlCp42lhNOrVzGwe7WL
         sgWm9duZNHmWR8BJCyGawCXxAfTsq7lMloNzwfNc2S9v9tro97JUlopsz7mf0l30TK
         T/jDlG93LB5dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 08/15] regulator: max77802: Bounds check regulator id against opmode
Date:   Sun, 26 Feb 2023 21:10:27 -0500
Message-Id: <20230227021038.1052958-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021038.1052958-1-sashal@kernel.org>
References: <20230227021038.1052958-1-sashal@kernel.org>
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
index 7b8ec8c0bd151..660e179a82a2c 100644
--- a/drivers/regulator/max77802-regulator.c
+++ b/drivers/regulator/max77802-regulator.c
@@ -95,9 +95,11 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
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
@@ -111,7 +113,7 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
@@ -128,6 +130,9 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -136,8 +141,10 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 static unsigned max77802_get_mode(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	return max77802_map_mode(max77802->opmode[id]);
 }
 
@@ -161,10 +168,13 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
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
@@ -210,9 +220,11 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
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
 
@@ -541,7 +553,7 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = regulators[i].id;
+		unsigned int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 		int ret;
 
@@ -559,10 +571,12 @@ static int max77802_pmic_probe(struct platform_device *pdev)
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

