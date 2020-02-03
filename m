Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87C1150BBE
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgBCQaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729919AbgBCQaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:07 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27FB82051A;
        Mon,  3 Feb 2020 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747406;
        bh=kn99cz0GjAnKndxodtkxjSTxtT0/UlgUMolk8tUwlSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISmNg/63LILatZonSREiRsS4VTt1WbL0EemEVZz3o6Wo2m1VFggaLymPcbV7Y09lT
         eKCZ5tXo96YqPEq0BTtTiZeFyJNUd23KQjKAb3nvnyGnfvdBRGsWVKxgplVaMnKypE
         I6YTdWEGi3J4dP85a1ISTOvID6bLH5cvNzp6812U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/89] gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP
Date:   Mon,  3 Feb 2020 16:19:11 +0000
Message-Id: <20200203161920.369849753@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c5706c7defc79de68a115b5536376298a8fef111 ]

Driver fails to compile in a minimized kernel's configuration because of
the missing dependency on GPIOLIB_IRQCHIP.

 error: ‘struct gpio_chip’ has no member named ‘irq’
   44 |   virq = irq_find_mapping(gpio->gpio_chip.irq.domain, offset);

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200106015154.12040-1-digetx@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 2357d2f73c1ad..8d2ab77c6581d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -990,6 +990,7 @@ config GPIO_LP87565
 config GPIO_MAX77620
 	tristate "GPIO support for PMIC MAX77620 and MAX20024"
 	depends on MFD_MAX77620
+	select GPIOLIB_IRQCHIP
 	help
 	  GPIO driver for MAX77620 and MAX20024 PMIC from Maxim Semiconductor.
 	  MAX77620 PMIC has 8 pins that can be configured as GPIOs. The
-- 
2.20.1



