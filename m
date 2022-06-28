Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D02455CBFF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243655AbiF1CWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243656AbiF1CVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3722F101E5;
        Mon, 27 Jun 2022 19:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 878B1CE1DCC;
        Tue, 28 Jun 2022 02:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50BCC385A9;
        Tue, 28 Jun 2022 02:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382857;
        bh=d4yHdwcIVcHGy3DfNH08m8dj2XE0tK+LPYMKfYq2wJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4ks9HAVBx2GaWJaBdHk9vcBDEXyyI2l+CWjs8xrbCPDnsKOdwQ0HyJvtXEEIocel
         anvVBqDm3eTUcAgdyKBFnBrT3MrDPy6WYYSyaFVQAdMHmENDsyDfl84LwQhriIbgji
         aWMBHEBU811MrmfkF340ZoFCCu2cGLdtw3vpDQgBtcxnr1Xubi/NU/Za2EURLlpwTy
         KWPmUT9i6Doa0gZ2+ilIcylic1u0P2QjXmOlGxzn8APVGyoj4CMesSKxFMSXEuYaLL
         qsQb3lQa9w3qGptWoFPKwD1LHIsT6BXjjegyTIxrb09cxcvUJroZmUEHVL1YhIuDGM
         D4jiNniK/Uaxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 52/53] gpio: grgpio: Fix device removing
Date:   Mon, 27 Jun 2022 22:18:38 -0400
Message-Id: <20220628021839.594423-52-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c1c2a15c2b5379ea8e44dcdcc298e3de42076ba0 ]

If a platform device's remove callback returns non-zero, the device core
emits a warning and still removes the device and calls the devm cleanup
callbacks.

So it's not save to not unregister the gpiochip because on the next request
to a GPIO the driver accesses kfree()'d memory. Also if an IRQ triggers,
the freed memory is accessed.

Instead rely on the GPIO framework to ensure that after gpiochip_remove()
all GPIOs are freed and so the corresponding IRQs are unmapped.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 23d447e17a67..6ad0466828f4 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -434,25 +434,13 @@ static int grgpio_probe(struct platform_device *ofdev)
 static int grgpio_remove(struct platform_device *ofdev)
 {
 	struct grgpio_priv *priv = platform_get_drvdata(ofdev);
-	int i;
-	int ret = 0;
-
-	if (priv->domain) {
-		for (i = 0; i < GRGPIO_MAX_NGPIO; i++) {
-			if (priv->uirqs[i].refcnt != 0) {
-				ret = -EBUSY;
-				goto out;
-			}
-		}
-	}
 
 	gpiochip_remove(&priv->gc);
 
 	if (priv->domain)
 		irq_domain_remove(priv->domain);
 
-out:
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id grgpio_match[] = {
-- 
2.35.1

