Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFAC21FBDB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgGNSzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730854AbgGNSzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A7CA21D79;
        Tue, 14 Jul 2020 18:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752918;
        bh=JU237hWnDCNGho2nOLzreWepG0pFmFvZo5x1vMrKeAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgFMDQSawG1Pj1qVYEodk/ATASs1bzI1j4g0F2Ccgx+nvM/+ff+OUsiSdP06mK484
         Ec9DHOiPdEl7qA3O7S+8011WnNOtXCHNKTyDfD2dKbSQUKexMcvWTbxrtgYGHnegCp
         bn+ic1x9ddu/a45cVJ4RTqNUo7nS2OZE1NZ0HJVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 050/166] gpio: pca953x: Fix GPIO resource leak on Intel Galileo Gen 2
Date:   Tue, 14 Jul 2020 20:43:35 +0200
Message-Id: <20200714184118.271627771@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5d8913504ccfeea6120df5ae1c6f4479ff09b931 ]

When adding a quirk for IRQ on Intel Galileo Gen 2 the commit ba8c90c61847
("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
missed GPIO resource release. We can safely do this in the same quirk, since
IRQ will be locked by GPIO framework when requested and unlocked on freeing.

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index a10411958e3f2..48bea0997e70c 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -176,7 +176,12 @@ static int pca953x_acpi_get_irq(struct device *dev)
 	if (ret)
 		return ret;
 
-	return gpio_to_irq(pin);
+	ret = gpio_to_irq(pin);
+
+	/* When pin is used as an IRQ, no need to keep it requested */
+	gpio_free(pin);
+
+	return ret;
 }
 #endif
 
-- 
2.25.1



