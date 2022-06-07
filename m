Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4565406C9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344796AbiFGRiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347741AbiFGRfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:35:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C940E1078A1;
        Tue,  7 Jun 2022 10:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B132CE23CF;
        Tue,  7 Jun 2022 17:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B67C385A5;
        Tue,  7 Jun 2022 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623066;
        bh=Ut+bZrRoeLbuyeDLyw/oRKMIW9n1SnNA9eXj6UzrNTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNEPhAw2UO9o8PVW/G4Wk2fwykygn3hmdUfWbQ/nFONRGG9CbEt8Jv03L6LN1VdOz
         QZ9OT9tXCJjf2YheHJJ8wUiKNuvBrwXZ9eh0khkRoR/wvK318XZ3uWT6tykQpvA8Rd
         Hlts6bcMrqoqsaL/NVYtkXkwUvBzkt5v8hj1zPFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/452] pinctrl: bcm2835: implement hook for missing gpio-ranges
Date:   Tue,  7 Jun 2022 19:02:19 +0200
Message-Id: <20220607164916.953420462@linuxfoundation.org>
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

[ Upstream commit d2b67744fd99b06555b7e4d67302ede6c7c6a638 ]

The commit c8013355ead6 ("ARM: dts: gpio-ranges property is now required")
fixed the GPIO probing issues caused by "pinctrl: bcm2835: Change init
order for gpio hogs". This changed only the kernel DTS files. Unfortunately
it isn't guaranteed that these files are shipped to all users.

So implement the necessary backward compatibility for BCM2835 and
BCM2711 platform.

Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220409095129.45786-3-stefan.wahren@i2se.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 6768b2f03d68..39d2024dc2ee 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -351,6 +351,22 @@ static int bcm2835_gpio_direction_output(struct gpio_chip *chip,
 	return pinctrl_gpio_direction_output(chip->base + offset);
 }
 
+static int bcm2835_of_gpio_ranges_fallback(struct gpio_chip *gc,
+					   struct device_node *np)
+{
+	struct pinctrl_dev *pctldev = of_pinctrl_get(np);
+
+	of_node_put(np);
+
+	if (!pctldev)
+		return 0;
+
+	gpiochip_add_pin_range(gc, pinctrl_dev_get_devname(pctldev), 0, 0,
+			       gc->ngpio);
+
+	return 0;
+}
+
 static const struct gpio_chip bcm2835_gpio_chip = {
 	.label = MODULE_NAME,
 	.owner = THIS_MODULE,
@@ -365,6 +381,7 @@ static const struct gpio_chip bcm2835_gpio_chip = {
 	.base = -1,
 	.ngpio = BCM2835_NUM_GPIOS,
 	.can_sleep = false,
+	.of_gpio_ranges_fallback = bcm2835_of_gpio_ranges_fallback,
 };
 
 static const struct gpio_chip bcm2711_gpio_chip = {
@@ -381,6 +398,7 @@ static const struct gpio_chip bcm2711_gpio_chip = {
 	.base = -1,
 	.ngpio = BCM2711_NUM_GPIOS,
 	.can_sleep = false,
+	.of_gpio_ranges_fallback = bcm2835_of_gpio_ranges_fallback,
 };
 
 static void bcm2835_gpio_irq_handle_bank(struct bcm2835_pinctrl *pc,
-- 
2.35.1



