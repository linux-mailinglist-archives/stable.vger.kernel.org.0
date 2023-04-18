Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D826E6E620E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjDRM3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDRM3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:29:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0ACB758
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10000631C1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242A5C433EF;
        Tue, 18 Apr 2023 12:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820956;
        bh=QYFFB3k7rz2OOvpSoTXzRsOAYuZUEaWg4sFFMo2KC+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1zVaJFPKTij8cgTWiZ9DMEIPSBrobJCCh3GunebulZAxWvPW2Q4bn2u/giw+uNRj
         tmo2sZvIpSDW33Mh3MQpFPLDh7hBsLqYZ93VYgu1dLluud43iEkjM1RqoFo98gcb3d
         zpSLDWMlJba66kBUFAd6R1MSsEwBTPf/TGbItZNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sandeep Singh <sandeep.singh@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/92] pinctrl: amd: Use irqchip template
Date:   Tue, 18 Apr 2023 14:20:42 +0200
Message-Id: <20230418120305.008378987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e81376ebbafc679a5cea65f25f5ab242172f52df ]

This makes the driver use the irqchip template to assign
properties to the gpio_irq_chip instead of using the
explicit call to gpiochip_irqchip_add().

The irqchip is instead added while adding the gpiochip.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc: Sandeep Singh <sandeep.singh@amd.com>
Link: https://lore.kernel.org/r/20200722101545.144373-1-linus.walleij@linaro.org
Stable-dep-of: b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index ca3f18aa16acb..c4e1ebd6e4ea1 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -852,6 +852,7 @@ static int amd_gpio_probe(struct platform_device *pdev)
 	int irq_base;
 	struct resource *res;
 	struct amd_gpio *gpio_dev;
+	struct gpio_irq_chip *girq;
 
 	gpio_dev = devm_kzalloc(&pdev->dev,
 				sizeof(struct amd_gpio), GFP_KERNEL);
@@ -913,6 +914,15 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		return PTR_ERR(gpio_dev->pctrl);
 	}
 
+	girq = &gpio_dev->gc.irq;
+	girq->chip = &amd_gpio_irqchip;
+	/* This will let us handle the parent IRQ in the driver */
+	girq->parent_handler = NULL;
+	girq->num_parents = 0;
+	girq->parents = NULL;
+	girq->default_type = IRQ_TYPE_NONE;
+	girq->handler = handle_simple_irq;
+
 	ret = gpiochip_add_data(&gpio_dev->gc, gpio_dev);
 	if (ret)
 		return ret;
@@ -924,17 +934,6 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		goto out2;
 	}
 
-	ret = gpiochip_irqchip_add(&gpio_dev->gc,
-				&amd_gpio_irqchip,
-				0,
-				handle_simple_irq,
-				IRQ_TYPE_NONE);
-	if (ret) {
-		dev_err(&pdev->dev, "could not add irqchip\n");
-		ret = -ENODEV;
-		goto out2;
-	}
-
 	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, gpio_dev);
 	if (ret)
-- 
2.39.2



