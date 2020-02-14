Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAF915E6AB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405198AbgBNQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405195AbgBNQUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93352472C;
        Fri, 14 Feb 2020 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697219;
        bh=Wt3NAeACM4K4qNvn/QVuLHb67CRV4buzK2nKtMV9C+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crNLKs3WcGdSvFC88YyXvGbk0YrQoX/hQtxgBBlwHPgMIRvAocFW3WnG2susfkRcS
         0VFXLAnhXpu2bVdSDw0vqEr8o3zpDuReoMJdKK83NyEhkQvLwNhtdGwP0kkV0ZvNbI
         wLERTA7JUun2YxEj4rzwWaHno2Z3EMXh9c9enKMM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 143/186] pwm: Remove set but not set variable 'pwm'
Date:   Fri, 14 Feb 2020 11:16:32 -0500
Message-Id: <20200214161715.18113-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 9871abffc81048e20f02e15d6aa4558a44ad53ea ]

Fixes gcc '-Wunused-but-set-variable' warning:

	drivers/pwm/pwm-pca9685.c: In function ‘pca9685_pwm_gpio_free’:
	drivers/pwm/pwm-pca9685.c:162:21: warning: variable ‘pwm’ set but not used [-Wunused-but-set-variable]

It is never used, and so can be removed. In that case, hold and release
the lock 'pca->lock' can be removed since nothing will be done between
them.

Fixes: e926b12c611c ("pwm: Clear chip_data in pwm_put()")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-pca9685.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index 567f5e2771c47..e1e5dfcb16f36 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -170,13 +170,9 @@ static void pca9685_pwm_gpio_set(struct gpio_chip *gpio, unsigned int offset,
 static void pca9685_pwm_gpio_free(struct gpio_chip *gpio, unsigned int offset)
 {
 	struct pca9685 *pca = gpiochip_get_data(gpio);
-	struct pwm_device *pwm;
 
 	pca9685_pwm_gpio_set(gpio, offset, 0);
 	pm_runtime_put(pca->chip.dev);
-	mutex_lock(&pca->lock);
-	pwm = &pca->chip.pwms[offset];
-	mutex_unlock(&pca->lock);
 }
 
 static int pca9685_pwm_gpio_get_direction(struct gpio_chip *chip,
-- 
2.20.1

