Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671574C75E2
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbiB1R4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239784AbiB1Rxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DBEAC068;
        Mon, 28 Feb 2022 09:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDC48B815AB;
        Mon, 28 Feb 2022 17:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D2FC340E7;
        Mon, 28 Feb 2022 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070039;
        bh=urQX6y50ENfkDfckR2XgPPLuEaOQejttoMPgSiW3WW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQzvYMVfptxAMrb/TWomR0D7fDydFlyjxt6knVd9Ghc4liJu47rAiz7mq8uqhnl/w
         lqI24Umd+KwYomiKg+dCJbRxRSlT9bfd9F4q80e05S51+0+FtFC8qDHxVqJJgD/kjZ
         wNx/rQIhci+pshCs/mCEeY4oYN/0nn3ryx2hs1b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Savaton <guillaume@baierouge.fr>,
        Samuel Holland <samuel@sholland.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/139] gpio: rockchip: Reset int_bothedge when changing trigger
Date:   Mon, 28 Feb 2022 18:24:20 +0100
Message-Id: <20220228172356.701598093@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 7920af5c826cb4a7ada1ae26fdd317642805adc2 ]

With v2 hardware, an IRQ can be configured to trigger on both edges via
a bit in the int_bothedge register. Currently, the driver sets this bit
when changing the trigger type to IRQ_TYPE_EDGE_BOTH, but fails to reset
this bit if the trigger type is later changed to something else. This
causes spurious IRQs, and when using gpio-keys with wakeup-event-action
set to EV_ACT_(DE)ASSERTED, those IRQs translate into spurious wakeups.

Fixes: 3bcbd1a85b68 ("gpio/rockchip: support next version gpio controller")
Reported-by: Guillaume Savaton <guillaume@baierouge.fr>
Tested-by: Guillaume Savaton <guillaume@baierouge.fr>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 56 +++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index ce63cbd14d69a..24155c038f6d0 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -410,10 +410,8 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 	level = rockchip_gpio_readl(bank, bank->gpio_regs->int_type);
 	polarity = rockchip_gpio_readl(bank, bank->gpio_regs->int_polarity);
 
-	switch (type) {
-	case IRQ_TYPE_EDGE_BOTH:
+	if (type == IRQ_TYPE_EDGE_BOTH) {
 		if (bank->gpio_type == GPIO_TYPE_V2) {
-			bank->toggle_edge_mode &= ~mask;
 			rockchip_gpio_writel_bit(bank, d->hwirq, 1,
 						 bank->gpio_regs->int_bothedge);
 			goto out;
@@ -431,30 +429,34 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 			else
 				polarity |= mask;
 		}
-		break;
-	case IRQ_TYPE_EDGE_RISING:
-		bank->toggle_edge_mode &= ~mask;
-		level |= mask;
-		polarity |= mask;
-		break;
-	case IRQ_TYPE_EDGE_FALLING:
-		bank->toggle_edge_mode &= ~mask;
-		level |= mask;
-		polarity &= ~mask;
-		break;
-	case IRQ_TYPE_LEVEL_HIGH:
-		bank->toggle_edge_mode &= ~mask;
-		level &= ~mask;
-		polarity |= mask;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		bank->toggle_edge_mode &= ~mask;
-		level &= ~mask;
-		polarity &= ~mask;
-		break;
-	default:
-		ret = -EINVAL;
-		goto out;
+	} else {
+		if (bank->gpio_type == GPIO_TYPE_V2) {
+			rockchip_gpio_writel_bit(bank, d->hwirq, 0,
+						 bank->gpio_regs->int_bothedge);
+		} else {
+			bank->toggle_edge_mode &= ~mask;
+		}
+		switch (type) {
+		case IRQ_TYPE_EDGE_RISING:
+			level |= mask;
+			polarity |= mask;
+			break;
+		case IRQ_TYPE_EDGE_FALLING:
+			level |= mask;
+			polarity &= ~mask;
+			break;
+		case IRQ_TYPE_LEVEL_HIGH:
+			level &= ~mask;
+			polarity |= mask;
+			break;
+		case IRQ_TYPE_LEVEL_LOW:
+			level &= ~mask;
+			polarity &= ~mask;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	rockchip_gpio_writel(bank, level, bank->gpio_regs->int_type);
-- 
2.34.1



