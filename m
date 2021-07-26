Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4746E3D6197
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhGZPcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhGZPaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DB1C60F5E;
        Mon, 26 Jul 2021 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315839;
        bh=u+nrYs8kgIxkE78GC04cHDkkMC7HisEe6KV2i+EgDj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtJlFcPjoKYNtz0yLGZ1TqzUO7STcUwiklu8laJbIFPa07sq9r3sCrhLCMhhpIIXk
         hEXfMTFQiiplolaKEY3DwAHMt5QocBOdsj293Mphi8vWfW0D+it/XCMEoALF1wWxXv
         RuKU9N7A5L/hVLznOXmYJvMEaeBh4K0Wl32IU5lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 070/223] regulator: hi6421: Fix getting wrong drvdata
Date:   Mon, 26 Jul 2021 17:37:42 +0200
Message-Id: <20210726153848.545127465@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 1c73daee4bf30ccdff5e86dc400daa6f74735da5 ]

Since config.dev = pdev->dev.parent in current code, so
dev_get_drvdata(rdev->dev.parent) call in hi6421_regulator_enable
returns the drvdata of the mfd device rather than the regulator. Fix it.

This was broken while converting to use simplified DT parsing because the
config.dev changed from pdev->dev to pdev->dev.parent for parsing the
parent's of_node.

Fixes: 29dc269a85ef ("regulator: hi6421: Convert to use simplified DT parsing")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210630095959.2411543-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/hi6421-regulator.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
index bff8c515dcde..d144a4bdb76d 100644
--- a/drivers/regulator/hi6421-regulator.c
+++ b/drivers/regulator/hi6421-regulator.c
@@ -366,9 +366,8 @@ static struct hi6421_regulator_info
 
 static int hi6421_regulator_enable(struct regulator_dev *rdev)
 {
-	struct hi6421_regulator_pdata *pdata;
+	struct hi6421_regulator_pdata *pdata = rdev_get_drvdata(rdev);
 
-	pdata = dev_get_drvdata(rdev->dev.parent);
 	/* hi6421 spec requires regulator enablement must be serialized:
 	 *  - Because when BUCK, LDO switching from off to on, it will have
 	 *    a huge instantaneous current; so you can not turn on two or
@@ -385,9 +384,10 @@ static int hi6421_regulator_enable(struct regulator_dev *rdev)
 
 static unsigned int hi6421_regulator_ldo_get_mode(struct regulator_dev *rdev)
 {
-	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
+	struct hi6421_regulator_info *info;
 	unsigned int reg_val;
 
+	info = container_of(rdev->desc, struct hi6421_regulator_info, desc);
 	regmap_read(rdev->regmap, rdev->desc->enable_reg, &reg_val);
 	if (reg_val & info->mode_mask)
 		return REGULATOR_MODE_IDLE;
@@ -397,9 +397,10 @@ static unsigned int hi6421_regulator_ldo_get_mode(struct regulator_dev *rdev)
 
 static unsigned int hi6421_regulator_buck_get_mode(struct regulator_dev *rdev)
 {
-	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
+	struct hi6421_regulator_info *info;
 	unsigned int reg_val;
 
+	info = container_of(rdev->desc, struct hi6421_regulator_info, desc);
 	regmap_read(rdev->regmap, rdev->desc->enable_reg, &reg_val);
 	if (reg_val & info->mode_mask)
 		return REGULATOR_MODE_STANDBY;
@@ -410,9 +411,10 @@ static unsigned int hi6421_regulator_buck_get_mode(struct regulator_dev *rdev)
 static int hi6421_regulator_ldo_set_mode(struct regulator_dev *rdev,
 						unsigned int mode)
 {
-	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
+	struct hi6421_regulator_info *info;
 	unsigned int new_mode;
 
+	info = container_of(rdev->desc, struct hi6421_regulator_info, desc);
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
 		new_mode = 0;
@@ -434,9 +436,10 @@ static int hi6421_regulator_ldo_set_mode(struct regulator_dev *rdev,
 static int hi6421_regulator_buck_set_mode(struct regulator_dev *rdev,
 						unsigned int mode)
 {
-	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
+	struct hi6421_regulator_info *info;
 	unsigned int new_mode;
 
+	info = container_of(rdev->desc, struct hi6421_regulator_info, desc);
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
 		new_mode = 0;
@@ -459,7 +462,9 @@ static unsigned int
 hi6421_regulator_ldo_get_optimum_mode(struct regulator_dev *rdev,
 			int input_uV, int output_uV, int load_uA)
 {
-	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
+	struct hi6421_regulator_info *info;
+
+	info = container_of(rdev->desc, struct hi6421_regulator_info, desc);
 
 	if (load_uA > info->eco_microamp)
 		return REGULATOR_MODE_NORMAL;
@@ -543,14 +548,13 @@ static int hi6421_regulator_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENOMEM;
 	mutex_init(&pdata->lock);
-	platform_set_drvdata(pdev, pdata);
 
 	for (i = 0; i < ARRAY_SIZE(hi6421_regulator_info); i++) {
 		/* assign per-regulator data */
 		info = &hi6421_regulator_info[i];
 
 		config.dev = pdev->dev.parent;
-		config.driver_data = info;
+		config.driver_data = pdata;
 		config.regmap = pmic->regmap;
 
 		rdev = devm_regulator_register(&pdev->dev, &info->desc,
-- 
2.30.2



