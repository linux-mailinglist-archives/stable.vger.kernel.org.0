Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35202B63D6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbgKQNmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733292AbgKQNmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DD6B206A5;
        Tue, 17 Nov 2020 13:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620524;
        bh=69KL8wVs4W0GqzEaSxcpLeSztfxQ7vyJpa/xfYTFQG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LY+NKXQ1ZJH9zF3ORRFIwg0xADgAD5mWRx7yYTFyW1eAkR9YNn+XdqodKPDwdbNmZ
         NmFCu4yVJ9BBMwNm0J6VWQ9hX8qmC8Bp0s2cYU5OJXQ19CDEhY7U79mr/fcYgEWmja
         AbK+KudRbR03JcFegM7b651IA72/a0dcq1v+UF4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.9 221/255] gpio: sifive: Fix SiFive gpio probe
Date:   Tue, 17 Nov 2020 14:06:01 +0100
Message-Id: <20201117122149.692446257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit b72de3ff19fdc4bbe4d4bb3f4483c7e46e00bac3 upstream.

Fix the check on the number of IRQs to allow up to the maximum (32)
instead of only the maximum minus one.

Fixes: 96868dce644d ("gpio/sifive: Add GPIO driver for SiFive SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Link: https://lore.kernel.org/r/20201107081420.60325-10-damien.lemoal@wdc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-sifive.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -183,7 +183,7 @@ static int sifive_gpio_probe(struct plat
 		return PTR_ERR(chip->regs);
 
 	ngpio = of_irq_count(node);
-	if (ngpio >= SIFIVE_GPIO_MAX) {
+	if (ngpio > SIFIVE_GPIO_MAX) {
 		dev_err(dev, "Too many GPIO interrupts (max=%d)\n",
 			SIFIVE_GPIO_MAX);
 		return -ENXIO;


