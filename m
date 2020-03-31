Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD8919918D
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgCaJPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731872AbgCaJO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB142137B;
        Tue, 31 Mar 2020 09:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646097;
        bh=LmSOA6eA7punsys1NXG8+fu3gkgXH5pP+LxHwgF/0sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYg4mFCKi9BQCmy2ebF7sPbrsL665aaA2HfScneK2zwlS8wl9b+x7OK5N9RTO+lJH
         8PX2q4EMBNxJFIBdKD7fcaFcqII+EczjfBjcpWI7zWBuS9aKgQh6wSiKLdUcpcrdo5
         sbLW0XfBmpw73UGPMPnugXAjjLJs1VqTUNUV85d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 083/155] gpiolib: Fix irq_disable() semantics
Date:   Tue, 31 Mar 2020 10:58:43 +0200
Message-Id: <20200331085427.596028836@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 8959b304c7062889b1276092cc8590dc1ba98f65 upstream.

The implementation if .irq_disable() which kicks in between
the gpiolib and the driver is not properly mimicking the
expected semantics of the irqchip core: the irqchip will
call .irq_disable() if that exists, else it will call
mask_irq() which first checks if .irq_mask() is defined
before calling it.

Since we are calling it unconditionally, we get this bug
from drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c, as it only
defines .irq_mask_ack and not .irq_mask:

  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = (ptrval)
  (...)
  PC is at 0x0
  LR is at gpiochip_irq_disable+0x20/0x30

Fix this by only calling .irq_mask() if it exists.

Cc: Brian Masney <masneyb@onstation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Fixes: 461c1a7d4733 ("gpiolib: override irq_enable/disable")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20200306132326.1329640-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2194,9 +2194,16 @@ static void gpiochip_irq_disable(struct
 {
 	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
 
+	/*
+	 * Since we override .irq_disable() we need to mimic the
+	 * behaviour of __irq_disable() in irq/chip.c.
+	 * First call .irq_disable() if it exists, else mimic the
+	 * behaviour of mask_irq() which calls .irq_mask() if
+	 * it exists.
+	 */
 	if (chip->irq.irq_disable)
 		chip->irq.irq_disable(d);
-	else
+	else if (chip->irq.chip->irq_mask)
 		chip->irq.chip->irq_mask(d);
 	gpiochip_disable_irq(chip, d->hwirq);
 }


