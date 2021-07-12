Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A733C4681
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhGLG0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235235AbhGLGZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E3E561108;
        Mon, 12 Jul 2021 06:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070952;
        bh=+T3T32pRV5cdKCPUZQOH1EjPZLywNUXkjRyqIJN4Nx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAlHG0xQK4zeVmeUtt658YcSUJ4sf/RALi48LuHgmoEsifnmo1dbpsYhDmfZ0ZXA8
         bhJRrWRT9jqxpM9zRL8rQOtJbPoMfrwQyUouVWhIhdgwnczSAQr2k2MFI2dnWQVZul
         CSJJVr1GX70IixQBn+uWhcqIxBFk+MdKJtgxzv7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/348] regulator: hi655x: Fix pass wrong pointer to config.driver_data
Date:   Mon, 12 Jul 2021 08:09:12 +0200
Message-Id: <20210712060723.179788148@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 61eb1b24f9e4f4e0725aa5f8164a932c933f3339 ]

Current code sets config.driver_data to a zero initialized regulator
which is obviously wrong. Fix it.

Fixes: 4618119b9be5 ("regulator: hi655x: enable regulator for hi655x PMIC")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210620132715.60215-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/hi655x-regulator.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/hi655x-regulator.c b/drivers/regulator/hi655x-regulator.c
index ac2ee2030211..b44f492a2b83 100644
--- a/drivers/regulator/hi655x-regulator.c
+++ b/drivers/regulator/hi655x-regulator.c
@@ -72,7 +72,7 @@ enum hi655x_regulator_id {
 static int hi655x_is_enabled(struct regulator_dev *rdev)
 {
 	unsigned int value = 0;
-	struct hi655x_regulator *regulator = rdev_get_drvdata(rdev);
+	const struct hi655x_regulator *regulator = rdev_get_drvdata(rdev);
 
 	regmap_read(rdev->regmap, regulator->status_reg, &value);
 	return (value & rdev->desc->enable_mask);
@@ -80,7 +80,7 @@ static int hi655x_is_enabled(struct regulator_dev *rdev)
 
 static int hi655x_disable(struct regulator_dev *rdev)
 {
-	struct hi655x_regulator *regulator = rdev_get_drvdata(rdev);
+	const struct hi655x_regulator *regulator = rdev_get_drvdata(rdev);
 
 	return regmap_write(rdev->regmap, regulator->disable_reg,
 			    rdev->desc->enable_mask);
@@ -169,7 +169,6 @@ static const struct hi655x_regulator regulators[] = {
 static int hi655x_regulator_probe(struct platform_device *pdev)
 {
 	unsigned int i;
-	struct hi655x_regulator *regulator;
 	struct hi655x_pmic *pmic;
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
@@ -180,22 +179,17 @@ static int hi655x_regulator_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	regulator = devm_kzalloc(&pdev->dev, sizeof(*regulator), GFP_KERNEL);
-	if (!regulator)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, regulator);
-
 	config.dev = pdev->dev.parent;
 	config.regmap = pmic->regmap;
-	config.driver_data = regulator;
 	for (i = 0; i < ARRAY_SIZE(regulators); i++) {
+		config.driver_data = (void *) &regulators[i];
+
 		rdev = devm_regulator_register(&pdev->dev,
 					       &regulators[i].rdesc,
 					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
-				regulator->rdesc.name);
+				regulators[i].rdesc.name);
 			return PTR_ERR(rdev);
 		}
 	}
-- 
2.30.2



