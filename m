Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9ACB6782
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfIRPwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 11:52:07 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41829 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfIRPwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 11:52:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id t10so139423plr.8;
        Wed, 18 Sep 2019 08:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hgDF40EJKMi1lbTCtoI7X1hwyDhhh6fltKUSKOUxbr0=;
        b=iHP90SdEbgkC/O+srbBHe66wt/JC9A2blIYPnV14CtXzAXg8TTVAqvwuaEHrtJmci8
         /WUPYUBCtE8eeS462HuopL5XULobH5M++G1PTuQb1ZcBpqQSTuwcsWQxXoncm8Ns2er4
         YVDcaGtu/6QD65uy/MyRal2EkXpOOJ9xw5jVuvMkmJHEgX3I5qtTgBT53ti/iJKEHLnE
         VErgEGPkB1o2ve590N4+23LT9++nunwfRd0BjPO7gtip1E6/X17cHVYfwDe5xUZFGKJv
         5cnGDKUeSZlIXlSPW3XeFIjIFywqn3EZ8VU8eQ9lETgavLKlrdI5arpjXsfMqCnBQvW0
         l8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hgDF40EJKMi1lbTCtoI7X1hwyDhhh6fltKUSKOUxbr0=;
        b=Hnb/Hnz56RAlaAU3ioBV2Iba1cXJWVcyL67ETuJYqP5DNOfAgfmVedlCRE4VeOzvF4
         s/HLCcnxXcw3hiHyy3/M9pogq9oxcfC7tzzebvCVBnBPeOCfOEgwNKKuRbe2i0wX7qVg
         Cl868jLJi33jYu9op3UkisZed29fQstdoRitCWCcFIECeqLGHtqBGichupQyDD4qrnkj
         G2ppqkA8I9zVx8BUMUPo/wOGXv0fnyRP5kwioTs0dh5wkywKEFU+bP0oTbg1cFXF/oL5
         c3Y3XZAiqE6nuwvodjHuiNZNinP+HaqQJjRyaFHmR8RvFKMMKd9NpVxMIMsHulGz6CW8
         BmaQ==
X-Gm-Message-State: APjAAAXyZj+hwTPkOVO6T5uAp3ksOOxdvIZeX6Ru16w1K6JipTC+FwuK
        i//g5g/cCw5YRTnBVUTW5HBNx+AkpvM=
X-Google-Smtp-Source: APXvYqyr2yRSweOeqQCiVv6VpIO24r8Vx3T3ovM+f2mC3+xHG1g8iWqR29BYCclecTJHLU4+xe4UDg==
X-Received: by 2002:a17:902:7401:: with SMTP id g1mr4962495pll.20.1568821925689;
        Wed, 18 Sep 2019 08:52:05 -0700 (PDT)
Received: from P65xSA.lan ([2001:250:3002:22c0:d407:4304:c30b:1a00])
        by smtp.gmail.com with ESMTPSA id y144sm8572779pfb.188.2019.09.18.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 08:52:05 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     linux-spi@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] spi: spi-gpio: fix crash when num-chipselects is 0
Date:   Wed, 18 Sep 2019 23:52:00 +0800
Message-Id: <20190918155200.12614-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an spi-gpio was specified with num-chipselects = <0> in dts, kernel will crash:

Unable to handle kernel paging request at virtual address 32697073
pgd = (ptrval)
[32697073] *pgd=00000000
Internal error: Oops: 5 [# 1] SMP ARM
Modules linked in:
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.72 #0
Hardware name: Generic DT based system
PC is at validate_desc+0x28/0x80
LR is at gpiod_direction_output+0x14/0x128
...
[<c0544db4>] (validate_desc) from [<c0545228>] (gpiod_direction_output+0x14/0x128)
[<c0545228>] (gpiod_direction_output) from [<c05fa714>] (spi_gpio_setup+0x58/0x64)
[<c05fa714>] (spi_gpio_setup) from [<c05f7258>] (spi_setup+0x12c/0x148)
[<c05f7258>] (spi_setup) from [<c05f7330>] (spi_add_device+0xbc/0x12c)
[<c05f7330>] (spi_add_device) from [<c05f7f74>] (spi_register_controller+0x838/0x924)
[<c05f7f74>] (spi_register_controller) from [<c05fa494>] (spi_bitbang_start+0x108/0x120)
[<c05fa494>] (spi_bitbang_start) from [<c05faa34>] (spi_gpio_probe+0x314/0x338)
[<c05faa34>] (spi_gpio_probe) from [<c05a844c>] (platform_drv_probe+0x34/0x70)

The cause is spi_gpio_setup() did not check if the spi-gpio has chipselect pins
before setting their direction and results in derefing an invalid pointer.

The bug is spotted in kernel 4.19.72 on OpenWrt, and does not occur in 4.14.

There is a similar fix upstream 249e2632dcd0509b8f8f296f5aabf4d48dfd6da8.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/spi/spi-gpio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 77838d8fd..3b7f0d077 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -242,10 +242,12 @@ static int spi_gpio_setup(struct spi_device *spi)
 	 * The CS GPIOs have already been
 	 * initialized from the descriptor lookup.
 	 */
-	cs = spi_gpio->cs_gpios[spi->chip_select];
-	if (!spi->controller_state && cs)
-		status = gpiod_direction_output(cs,
-						!(spi->mode & SPI_CS_HIGH));
+	if (spi_gpio->has_cs) {
+		cs = spi_gpio->cs_gpios[spi->chip_select];
+		if (!spi->controller_state && cs)
+			status = gpiod_direction_output(cs,
+						  !(spi->mode & SPI_CS_HIGH));
+	}
 
 	if (!status)
 		status = spi_bitbang_setup(spi);
-- 
2.23.0

