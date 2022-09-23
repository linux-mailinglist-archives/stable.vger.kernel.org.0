Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6E5E7D9A
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiIWOwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 10:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiIWOwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 10:52:16 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FCF12FF3A;
        Fri, 23 Sep 2022 07:52:14 -0700 (PDT)
Received: (Authenticated sender: foss@0leil.net)
        by mail.gandi.net (Postfix) with ESMTPSA id C18C860005;
        Fri, 23 Sep 2022 14:52:08 +0000 (UTC)
From:   Quentin Schulz <foss+kernel@0leil.net>
Cc:     linus.walleij@linaro.org, brgl@bgdev.pl, heiko@sntech.de,
        jay.xu@rock-chips.com, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        foss+kernel@0leil.net,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] gpio: rockchip: request GPIO mux to pinctrl when setting direction
Date:   Fri, 23 Sep 2022 16:51:41 +0200
Message-Id: <20220923145141.3463754-3-foss+kernel@0leil.net>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220923145141.3463754-1-foss+kernel@0leil.net>
References: <20220923145141.3463754-1-foss+kernel@0leil.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

Before the split of gpio and pinctrl sections in their own driver,
rockchip_set_mux was called in pinmux_ops.gpio_set_direction for
configuring a pin in its GPIO function.

This is essential for cases where pinctrl is "bypassed" by gpio
consumers otherwise the GPIO function is not configured for the pin and
it does not work. Such was the case for the sysfs/libgpiod userspace
GPIO handling.

Let's call pinctrl_gpio_direction_input/output when setting the
direction of a GPIO so that the pinctrl core requests from the rockchip
pinctrl driver to put the pin in its GPIO function.

Fixes: 9ce9a02039de ("pinctrl/rockchip: drop the gpio related codes")
Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
---
 drivers/gpio/gpio-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index bb50335239ac8..b83913e1ee49e 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -156,6 +156,12 @@ static int rockchip_gpio_set_direction(struct gpio_chip *chip,
 	unsigned long flags;
 	u32 data = input ? 0 : 1;
 
+
+	if (input)
+		pinctrl_gpio_direction_input(bank->pin_base + offset);
+	else
+		pinctrl_gpio_direction_output(bank->pin_base + offset);
+
 	raw_spin_lock_irqsave(&bank->slock, flags);
 	rockchip_gpio_writel_bit(bank, offset, data, bank->gpio_regs->port_ddr);
 	raw_spin_unlock_irqrestore(&bank->slock, flags);
-- 
2.37.3

