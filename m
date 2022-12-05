Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C3464334A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiLETfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiLETfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:35:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8365A0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36649612D8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BB7C433C1;
        Mon,  5 Dec 2022 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268663;
        bh=72QWlh/ywBxcttKhziILkGnOUblGZnMtqbNXIgB1pN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDfZGBEt3DyIkkc7gaBnV63ll+LlReHPV2uiZDE6SmHFJvFk5ebLu8SqVN6RH6PA7
         QGa0QbDFDm10xXaj3VGayZxCstGsjZ5gZ0kM2fcP36z/AE7aN1HQXUD7AXaWHf8fZm
         Z3veleYUw2+7h2GdaoOayklDNNoo2iKwCDL8lTzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dale Smith <dalepsmith@gmail.com>,
        John Harris <jmharris@gmail.com>
Subject: [PATCH 5.10 59/92] pinctrl: intel: Save and restore pins in "direct IRQ" mode
Date:   Mon,  5 Dec 2022 20:10:12 +0100
Message-Id: <20221205190805.477835237@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 6989ea4881c8944fbf04378418bb1af63d875ef8 upstream.

The firmware on some systems may configure GPIO pins to be
an interrupt source in so called "direct IRQ" mode. In such
cases the GPIO controller driver has no idea if those pins
are being used or not. At the same time, there is a known bug
in the firmwares that don't restore the pin settings correctly
after suspend, i.e. by an unknown reason the Rx value becomes
inverted.

Hence, let's save and restore the pins that are configured
as GPIOs in the input mode with GPIROUTIOXAPIC bit set.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Dale Smith <dalepsmith@gmail.com>
Reported-and-tested-by: John Harris <jmharris@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214749
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20221124222926.72326-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -426,9 +426,14 @@ static void __intel_gpio_set_direction(v
 	writel(value, padcfg0);
 }
 
+static int __intel_gpio_get_gpio_mode(u32 value)
+{
+	return (value & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+}
+
 static int intel_gpio_get_gpio_mode(void __iomem *padcfg0)
 {
-	return (readl(padcfg0) & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+	return __intel_gpio_get_gpio_mode(readl(padcfg0));
 }
 
 static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
@@ -1604,6 +1609,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1618,6 +1624,25 @@ static bool intel_pinctrl_should_save(st
 	    gpiochip_line_is_irq(&pctrl->chip, intel_pin_to_gpio(pctrl, pin)))
 		return true;
 
+	/*
+	 * The firmware on some systems may configure GPIO pins to be
+	 * an interrupt source in so called "direct IRQ" mode. In such
+	 * cases the GPIO controller driver has no idea if those pins
+	 * are being used or not. At the same time, there is a known bug
+	 * in the firmwares that don't restore the pin settings correctly
+	 * after suspend, i.e. by an unknown reason the Rx value becomes
+	 * inverted.
+	 *
+	 * Hence, let's save and restore the pins that are configured
+	 * as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
+	 *
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
+	 */
+	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
+	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+		return true;
+
 	return false;
 }
 


