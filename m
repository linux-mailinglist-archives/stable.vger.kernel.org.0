Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE31582FA2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242186AbiG0R2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242161AbiG0R1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995347F505;
        Wed, 27 Jul 2022 09:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BB4261629;
        Wed, 27 Jul 2022 16:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383F3C43470;
        Wed, 27 Jul 2022 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940433;
        bh=Q8YPi+BWUHDf7BRhBTc9sgcZya0rrya2AxGzyzuI8cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Z62Sc+jts5d1p0abCRXG/YSFS3zQ2s+TGFIcowUx+P0JryYwdx43hRn2OHMbyZbM
         sMS6wVAKL00WPYY663SDoAJe0Rqkb2LrOOqaG/Y5cPQcpTvkBfTih9540bkUw/eg8J
         TEPxXe4Mo4vMvzcrpvbK4uupy72B43NuKPbcpHl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Chao <gaochao49@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 021/158] power: supply: ab8500_fg: add missing destroy_workqueue in ab8500_fg_probe
Date:   Wed, 27 Jul 2022 18:11:25 +0200
Message-Id: <20220727161022.316867058@linuxfoundation.org>
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

From: Gao Chao <gaochao49@huawei.com>

[ Upstream commit 0f5de2f0532229752d923c769a5b202ae437523b ]

In ab8500_fg_probe, misses destroy_workqueue in error path, this patch
fixes that.

Fixes: 010ddb813f35 ("power: supply: ab8500_fg: Allocate wq in probe")
Signed-off-by: Gao Chao <gaochao49@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index ec8a404d71b4..4339fa9ff009 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3148,6 +3148,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	ret = ab8500_fg_init_hw_registers(di);
 	if (ret) {
 		dev_err(dev, "failed to initialize registers\n");
+		destroy_workqueue(di->fg_wq);
 		return ret;
 	}
 
@@ -3159,6 +3160,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	di->fg_psy = devm_power_supply_register(dev, &ab8500_fg_desc, &psy_cfg);
 	if (IS_ERR(di->fg_psy)) {
 		dev_err(dev, "failed to register FG psy\n");
+		destroy_workqueue(di->fg_wq);
 		return PTR_ERR(di->fg_psy);
 	}
 
@@ -3174,8 +3176,10 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	/* Register primary interrupt handlers */
 	for (i = 0; i < ARRAY_SIZE(ab8500_fg_irq); i++) {
 		irq = platform_get_irq_byname(pdev, ab8500_fg_irq[i].name);
-		if (irq < 0)
+		if (irq < 0) {
+			destroy_workqueue(di->fg_wq);
 			return irq;
+		}
 
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				  ab8500_fg_irq[i].isr,
@@ -3185,6 +3189,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 		if (ret != 0) {
 			dev_err(dev, "failed to request %s IRQ %d: %d\n",
 				ab8500_fg_irq[i].name, irq, ret);
+			destroy_workqueue(di->fg_wq);
 			return ret;
 		}
 		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
@@ -3200,6 +3205,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	ret = ab8500_fg_sysfs_init(di);
 	if (ret) {
 		dev_err(dev, "failed to create sysfs entry\n");
+		destroy_workqueue(di->fg_wq);
 		return ret;
 	}
 
@@ -3207,6 +3213,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "failed to create FG psy\n");
 		ab8500_fg_sysfs_exit(di);
+		destroy_workqueue(di->fg_wq);
 		return ret;
 	}
 
-- 
2.35.1



