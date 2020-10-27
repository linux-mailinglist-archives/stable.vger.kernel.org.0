Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6D429C3F4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813544AbgJ0Rvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901516AbgJ0OYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73F320773;
        Tue, 27 Oct 2020 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808646;
        bh=eKiQzv22GiZPQaooQmQqwAP0pgqKAn2zqbeOSKlbBOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4L0eiyEZ07+ba6sOHAt746dzl9d35yzhn8JbUqO0kMW/6Vyr6AuBor0/MLQIZzX6
         op+y8dX5azstbhpo6PJpXEf5tI1Gdh/d8BEqPw0nL+PeO84aC8wE131TS9yGihRvjz
         8ARIaP35Bgn3PLyEwbUwHh7eHnP7Q5xBNSPxRY/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/264] pwm: img: Fix null pointer access in probe
Date:   Tue, 27 Oct 2020 14:53:48 +0100
Message-Id: <20201027135438.665175696@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit b39c0615d0667b3a6f2f5c4bf99ffadf3b518bb1 ]

dev_get_drvdata() is called in img_pwm_runtime_resume() before the
driver data is set.
When pm_runtime_enabled() returns false in img_pwm_probe() it calls
img_pwm_runtime_resume() which results in a null pointer access.

This patch fixes the problem by setting the driver data earlier in the
img_pwm_probe() function.

This crash was seen when booting the Imagination Technologies Creator
Ci40 (Marduk) with kernel 5.4 in OpenWrt.

Fixes: e690ae526216 ("pwm: img: Add runtime PM")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-img.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-img.c b/drivers/pwm/pwm-img.c
index da72b2866e88e..3b0a097ce2abd 100644
--- a/drivers/pwm/pwm-img.c
+++ b/drivers/pwm/pwm-img.c
@@ -280,6 +280,8 @@ static int img_pwm_probe(struct platform_device *pdev)
 		return PTR_ERR(pwm->pwm_clk);
 	}
 
+	platform_set_drvdata(pdev, pwm);
+
 	pm_runtime_set_autosuspend_delay(&pdev->dev, IMG_PWM_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
@@ -316,7 +318,6 @@ static int img_pwm_probe(struct platform_device *pdev)
 		goto err_suspend;
 	}
 
-	platform_set_drvdata(pdev, pwm);
 	return 0;
 
 err_suspend:
-- 
2.25.1



