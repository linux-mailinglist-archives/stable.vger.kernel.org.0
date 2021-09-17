Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9840EFB5
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243377AbhIQChl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243389AbhIQCg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D95F610C8;
        Fri, 17 Sep 2021 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846106;
        bh=vZCh2ARLYcUt3OW6Md53MKI/zGAahzNzswRDFu8Ueb0=;
        h=From:To:Cc:Subject:Date:From;
        b=XsL2Jo+cgXzhhxsy6AhCH2j4fjDvmbauSIW8G59vB8sLmaUXUz+MATKOZsdE+Q0C1
         NQOJjnBlEy54SqEorbpJhss25xEOZPKh2X0gztKfPIm2PrDKLXOh+ORStBH9vRE5qg
         YdLDrELMF21gOxr/dyNP7EiMnly2NqedjDkz1BvF/KnY07Pnj3Ab58V4VVX1A5HDxd
         gWKJh7JYGl9Pi+Jbc/Fna66rswrjUWY8Wy/ZmfDu/2NbJQ5UDbQWdfTNy93Al/4j7U
         6nhPB2cU0MKTB8b4M5mstmKkrui6cRE6B1iHboQUqlcYOyMkY51CvnMFxyC+pxfeIC
         lcy8rdMIqrRpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        heiko@sntech.de, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 1/2] pwm: rockchip: Don't modify HW state in .remove() callback
Date:   Thu, 16 Sep 2021 22:35:03 -0400
Message-Id: <20210917023504.816909-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9d768cd7fd42bb0be16f36aec48548fca5260759 ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rockchip.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index 48bcc853d57a..cf34fb00c054 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -392,20 +392,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
 {
 	struct rockchip_pwm_chip *pc = platform_get_drvdata(pdev);
 
-	/*
-	 * Disable the PWM clk before unpreparing it if the PWM device is still
-	 * running. This should only happen when the last PWM user left it
-	 * enabled, or when nobody requested a PWM that was previously enabled
-	 * by the bootloader.
-	 *
-	 * FIXME: Maybe the core should disable all PWM devices in
-	 * pwmchip_remove(). In this case we'd only have to call
-	 * clk_unprepare() after pwmchip_remove().
-	 *
-	 */
-	if (pwm_is_enabled(pc->chip.pwms))
-		clk_disable(pc->clk);
-
 	clk_unprepare(pc->pclk);
 	clk_unprepare(pc->clk);
 
-- 
2.30.2

