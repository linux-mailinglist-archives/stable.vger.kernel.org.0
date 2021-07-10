Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270553C38B2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhGJXzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhGJXy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04944613E5;
        Sat, 10 Jul 2021 23:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961095;
        bh=7K9eVUMY1pQAF+2qstCDKAH0TI5uw0X4L1n6GzI9Y7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OX1igyvBMZWwzVR/U5Sq+zqQ8jYeZGnNVBPyIdjVcWM7NGHvyn0nctjIeczsPhzTS
         c78uWevnqxAvpqiYjSgFbTBD8ea479EgzGjfDYUD4AjF248BwyJXG2lRpp9I5sKb17
         0fNHVlao2c+pUrYfesZHdqu4uubSe5SVPSLbuCsiW22lXKXKYAWS3FEEdG/nmCkjaF
         msB0SIhGqiGzXyV5eUyv+IeoveT0uStjZFrGki6awLZmqxQmip9NTlb+qGzTQaHdi1
         wOd8HNHdMGBK5viZWNhCWmuYkMn7QDr2Jv0TZGgnQ3n4n9xYiD5mB44nQ1xCmONxLA
         JWfEVQgCsSKUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/28] pwm: tegra: Don't modify HW state in .remove callback
Date:   Sat, 10 Jul 2021 19:51:01 -0400
Message-Id: <20210710235107.3221840-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 86f7fa71cd830d18d7ebcaf719dffd5ddfe1acdd ]

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
 drivers/pwm/pwm-tegra.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index aa12fb3ed92e..3d55e30a6866 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -232,7 +232,6 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 static int tegra_pwm_remove(struct platform_device *pdev)
 {
 	struct tegra_pwm_chip *pc = platform_get_drvdata(pdev);
-	unsigned int i;
 	int err;
 
 	if (WARN_ON(!pc))
@@ -242,18 +241,6 @@ static int tegra_pwm_remove(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	for (i = 0; i < pc->chip.npwm; i++) {
-		struct pwm_device *pwm = &pc->chip.pwms[i];
-
-		if (!pwm_is_enabled(pwm))
-			if (clk_prepare_enable(pc->clk) < 0)
-				continue;
-
-		pwm_writel(pc, i, 0);
-
-		clk_disable_unprepare(pc->clk);
-	}
-
 	reset_control_assert(pc->rst);
 	clk_disable_unprepare(pc->clk);
 
-- 
2.30.2

