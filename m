Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2742E4006
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbgL1Oqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502900AbgL1OXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4582206D4;
        Mon, 28 Dec 2020 14:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165387;
        bh=MmG8KOuktm7mFn9OvCZwv5Ou7Rl4C6yIs4bp9OjUqw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAUEREY6sa9X+5/4bdpnnRlUs3oc2CNnqg07rO8XYxEmOpbzPj4bE1GzrRs71X6no
         QQ+yOWq7UgMcG5A8071KdbcwJDEzY4syicQ37CFu+g84KYeXt5FoU6GyAmp4gyI+0Y
         fsGMJNn8miYgbMd/eP24bYdg3ZBhS+B1IXr89zyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taras Galchenko <tpgalchenko@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/717] pwm: sun4i: Remove erroneous else branch
Date:   Mon, 28 Dec 2020 13:48:00 +0100
Message-Id: <20201228125044.061381976@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>

[ Upstream commit 6eefb79d6f5bc4086bd02c76f1072dd4a8d9d9f6 ]

Commit d3817a647059 ("pwm: sun4i: Remove redundant needs_delay") changed
the logic of an else branch so that the PWM_EN and PWM_CLK_GATING bits
are now cleared if the PWM is to be disabled, whereas previously the
condition was always false, and hence the branch never got executed.

This code is reported causing backlight issues on boards based on the
Allwinner A20 SoC. Fix this by removing the else branch, which restores
the behaviour prior to the offending commit.

Note that the PWM_EN and PWM_CLK_GATING bits still get cleared later in
sun4i_pwm_apply() if the PWM is to be disabled.

Fixes: d3817a647059 ("pwm: sun4i: Remove redundant needs_delay")
Reported-by: Taras Galchenko <tpgalchenko@gmail.com>
Suggested-by: Taras Galchenko <tpgalchenko@gmail.com>
Tested-by: Taras Galchenko <tpgalchenko@gmail.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sun4i.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
index 38a4c5c1317b2..482d5b9cec1fb 100644
--- a/drivers/pwm/pwm-sun4i.c
+++ b/drivers/pwm/pwm-sun4i.c
@@ -294,12 +294,8 @@ static int sun4i_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	ctrl |= BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
 
-	if (state->enabled) {
+	if (state->enabled)
 		ctrl |= BIT_CH(PWM_EN, pwm->hwpwm);
-	} else {
-		ctrl &= ~BIT_CH(PWM_EN, pwm->hwpwm);
-		ctrl &= ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
-	}
 
 	sun4i_pwm_writel(sun4i_pwm, ctrl, PWM_CTRL_REG);
 
-- 
2.27.0



