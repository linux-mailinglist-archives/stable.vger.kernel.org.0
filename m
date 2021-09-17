Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5658640EF6B
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbhIQCfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242900AbhIQCfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB8F361139;
        Fri, 17 Sep 2021 02:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846063;
        bh=OfVVcOguo7t7b7kwci97eIZXuWJ8X7903fh7rZvrrPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POMsAYgWso2ABNxRnExLwvgoLyZHN94pHk31PgblkM3GlZWwAwNsnIAYT8Sr2rkGQ
         rNmT4uMUH4njxLFLce2mE87Pyv6vxDL+z/ssptzBF69T5PL5AA2cXdxDNntc/6Jj+k
         Mp5+AoUy7m8ydTxT9d1G2tSGptiM2FbJfbdih2oJEdSE4z2aKY2RNMYjrsCz5od61q
         sY3qF6mGMst3+ED2ci3ZOQeANCw7eeBtQEMTOqFI5Tk4z6dJvVy/Y9lYdxKnL5uFct
         sbRCOQP4Z4fy7GkLRg76yqMBF6zS0NK96Nj1AMPXF/hxk1b5Vt4u7F4eBh1R9Tfv7A
         yfNCP4wm/+9hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, fabrice.gasnier@foss.st.com,
        lee.jones@linaro.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com
Subject: [PATCH AUTOSEL 5.14 13/21] pwm: stm32-lp: Don't modify HW state in .remove() callback
Date:   Thu, 16 Sep 2021 22:33:07 -0400
Message-Id: <20210917023315.816225-13-sashal@kernel.org>
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
index 93dd03618465..e4a10aac354d 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -222,8 +222,6 @@ static int stm32_pwm_lp_remove(struct platform_device *pdev)
 {
 	struct stm32_pwm_lp *priv = platform_get_drvdata(pdev);
 
-	pwm_disable(&priv->chip.pwms[0]);
-
 	return pwmchip_remove(&priv->chip);
 }
 
-- 
2.30.2

