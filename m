Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD5E16740C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgBUISB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:18:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbgBUISA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0292468A;
        Fri, 21 Feb 2020 08:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273079;
        bh=Uy+uU0lTHozrOu7Zp3nMGr4SJBMZzKyAgAl9QYPUfTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxZN/l1Dqgwp/n9TxiSKBbMveJKURM6EdUEiY9vQQqqpeRmm8JwlEkD2tqLHAcds5
         gn1mD+ywoUzXxhrsyewWPitenYsgvVwp6/PsChOUY+rE/yQvVHieUk9+MHEIy4TaeX
         SgwwJVxpXTzczQ4iiEgJ9g1MLxAyUJZ4rNwZAxI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/191] pwm: omap-dmtimer: Simplify error handling
Date:   Fri, 21 Feb 2020 08:40:11 +0100
Message-Id: <20200221072256.150152720@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -342,13 +337,28 @@ put:
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



