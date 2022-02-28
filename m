Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05954C73E3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiB1RjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbiB1Rh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:37:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561033BFB5;
        Mon, 28 Feb 2022 09:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD3DB815BD;
        Mon, 28 Feb 2022 17:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35967C340F1;
        Mon, 28 Feb 2022 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069522;
        bh=lOKstslbYrY+nxQARpLVOyEJ89Vqe2153PAdOHBhjNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ6D3YChNfw9YsdogXnZRwoT2y3U+8pK9a9nV5dD7nnWP0i6X1hoZs7p18C0LuC1h
         +mq4BTzgnqcTyvcf4qt5rtAGkg40DlPhjX+mD21RLLWT9jUSXYsoCr490cvddmCAHu
         IoBvEoP4ifVNT3hFbopAh5WLyJ+pc3oawEm9bSqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 50/53] gpio: tegra186: Fix chip_data type confusion
Date:   Mon, 28 Feb 2022 18:24:48 +0100
Message-Id: <20220228172251.915821058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit d1e972ace42390de739cde87d96043dcbe502286 upstream.

The tegra186 GPIO driver makes the assumption that the pointer
returned by irq_data_get_irq_chip_data() is a pointer to a
tegra_gpio structure. Unfortunately, it is actually a pointer
to the inner gpio_chip structure, as mandated by the gpiolib
infrastructure. Nice try.

The saving grace is that the gpio_chip is the first member of
tegra_gpio, so the bug has gone undetected since... forever.

Fix it by performing a container_of() on the pointer. This results
in no additional code, and makes it possible to understand how
the whole thing works.

Fixes: 5b2b135a87fc ("gpio: Add Tegra186 support")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20220211093904.1112679-1-maz@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tegra186.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -234,9 +234,12 @@ static int tegra186_gpio_of_xlate(struct
 	return offset + pin;
 }
 
+#define to_tegra_gpio(x) container_of((x), struct tegra_gpio, gpio)
+
 static void tegra186_irq_ack(struct irq_data *data)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 
 	base = tegra186_gpio_get_base(gpio, data->hwirq);
@@ -248,7 +251,8 @@ static void tegra186_irq_ack(struct irq_
 
 static void tegra186_irq_mask(struct irq_data *data)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 	u32 value;
 
@@ -263,7 +267,8 @@ static void tegra186_irq_mask(struct irq
 
 static void tegra186_irq_unmask(struct irq_data *data)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 	u32 value;
 
@@ -278,7 +283,8 @@ static void tegra186_irq_unmask(struct i
 
 static int tegra186_irq_set_type(struct irq_data *data, unsigned int type)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 	u32 value;
 


