Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31AC4F3852
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241087AbiDELW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349471AbiDEJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DA0FD21;
        Tue,  5 Apr 2022 02:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2B9AB81B76;
        Tue,  5 Apr 2022 09:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23093C385A1;
        Tue,  5 Apr 2022 09:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152005;
        bh=/4hjeViN+EfUTKzkf5o0XiMashHr4EoRfdRaBYxu8NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYV6fiLYMQaJQ4Pd6a3xnJlTetcnF68ZhqFsUHKl+18XvJufsC/q+VTap7NZti/Wi
         gYISxzuUtGz6phlH5a7VENaELDahvi+VAWAM9Eid+TYSDrrIqzG9bF2klEXeFm57SH
         CsNRzxOa/2p4pE8HfWSo9c679LVATzmCXNLBbWlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 582/913] pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()
Date:   Tue,  5 Apr 2022 09:27:24 +0200
Message-Id: <20220405070357.290361080@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0401f24cd238ae200a23a13925f98de3d2c883b8 ]

When a driver calls pwmchip_add() it has to be prepared to immediately
get its callbacks called. So move allocation of driver data and hardware
initialization before the call to pwmchip_add().

This fixes a potential NULL pointer exception and a race condition on
register writes.

Fixes: 841e6f90bb78 ("pwm: NXP LPC18xx PWM/SCT driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpc18xx-sct.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-lpc18xx-sct.c b/drivers/pwm/pwm-lpc18xx-sct.c
index 8e461f3baa05..8cc8ae16553c 100644
--- a/drivers/pwm/pwm-lpc18xx-sct.c
+++ b/drivers/pwm/pwm-lpc18xx-sct.c
@@ -395,12 +395,6 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 	lpc18xx_pwm_writel(lpc18xx_pwm, LPC18XX_PWM_LIMIT,
 			   BIT(lpc18xx_pwm->period_event));
 
-	ret = pwmchip_add(&lpc18xx_pwm->chip);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "pwmchip_add failed: %d\n", ret);
-		goto disable_pwmclk;
-	}
-
 	for (i = 0; i < lpc18xx_pwm->chip.npwm; i++) {
 		struct lpc18xx_pwm_data *data;
 
@@ -410,14 +404,12 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 				    GFP_KERNEL);
 		if (!data) {
 			ret = -ENOMEM;
-			goto remove_pwmchip;
+			goto disable_pwmclk;
 		}
 
 		pwm_set_chip_data(pwm, data);
 	}
 
-	platform_set_drvdata(pdev, lpc18xx_pwm);
-
 	val = lpc18xx_pwm_readl(lpc18xx_pwm, LPC18XX_PWM_CTRL);
 	val &= ~LPC18XX_PWM_BIDIR;
 	val &= ~LPC18XX_PWM_CTRL_HALT;
@@ -425,10 +417,16 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 	val |= LPC18XX_PWM_PRE(0);
 	lpc18xx_pwm_writel(lpc18xx_pwm, LPC18XX_PWM_CTRL, val);
 
+	ret = pwmchip_add(&lpc18xx_pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "pwmchip_add failed: %d\n", ret);
+		goto disable_pwmclk;
+	}
+
+	platform_set_drvdata(pdev, lpc18xx_pwm);
+
 	return 0;
 
-remove_pwmchip:
-	pwmchip_remove(&lpc18xx_pwm->chip);
 disable_pwmclk:
 	clk_disable_unprepare(lpc18xx_pwm->pwm_clk);
 	return ret;
-- 
2.34.1



