Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5986380E7
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 23:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKXW3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 17:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKXW3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 17:29:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ADB8FB0A;
        Thu, 24 Nov 2022 14:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669328951; x=1700864951;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RCRRDp08lZIx9uPRpzFvsZ4CNT2lsbwsHsXdZTgGwTE=;
  b=bsWpOpWy4zovYpWqxnSMAbSBcpGFtV0aSxR5lOEMh/06mKWobS/zgvZS
   GsP69ch6N+DeaAzRKyZhdVq9AFlp0c/FhYihJiUXakYdhPThk8TwbDly0
   H8gU/EPsFKIgOvvhsrxuDzQQEGj/7LnaKD51BaCzKZZJeGfnjcJ1e9xlP
   OKvrjw4IR6eYTuLPEKBc4dgaTwyRBydvpszrr3Iml4g3Gn1H+hUGVKRTh
   FnuewuSzviPdj2/fIqGy2YHl4Iduoe8sBp6V3G678fU0yRHswKBMStdxn
   j48n+ApEFZ9xLVfiAGNHl9CUbuadZEJZPO5KaoyEKFCJxGf9h76S9dqkl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314407970"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="314407970"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 14:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="644608935"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="644608935"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 24 Nov 2022 14:29:09 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 604B9128; Fri, 25 Nov 2022 00:29:35 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andy@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Dale Smith <dalepsmith@gmail.com>,
        John Harris <jmharris@gmail.com>
Subject: [PATCH v1 1/1] pinctrl: intel: Save and restore pins in "direct IRQ" mode
Date:   Fri, 25 Nov 2022 00:29:26 +0200
Message-Id: <20221124222926.72326-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Linus, I hope that this can still make v6.1 release. I'm not going to
send a PR for this change unless you insist.

 drivers/pinctrl/intel/pinctrl-intel.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 739030e24093..57553ac77518 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -446,9 +446,14 @@ static void __intel_gpio_set_direction(void __iomem *padcfg0, bool input)
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
@@ -1705,6 +1710,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_data);
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1719,6 +1725,25 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
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
 
-- 
2.35.1

