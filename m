Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD52310BEF0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfK0Uns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729498AbfK0Uns (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:43:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F052080F;
        Wed, 27 Nov 2019 20:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887428;
        bh=FnI+fa6RYHCzzLqSE6NIcC3D6jU/xkVbeou+UhqK7sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvaxB0JUOsuzaS8s5A6tYZbOUPLEN0LtXgaakmGP9w0KQwTsxKVSa5DMvL5Fen12r
         p7xRBbgc6FaPsPR6kuteMg70dQi7/zswLjkq/WCmwDYQXQRkNC0cnE4OTYnG5YKLdH
         mUUKXAhBSTJ8dPilHpMaIodeiPXhWhrAxng0TN04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/151] pinctrl: lpc18xx: Use define directive for PIN_CONFIG_GPIO_PIN_INT
Date:   Wed, 27 Nov 2019 21:31:28 +0100
Message-Id: <20191127203040.899342059@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e053f1fa55120..ab2a451f31562 100644
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



