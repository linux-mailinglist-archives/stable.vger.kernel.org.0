Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9560640EF69
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243037AbhIQCfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243046AbhIQCfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B68B261152;
        Fri, 17 Sep 2021 02:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846062;
        bh=tLGOTWDjMWzwwlse4QBjCulXFR9ZxjdrNJTC+VCz/x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhC0ZRKSYqw62gD8FEnw2kw1bTj8cWR8tmk9KrWKNTsP0/U13xFon57in8YglN+Yi
         XQzRGnmloSCZoReLuT43CHwR3pZnlUSCiidceJ7Dj8o3sYAkhe7+EIycYtvg7dmNCq
         7vaSEJ/SOsHQSyjdoQYgY1HPeNN1IwIJrUOwLwnGazIATGkDLn5RyA7EkmQkhlRONN
         SjG5INKvwtSRyqL8YOVCiuSH0oFbfugREWfXt9g02uTNzTAfKLO60PrF52k930SKTJ
         K3JAB91X7iOnwl7C+n1qCCbVn4lihS3k6JkoialDnLX5aLHcxI5qod4RL7NVyjlIBw
         i9Rq0cGeQZYPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        heiko@sntech.de
Subject: [PATCH AUTOSEL 5.14 12/21] pwm: rockchip: Don't modify HW state in .remove() callback
Date:   Thu, 16 Sep 2021 22:33:06 -0400
Message-Id: <20210917023315.816225-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
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
index cbe900877724..8fcef29948d7 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -384,20 +384,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
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

