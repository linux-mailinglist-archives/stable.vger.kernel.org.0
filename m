Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9124C3C3940
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhGJX61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233939AbhGJX5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F0B6140C;
        Sat, 10 Jul 2021 23:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961153;
        bh=DPYLXDBQlJ4xCJUeTqh/3nUbSMOGFtVr9aV+f0tGoH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHCuFxyaT2fpyVmiZx4XB6ldel4RXR13ZY/4uRs7FYlatevVlpXsC1XPoduXFykcL
         wpEP1MnwiAKu4rRgNvpaVxbRQCVxXo7dPx053sooFsMb6SubwRAhFwpEs3AN6CHqwD
         fOlzjS63LECCg957h+DPqDmH5njAgIWOsaJq/vvKIdN8EtfqwN7m53NDrSY0Ya00CQ
         uf2or82PKvsWmkrA9ARERWMuwo5Tl/ALQsaFKJVYf9oy2B6TD83YhfjBh27ItYzEqd
         iQUjhrHw2B2OvrUytU1yCE9IiLdUyUD1q1njrQf9zNBFiEtuC+ObxhYim71RMzFN0q
         XhoJuC81r9zRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/21] pwm: tegra: Don't modify HW state in .remove callback
Date:   Sat, 10 Jul 2021 19:52:07 -0400
Message-Id: <20210710235212.3222375-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
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
index f8ebbece57b7..6be14e0f1dc3 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -245,7 +245,6 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 static int tegra_pwm_remove(struct platform_device *pdev)
 {
 	struct tegra_pwm_chip *pc = platform_get_drvdata(pdev);
-	unsigned int i;
 	int err;
 
 	if (WARN_ON(!pc))
@@ -255,18 +254,6 @@ static int tegra_pwm_remove(struct platform_device *pdev)
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

