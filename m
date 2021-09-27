Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AE1419A1B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhI0RGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236014AbhI0RGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F16461074;
        Mon, 27 Sep 2021 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762283;
        bh=YK9aUxM+x/SVjA1+AFEDmwnpEuww1OfFA0kiRSklzZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmcJYLGpmydgqg9rAZyEzTk6AYKwvQ0MclQ42YpJ8ueSdjHanbAxBdHKOblSX6uyg
         AoDPi4FYjC3KLS07ZjoqFmXAbwx4d5crAYx0KoLKjWan2u6egFUIxISanrzD2C2MIF
         oUGbN7Ld2b8YE+XS+kOVJJv//gqQnrRcXJpgRB58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/68] gpio: uniphier: Fix void functions to remove return value
Date:   Mon, 27 Sep 2021 19:02:26 +0200
Message-Id: <20210927170221.013699834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 2dd824cca3407bc9a2bd11b00f6e117b66fcfcf1 ]

The return type of irq_chip.irq_mask() and irq_chip.irq_unmask() should
be void.

Fixes: dbe776c2ca54 ("gpio: uniphier: add UniPhier GPIO controller driver")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-uniphier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-uniphier.c b/drivers/gpio/gpio-uniphier.c
index 93cdcc41e9fb..0f1cf50b4dce 100644
--- a/drivers/gpio/gpio-uniphier.c
+++ b/drivers/gpio/gpio-uniphier.c
@@ -188,7 +188,7 @@ static void uniphier_gpio_irq_mask(struct irq_data *data)
 
 	uniphier_gpio_reg_update(priv, UNIPHIER_GPIO_IRQ_EN, mask, 0);
 
-	return irq_chip_mask_parent(data);
+	irq_chip_mask_parent(data);
 }
 
 static void uniphier_gpio_irq_unmask(struct irq_data *data)
@@ -198,7 +198,7 @@ static void uniphier_gpio_irq_unmask(struct irq_data *data)
 
 	uniphier_gpio_reg_update(priv, UNIPHIER_GPIO_IRQ_EN, mask, mask);
 
-	return irq_chip_unmask_parent(data);
+	irq_chip_unmask_parent(data);
 }
 
 static int uniphier_gpio_irq_set_type(struct irq_data *data, unsigned int type)
-- 
2.33.0



