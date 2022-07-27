Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9351582E81
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiG0RNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiG0RMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:12:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E1A753BD;
        Wed, 27 Jul 2022 09:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456CDB821D5;
        Wed, 27 Jul 2022 16:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD9FC433C1;
        Wed, 27 Jul 2022 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940119;
        bh=BXg5fLLfCrboKcDhCRE6/09nN66VrHApWnu3zne7LGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKEUadedFeR/cSTp3aoKAhDGVlJ61gorXWN3PmWrzIt+CsUh8I2m8dhNBDfno5KWj
         7wTSr8ZDFAh7zzbYAk+mpCT3XhhjrBdo0Dbwa84uqxPhFkhdRwWEptGxjhoepzmEGi
         L7IzTZzomZzyszCe9qrUaLs87MtE10GJuc7MXZdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/201] pinctrl: armada-37xx: Convert to use dev_err_probe()
Date:   Wed, 27 Jul 2022 18:10:08 +0200
Message-Id: <20220727161032.059592834@linuxfoundation.org>
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

[ Upstream commit 06cb10ea0cd5c5f4db9627a33ab47fec32cb5960 ]

It's fine to call dev_err_probe() in ->probe() when error code is known.
Convert the driver to use dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 40bcf05123eb..7d0d2771a9ac 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -736,10 +736,8 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 			break;
 		}
 	}
-	if (ret) {
-		dev_err(dev, "no gpio-controller child node\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "no gpio-controller child node\n");
 
 	nr_irq_parent = of_irq_count(np);
 	spin_lock_init(&info->irq_lock);
@@ -996,10 +994,8 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 		return ret;
 
 	info->pctl_dev = devm_pinctrl_register(dev, ctrldesc, info);
-	if (IS_ERR(info->pctl_dev)) {
-		dev_err(dev, "could not register pinctrl driver\n");
-		return PTR_ERR(info->pctl_dev);
-	}
+	if (IS_ERR(info->pctl_dev))
+		return dev_err_probe(dev, PTR_ERR(info->pctl_dev), "could not register pinctrl driver\n");
 
 	return 0;
 }
@@ -1135,10 +1131,8 @@ static int __init armada_37xx_pinctrl_probe(struct platform_device *pdev)
 	info->dev = dev;
 
 	regmap = syscon_node_to_regmap(np);
-	if (IS_ERR(regmap)) {
-		dev_err(dev, "cannot get regmap\n");
-		return PTR_ERR(regmap);
-	}
+	if (IS_ERR(regmap))
+		return dev_err_probe(dev, PTR_ERR(regmap), "cannot get regmap\n");
 	info->regmap = regmap;
 
 	info->data = of_device_get_match_data(dev);
-- 
2.35.1



