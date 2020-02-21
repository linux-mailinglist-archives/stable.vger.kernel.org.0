Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C6A1671BE
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgBUH4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgBUH4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:56:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F7920578;
        Fri, 21 Feb 2020 07:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271811;
        bh=y2KdCYZvWSq0h8YAq2s31CMB/GuJJswO/YD0CnIzWXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsWkmGaEt+MEpMarvMfD78CoD/qH2HLoI6okP9/WfiQa5+6d6ADK01z4+UZ+mmOP2
         B15eXXxEz+bBjagcEbCxQlQQ+p0KfYCVm/oPOE/WZCZ1/tqROSHpz1fIJcb8YYfq/l
         rCuHdExpI7hoYX5Tbxf58Fe6o40jCeQ+6MvIjI/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yu kuai <yukuai3@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 306/399] pwm: Remove set but not set variable pwm
Date:   Fri, 21 Feb 2020 08:40:31 +0100
Message-Id: <20200221072431.363511352@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 168684b02ebce..b07bdca3d510d 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -159,13 +159,9 @@ static void pca9685_pwm_gpio_set(struct gpio_chip *gpio, unsigned int offset,
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



