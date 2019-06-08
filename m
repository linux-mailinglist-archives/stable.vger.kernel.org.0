Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6108B39E7B
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfFHLs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbfFHLs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:48:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C492521726;
        Sat,  8 Jun 2019 11:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994536;
        bh=xGNvfSkJpos0XatsvLVLRADF5VlntOdYvEp1Bbncnjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBbZoenDdXIzRR7r00sby1YiZCBmjO42/RSEwM+YKP92ZMOwGwfvKcZEeCryEGPIT
         hJtYewF6svSCLVS+8l7Dx2ksbVeIN9NdA3BJDnoFPQHx5PuTncRpnGQAV/oVPD/VHw
         YSNSe+kx8+v8aG9aAGyN2Jphti/RmMPLI3mlKdio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kbuild test robot <lkp@intel.com>,
        linux-gpio@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 05/13] gpio: fix gpio-adp5588 build errors
Date:   Sat,  8 Jun 2019 07:48:37 -0400
Message-Id: <20190608114847.9973-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114847.9973-1-sashal@kernel.org>
References: <20190608114847.9973-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

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
index 469dc378adeb..aaae6040b4c8 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -579,6 +579,7 @@ config GPIO_ADP5588
 config GPIO_ADP5588_IRQ
 	bool "Interrupt controller support for ADP5588"
 	depends on GPIO_ADP5588=y
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to enable the adp5588 to be used as an interrupt
 	  controller. It requires the driver to be built in the kernel.
-- 
2.20.1

