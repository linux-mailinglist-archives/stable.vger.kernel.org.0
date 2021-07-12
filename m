Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A956D3C52BB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243817AbhGLHs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346564AbhGLHqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D252E61403;
        Mon, 12 Jul 2021 07:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075717;
        bh=rr5XXnFqzW5OUVVX3XvCcLkpgYkdGzIUdUIQrU+I9d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdOCa44QU5l6xmiaqAup1Jw+6XRGv5Kup+SHYnd6mqkqFolEQhvpc8OuhK8TwYMtt
         VnsxMtp+FVLZZz2tNBkVVb01K5PioaDAMSHFtIXgeLM7KIrUp6Tsb6iDE+NbwMoovH
         7O+D7kKLNc/iTTgqNdlktHRJ9uF9pHAGok/pU838=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 332/800] regulator: hi655x: Fix pass wrong pointer to config.driver_data
Date:   Mon, 12 Jul 2021 08:05:55 +0200
Message-Id: <20210712061001.821270008@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 68cdb173196d..556bb73f3329 100644
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



