Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC940541BEE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381943AbiFGVz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383706AbiFGVxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21348216286;
        Tue,  7 Jun 2022 12:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECED6618DF;
        Tue,  7 Jun 2022 19:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014F9C385A2;
        Tue,  7 Jun 2022 19:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629119;
        bh=wppAPTYZacra8jvjOGCwiUf7y78jF2kYF71m4qcN1Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVHmiAslLOAMyzxxzVpLkJLg8JOIVQZie4M3Jro7ANVT3ZupzYfMQDCL3w4ccZYOu
         bmm266/dHLrf3y9uS8Q8DLbXaki8j5LNK1M9YY4jF696kR2M2Zx1IKHYRI1pNJwWB6
         aU5cNk64M3Q19lm1iiW9CKxkD4+qvKMJ5jo+4daQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 575/879] pinctrl: bcm2835: implement hook for missing gpio-ranges
Date:   Tue,  7 Jun 2022 19:01:33 +0200
Message-Id: <20220607165019.545531859@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 47e433e09c5c..dad453054776 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -358,6 +358,22 @@ static int bcm2835_gpio_direction_output(struct gpio_chip *chip,
 	return 0;
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
@@ -372,6 +388,7 @@ static const struct gpio_chip bcm2835_gpio_chip = {
 	.base = -1,
 	.ngpio = BCM2835_NUM_GPIOS,
 	.can_sleep = false,
+	.of_gpio_ranges_fallback = bcm2835_of_gpio_ranges_fallback,
 };
 
 static const struct gpio_chip bcm2711_gpio_chip = {
@@ -388,6 +405,7 @@ static const struct gpio_chip bcm2711_gpio_chip = {
 	.base = -1,
 	.ngpio = BCM2711_NUM_GPIOS,
 	.can_sleep = false,
+	.of_gpio_ranges_fallback = bcm2835_of_gpio_ranges_fallback,
 };
 
 static void bcm2835_gpio_irq_handle_bank(struct bcm2835_pinctrl *pc,
-- 
2.35.1



