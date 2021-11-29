Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4C646244B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhK2WRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhK2WQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35583C12A75E;
        Mon, 29 Nov 2021 10:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1D0CB815C8;
        Mon, 29 Nov 2021 18:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1D8C53FAD;
        Mon, 29 Nov 2021 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210203;
        bh=6CaZZTP3bYDrQ8TcCrLfTeVJ2TcKSn6LmwPmfLL2Tc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEImscEhnCT0Kdrb7ttkC8RRnDwUj5D7daMyxBGAtbm+84ejnG1bIUm1Jmp82aZah
         OdVvs7fT5MttvtSZC5BvVr/U9VhX87jvk3YyLfW661Zj2BPe1E0VoRAHxk01Am62Rk
         LkH1gHaGaczh/tCCPTmPiILvV3v+KqdJyUR9gfyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 34/69] pinctrl: armada-37xx: Correct PWM pins definitions
Date:   Mon, 29 Nov 2021 19:18:16 +0100
Message-Id: <20211129181704.782935448@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Marek Beh�n" <kabel@kernel.org>

commit baf8d6899b1e8906dc076ef26cc633e96a8bb0c3 upstream.

The PWM pins on North Bridge on Armada 37xx can be configured into PWM
or GPIO functions. When in PWM function, each pin can also be configured
to drive low on 0 and tri-state on 1 (LED mode).

The current definitions handle this by declaring two pin groups for each
pin:
- group "pwmN" with functions "pwm" and "gpio"
- group "ledN_od" ("od" for open drain) with functions "led" and "gpio"

This is semantically incorrect. The correct definition for each pin
should be one group with three functions: "pwm", "led" and "gpio".

Change the "pwmN" groups to support "led" function.

Remove "ledN_od" groups. This cannot break backwards compatibility with
older device trees: no device tree uses it since there is no PWM driver
for this SOC yet. Also "ledN_od" groups are not even documented.

Fixes: b835d6953009 ("pinctrl: armada-37xx: swap polarity on LED group")
Signed-off-by: Marek Behún <kabel@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210719112938.27594-1-kabel@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt |    8 ++--
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                               |   17 ++++------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
@@ -43,19 +43,19 @@ group emmc_nb
 
 group pwm0
  - pin 11 (GPIO1-11)
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pwm1
  - pin 12
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pwm2
  - pin 13
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pwm3
  - pin 14
- - functions pwm, gpio
+ - functions pwm, led, gpio
 
 group pmic1
  - pin 7
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -166,10 +166,14 @@ static struct armada_37xx_pin_group arma
 	PIN_GRP_GPIO("jtag", 20, 5, BIT(0), "jtag"),
 	PIN_GRP_GPIO("sdio0", 8, 3, BIT(1), "sdio"),
 	PIN_GRP_GPIO("emmc_nb", 27, 9, BIT(2), "emmc"),
-	PIN_GRP_GPIO("pwm0", 11, 1, BIT(3), "pwm"),
-	PIN_GRP_GPIO("pwm1", 12, 1, BIT(4), "pwm"),
-	PIN_GRP_GPIO("pwm2", 13, 1, BIT(5), "pwm"),
-	PIN_GRP_GPIO("pwm3", 14, 1, BIT(6), "pwm"),
+	PIN_GRP_GPIO_3("pwm0", 11, 1, BIT(3) | BIT(20), 0, BIT(20), BIT(3),
+		       "pwm", "led"),
+	PIN_GRP_GPIO_3("pwm1", 12, 1, BIT(4) | BIT(21), 0, BIT(21), BIT(4),
+		       "pwm", "led"),
+	PIN_GRP_GPIO_3("pwm2", 13, 1, BIT(5) | BIT(22), 0, BIT(22), BIT(5),
+		       "pwm", "led"),
+	PIN_GRP_GPIO_3("pwm3", 14, 1, BIT(6) | BIT(23), 0, BIT(23), BIT(6),
+		       "pwm", "led"),
 	PIN_GRP_GPIO("pmic1", 7, 1, BIT(7), "pmic"),
 	PIN_GRP_GPIO("pmic0", 6, 1, BIT(8), "pmic"),
 	PIN_GRP_GPIO("i2c2", 2, 2, BIT(9), "i2c"),
@@ -183,11 +187,6 @@ static struct armada_37xx_pin_group arma
 	PIN_GRP_EXTRA("uart2", 9, 2, BIT(1) | BIT(13) | BIT(14) | BIT(19),
 		      BIT(1) | BIT(13) | BIT(14), BIT(1) | BIT(19),
 		      18, 2, "gpio", "uart"),
-	PIN_GRP_GPIO_2("led0_od", 11, 1, BIT(20), BIT(20), 0, "led"),
-	PIN_GRP_GPIO_2("led1_od", 12, 1, BIT(21), BIT(21), 0, "led"),
-	PIN_GRP_GPIO_2("led2_od", 13, 1, BIT(22), BIT(22), 0, "led"),
-	PIN_GRP_GPIO_2("led3_od", 14, 1, BIT(23), BIT(23), 0, "led"),
-
 };
 
 static struct armada_37xx_pin_group armada_37xx_sb_groups[] = {


