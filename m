Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327BA582EDF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbiG0RS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241706AbiG0RRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:17:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3A07968F;
        Wed, 27 Jul 2022 09:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3349B821C5;
        Wed, 27 Jul 2022 16:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19929C433C1;
        Wed, 27 Jul 2022 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940211;
        bh=VYoj6IEjQrE/YjSKAbjbTBde62Fy24vqoUFL94YJ+Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGa5Klau1Pc/V1i+H0k7rRK9jdRvG8piGoZOhk1S18J8/Gi5d2/ZAr8EalGYrpexO
         Rvjszn+wjWkjnetngryaM452tfs9bzV4+oAHcbirMw1dgOyMW969FbtYnWMmpHC5K+
         bJOQJQy9IZ1tqnrgKxbDcUe0sS59wCVDZ3DrX2LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/201] pinctrl: armada-37xx: Make use of the devm_platform_ioremap_resource()
Date:   Wed, 27 Jul 2022 18:10:07 +0200
Message-Id: <20220727161032.016701897@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 49bdef501728acbfadc7eeafafb4f6c3fea415eb ]

Use the devm_platform_ioremap_resource() helper instead of
calling of_address_to_resource() and devm_ioremap_resource()
separately.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index e1f76b4ddf23..40bcf05123eb 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -727,7 +727,6 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	struct gpio_irq_chip *girq = &gc->irq;
 	struct device *dev = &pdev->dev;
 	struct device_node *np;
-	struct resource res;
 	int ret = -ENODEV, i, nr_irq_parent;
 
 	/* Check if we have at least one gpio-controller child node */
@@ -750,12 +749,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 		return 0;
 	}
 
-	if (of_address_to_resource(dev->of_node, 1, &res)) {
-		dev_err(dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
-	info->base = devm_ioremap_resource(dev, &res);
+	info->base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(info->base))
 		return PTR_ERR(info->base);
 
-- 
2.35.1



