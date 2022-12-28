Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31AD658226
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiL1Qd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiL1QdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC331A219
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EB5AB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DA8C433D2;
        Wed, 28 Dec 2022 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245020;
        bh=4hEtNKm4C3mnB40PXHEoFjhTSymawBm29/B8KKyP6Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EudtIygM7G0P47ByqJ2KDfV5hXVEa3xk0raxaQ1AO5r4DLFD0KTEvWJGyQHFXoX6K
         R58HQvkw+1DCAVzF+u84vsuG+O50TbECYTH0Fm3SaAQyPYSZz/jYZKtZQ7WulGaTny
         pKYOYKku4lKq1xp4z5nedO0XXX0BXj840TgFDOP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Marek Vasut <marex@denx.de>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0779/1146] power: supply: bq25890: Factor out regulator registration code
Date:   Wed, 28 Dec 2022 15:38:38 +0100
Message-Id: <20221228144351.307102068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5f5c10ecaf3fdeba9b2b0af5301977420c2c4df0 ]

Pull the regulator registration code into separate function, so it can
be extended to register more regulators later. Currently this is only
moving ifdeffery into one place and other preparatory changes. The
dev_err_probe() output string is changed to explicitly list vbus
regulator failure, so that once more regulators are registered, it
would be clear which one failed.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: a7aaa80098d5 ("power: supply: bq25890: Ensure pump_express_work is cancelled on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 51 ++++++++++++++++++--------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 6020b58c641d..624e466e2cfa 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1049,6 +1049,36 @@ static const struct regulator_desc bq25890_vbus_desc = {
 	.fixed_uV = 5000000,
 	.n_voltages = 1,
 };
+
+static int bq25890_register_regulator(struct bq25890_device *bq)
+{
+	struct bq25890_platform_data *pdata = dev_get_platdata(bq->dev);
+	struct regulator_config cfg = {
+		.dev = bq->dev,
+		.driver_data = bq,
+	};
+	struct regulator_dev *reg;
+
+	if (!IS_ERR_OR_NULL(bq->usb_phy))
+		return 0;
+
+	if (pdata)
+		cfg.init_data = pdata->regulator_init_data;
+
+	reg = devm_regulator_register(bq->dev, &bq25890_vbus_desc, &cfg);
+	if (IS_ERR(reg)) {
+		return dev_err_probe(bq->dev, PTR_ERR(reg),
+				     "registering vbus regulator");
+	}
+
+	return 0;
+}
+#else
+static inline int
+bq25890_register_regulator(struct bq25890_device *bq)
+{
+	return 0;
+}
 #endif
 
 static int bq25890_get_chip_version(struct bq25890_device *bq)
@@ -1244,27 +1274,16 @@ static int bq25890_probe(struct i2c_client *client,
 
 	/* OTG reporting */
 	bq->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+
+	ret = bq25890_register_regulator(bq);
+	if (ret)
+		return ret;
+
 	if (!IS_ERR_OR_NULL(bq->usb_phy)) {
 		INIT_WORK(&bq->usb_work, bq25890_usb_work);
 		bq->usb_nb.notifier_call = bq25890_usb_notifier;
 		usb_register_notifier(bq->usb_phy, &bq->usb_nb);
 	}
-#ifdef CONFIG_REGULATOR
-	else {
-		struct bq25890_platform_data *pdata = dev_get_platdata(dev);
-		struct regulator_config cfg = { };
-		struct regulator_dev *reg;
-
-		cfg.dev = dev;
-		cfg.driver_data = bq;
-		if (pdata)
-			cfg.init_data = pdata->regulator_init_data;
-
-		reg = devm_regulator_register(dev, &bq25890_vbus_desc, &cfg);
-		if (IS_ERR(reg))
-			return dev_err_probe(dev, PTR_ERR(reg), "registering regulator");
-	}
-#endif
 
 	ret = bq25890_power_supply_init(bq);
 	if (ret < 0) {
-- 
2.35.1



