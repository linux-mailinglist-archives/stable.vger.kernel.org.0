Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B223040EF9A
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbhIQCg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243242AbhIQCgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3759061248;
        Fri, 17 Sep 2021 02:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846094;
        bh=/hb9GIZb9Fv8i8fpV9Vo6wFplZV9WG8Ic/1WvmTvOxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdk7Lqro1G0z/Bblx0B15S66YIC533xSQX0b0RFzly7mKGN6u9Ecxxwq9biNGzRHM
         6sjecbpJ8Pit/rv1U3Gf5xSpfVCBbRtRRiGQCfWjMkJt9lZgE6Q/Rkpor8NmaISmq8
         px8dK+7X6220H9Wym4KweFPZ/x3uR+Xcg6ktvGTHQvN16Bd//O5tah8m32X2YGeWHi
         uEA/oY9Ns5YKPBamRBf9FL1FwWvXsBHa5uvirk9Nf8aLaFveP5ThRHSbi3rOE+GXAh
         dWGRDnu//LsRaFTtjwrWMQxKVuIFf3HcaH1DhdWp2haJgspGar4i7HnXhiuK4XZdER
         ZatBmZt1SSnpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, fabrice.gasnier@foss.st.com,
        lee.jones@linaro.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, linux-pwm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 3/5] pwm: stm32-lp: Don't modify HW state in .remove() callback
Date:   Thu, 16 Sep 2021 22:34:47 -0400
Message-Id: <20210917023449.816713-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023449.816713-1-sashal@kernel.org>
References: <20210917023449.816713-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit d44084c93427bb0a9261432db1a8ca76a42d805e ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32-lp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 67fca62524dc..05bb1f95a773 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -225,8 +225,6 @@ static int stm32_pwm_lp_remove(struct platform_device *pdev)
 {
 	struct stm32_pwm_lp *priv = platform_get_drvdata(pdev);
 
-	pwm_disable(&priv->chip.pwms[0]);
-
 	return pwmchip_remove(&priv->chip);
 }
 
-- 
2.30.2

