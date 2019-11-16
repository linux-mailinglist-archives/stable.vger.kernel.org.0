Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6F1FF1F1
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfKPQQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729625AbfKPPrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:07 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB78C2084F;
        Sat, 16 Nov 2019 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919226;
        bh=joWvDbyWmwlaBdQTIKjS8/wZr1JeRCpZe/Ec4J4cdhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWq54rnu2mOcs1J5vVAETXXQOQkR/Aj/Ni6ugaiohXCAzwiRqat9oJRngrIUYCOIm
         sy4HJSjnzQxiY9d5X5irBifUGo7P1O6zkfFdpp5avv0VeeTmooLZngq066N9YKiR5/
         ZldgFt4qpEYWyQIlaDsQTQQ7g/5g6upPXkB9R1PM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 229/237] pinctrl: lpc18xx: Use define directive for PIN_CONFIG_GPIO_PIN_INT
Date:   Sat, 16 Nov 2019 10:41:04 -0500
Message-Id: <20191116154113.7417-229-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit f24bfb39975c241374cadebbd037c17960cf1412 ]

Clang warns when one enumerated type is implicitly converted to another:

drivers/pinctrl/pinctrl-lpc18xx.c:643:29: warning: implicit conversion
from enumeration type 'enum lpc18xx_pin_config_param' to different
enumeration type 'enum pin_config_param' [-Wenum-conversion]
        {"nxp,gpio-pin-interrupt", PIN_CONFIG_GPIO_PIN_INT, 0},
        ~                          ^~~~~~~~~~~~~~~~~~~~~~~
drivers/pinctrl/pinctrl-lpc18xx.c:648:12: warning: implicit conversion
from enumeration type 'enum lpc18xx_pin_config_param' to different
enumeration type 'enum pin_config_param' [-Wenum-conversion]
        PCONFDUMP(PIN_CONFIG_GPIO_PIN_INT, "gpio pin int", NULL, true),
        ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/pinctrl/pinconf-generic.h:163:11: note: expanded from
macro 'PCONFDUMP'
        .param = a, .display = b, .format = c, .has_arg = d     \
                 ^
2 warnings generated.

It is expected that pinctrl drivers can extend pin_config_param because
of the gap between PIN_CONFIG_END and PIN_CONFIG_MAX so this conversion
isn't an issue. Most drivers that take advantage of this define the
PIN_CONFIG variables as constants, rather than enumerated values. Do the
same thing here so that Clang no longer warns.

Link: https://github.com/ClangBuiltLinux/linux/issues/140
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-lpc18xx.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-lpc18xx.c b/drivers/pinctrl/pinctrl-lpc18xx.c
index 190f17e4bbdaf..1d3b88e6ab862 100644
--- a/drivers/pinctrl/pinctrl-lpc18xx.c
+++ b/drivers/pinctrl/pinctrl-lpc18xx.c
@@ -630,14 +630,8 @@ static const struct pinctrl_pin_desc lpc18xx_pins[] = {
 	LPC18XX_PIN(i2c0_sda, PIN_I2C0_SDA),
 };
 
-/**
- * enum lpc18xx_pin_config_param - possible pin configuration parameters
- * @PIN_CONFIG_GPIO_PIN_INT: route gpio to the gpio pin interrupt
- * 	controller.
- */
-enum lpc18xx_pin_config_param {
-	PIN_CONFIG_GPIO_PIN_INT = PIN_CONFIG_END + 1,
-};
+/* PIN_CONFIG_GPIO_PIN_INT: route gpio to the gpio pin interrupt controller */
+#define PIN_CONFIG_GPIO_PIN_INT		(PIN_CONFIG_END + 1)
 
 static const struct pinconf_generic_params lpc18xx_params[] = {
 	{"nxp,gpio-pin-interrupt", PIN_CONFIG_GPIO_PIN_INT, 0},
-- 
2.20.1

