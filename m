Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3291D2E3A7C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390812AbgL1Nhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390798AbgL1Nhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15AB720719;
        Mon, 28 Dec 2020 13:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162635;
        bh=b3W3qxLUR+uGTD4xK2QVvQWDVrAxkeDSCuy0HJfUHEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q61SWo2NVuAqHvQAPXhOVOqMqdMB49jKH6IxeQnymMLTfA2QBEOMG0EMuPmUIn0a0
         554A3boqJR7ZPQeCBGG171P4X1Z0TFUGvwjTXsUPGpKU4VCMgRbeXIMA69SAYKtMAx
         ivzzAMLSlH6z8J35ImtMyVKZnOGh+cVLUYXIWaSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Billy Tsai <billy_tsai@aspeedtech.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/453] pinctrl: aspeed: Fix GPIO requests on pass-through banks
Date:   Mon, 28 Dec 2020 13:44:17 +0100
Message-Id: <20201228124938.274155220@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit 7aeb353802611a8e655e019f09a370ff682af1a6 ]

Commit 6726fbff19bf ("pinctrl: aspeed: Fix GPI only function problem.")
fixes access to GPIO banks T and U on the AST2600. Both banks contain
input-only pins and the GPIO pin function is named GPITx and GPIUx
respectively. Unfortunately the fix had a negative impact on GPIO banks
D and E for the AST2400 and AST2500 where the GPIO pass-through
functions take similar "GPI"-style names. The net effect on the older
SoCs was that when the GPIO subsystem requested a pin in banks D or E be
muxed for GPIO, they were instead muxed for pass-through mode.
Mistakenly muxing pass-through mode e.g. breaks booting the host on
IBM's Witherspoon (AC922) platform where GPIOE0 is used for FSI.

Further exploit the names in the provided expression structure to
differentiate pass-through from pin-specific GPIO modes.

This follow-up fix gives the expected behaviour for the following tests:

Witherspoon BMC (AST2500):

1. Power-on the Witherspoon host
2. Request GPIOD1 be muxed via /sys/class/gpio/export
3. Request GPIOE1 be muxed via /sys/class/gpio/export
4. Request the balls for GPIOs E2 and E3 be muxed as GPIO pass-through
   ("GPIE2" mode) via a pinctrl hog in the devicetree

Rainier BMC (AST2600):

5. Request GPIT0 be muxed via /sys/class/gpio/export
6. Request GPIU0 be muxed via /sys/class/gpio/export

Together the tests demonstrate that all three pieces of functionality
(general GPIOs via 1, 2 and 3, input-only GPIOs via 5 and 6, pass-through
mode via 4) operate as desired across old and new SoCs.

Fixes: 9b92f5c51e9a ("pinctrl: aspeed: Fix GPI only function problem.")
Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Tested-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Cc: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20201126063337.489927-1-andrew@aj.id.au
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 74 +++++++++++++++++++++++--
 drivers/pinctrl/aspeed/pinmux-aspeed.h  |  7 ++-
 2 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 93b5654ff2828..22aca6d182c0c 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -277,14 +277,76 @@ int aspeed_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned int function,
 static bool aspeed_expr_is_gpio(const struct aspeed_sig_expr *expr)
 {
 	/*
-	 * The signal type is GPIO if the signal name has "GPI" as a prefix.
-	 * strncmp (rather than strcmp) is used to implement the prefix
-	 * requirement.
+	 * We need to differentiate between GPIO and non-GPIO signals to
+	 * implement the gpio_request_enable() interface. For better or worse
+	 * the ASPEED pinctrl driver uses the expression names to determine
+	 * whether an expression will mux a pin for GPIO.
 	 *
-	 * expr->signal might look like "GPIOB1" in the GPIO case.
-	 * expr->signal might look like "GPIT0" in the GPI case.
+	 * Generally we have the following - A GPIO such as B1 has:
+	 *
+	 *    - expr->signal set to "GPIOB1"
+	 *    - expr->function set to "GPIOB1"
+	 *
+	 * Using this fact we can determine whether the provided expression is
+	 * a GPIO expression by testing the signal name for the string prefix
+	 * "GPIO".
+	 *
+	 * However, some GPIOs are input-only, and the ASPEED datasheets name
+	 * them differently. An input-only GPIO such as T0 has:
+	 *
+	 *    - expr->signal set to "GPIT0"
+	 *    - expr->function set to "GPIT0"
+	 *
+	 * It's tempting to generalise the prefix test from "GPIO" to "GPI" to
+	 * account for both GPIOs and GPIs, but in doing so we run aground on
+	 * another feature:
+	 *
+	 * Some pins in the ASPEED BMC SoCs have a "pass-through" GPIO
+	 * function where the input state of one pin is replicated as the
+	 * output state of another (as if they were shorted together - a mux
+	 * configuration that is typically enabled by hardware strapping).
+	 * This feature allows the BMC to pass e.g. power button state through
+	 * to the host while the BMC is yet to boot, but take control of the
+	 * button state once the BMC has booted by muxing each pin as a
+	 * separate, pin-specific GPIO.
+	 *
+	 * Conceptually this pass-through mode is a form of GPIO and is named
+	 * as such in the datasheets, e.g. "GPID0". This naming similarity
+	 * trips us up with the simple GPI-prefixed-signal-name scheme
+	 * discussed above, as the pass-through configuration is not what we
+	 * want when muxing a pin as GPIO for the GPIO subsystem.
+	 *
+	 * On e.g. the AST2400, a pass-through function "GPID0" is grouped on
+	 * balls A18 and D16, where we have:
+	 *
+	 *    For ball A18:
+	 *    - expr->signal set to "GPID0IN"
+	 *    - expr->function set to "GPID0"
+	 *
+	 *    For ball D16:
+	 *    - expr->signal set to "GPID0OUT"
+	 *    - expr->function set to "GPID0"
+	 *
+	 * By contrast, the pin-specific GPIO expressions for the same pins are
+	 * as follows:
+	 *
+	 *    For ball A18:
+	 *    - expr->signal looks like "GPIOD0"
+	 *    - expr->function looks like "GPIOD0"
+	 *
+	 *    For ball D16:
+	 *    - expr->signal looks like "GPIOD1"
+	 *    - expr->function looks like "GPIOD1"
+	 *
+	 * Testing both the signal _and_ function names gives us the means
+	 * differentiate the pass-through GPIO pinmux configuration from the
+	 * pin-specific configuration that the GPIO subsystem is after: An
+	 * expression is a pin-specific (non-pass-through) GPIO configuration
+	 * if the signal prefix is "GPI" and the signal name matches the
+	 * function name.
 	 */
-	return strncmp(expr->signal, "GPI", 3) == 0;
+	return !strncmp(expr->signal, "GPI", 3) &&
+			!strcmp(expr->signal, expr->function);
 }
 
 static bool aspeed_gpio_in_exprs(const struct aspeed_sig_expr **exprs)
diff --git a/drivers/pinctrl/aspeed/pinmux-aspeed.h b/drivers/pinctrl/aspeed/pinmux-aspeed.h
index 140c5ce9fbc11..0aaa20653536f 100644
--- a/drivers/pinctrl/aspeed/pinmux-aspeed.h
+++ b/drivers/pinctrl/aspeed/pinmux-aspeed.h
@@ -452,10 +452,11 @@ struct aspeed_sig_desc {
  * evaluation of the descriptors.
  *
  * @signal: The signal name for the priority level on the pin. If the signal
- *          type is GPIO, then the signal name must begin with the string
- *          "GPIO", e.g. GPIOA0, GPIOT4 etc.
+ *          type is GPIO, then the signal name must begin with the
+ *          prefix "GPI", e.g. GPIOA0, GPIT0 etc.
  * @function: The name of the function the signal participates in for the
- *            associated expression
+ *            associated expression. For pin-specific GPIO, the function
+ *            name must match the signal name.
  * @ndescs: The number of signal descriptors in the expression
  * @descs: Pointer to an array of signal descriptors that comprise the
  *         function expression
-- 
2.27.0



