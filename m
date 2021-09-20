Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EF84124C0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381068AbhITShV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381067AbhITSfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDB261AAC;
        Mon, 20 Sep 2021 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158942;
        bh=6I/5+lZTxVowLex+9DEtwKrtO2w5YLB5jsD+GBWlSsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tnl+aFC0ttYVetQTolsakzGV9GC3f3iJtWpH/bTXFd6FHL8FCAPZyF18yzST1q/uj
         zQM/m4qnplOKc8rkgU/UVwfqDXdh7xZMAcG1iHcY/EZt3nmHjPyKQlawDciFsb+xgi
         YiFhGzyrgGYsWD4p/FutncM+z+hz6R7VE26SmTq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/122] gpio: mpc8xxx: Fix a potential double iounmap call in mpc8xxx_probe()
Date:   Mon, 20 Sep 2021 18:44:32 +0200
Message-Id: <20210920163919.067590477@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index 5b2a919a6644..a4983c5d1f16 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -329,7 +329,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 				 mpc8xxx_gc->regs + GPIO_DIR, NULL,
 				 BGPIOF_BIG_ENDIAN);
 		if (ret)
-			goto err;
+			return ret;
 		dev_dbg(&pdev->dev, "GPIO registers are LITTLE endian\n");
 	} else {
 		ret = bgpio_init(gc, &pdev->dev, 4,
@@ -339,7 +339,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 				 BGPIOF_BIG_ENDIAN
 				 | BGPIOF_BIG_ENDIAN_BYTE_ORDER);
 		if (ret)
-			goto err;
+			return ret;
 		dev_dbg(&pdev->dev, "GPIO registers are BIG endian\n");
 	}
 
@@ -378,7 +378,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	if (ret) {
 		pr_err("%pOF: GPIO chip registration failed with status %d\n",
 		       np, ret);
-		goto err;
+		return ret;
 	}
 
 	mpc8xxx_gc->irqn = irq_of_parse_and_map(np, 0);
@@ -406,9 +406,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	if (mpc8xxx_gc->irq)
-		irq_domain_remove(mpc8xxx_gc->irq);
-	iounmap(mpc8xxx_gc->regs);
+	irq_domain_remove(mpc8xxx_gc->irq);
 	return ret;
 }
 
@@ -422,7 +420,6 @@ static int mpc8xxx_remove(struct platform_device *pdev)
 	}
 
 	gpiochip_remove(&mpc8xxx_gc->gc);
-	iounmap(mpc8xxx_gc->regs);
 
 	return 0;
 }
-- 
2.30.2



