Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D689D45D0CE
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352514AbhKXXIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352496AbhKXXIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC3326108B;
        Wed, 24 Nov 2021 23:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795133;
        bh=D4HZMD4ohmGhTDTUiyA1vFMxJ/UZJralnuyEMKrVXS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+qVOhLfMViJjmh9LsdEIECIanGUNsnjsAj8qpLQdG/cb2JwVey5WR5H+uzbM87xO
         uJq2Xism4dyzP4IygXfpLWx7dzr5luEGTPklWaQJkRifwdahzbWyVFC84gjo5HjuUz
         P7HEAdM+N3I3kVf8Ym8Q0nsYUBR+tpNU8FyOzZIZAlwDce3xYlPR+wU9eo5JiihL9F
         XU1vbVBBFkXyme6LjE5YSjSOYwFEYOv7rqib/qouXKIAVE/qVyjUWu8PFo/qcVJXle
         vywujRU+7aXWLOmkJf7IGUw982LUmaXLFQH6romDcouOJ2YzU+oOgGV/hY4lzwlDET
         GUt0J4h79iBug==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 16/20] pinctrl: armada-37xx: Correct mpp definitions
Date:   Thu, 25 Nov 2021 00:04:56 +0100
Message-Id: <20211124230500.27109-17-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

commit 823868fceae3bac07cf5eccb128d6916e7a5ae9d upstream.

This is a cleanup and fix of the patch by Ken Ma <make@marvell.com>.

Fix the mpp definitions according to newest revision of the
specification:
  - northbridge:
    fix pmic1 gpio number to 7
    fix pmic0 gpio number to 6
  - southbridge
    split pcie1 group bit mask to BIT(5) and  BIT(9)
    fix ptp group bit mask to BIT(11) | BIT(12) | BIT(13)
    add smi group with bit mask BIT(4)

[gregory: split the pcie group in 2, as at hardware level they can be
configured separately]
Signed-off-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../pinctrl/marvell,armada-37xx-pinctrl.txt    | 18 +++++++++++++-----
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c    | 10 ++++++----
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
index c7c088d2dd50..f69f82741cae 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt
@@ -58,11 +58,11 @@ group pwm3
  - functions pwm, gpio
 
 group pmic1
- - pin 17
+ - pin 7
  - functions pmic, gpio
 
 group pmic0
- - pin 16
+ - pin 6
  - functions pmic, gpio
 
 group i2c2
@@ -112,17 +112,25 @@ group usb2_drvvbus1
  - functions drvbus, gpio
 
 group sdio_sb
- - pins 60-64
+ - pins 60-65
  - functions sdio, gpio
 
 group rgmii
- - pins 42-55
+ - pins 42-53
  - functions mii, gpio
 
 group pcie1
- - pins 39-40
+ - pins 39
+ - functions pcie, gpio
+
+group pcie1_clkreq
+ - pins 40
  - functions pcie, gpio
 
+group smi
+ - pins 54-55
+ - functions smi, gpio
+
 group ptp
  - pins 56-58
  - functions ptp, gpio
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index d76ac6b4b40d..cf678ac22a95 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -170,8 +170,8 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
 	PIN_GRP_GPIO("pwm1", 12, 1, BIT(4), "pwm"),
 	PIN_GRP_GPIO("pwm2", 13, 1, BIT(5), "pwm"),
 	PIN_GRP_GPIO("pwm3", 14, 1, BIT(6), "pwm"),
-	PIN_GRP_GPIO("pmic1", 17, 1, BIT(7), "pmic"),
-	PIN_GRP_GPIO("pmic0", 16, 1, BIT(8), "pmic"),
+	PIN_GRP_GPIO("pmic1", 7, 1, BIT(7), "pmic"),
+	PIN_GRP_GPIO("pmic0", 6, 1, BIT(8), "pmic"),
 	PIN_GRP_GPIO("i2c2", 2, 2, BIT(9), "i2c"),
 	PIN_GRP_GPIO("i2c1", 0, 2, BIT(10), "i2c"),
 	PIN_GRP_GPIO("spi_cs1", 17, 1, BIT(12), "spi"),
@@ -195,8 +195,10 @@ static struct armada_37xx_pin_group armada_37xx_sb_groups[] = {
 	PIN_GRP_GPIO("usb2_drvvbus1", 1, 1, BIT(1), "drvbus"),
 	PIN_GRP_GPIO("sdio_sb", 24, 6, BIT(2), "sdio"),
 	PIN_GRP_GPIO("rgmii", 6, 12, BIT(3), "mii"),
-	PIN_GRP_GPIO("pcie1", 3, 2, BIT(4), "pcie"),
-	PIN_GRP_GPIO("ptp", 20, 3, BIT(5), "ptp"),
+	PIN_GRP_GPIO("smi", 18, 2, BIT(4), "smi"),
+	PIN_GRP_GPIO("pcie1", 3, 1, BIT(5), "pcie"),
+	PIN_GRP_GPIO("pcie1_clkreq", 4, 1, BIT(9), "pcie"),
+	PIN_GRP_GPIO("ptp", 20, 3, BIT(11) | BIT(12) | BIT(13), "ptp"),
 	PIN_GRP("ptp_clk", 21, 1, BIT(6), "ptp", "mii"),
 	PIN_GRP("ptp_trig", 22, 1, BIT(7), "ptp", "mii"),
 	PIN_GRP_GPIO_3("mii_col", 23, 1, BIT(8) | BIT(14), 0, BIT(8), BIT(14),
-- 
2.32.0

