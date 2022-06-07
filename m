Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F6E541512
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377178AbiFGU2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359578AbiFGUXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4928113D0F;
        Tue,  7 Jun 2022 11:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2EDBB82239;
        Tue,  7 Jun 2022 18:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A78C385A2;
        Tue,  7 Jun 2022 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626729;
        bh=X2ui7TYzHuY8jWMYRvjVJF4NqQtBD9L+/RpYLL9Y9cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEpzDDMbRB0pXOCQdH90vazhwLLHL9tJx+SlRRzqk9wgkHHxMksIs/kJ7LaZQa//l
         phZjrKUGoHzZviEr24NnJ9qn4iWYOVmUA+63P07Z+KufTxRggnJKDRYRJzI4Xzyul1
         +zS5nmKgtng3H0V8F9xgmlE149j46QPo5AGw9uQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 484/772] gpiolib: of: Introduce hook for missing gpio-ranges
Date:   Tue,  7 Jun 2022 19:01:16 +0200
Message-Id: <20220607165003.249211689@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 775a7dadf9a3..1fcb759062c4 100644
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
index f8996b46f430..9f0408222f40 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -498,6 +498,18 @@ struct gpio_chip {
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



