Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36FF24088C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgHJPVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbgHJPUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036222075F;
        Mon, 10 Aug 2020 15:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072822;
        bh=FVS1rwU/d7kpluk2AmFSvZlK16GV3N0vXDMvPzBHcPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFB7H72mf53Qt8WpmRE9fWEEtrh+TdiXM7azOm/9qIlr+EvH3Y6iLuFmS/aXz/T0E
         5uXr/Sf6iTA8jugTwv+4TZHWMfoFecg77wp1o/yf6r2M9ClQoxbPlhDmujCaaVLLNo
         V4kS/9xC2/ORXdvtSToi8RO6BarQqhpULseqsFi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.8 30/38] gpio: max77620: Fix missing release of interrupt
Date:   Mon, 10 Aug 2020 17:19:20 +0200
Message-Id: <20200810151805.396220448@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 2a5e6f7eede8cd1c4bac0b8ec6491cec4e75c99a upstream.

The requested interrupt is never released by the driver. Fix this by
using the resource-managed variant of request_threaded_irq().

Fixes: ab3dd9cc24d4 ("gpio: max77620: Fix interrupt handling")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: <stable@vger.kernel.org> # 5.5+
Link: https://lore.kernel.org/r/20200709171203.12950-3-digetx@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-max77620.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-max77620.c
+++ b/drivers/gpio/gpio-max77620.c
@@ -305,8 +305,9 @@ static int max77620_gpio_probe(struct pl
 	gpiochip_irqchip_add_nested(&mgpio->gpio_chip, &max77620_gpio_irqchip,
 				    0, handle_edge_irq, IRQ_TYPE_NONE);
 
-	ret = request_threaded_irq(gpio_irq, NULL, max77620_gpio_irqhandler,
-				   IRQF_ONESHOT, "max77620-gpio", mgpio);
+	ret = devm_request_threaded_irq(&pdev->dev, gpio_irq, NULL,
+					max77620_gpio_irqhandler, IRQF_ONESHOT,
+					"max77620-gpio", mgpio);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request IRQ: %d\n", ret);
 		return ret;


