Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D4D461D92
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348991AbhK2S0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:26:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58702 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348816AbhK2SYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:24:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C7E7B815C3;
        Mon, 29 Nov 2021 18:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9A4C53FAD;
        Mon, 29 Nov 2021 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210076;
        bh=fxqoR0Ud6hEWU8jJHnzLf1s2yUvB/sczijFrOho9szM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIdTElbpjomqiARccqE2jdo45jjScQyvig57HQuU0WJRJ+pu50qaD7L6Z8mMvLI5N
         xhXRyQNl7fIykcod1vNieTYIBndbo8OqF4ENUDSETiWWDdA+LgCRirEZ436AlOgJH6
         p1lIZq0C0ecAkozCkT51jLllixU8kRUXWBvlFJpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 32/69] pinctrl: armada-37xx: Correct mpp definitions
Date:   Mon, 29 Nov 2021 19:18:14 +0100
Message-Id: <20211129181704.713528332@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt |   18 +++++++---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                               |   10 +++--
 2 files changed, 19 insertions(+), 9 deletions(-)

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
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -170,8 +170,8 @@ static struct armada_37xx_pin_group arma
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
@@ -195,8 +195,10 @@ static struct armada_37xx_pin_group arma
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


