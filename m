Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226594FCA70
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiDLAx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245721AbiDLAxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5EF3389B;
        Mon, 11 Apr 2022 17:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14268B819C8;
        Tue, 12 Apr 2022 00:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9F0C385A4;
        Tue, 12 Apr 2022 00:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724480;
        bh=PdqZVzizgk6/NDj9Gpg1f+LUl/smdkF9TxT+ushn/pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYck9I0u4KduLtWMTdFizUKgXLCicmKww1I8eTSj29FvIv1DIeHKo5lPvf4JSKgA+
         BRLI3IH//jWoS4PczLvcOhmokO15fpKcOpKI6jdQ9AbOgR4uzWZzD/IGh79d1GSpjE
         KLk+tZQyaFB+gG9IuwM3+JGIhxN5UV2ultRm7DsKi8OCHLlW99apIPhe1avwe0WsPS
         D1LVst5yGDIh2IsPiwvJxyFG8Pi4IOh54Y6SJqfrzza510BHdabmbzDvagDwkmMah3
         pUFmQ/8lhJCItF1Nweoz+TIpMTnigbbTjLYS5n10PfZJdp3LpNZTzXZuZZ4E+h5rHJ
         cv6aK1PKESdKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Bakker <xc-racer2@live.ca>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.15 21/41] regulator: wm8994: Add an off-on delay for WM8994 variant
Date:   Mon, 11 Apr 2022 20:46:33 -0400
Message-Id: <20220412004656.350101-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit 92d96b603738ec4f35cde7198c303ae264dd47cb ]

As per Table 130 of the wm8994 datasheet at [1], there is an off-on
delay for LDO1 and LDO2.  In the wm8958 datasheet [2], I could not
find any reference to it.  I could not find a wm1811 datasheet to
double-check there, but as no one has complained presumably it works
without it.

This solves the issue on Samsung Aries boards with a wm8994 where
register writes fail when the device is powered off and back-on
quickly.

[1] https://statics.cirrus.com/pubs/proDatasheet/WM8994_Rev4.6.pdf
[2] https://statics.cirrus.com/pubs/proDatasheet/WM8958_v3.5.pdf

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/CY4PR04MB056771CFB80DC447C30D5A31CB1D9@CY4PR04MB0567.namprd04.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/wm8994-regulator.c | 42 ++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index cadea0344486..40befdd9dfa9 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -71,6 +71,35 @@ static const struct regulator_ops wm8994_ldo2_ops = {
 };
 
 static const struct regulator_desc wm8994_ldo_desc[] = {
+	{
+		.name = "LDO1",
+		.id = 1,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8994_LDO1_MAX_SELECTOR + 1,
+		.vsel_reg = WM8994_LDO_1,
+		.vsel_mask = WM8994_LDO1_VSEL_MASK,
+		.ops = &wm8994_ldo1_ops,
+		.min_uV = 2400000,
+		.uV_step = 100000,
+		.enable_time = 3000,
+		.off_on_delay = 36000,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO2",
+		.id = 2,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8994_LDO2_MAX_SELECTOR + 1,
+		.vsel_reg = WM8994_LDO_2,
+		.vsel_mask = WM8994_LDO2_VSEL_MASK,
+		.ops = &wm8994_ldo2_ops,
+		.enable_time = 3000,
+		.off_on_delay = 36000,
+		.owner = THIS_MODULE,
+	},
+};
+
+static const struct regulator_desc wm8958_ldo_desc[] = {
 	{
 		.name = "LDO1",
 		.id = 1,
@@ -172,9 +201,16 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	 * regulator core and we need not worry about it on the
 	 * error path.
 	 */
-	ldo->regulator = devm_regulator_register(&pdev->dev,
-						 &wm8994_ldo_desc[id],
-						 &config);
+	if (ldo->wm8994->type == WM8994) {
+		ldo->regulator = devm_regulator_register(&pdev->dev,
+							 &wm8994_ldo_desc[id],
+							 &config);
+	} else {
+		ldo->regulator = devm_regulator_register(&pdev->dev,
+							 &wm8958_ldo_desc[id],
+							 &config);
+	}
+
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm8994->dev, "Failed to register LDO%d: %d\n",
-- 
2.35.1

