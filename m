Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725C445D0D0
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352496AbhKXXIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352502AbhKXXIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B159610A1;
        Wed, 24 Nov 2021 23:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795136;
        bh=KrSWRxYmtCMOks9YM+bFyCiY63OXqOT/GmokcUXtm9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LARHpqhcuVeLvGL1YMdGfJL3ZgkxLk09IhwazuUJ9Mu+505rh9Y47WhqRzmhQ687q
         geFpqR/RAKEAFBgr/O8sTGS++M5JAcpLK7lI9Z+1zFTto1bOre0ruga771aPG9OILt
         zeWLL65eQGj3qzqs74PEGZOKQVHA0SfRzMKfR1SPtnCoV6RfsPJAXgtc5TKTaUIWsg
         Zc4/UYPLWqHQXALHSCqKGiIXy4t6BGJkVBPjU9Wd22Kt30wX4BhB7v8a9h4cx+UYvi
         NluIuQiMOC2aTuWo59UlYC2VNz3BgDjqyJXnNH93swBHg+4Q16LHcHP5lqKWBdPJYr
         Oo94+54J2q6CQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 18/20] pinctrl: armada-37xx: Correct PWM pins definitions
Date:   Thu, 25 Nov 2021 00:04:58 +0100
Message-Id: <20211124230500.27109-19-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 .../pinctrl/marvell,armada-37xx-pinctrl.txt     |  8 ++++----
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c     | 17 ++++++++---------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
index f69f82741cae..fb8ec9b0f8c7 100644
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
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index adfb1d0d58dd..e69b84d9538a 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -166,10 +166,14 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
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
@@ -183,11 +187,6 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
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
-- 
2.32.0

