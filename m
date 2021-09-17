Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73B040EF67
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242966AbhIQCft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243031AbhIQCfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D8676113E;
        Fri, 17 Sep 2021 02:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846061;
        bh=d9eEmnjfVoAnsugk/Swxx8TaxB5WZO7slyJYwD+sB84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpVWbK70ulTjH4s5lI/MxocArqT8DTXyS2r1VcKhXIuYjyIhCIbokUP86StCls/z/
         DICNNbzRLh0jJW83LnpZw6hQKWELZHGAF7C4xy3FpXmBknyzo/8c+jTa3i2Drjl8K6
         Orbh1xP6/iUB92GN5g83HRmKILL6LPB8inS23205hm1+li/Tlcnd71EbASdlq8TWfZ
         4VnkLd+KrswS2q12PYftmvPlx600n52fg0ya+jOnaF1xxxF6uyh3+ZbDsIwTTVzx2u
         k1hvt9EqmQAS6fPb5kolXE+MUWonPyracRo+HQdda4ZXenZ/8LJsqQZtsPL1LkpzJh
         HyWRbUe7qJqkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org
Subject: [PATCH AUTOSEL 5.14 11/21] pwm: img: Don't modify HW state in .remove() callback
Date:   Thu, 16 Sep 2021 22:33:05 -0400
Message-Id: <20210917023315.816225-11-sashal@kernel.org>
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

[ Upstream commit c68eb29c8e9067c08175dd0414f6984f236f719d ]

A consumer is expected to disable a PWM before calling pwm_put(). And if
they didn't there is hopefully a good reason (or the consumer needs
fixing). Also if disabling an enabled PWM was the right thing to do,
this should better be done in the framework instead of in each low level
driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-img.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/pwm/pwm-img.c b/drivers/pwm/pwm-img.c
index 11b16ecc4f96..18d8e34d0d08 100644
--- a/drivers/pwm/pwm-img.c
+++ b/drivers/pwm/pwm-img.c
@@ -326,23 +326,7 @@ static int img_pwm_probe(struct platform_device *pdev)
 static int img_pwm_remove(struct platform_device *pdev)
 {
 	struct img_pwm_chip *pwm_chip = platform_get_drvdata(pdev);
-	u32 val;
-	unsigned int i;
-	int ret;
-
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0) {
-		pm_runtime_put(&pdev->dev);
-		return ret;
-	}
-
-	for (i = 0; i < pwm_chip->chip.npwm; i++) {
-		val = img_pwm_readl(pwm_chip, PWM_CTRL_CFG);
-		val &= ~BIT(i);
-		img_pwm_writel(pwm_chip, PWM_CTRL_CFG, val);
-	}
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		img_pwm_runtime_suspend(&pdev->dev);
-- 
2.30.2

