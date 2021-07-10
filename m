Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9F83C375B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhGJXvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhGJXvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D789761356;
        Sat, 10 Jul 2021 23:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960943;
        bh=dr/RxNerB3iZPvigGjF9oT3gndKmVCtkZP8nkwtjB+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8KzkRMDusjtVF/Vy7Y7Ped2ev/8ozsoE8+HK4gC8W8T6xbibqzT5qZ/ra9ZKNIE9
         L7F9eX32LRF/3q6WFB2PY0endRG3S2YQ6qSanOAA9rqx9zV3HXQwtpWHrbrW0pj2g4
         PbvhVSH8IVhgBIDdNcuWklJgplwl+HU8RGdlSDs8M7nP0ybw3y204VN2BHqDP735vR
         g0AhqWaLoirHLrXAJp3qq5pfr0QDjsDMQwW55r1uZawAWrfHmVQ8ICEotaA0pAaqhw
         cuPyrX7CWoYNchA/MDkGjzh3f45KB2oqUXj0N0ne82KWccl+81HuUkZ2OM+pYkBEgb
         uCqlq+KWlwNYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/53] pwm: spear: Don't modify HW state in .remove callback
Date:   Sat, 10 Jul 2021 19:48:08 -0400
Message-Id: <20210710234857.3220040-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234857.3220040-1-sashal@kernel.org>
References: <20210710234857.3220040-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit b601a18f12383001e7a8da238de7ca1559ebc450 ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

So drop the hardware modification from the .remove() callback.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-spear.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 1a1cedfd11ce..6879b49581b3 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -228,10 +228,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
 static int spear_pwm_remove(struct platform_device *pdev)
 {
 	struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < NUM_PWM; i++)
-		pwm_disable(&pc->chip.pwms[i]);
 
 	/* clk was prepared in probe, hence unprepare it here */
 	clk_unprepare(pc->clk);
-- 
2.30.2

