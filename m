Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE4B6433E8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiLETki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiLETkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AD626F7
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB33B811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE919C433C1;
        Mon,  5 Dec 2022 19:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269058;
        bh=/tpOELxwIj6VTNgSuaULuBLZG9FCXL+NackIq/q/DO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVX3xKOYVJByS8hK9JKONKNAC5ZgDqmOLDL4g3rvud3iCcwbmQJ6my5Vgk5oknzxZ
         WKnl/hto7OAu7uEpfVrLoBGRHI6J05wfSy3scpMtSdRc62d/kPfTQ/W43cvI0q6hXk
         sj6PeGZAQCRDqTJbpVd1qvpl8kOMljRAs8PqddFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dale Smith <dalepsmith@gmail.com>,
        John Harris <jmharris@gmail.com>
Subject: [PATCH 5.15 073/120] pinctrl: intel: Save and restore pins in "direct IRQ" mode
Date:   Mon,  5 Dec 2022 20:10:13 +0100
Message-Id: <20221205190808.808828091@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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
@@ -436,9 +436,14 @@ static void __intel_gpio_set_direction(v
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
@@ -1659,6 +1664,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1673,6 +1679,25 @@ static bool intel_pinctrl_should_save(st
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
 


