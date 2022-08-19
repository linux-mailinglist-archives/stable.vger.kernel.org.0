Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726A2599FC2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351062AbiHSQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351444AbiHSQBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6621EC71;
        Fri, 19 Aug 2022 08:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A5B6175A;
        Fri, 19 Aug 2022 15:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DEFC433C1;
        Fri, 19 Aug 2022 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924388;
        bh=JTvFqd0ib5uSBHUiC5QwTZkUgTY8YHyeZXY9NXQJrTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xxp5BTLLtq3PAxs6M98PT2cmvcsiEnyX+ysdkqeF1DVOPXqzO/2z8u0ITL9hLChxX
         2ekjX8KNlGmVUrBCZo2wnXkPwivy4jkIU5rwXLY+UegdgnGrxjl6UUW6Ka40jTkztK
         iWZRF4mdX/cyluEzrCCYbE5/NaVfmXMkS5rwprQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/545] Input: atmel_mxt_ts - fix up inverted RESET handler
Date:   Fri, 19 Aug 2022 17:38:04 +0200
Message-Id: <20220819153834.396294164@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit feedaacdadfc332e1a6e436f3adfbc67e244db47 ]

This driver uses GPIO descriptors to drive the touchscreen RESET line. In
the existing device trees this has in conflict with intution been flagged
as GPIO_ACTIVE_HIGH and the driver then applies the reverse action by
driving the line low (setting to 0) to enter reset state and driving the
line high (setting to 1) to get out of reset state.

The correct way to handle active low GPIO lines is to provide the
GPIO_ACTIVE_LOW in the device tree (thus properly describing the hardware)
and letting the GPIO framework invert the assertion (driving high) to a
low level and vice versa.

This is considered a bug since the device trees are incorrectly
mis-specifying the line as active high.

Fix the driver and all device trees specifying a reset line.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Philippe Schenker <philippe.schenker@toradex.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201104153032.1387747-1-linus.walleij@linaro.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-ppd.dts                 | 2 +-
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts    | 2 +-
 arch/arm/boot/dts/imx6q-apalis-eval.dts         | 2 +-
 arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts   | 2 +-
 arch/arm/boot/dts/imx6q-apalis-ixora.dts        | 2 +-
 arch/arm/boot/dts/imx7-colibri-aster.dtsi       | 2 +-
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi     | 2 +-
 arch/arm/boot/dts/motorola-mapphone-common.dtsi | 2 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi            | 2 +-
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts | 2 +-
 drivers/input/touchscreen/atmel_mxt_ts.c        | 6 ++++--
 11 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index 6d9a5ede94aa..006fbd7f5432 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -592,7 +592,7 @@ &i2c2 {
 
 	touchscreen@4b {
 		compatible = "atmel,maxtouch";
-		reset-gpio = <&gpio5 19 GPIO_ACTIVE_HIGH>;
+		reset-gpio = <&gpio5 19 GPIO_ACTIVE_LOW>;
 		reg = <0x4b>;
 		interrupt-parent = <&gpio5>;
 		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts b/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
index 65359aece950..7da74e6f46d9 100644
--- a/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
@@ -143,7 +143,7 @@ touchscreen@4a {
 		reg = <0x4a>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <9 IRQ_TYPE_EDGE_FALLING>;		/* SODIMM 28 */
-		reset-gpios = <&gpio2 10 GPIO_ACTIVE_HIGH>;	/* SODIMM 30 */
+		reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;	/* SODIMM 30 */
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/imx6q-apalis-eval.dts b/arch/arm/boot/dts/imx6q-apalis-eval.dts
index fab83abb6466..a0683b4aeca1 100644
--- a/arch/arm/boot/dts/imx6q-apalis-eval.dts
+++ b/arch/arm/boot/dts/imx6q-apalis-eval.dts
@@ -140,7 +140,7 @@ touchscreen@4a {
 		reg = <0x4a>;
 		interrupt-parent = <&gpio6>;
 		interrupts = <10 IRQ_TYPE_EDGE_FALLING>;
-		reset-gpios = <&gpio6 9 GPIO_ACTIVE_HIGH>; /* SODIMM 13 */
+		reset-gpios = <&gpio6 9 GPIO_ACTIVE_LOW>; /* SODIMM 13 */
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts b/arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts
index 1614b1ae501d..86e84781cf5d 100644
--- a/arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts
+++ b/arch/arm/boot/dts/imx6q-apalis-ixora-v1.1.dts
@@ -145,7 +145,7 @@ touchscreen@4a {
 		reg = <0x4a>;
 		interrupt-parent = <&gpio6>;
 		interrupts = <10 IRQ_TYPE_EDGE_FALLING>;
-		reset-gpios = <&gpio6 9 GPIO_ACTIVE_HIGH>; /* SODIMM 13 */
+		reset-gpios = <&gpio6 9 GPIO_ACTIVE_LOW>; /* SODIMM 13 */
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/imx6q-apalis-ixora.dts b/arch/arm/boot/dts/imx6q-apalis-ixora.dts
index fa9f98dd15ac..62e72773e53b 100644
--- a/arch/arm/boot/dts/imx6q-apalis-ixora.dts
+++ b/arch/arm/boot/dts/imx6q-apalis-ixora.dts
@@ -144,7 +144,7 @@ touchscreen@4a {
 		reg = <0x4a>;
 		interrupt-parent = <&gpio6>;
 		interrupts = <10 IRQ_TYPE_EDGE_FALLING>;
-		reset-gpios = <&gpio6 9 GPIO_ACTIVE_HIGH>; /* SODIMM 13 */
+		reset-gpios = <&gpio6 9 GPIO_ACTIVE_LOW>; /* SODIMM 13 */
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/imx7-colibri-aster.dtsi b/arch/arm/boot/dts/imx7-colibri-aster.dtsi
index 9fa701bec2ec..139188eb9f40 100644
--- a/arch/arm/boot/dts/imx7-colibri-aster.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-aster.dtsi
@@ -99,7 +99,7 @@ touchscreen@4a {
 		reg = <0x4a>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <15 IRQ_TYPE_EDGE_FALLING>;	/* SODIMM 107 */
-		reset-gpios = <&gpio2 28 GPIO_ACTIVE_HIGH>;	/* SODIMM 106 */
+		reset-gpios = <&gpio2 28 GPIO_ACTIVE_LOW>;	/* SODIMM 106 */
 	};
 
 	/* M41T0M6 real time clock on carrier board */
diff --git a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
index 97601375f264..3caf450735d7 100644
--- a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
@@ -124,7 +124,7 @@ touchscreen@4a {
 		reg = <0x4a>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <9 IRQ_TYPE_EDGE_FALLING>;		/* SODIMM 28 */
-		reset-gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;	/* SODIMM 30 */
+		reset-gpios = <&gpio1 10 GPIO_ACTIVE_LOW>;	/* SODIMM 30 */
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index d5ded4f794df..5f8f77cfbe59 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -430,7 +430,7 @@ touchscreen@4a {
 		pinctrl-names = "default";
 		pinctrl-0 = <&touchscreen_pins>;
 
-		reset-gpios = <&gpio6 13 GPIO_ACTIVE_HIGH>; /* gpio173 */
+		reset-gpios = <&gpio6 13 GPIO_ACTIVE_LOW>; /* gpio173 */
 
 		/* gpio_183 with sys_nirq2 pad as wakeup */
 		interrupts-extended = <&gpio6 23 IRQ_TYPE_LEVEL_LOW>,
diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 9005f0a23e8f..984bc8dc5e4b 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -631,7 +631,7 @@ touchscreen@4a {
 		interrupts = <5 IRQ_TYPE_EDGE_FALLING>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&ts_irq>;
-		reset-gpios = <&gpj1 3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpj1 3 GPIO_ACTIVE_LOW>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
index 5dbfb83c1b06..ce87e1ec10dc 100644
--- a/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
+++ b/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
@@ -446,7 +446,7 @@ touchscreen@4c {
 			interrupt-parent = <&gpio>;
 			interrupts = <TEGRA_GPIO(V, 6) IRQ_TYPE_LEVEL_LOW>;
 
-			reset-gpios = <&gpio TEGRA_GPIO(Q, 7) GPIO_ACTIVE_HIGH>;
+			reset-gpios = <&gpio TEGRA_GPIO(Q, 7) GPIO_ACTIVE_LOW>;
 
 			vdda-supply = <&vdd_3v3_sys>;
 			vdd-supply  = <&vdd_3v3_sys>;
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 8df402a1ed44..3c152e934cb8 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -3134,8 +3134,9 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (error)
 		return error;
 
+	/* Request the RESET line as asserted so we go into reset */
 	data->reset_gpio = devm_gpiod_get_optional(&client->dev,
-						   "reset", GPIOD_OUT_LOW);
+						   "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(data->reset_gpio)) {
 		error = PTR_ERR(data->reset_gpio);
 		dev_err(&client->dev, "Failed to get reset gpio: %d\n", error);
@@ -3153,8 +3154,9 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	disable_irq(client->irq);
 
 	if (data->reset_gpio) {
+		/* Wait a while and then de-assert the RESET GPIO line */
 		msleep(MXT_RESET_GPIO_TIME);
-		gpiod_set_value(data->reset_gpio, 1);
+		gpiod_set_value(data->reset_gpio, 0);
 		msleep(MXT_RESET_INVALID_CHG);
 	}
 
-- 
2.35.1



