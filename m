Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB040EF80
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243316AbhIQCgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243046AbhIQCgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5239D610C8;
        Fri, 17 Sep 2021 02:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846082;
        bh=LoYJ87gv2goO8Eljq78y0gFbs8AqzHAnEiBkCqKBCgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4WJj7AI84nuptlTGDrZmPfmEJ0j40n5sopM9AJ2CUNx+0G43jxXSf1c/VmMMwVPr
         GccwlsfkCLUuNHm0Q+0E+h6QaakAR9Af5r1xDGLMQ+kJsr2d36TtpaC+5Sr2w5ZlJT
         DhmvowvBd+WrDAXNZH6GEf068MYAmZ7xG31EVFaDO4tLr3VIody/65qbDcGKtp7Jay
         Or66JTsZqitejmYx++gfH7tkMNyG/tZ4H6SbowClIexpefAMU9G6hE4j/caTqZjv2c
         Ti2EdpVAA0GnHU0iXaF8HR0GGTjtdRZaXoHlcHTM/UBQNk7orOHAug7Vvk6ybfRM6Z
         7HZQMNP2ObGjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        heiko@sntech.de, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 3/8] pwm: rockchip: Don't modify HW state in .remove() callback
Date:   Thu, 16 Sep 2021 22:34:28 -0400
Message-Id: <20210917023437.816574-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023437.816574-1-sashal@kernel.org>
References: <20210917023437.816574-1-sashal@kernel.org>
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
index 3b8da7b0091b..1f3079562b38 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -382,20 +382,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
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

