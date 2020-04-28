Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB3E1BC881
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgD1SdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbgD1SdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D7220B80;
        Tue, 28 Apr 2020 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098795;
        bh=pee3zUleh4ZtCgWyYYLwuFN+JFW53m0iamtGFVqoGCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqEtVdl1SEKFw/PEG6SG6nY7M2Rk9qbna2783lv69Cfx5rh0/V/pwLKYdstsWPh8a
         C59gL2AhUoUrC7a5u+NY8FvrF0JV3BmOUwXOosiY9uS5rV0cnFASWEzFgEbB7cXPm9
         FqpmHOwzr0P+OHmrp+5ORpgSP7kELcYf/Q1VTYOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/168] pwm: rcar: Fix late Runtime PM enablement
Date:   Tue, 28 Apr 2020 20:23:10 +0200
Message-Id: <20200428182233.749983709@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1451a3eed24b5fd6a604683f0b6995e0e7e16c79 ]

Runtime PM should be enabled before calling pwmchip_add(), as PWM users
can appear immediately after the PWM chip has been added.
Likewise, Runtime PM should be disabled after the removal of the PWM
chip.

Fixes: ed6c1476bf7f16d5 ("pwm: Add support for R-Car PWM Timer")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rcar.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-rcar.c b/drivers/pwm/pwm-rcar.c
index 852eb2347954d..b98ec8847b488 100644
--- a/drivers/pwm/pwm-rcar.c
+++ b/drivers/pwm/pwm-rcar.c
@@ -228,24 +228,28 @@ static int rcar_pwm_probe(struct platform_device *pdev)
 	rcar_pwm->chip.base = -1;
 	rcar_pwm->chip.npwm = 1;
 
+	pm_runtime_enable(&pdev->dev);
+
 	ret = pwmchip_add(&rcar_pwm->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register PWM chip: %d\n", ret);
+		pm_runtime_disable(&pdev->dev);
 		return ret;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-
 	return 0;
 }
 
 static int rcar_pwm_remove(struct platform_device *pdev)
 {
 	struct rcar_pwm_chip *rcar_pwm = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pwmchip_remove(&rcar_pwm->chip);
 
 	pm_runtime_disable(&pdev->dev);
 
-	return pwmchip_remove(&rcar_pwm->chip);
+	return ret;
 }
 
 static const struct of_device_id rcar_pwm_of_table[] = {
-- 
2.20.1



