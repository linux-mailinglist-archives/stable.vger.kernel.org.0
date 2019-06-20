Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876F54D7C0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfFTSKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbfFTSKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CA412089C;
        Thu, 20 Jun 2019 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054199;
        bh=j+BKCNRN74X5uWshiyqdZsvkmT1yZx0amC6VTFoSuJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoPJHlh9cCo2j25JFf8OeLLS9LmRSjWKM2xHlJ6WlACsblqgBaMGR9uqYrsd72VM7
         yeLms08A62+LJkxYF7qcpqm5YbeZOuN3hBrDuGxHj6jrsl1C76R6SaqYKqFzAnR+kg
         /eBtqcSQZc1QUnOJPvUQUUjOt3z8x+7gDA7Y4Dl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-gpio@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/45] gpio: fix gpio-adp5588 build errors
Date:   Thu, 20 Jun 2019 19:57:24 +0200
Message-Id: <20190620174337.667118954@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e9646f0f5bb62b7d43f0968f39d536cfe7123b53 ]

The gpio-adp5588 driver uses interfaces that are provided by
GPIOLIB_IRQCHIP, so select that symbol in its Kconfig entry.

Fixes these build errors:

../drivers/gpio/gpio-adp5588.c: In function ‘adp5588_irq_handler’:
../drivers/gpio/gpio-adp5588.c:266:26: error: ‘struct gpio_chip’ has no member named ‘irq’
            dev->gpio_chip.irq.domain, gpio));
                          ^
../drivers/gpio/gpio-adp5588.c: In function ‘adp5588_irq_setup’:
../drivers/gpio/gpio-adp5588.c:298:2: error: implicit declaration of function ‘gpiochip_irqchip_add_nested’ [-Werror=implicit-function-declaration]
  ret = gpiochip_irqchip_add_nested(&dev->gpio_chip,
  ^
../drivers/gpio/gpio-adp5588.c:307:2: error: implicit declaration of function ‘gpiochip_set_nested_irqchip’ [-Werror=implicit-function-declaration]
  gpiochip_set_nested_irqchip(&dev->gpio_chip,
  ^

Fixes: 459773ae8dbb ("gpio: adp5588-gpio: support interrupt controller")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-gpio@vger.kernel.org
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3f80f167ed56..2357d2f73c1a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -712,6 +712,7 @@ config GPIO_ADP5588
 config GPIO_ADP5588_IRQ
 	bool "Interrupt controller support for ADP5588"
 	depends on GPIO_ADP5588=y
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to enable the adp5588 to be used as an interrupt
 	  controller. It requires the driver to be built in the kernel.
-- 
2.20.1



