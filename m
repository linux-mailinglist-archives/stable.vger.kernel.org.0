Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1C3C3987
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhGKAAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233949AbhGJX61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC9556136D;
        Sat, 10 Jul 2021 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961184;
        bh=lwqM6PvVga1wrNPdaKICIzDas3E2Hl7kjyv++ULeiNA=;
        h=From:To:Cc:Subject:Date:From;
        b=nm/5CPmqI7PW9UzuukoCVTkBk+mDPazHNP4nVQpwjSfnI7pdw2mUSkja1a78JWXVj
         +VpL07koGLxyMrN0p158iHTRLS7hM9ns+IKOa5uvcxed7CTWMlKq9CqwCwn/yL5MEH
         +b8jXprQK4wZmUvhPOaiPCCTDxNNTK9Cxz3UHIyF2GaIK1Af6n1JmotIicBbVUBbWM
         ZnZC/WL2tTW+iNmC/ukynQjZUCn7tZwHNjTQHILwjgn2vZBZmDyNpY2Jq+2mnnvODQ
         zlONzPLuBdEbC8Mk9VXlRO6LXBq5CXib9BhvjGJcGkRlIlQHslRlnubHNmXF7Ghv86
         vQ+vNJUwPauDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/12] pwm: spear: Don't modify HW state in .remove callback
Date:   Sat, 10 Jul 2021 19:52:51 -0400
Message-Id: <20210710235302.3222809-1-sashal@kernel.org>
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
index 6c6b44fd3f43..2d11ac277de8 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -231,10 +231,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
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

