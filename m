Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF90583070
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbiG0RiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242619AbiG0Rhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC43B8689F;
        Wed, 27 Jul 2022 09:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B3F616FA;
        Wed, 27 Jul 2022 16:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9E1C433D6;
        Wed, 27 Jul 2022 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940603;
        bh=49Ylmd6QtRg5NoLeTrOXyRJ1bNwFt5vYNEfZxBZVBSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5klBnD2u4hcpmOhr2Gt+ZNGX/p/9zhSvM/eIIMX0gaCOdu4O4ZUNPpFD9cy7q+XC
         aa3FwLxRG2TTZ0hQWAJSCSK2AxEEhzX5w5n3lGvggBYwm852XdpBcqNoX8aB/vn72k
         G1HKCsAnrrxzlyoP6IWwpAWHEwvzYnH3i1ZHcDa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 082/158] pinctrl: armada-37xx: Reuse GPIO fwnode in armada_37xx_irqchip_register()
Date:   Wed, 27 Jul 2022 18:12:26 +0200
Message-Id: <20220727161024.788030612@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

[ Upstream commit 46d34d4d502ea1030f5de434e6677ec96ca131c3 ]

Since we have fwnode of the first found GPIO controller assigned to the
struct gpio_chip, we may reuse it in the armada_37xx_irqchip_register().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 5fc305222d2f..226798d9c067 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -726,23 +726,13 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	struct gpio_chip *gc = &info->gpio_chip;
 	struct irq_chip *irqchip = &info->irq_chip;
 	struct gpio_irq_chip *girq = &gc->irq;
+	struct device_node *np = to_of_node(gc->fwnode);
 	struct device *dev = &pdev->dev;
-	struct device_node *np;
-	int ret = -ENODEV, i, nr_irq_parent;
-
-	/* Check if we have at least one gpio-controller child node */
-	for_each_child_of_node(dev->of_node, np) {
-		if (of_property_read_bool(np, "gpio-controller")) {
-			ret = 0;
-			break;
-		}
-	}
-	if (ret)
-		return dev_err_probe(dev, ret, "no gpio-controller child node\n");
+	unsigned int i, nr_irq_parent;
 
-	nr_irq_parent = of_irq_count(np);
 	spin_lock_init(&info->irq_lock);
 
+	nr_irq_parent = of_irq_count(np);
 	if (!nr_irq_parent) {
 		dev_err(dev, "invalid or no IRQ\n");
 		return 0;
-- 
2.35.1



