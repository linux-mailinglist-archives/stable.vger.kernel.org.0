Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4C1EA948
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgFASAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729587AbgFASAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73060206E2;
        Mon,  1 Jun 2020 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034400;
        bh=EVMYPFXCa8UDgn/EF4So3rbeYZBZ4Xjld31+FkORFH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryElohxY3QoHhzAmgy7yKxGJqvEihPvrA3zMgSq4FNzCdRnACHsGS0gs200qZtq6q
         2ilazZY1PNr5Klsf9ivS7zeZ2N6Kmn06Rl5RZtE7uCqFNskkKqzsfUagLifhLV2s/a
         dxzNaC6pj9Viwt/+neyilPQDBYILYEPpWJvKhwkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/77] gpio: tegra: mask GPIO IRQs during IRQ shutdown
Date:   Mon,  1 Jun 2020 19:53:20 +0200
Message-Id: <20200601174019.217567368@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

[ Upstream commit 0cf253eed5d2bdf7bb3152457b38f39b012955f7 ]

The driver currently leaves GPIO IRQs unmasked even when the GPIO IRQ
client has released the GPIO IRQ. This allows the HW to raise IRQs, and
SW to process them, after shutdown. Fix this by masking the IRQ when it's
shut down. This is usually taken care of by the irqchip core, but since
this driver has a custom irq_shutdown implementation, it must do this
explicitly itself.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Link: https://lore.kernel.org/r/20200427232605.11608-1-swarren@wwwdotorg.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 1eb857e2f62f..dd801f5d5253 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -356,6 +356,7 @@ static void tegra_gpio_irq_shutdown(struct irq_data *d)
 	struct tegra_gpio_info *tgi = bank->tgi;
 	unsigned int gpio = d->hwirq;
 
+	tegra_gpio_irq_mask(d);
 	gpiochip_unlock_as_irq(&tgi->gc, gpio);
 }
 
-- 
2.25.1



