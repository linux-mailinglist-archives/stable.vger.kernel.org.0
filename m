Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B63382F71
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbhEQOQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239011AbhEQOOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D76C613E5;
        Mon, 17 May 2021 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260535;
        bh=30jsrc77WtINc5vw2shIcoQN3HjUq1nr2Dhbb6r4OeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQZIXgqun2/HUq61s7qTuAsgoVvdOKAxBDdN8boCn0Yj0c8c0KoOpRYbQMl1z1ism
         m521Mok1loJC662hJ2i22RshjUD2vS5c7ufF9B75aZKn3rIAzKQjn4wOfjzXlEHRi1
         emr0yB38f3KHx6yV+TqVFyjMmg1EmJOXbtjTAVtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 125/363] leds: lgm: fix gpiolib dependency
Date:   Mon, 17 May 2021 15:59:51 +0200
Message-Id: <20210517140306.846128736@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 34731ed13e8a8ca95fa0dca466537396b5f2d1af ]

Without gpiolib, the driver fails to build:

    drivers/leds/blink/leds-lgm-sso.c:123:19: error: field has incomplete type 'struct gpio_chip'
            struct gpio_chip chip;
                             ^
    include/linux/gpio.h:107:8: note: forward declaration of 'struct gpio_chip'
    struct gpio_chip;
           ^
    drivers/leds/blink/leds-lgm-sso.c:263:3: error: implicit declaration of function 'gpiod_set_value' [-Werror,-Wimplicit-function-declaration]
                    gpiod_set_value(led->gpiod, val);
                    ^
    drivers/leds/blink/leds-lgm-sso.c:263:3: note: did you mean 'gpio_set_value'?
    include/linux/gpio.h:168:20: note: 'gpio_set_value' declared here
    static inline void gpio_set_value(unsigned gpio, int value)
                       ^
    drivers/leds/blink/leds-lgm-sso.c:345:3: error: implicit declaration of function 'gpiod_set_value' [-Werror,-Wimplicit-function-declaration]
                    gpiod_set_value(led->gpiod, 1);
                    ^

Add the dependency in Kconfig.

Fixes: c3987cd2bca3 ("leds: lgm: Add LED controller driver for LGM SoC")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/blink/Kconfig b/drivers/leds/blink/Kconfig
index 265b53476a80..6dedc58c47b3 100644
--- a/drivers/leds/blink/Kconfig
+++ b/drivers/leds/blink/Kconfig
@@ -9,6 +9,7 @@ if LEDS_BLINK
 
 config LEDS_BLINK_LGM
 	tristate "LED support for Intel LGM SoC series"
+	depends on GPIOLIB
 	depends on LEDS_CLASS
 	depends on MFD_SYSCON
 	depends on OF
-- 
2.30.2



