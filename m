Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1921FE516
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgFRCXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbgFRBSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ABEC21D80;
        Thu, 18 Jun 2020 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443084;
        bh=I2F6fN+42izECEedNu+3CiXDqLSxar4fLW5EChKmkQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBRMAHg3KNMoGoZjVuwUOX11B9+LOunD7lSZvytbm8Y6hWoSYHEdGxPEo7UdVBhc8
         CcJJOfeXQ78xtIrw5MeaNZQrl9ctrhmnFqhpwKJDUUCr8dea5HzKYpclMWw2DcFGrL
         lrziCQz8wt+Nfuyv2pV8lOoGMZp5UB9+GM+rdgg0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 069/266] pwm: img: Call pm_runtime_put() in pm_runtime_get_sync() failed case
Date:   Wed, 17 Jun 2020 21:13:14 -0400
Message-Id: <20200618011631.604574-69-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit ca162ce98110b98e7d97b7157328d34dcfdd40a9 ]

Even in failed case of pm_runtime_get_sync(), the usage_count is
incremented. In order to keep the usage_count with correct value call
appropriate pm_runtime_put().

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-img.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-img.c b/drivers/pwm/pwm-img.c
index c9e57bd109fb..599a0f66a384 100644
--- a/drivers/pwm/pwm-img.c
+++ b/drivers/pwm/pwm-img.c
@@ -129,8 +129,10 @@ static int img_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	duty = DIV_ROUND_UP(timebase * duty_ns, period_ns);
 
 	ret = pm_runtime_get_sync(chip->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(chip->dev);
 		return ret;
+	}
 
 	val = img_pwm_readl(pwm_chip, PWM_CTRL_CFG);
 	val &= ~(PWM_CTRL_CFG_DIV_MASK << PWM_CTRL_CFG_DIV_SHIFT(pwm->hwpwm));
@@ -331,8 +333,10 @@ static int img_pwm_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(&pdev->dev);
 		return ret;
+	}
 
 	for (i = 0; i < pwm_chip->chip.npwm; i++) {
 		val = img_pwm_readl(pwm_chip, PWM_CTRL_CFG);
-- 
2.25.1

