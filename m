Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8650529C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbiDRMrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiDRMqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE1129823;
        Mon, 18 Apr 2022 05:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED0F61014;
        Mon, 18 Apr 2022 12:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77467C385A8;
        Mon, 18 Apr 2022 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285178;
        bh=PdqZVzizgk6/NDj9Gpg1f+LUl/smdkF9TxT+ushn/pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQAiG0sQ3yfCc+15vAtVXoyQ5idV9mlWcjU+1f6hHrZIbSIHkT2/KQXrGZSN5QqYF
         lZcYOe2NNxJaz2CdVqV36jK02hpC1l21VlE0ovRSl216uAnDHsn5VxK0PCvX6bilbC
         ocoh8c6VOKkUwtyeQgH/nD+DUHRTxkEFderM5q8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/189] regulator: wm8994: Add an off-on delay for WM8994 variant
Date:   Mon, 18 Apr 2022 14:12:25 +0200
Message-Id: <20220418121204.476721313@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



