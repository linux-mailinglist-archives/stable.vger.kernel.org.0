Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38C54069A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiFGRhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347648AbiFGRfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B2671D95;
        Tue,  7 Jun 2022 10:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D2F0614D2;
        Tue,  7 Jun 2022 17:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32228C385A5;
        Tue,  7 Jun 2022 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623063;
        bh=ulQTVT6ZnXZ+m8mLeQxMtSc5sv6EYb6RAVOJ2jq00pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKVCP3P6K+wQ3w6aJtpY07QAoX2Ngdat9m/QBToFUaNj1AtJiNF4ssDENgn7paGCQ
         /M1dMqxOi8wlVyiBCVw3OkI77K1QZT0Qac3Aemh3w6KHwF/BhhzS6J7DK8vaGNvqOr
         bUa4Lr+/azOdfANrH/eeVDy0Q4kuixaS8jNUwcWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/452] gpiolib: of: Introduce hook for missing gpio-ranges
Date:   Tue,  7 Jun 2022 19:02:18 +0200
Message-Id: <20220607164916.923774152@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 3550bba25d5587a701e6edf20e20984d2ee72c78 ]

Since commit 2ab73c6d8323 ("gpio: Support GPIO controllers without pin-ranges")
the device tree nodes of GPIO controller need the gpio-ranges property to
handle gpio-hogs. Unfortunately it's impossible to guarantee that every new
kernel is shipped with an updated device tree binary.

In order to provide backward compatibility with those older DTB, we need a
callback within of_gpiochip_add_pin_range() so the relevant platform driver
can handle this case.

Fixes: 2ab73c6d8323 ("gpio: Support GPIO controllers without pin-ranges")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>
Link: https://lore.kernel.org/r/20220409095129.45786-2-stefan.wahren@i2se.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c   |  5 +++++
 include/linux/gpio/driver.h | 12 ++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 921a99578ff0..01424af654db 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -933,6 +933,11 @@ static int of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	if (!np)
 		return 0;
 
+	if (!of_property_read_bool(np, "gpio-ranges") &&
+	    chip->of_gpio_ranges_fallback) {
+		return chip->of_gpio_ranges_fallback(chip, np);
+	}
+
 	group_names = of_find_property(np, group_names_propname, NULL);
 
 	for (;; index++) {
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index b216899b4745..0552a9859a01 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -477,6 +477,18 @@ struct gpio_chip {
 	 */
 	int (*of_xlate)(struct gpio_chip *gc,
 			const struct of_phandle_args *gpiospec, u32 *flags);
+
+	/**
+	 * @of_gpio_ranges_fallback:
+	 *
+	 * Optional hook for the case that no gpio-ranges property is defined
+	 * within the device tree node "np" (usually DT before introduction
+	 * of gpio-ranges). So this callback is helpful to provide the
+	 * necessary backward compatibility for the pin ranges.
+	 */
+	int (*of_gpio_ranges_fallback)(struct gpio_chip *gc,
+				       struct device_node *np);
+
 #endif /* CONFIG_OF_GPIO */
 };
 
-- 
2.35.1



