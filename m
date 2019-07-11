Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2282D6532D
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 10:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfGKI3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 04:29:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38231 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGKI3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 04:29:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so5268985wrr.5
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 01:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FdHUqoEiI/8PFzP+nb28CeapgJPIaOc+zD/Fqu3mxsA=;
        b=hDRkpqgQiAzNXdREpgCryNPTTpkPxbaw2kKafW0BWjDICnyBpzULAh4PkGTmfT/Qb+
         OxHtAeKq6KLpAH+7IBPhIpFhpjblmzu3ovCNDSEhBaF9Ysa+VCyYTxIb+Wev658fvedi
         /ODbN7gEOOBry0AtyeoYvGDzvFYpiPGE0nyji8nrrCO2pRi3UqbLr61ee30Z3rWlfR6Q
         60g1qCgqxDvqQbfHLDkz+aX9Shl7IkFYfeI5cKjnjIVi8IETiVrQns/g/HSvFCDnNj8H
         xtq6UwHdRMxmNGfWNmhVLHeJiRNZI4niFsR4L/9sxg20TIAcJq2G7WgC2a5lJ4U/jgTm
         943A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FdHUqoEiI/8PFzP+nb28CeapgJPIaOc+zD/Fqu3mxsA=;
        b=sQFWrzTwK0jmeJN8oWNodAK7PkTeZHMWsEz2AhW4YDSVKw3WfpzoZrUA1rg/L+hFSr
         sCQE3qNwP3n+B799BAweKOGPrXqwKJYi3fNUxitTSd6kqmMc+DmzsHI+moMe3lQWW4O/
         3VobL2b+iga8jCdpIDuoBr3D7kKEJdRy6MctGV7VFoLfWAZj+4PX9qYdPH4eDKJ/Q7Fd
         66QrCNDqgcKnelOsCtRrrMOHCi1JrnNZtHaFhZhNjPUhtr7jetuMkuxIW1GTCRQNqXSV
         vjZNzIQL4oRoZZypMVxmM8paVlCUKVtMYhTJd22EQrVy4oH71Kwqknl/gUv1ex+OZ0K/
         O9Yw==
X-Gm-Message-State: APjAAAVjZabs/Eb3qatK7fBbIAjyrFb/IbRAV9WSyvKx9CBw0WCThQZk
        5d9DaNK4riegde+OtmbTFAA=
X-Google-Smtp-Source: APXvYqwchytOtZ9tsjAn0HXoKcFxOTCKPL1ct7E9RABxwigkhJc8CkAKO3nNjvDrpBZVqamEnzg7bw==
X-Received: by 2002:adf:f888:: with SMTP id u8mr3343527wrp.238.1562833782970;
        Thu, 11 Jul 2019 01:29:42 -0700 (PDT)
Received: from localhost.localdomain (amontpellier-652-1-281-69.w109-210.abo.wanadoo.fr. [109.210.96.69])
        by smtp.gmail.com with ESMTPSA id x20sm9374781wrg.10.2019.07.11.01.29.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 01:29:42 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Phil Reid <preid@electromag.com.au>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] gpio: em: remove the gpiochip before removing the irq domain
Date:   Thu, 11 Jul 2019 10:29:35 +0200
Message-Id: <20190711082936.8706-1-brgl@bgdev.pl>
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

Use devm_add_action_or_reset() to keep the ordering right and entirely
kill the remove() callback in the driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
v1 -> v2:
- use devm_add_action_or_reset() to automatically remove the domain if
  the underlying devm_add_action() fails

 drivers/gpio/gpio-em.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index b6af705a4e5f..a87951293aaa 100644
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
@@ -333,39 +340,30 @@ static int em_gio_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	ret = devm_add_action_or_reset(&pdev->dev, em_gio_irq_domain_remove,
+				       p->irq_domain);
+	if (ret)
+		return ret;
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
@@ -376,7 +374,6 @@ MODULE_DEVICE_TABLE(of, em_gio_dt_ids);
 
 static struct platform_driver em_gio_device_driver = {
 	.probe		= em_gio_probe,
-	.remove		= em_gio_remove,
 	.driver		= {
 		.name	= "em_gio",
 		.of_match_table = em_gio_dt_ids,
-- 
2.21.0

