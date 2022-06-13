Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F115495F6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356438AbiFMM4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358248AbiFMMzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CC46393;
        Mon, 13 Jun 2022 04:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057D060EF1;
        Mon, 13 Jun 2022 11:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBF1C3411C;
        Mon, 13 Jun 2022 11:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118893;
        bh=bt6icHp1z5mM4XKs4r2Z8SPOXr02Stt78U4Pdt+zBZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFDVatUU/CTyuUFigsvUQP+jOpG6LInr4x5VhUA3zPsm7HJ1/shu0dL8omttffWWv
         oYlaDMWOIQZMVm2oOb6BuxcdWrqxQlgKBLmks3qOwDfRlp2fSaBmTSQAodW9s2l2VV
         d+U3OcvUYaP2jXapzl4ePLodZWCHQZa1zSLwKY/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/247] rtc: ftrtc010: Fix error handling in ftrtc010_rtc_probe
Date:   Mon, 13 Jun 2022 12:09:10 +0200
Message-Id: <20220613094924.408268433@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b520cbe5be37b1b9b401c0b6ecbdae32575273db ]

In the error handling path, the clk_prepare_enable() function
call should be balanced by a corresponding 'clk_disable_unprepare()'
call , as already done in the remove function.

clk_disable_unprepare calls clk_disable() and clk_unprepare().
They will use IS_ERR_OR_NULL to check the argument.

Fixes: ac05fba39cc5 ("rtc: gemini: Add optional clock handling")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220403054912.31739-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 53bb08fe1cd4..25c6e7d9570f 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -137,26 +137,34 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 		ret = clk_prepare_enable(rtc->extclk);
 		if (ret) {
 			dev_err(dev, "failed to enable EXTCLK\n");
-			return ret;
+			goto err_disable_pclk;
 		}
 	}
 
 	rtc->rtc_irq = platform_get_irq(pdev, 0);
-	if (rtc->rtc_irq < 0)
-		return rtc->rtc_irq;
+	if (rtc->rtc_irq < 0) {
+		ret = rtc->rtc_irq;
+		goto err_disable_extclk;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
+	if (!res) {
+		ret = -ENODEV;
+		goto err_disable_extclk;
+	}
 
 	rtc->rtc_base = devm_ioremap(dev, res->start,
 				     resource_size(res));
-	if (!rtc->rtc_base)
-		return -ENOMEM;
+	if (!rtc->rtc_base) {
+		ret = -ENOMEM;
+		goto err_disable_extclk;
+	}
 
 	rtc->rtc_dev = devm_rtc_allocate_device(dev);
-	if (IS_ERR(rtc->rtc_dev))
-		return PTR_ERR(rtc->rtc_dev);
+	if (IS_ERR(rtc->rtc_dev)) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err_disable_extclk;
+	}
 
 	rtc->rtc_dev->ops = &ftrtc010_rtc_ops;
 
@@ -172,9 +180,15 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	ret = devm_request_irq(dev, rtc->rtc_irq, ftrtc010_rtc_interrupt,
 			       IRQF_SHARED, pdev->name, dev);
 	if (unlikely(ret))
-		return ret;
+		goto err_disable_extclk;
 
 	return devm_rtc_register_device(rtc->rtc_dev);
+
+err_disable_extclk:
+	clk_disable_unprepare(rtc->extclk);
+err_disable_pclk:
+	clk_disable_unprepare(rtc->pclk);
+	return ret;
 }
 
 static int ftrtc010_rtc_remove(struct platform_device *pdev)
-- 
2.35.1



