Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235284174FB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346694AbhIXNMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346161AbhIXNKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC2CF615A7;
        Fri, 24 Sep 2021 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488293;
        bh=s+6M7smfVbonIUXmdU6r9y3qwUuASd6HErQYJRWCFBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jqwhGOKaDzFHdkV/q9xDzp+RDCpb66facLCQ0aK562Pp9EdzlqTes9KBH27HJq4f
         E5MjsSylSn8Sys61bIwRCBeppaT9+Q+BlsVObCnLaPvathnJF/6d6S2R2RatutfKuk
         I0JIyRDCwnGCz1XkZVV4kFXaveaxNAbtgB6j+mcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/63] pwm: rockchip: Dont modify HW state in .remove() callback
Date:   Fri, 24 Sep 2021 14:44:57 +0200
Message-Id: <20210924124336.230659223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



