Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90983658189
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiL1Q3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiL1Q2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C17919C06
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EF726157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9DDC433EF;
        Wed, 28 Dec 2022 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244705;
        bh=jaxetIDVs7UmDTcGPX9dQhrAn9Cpek00T92R7i8EuQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYjwDAUwZZSzNPnWqHp0X2we9JxkhDtQIYtvvXNQhyj1VLM7jmV0uPiCayzT4JgMs
         1znEd4ByakBjTPNXhvrtwabDoSugZp5wYO/zdVv6DT6ACu0Y5Hac2kWlOATIrzlyZ/
         OsiSRHXi7RkmLukjDXY/J+uTyRMa5tQfS2iwSxs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Marek Vasut <marex@denx.de>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0751/1073] power: supply: bq25890: Factor out regulator registration code
Date:   Wed, 28 Dec 2022 15:38:59 +0100
Message-Id: <20221228144348.418522011@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 852a6fec4339..86228753e804 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1019,6 +1019,36 @@ static const struct regulator_desc bq25890_vbus_desc = {
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
@@ -1214,27 +1244,16 @@ static int bq25890_probe(struct i2c_client *client,
 
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



