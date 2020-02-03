Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90805150E19
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgBCQtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:49:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbgBCQZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:22 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35CED2080C;
        Mon,  3 Feb 2020 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747121;
        bh=Xhb1nh/FiHIeB1Iv8gg+VodxFY8ceMSYemck/IQ4NRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBRJJUJu4MPyIVzWaK0CKtMe+jqPqRdY75I6PGpNonApCMd5qIT/8wgtFVlbqLShQ
         CODDLH9Sv5NcEA3Q8ME3cYUjN/gWtOSbsbXeljXalYUu9fYejmmsm+LTnwTtpJsIsN
         2xQ/Xn4B5eOTxXQVhONbHKaRKEuEzdIgJzVzXEDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/68] gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP
Date:   Mon,  3 Feb 2020 16:19:17 +0000
Message-Id: <20200203161908.577154146@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
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
index b992badb99dd2..5d097d631e39f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -920,6 +920,7 @@ config GPIO_LP873X
 config GPIO_MAX77620
 	tristate "GPIO support for PMIC MAX77620 and MAX20024"
 	depends on MFD_MAX77620
+	select GPIOLIB_IRQCHIP
 	help
 	  GPIO driver for MAX77620 and MAX20024 PMIC from Maxim Semiconductor.
 	  MAX77620 PMIC has 8 pins that can be configured as GPIOs. The
-- 
2.20.1



