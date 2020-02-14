Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D030015EA82
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392068AbgBNRO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392010AbgBNQMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:12:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDDE246A5;
        Fri, 14 Feb 2020 16:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696754;
        bh=ol2g2nyhIXqw3n6QjzaZf1Poe1UQjmwRdesjHkzJb18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoMd5VgVN03CghRH5JB4BzAZVCFgYqaJY6hg5yXeMB14CNE4Y71P2wijcAZr5ed85
         mQhfnEFMjDRQJ8EO72zPJHMWwtXzcuz6KBZkKCaryBVMzGipteG57w2WpFdMo9j7I2
         fGDQPXkkOcP64RUoE5KUbWuHRdIYd5d623uPVRJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/252] pwm: omap-dmtimer: Simplify error handling
Date:   Fri, 14 Feb 2020 11:08:11 -0500
Message-Id: <20200214161147.15842-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c4cf7aa57eb83b108d2d9c6c37c143388fee2a4d ]

Instead of doing error handling in the middle of ->probe(), move error
handling and freeing the reference to timer to the end.

This fixes a resource leak as dm_timer wasn't freed when allocating
*omap failed.

Implementation note: The put: label was never reached without a goto and
ret being unequal to 0, so the removed return statement is fine.

Fixes: 6604c6556db9 ("pwm: Add PWM driver for OMAP using dual-mode timers")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-omap-dmtimer.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/pwm/pwm-omap-dmtimer.c b/drivers/pwm/pwm-omap-dmtimer.c
index f45798679e3c0..2d585c101d52e 100644
--- a/drivers/pwm/pwm-omap-dmtimer.c
+++ b/drivers/pwm/pwm-omap-dmtimer.c
@@ -301,15 +301,10 @@ static int pwm_omap_dmtimer_probe(struct platform_device *pdev)
 		goto put;
 	}
 
-put:
-	of_node_put(timer);
-	if (ret < 0)
-		return ret;
-
 	omap = devm_kzalloc(&pdev->dev, sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
-		pdata->free(dm_timer);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_alloc_omap;
 	}
 
 	omap->pdata = pdata;
@@ -342,13 +337,28 @@ static int pwm_omap_dmtimer_probe(struct platform_device *pdev)
 	ret = pwmchip_add(&omap->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register PWM\n");
-		omap->pdata->free(omap->dm_timer);
-		return ret;
+		goto err_pwmchip_add;
 	}
 
+	of_node_put(timer);
+
 	platform_set_drvdata(pdev, omap);
 
 	return 0;
+
+err_pwmchip_add:
+
+	/*
+	 * *omap is allocated using devm_kzalloc,
+	 * so no free necessary here
+	 */
+err_alloc_omap:
+
+	pdata->free(dm_timer);
+put:
+	of_node_put(timer);
+
+	return ret;
 }
 
 static int pwm_omap_dmtimer_remove(struct platform_device *pdev)
-- 
2.20.1

