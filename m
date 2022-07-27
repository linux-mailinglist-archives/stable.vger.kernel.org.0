Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD5582E98
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiG0RO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbiG0ROK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:14:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A5B76EB9;
        Wed, 27 Jul 2022 09:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18635614EA;
        Wed, 27 Jul 2022 16:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277A3C433D6;
        Wed, 27 Jul 2022 16:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940149;
        bh=z2V8vFHMnhOnE4/gebZpZ4UaFOeyJaDeG+40vnJokD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/q7eqcS+cMPv34Oa8SOLqWi5ld6L7CCDJMnp1ryup92LAgPZdZfqQ2iyMphfssVV
         3XtEGFoxtXoGtutjh0xvdgJYSJQvftHVVtUaW6df18n4kh3Kh+/bjxHHbvWL3llTsd
         hlcFrBAPy06BYwVH+7TdKYC/MRMuCka7j5beJUXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/201] pinctrl: armada-37xx: use raw spinlocks for regmap to avoid invalid wait context
Date:   Wed, 27 Jul 2022 18:10:09 +0200
Message-Id: <20220727161032.096638768@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4546760619cfa9b718fe2059ceb07101cf9ff61e ]

The irqchip->irq_set_type method is called by __irq_set_trigger() under
the desc->lock raw spinlock.

The armada-37xx implementation, armada_37xx_irq_set_type(), uses an MMIO
regmap created by of_syscon_register(), which uses plain spinlocks
(the kind that are sleepable on RT).

Therefore, this is an invalid locking scheme for which we get a kernel
splat stating just that ("[ BUG: Invalid wait context ]"), because the
context in which the plain spinlock may sleep is atomic due to the raw
spinlock. We need to go raw spinlocks all the way.

Make this driver create its own MMIO regmap, with use_raw_spinlock=true,
and stop relying on syscon to provide it.

This patch depends on commit 67021f25d952 ("regmap: teach regmap to use
raw spinlocks if requested in the config").

Cc: <stable@vger.kernel.org> # 5.15+
Fixes: 2f227605394b ("pinctrl: armada-37xx: Add irqchip support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220716233745.1704677-3-vladimir.oltean@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 27 ++++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 7d0d2771a9ac..7338bc353347 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -1116,25 +1116,40 @@ static const struct of_device_id armada_37xx_pinctrl_of_match[] = {
 	{ },
 };
 
+static const struct regmap_config armada_37xx_pinctrl_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.use_raw_spinlock = true,
+};
+
 static int __init armada_37xx_pinctrl_probe(struct platform_device *pdev)
 {
 	struct armada_37xx_pinctrl *info;
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 	struct regmap *regmap;
+	void __iomem *base;
 	int ret;
 
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(base)) {
+		dev_err(dev, "failed to ioremap base address: %pe\n", base);
+		return PTR_ERR(base);
+	}
+
+	regmap = devm_regmap_init_mmio(dev, base,
+				       &armada_37xx_pinctrl_regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(dev, "failed to create regmap: %pe\n", regmap);
+		return PTR_ERR(regmap);
+	}
+
 	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
 	info->dev = dev;
-
-	regmap = syscon_node_to_regmap(np);
-	if (IS_ERR(regmap))
-		return dev_err_probe(dev, PTR_ERR(regmap), "cannot get regmap\n");
 	info->regmap = regmap;
-
 	info->data = of_device_get_match_data(dev);
 
 	ret = armada_37xx_pinctrl_register(pdev, info);
-- 
2.35.1



