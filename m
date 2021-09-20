Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58076412653
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387252AbhITS4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384584AbhITSs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF9FB63379;
        Mon, 20 Sep 2021 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159246;
        bh=bctpGfzMw5o3U7ExE35/OvyYBNCX8ZGZmwVaVROj7KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5NdF7YOXyUkrAHC1to6UkBLcujbq5sQJMbFwqggagtb2xgwJ1gJ61HhjeI42MOAD
         8jYL6bJzHRoFuQIdPiNm6wkN+ftctM/bo3qkTyWuztsxb31OGrTKHD84Dq7ourcKAN
         HiOJ8kU2EA3pTyajWz3h4wG8Sl+uuWlViutKHeEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 144/168] gpio: mpc8xxx: Fix a potential double iounmap call in mpc8xxx_probe()
Date:   Mon, 20 Sep 2021 18:44:42 +0200
Message-Id: <20210920163926.393311485@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7d6588931ccd4c09e70a08175cf2e0cf7fc3b869 ]

Commit 76c47d1449fc ("gpio: mpc8xxx: Add ACPI support") has switched to a
managed version when dealing with 'mpc8xxx_gc->regs'. So the corresponding
'iounmap()' call in the error handling path and in the remove should be
removed to avoid a double unmap.

This also allows some simplification in the probe. All the error handling
paths related to managed resources can be direct returns and a NULL check
in what remains in the error handling path can be removed.

Fixes: 76c47d1449fc ("gpio: mpc8xxx: Add ACPI support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 9acfa25ad6ee..fdb22c2e1085 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -332,7 +332,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 				 mpc8xxx_gc->regs + GPIO_DIR, NULL,
 				 BGPIOF_BIG_ENDIAN);
 		if (ret)
-			goto err;
+			return ret;
 		dev_dbg(&pdev->dev, "GPIO registers are LITTLE endian\n");
 	} else {
 		ret = bgpio_init(gc, &pdev->dev, 4,
@@ -342,7 +342,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 				 BGPIOF_BIG_ENDIAN
 				 | BGPIOF_BIG_ENDIAN_BYTE_ORDER);
 		if (ret)
-			goto err;
+			return ret;
 		dev_dbg(&pdev->dev, "GPIO registers are BIG endian\n");
 	}
 
@@ -384,7 +384,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev,
 			"GPIO chip registration failed with status %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	mpc8xxx_gc->irqn = platform_get_irq(pdev, 0);
@@ -416,9 +416,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	if (mpc8xxx_gc->irq)
-		irq_domain_remove(mpc8xxx_gc->irq);
-	iounmap(mpc8xxx_gc->regs);
+	irq_domain_remove(mpc8xxx_gc->irq);
 	return ret;
 }
 
@@ -432,7 +430,6 @@ static int mpc8xxx_remove(struct platform_device *pdev)
 	}
 
 	gpiochip_remove(&mpc8xxx_gc->gc);
-	iounmap(mpc8xxx_gc->regs);
 
 	return 0;
 }
-- 
2.30.2



