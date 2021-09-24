Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2604173BB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345032AbhIXM7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345507AbhIXM63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC3F61360;
        Fri, 24 Sep 2021 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487952;
        bh=muaWMSZGa3agYFRVI6ewmcxjNXQ57VUARIHyLMqxB/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgP3xs/Y5LGV8vuQZl/rEf94n5dOUFpUtR/DUiYrQlj9IE0erXMSOpeRCD0AiHYra
         d5SwIpb/G1lFBrR8kolJxB6Fqy1puh6WTWYNpzAWlu/V5Jt0nvL1Gyrtxqd/uzuKIX
         uQ/a0DqK+eFAKKmvXo/QTqLScYeiF96dUu9VTGp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sylvain Lemieux <slemieux@tycoint.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.14 025/100] pwm: lpc32xx: Dont modify HW state in .probe() after the PWM chip was registered
Date:   Fri, 24 Sep 2021 14:43:34 +0200
Message-Id: <20210924124342.291560393@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 3d2813fb17e5fd0d73c1d1442ca0192bde4af10e upstream.

This fixes a race condition: After pwmchip_add() is called there might
already be a consumer and then modifying the hardware behind the
consumer's back is bad. So set the default before.

(Side-note: I don't know what this register setting actually does, if
this modifies the polarity there is an inconsistency because the
inversed polarity isn't considered if the PWM is already running during
.probe().)

Fixes: acfd92fdfb93 ("pwm: lpc32xx: Set PWM_PIN_LEVEL bit to default value")
Cc: Sylvain Lemieux <slemieux@tycoint.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-lpc32xx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -117,17 +117,17 @@ static int lpc32xx_pwm_probe(struct plat
 	lpc32xx->chip.ops = &lpc32xx_pwm_ops;
 	lpc32xx->chip.npwm = 1;
 
+	/* If PWM is disabled, configure the output to the default value */
+	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+	val &= ~PWM_PIN_LEVEL;
+	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+
 	ret = pwmchip_add(&lpc32xx->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add PWM chip, error %d\n", ret);
 		return ret;
 	}
 
-	/* When PWM is disable, configure the output to the default value */
-	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
-	val &= ~PWM_PIN_LEVEL;
-	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
-
 	platform_set_drvdata(pdev, lpc32xx);
 
 	return 0;


