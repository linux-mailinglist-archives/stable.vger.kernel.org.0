Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E4464421
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 11:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfGJJI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 05:08:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55532 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbfGJJI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 05:08:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so1420366wmj.5
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=32ir8BoyHUApgZIdTE/QpJVn9dg1MJ7QifLyluzaJtg=;
        b=iG2dLcmapWgTGUjHBg8ecVV631PEaBJxae3t8aI6ryIN9o4MvjnMv7fXHbC4okbWiL
         LoPW8zq2a7rI1Dt+SYkFu6U6MGGXKEbUCy28TYXx1dcZSAM21LCDkkYIKyvYiBs4fBTz
         M8SSpSukIP0Qzm6fGOpwL3l4YWwYyoU7i6Iim+szA1QsDf5Ar4lapJ/8rSrv52cki9aP
         HzqVEHbJHdUiPB9QK01pI6TshGZPrGO0rz6SG6dm8YfK18VlJLzI2xXasm2SbMEEcl4/
         M43DykhARgXvGbQcRoS1mwHgYzABmEtkUSVAC6Jxu93bxJnyhPvzYsF2ookuIwJ/XGcn
         pRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=32ir8BoyHUApgZIdTE/QpJVn9dg1MJ7QifLyluzaJtg=;
        b=pJwkm605/MVKR3ZSIbJrMnK4BxTL9zAuzGvFo1zJANIz09D4itC6h5AAHI044pzt4z
         SbF5XFkr2EU3goGWKiHzTMXXPKvkJbvKUc86tOQzKG7zLZtQob1x1uXkkdpj+g7VUsAm
         Wd94Ytu2kziDRr4cxpY+F/Gkrpl8Zr7HBlkSgAhYMzPYFx6MiE2uM37g8sCmv//k9Xk/
         zbJzLT7JCyfqgPXle6k1UHAsRvzLsV2IwFuDQIvcM25Al+74xvLlk7PDYvJK2Ea6zbxr
         AKDVS7/OJ0w+DZrhpnMRAvXtkz4i15aJEhsrJl7DISvkUfwFFcyMNeZd9gJW0ruQHS4x
         pm/Q==
X-Gm-Message-State: APjAAAV6df3MvPZaD69f6+M3dZe8eAuK3AojXk3QlhmBL112bIRUk2WU
        VTACpIjI441LybDUMcyiXNLPVjdhK9U=
X-Google-Smtp-Source: APXvYqww6icE8e7jiI4V2OlyxAFWjE/erPYTa+ycmXTiz3PblU97UZU9UoJDm5tJrmXxBpmkG3F4zw==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr4118488wmg.135.1562749736681;
        Wed, 10 Jul 2019 02:08:56 -0700 (PDT)
Received: from debian-brgl.home ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id u186sm2308511wmu.26.2019.07.10.02.08.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 02:08:56 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] gpio: em: remove the gpiochip before removing the irq domain
Date:   Wed, 10 Jul 2019 11:08:51 +0200
Message-Id: <20190710090852.9239-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

In commit 8764c4ca5049 ("gpio: em: use the managed version of
gpiochip_add_data()") we implicitly altered the ordering of resource
freeing: since gpiochip_remove() calls gpiochip_irqchip_remove()
internally, we now can potentially use the irq_domain after it was
destroyed in the remove() callback (as devm resources are freed after
remove() has returned).

Use devm_add_action() to keep the ordering right and entirely kill
the remove() callback in the driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/gpio/gpio-em.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index b6af705a4e5f..c88028ac66f2 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -259,6 +259,13 @@ static const struct irq_domain_ops em_gio_irq_domain_ops = {
 	.xlate	= irq_domain_xlate_twocell,
 };
 
+static void em_gio_irq_domain_remove(void *data)
+{
+	struct irq_domain *domain = data;
+
+	irq_domain_remove(domain);
+}
+
 static int em_gio_probe(struct platform_device *pdev)
 {
 	struct em_gio_priv *p;
@@ -333,39 +340,32 @@ static int em_gio_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	ret = devm_add_action(&pdev->dev,
+			      em_gio_irq_domain_remove, p->irq_domain);
+	if (ret) {
+		irq_domain_remove(p->irq_domain);
+		return ret;
+	}
+
 	if (devm_request_irq(&pdev->dev, irq[0]->start,
 			     em_gio_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request low IRQ\n");
-		ret = -ENOENT;
-		goto err1;
+		return -ENOENT;
 	}
 
 	if (devm_request_irq(&pdev->dev, irq[1]->start,
 			     em_gio_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request high IRQ\n");
-		ret = -ENOENT;
-		goto err1;
+		return -ENOENT;
 	}
 
 	ret = devm_gpiochip_add_data(&pdev->dev, gpio_chip, p);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add GPIO controller\n");
-		goto err1;
+		return ret;
 	}
 
 	return 0;
-
-err1:
-	irq_domain_remove(p->irq_domain);
-	return ret;
-}
-
-static int em_gio_remove(struct platform_device *pdev)
-{
-	struct em_gio_priv *p = platform_get_drvdata(pdev);
-
-	irq_domain_remove(p->irq_domain);
-	return 0;
 }
 
 static const struct of_device_id em_gio_dt_ids[] = {
@@ -376,7 +376,6 @@ MODULE_DEVICE_TABLE(of, em_gio_dt_ids);
 
 static struct platform_driver em_gio_device_driver = {
 	.probe		= em_gio_probe,
-	.remove		= em_gio_remove,
 	.driver		= {
 		.name	= "em_gio",
 		.of_match_table = em_gio_dt_ids,
-- 
2.21.0

