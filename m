Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CDF1AED58
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgDRNtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgDRNtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7008221D6C;
        Sat, 18 Apr 2020 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217750;
        bh=PMTvBFQ0x9YqKY+5Qb8S07kDaFrBmGmU4R7NP/CG0k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B28Ld8acGt1EPYRfjrwPn0L/PWo2DrIinjdrzR80aV+IHT3Z4mLCnVfYayFY3h5Ts
         mz1epKQdW5BXVCzVHO3LwqYCDC9CcXkAy6svC3fiSoPo7KSyw5jtU5eoPa8RUKdMQA
         zac0BNzKoJV3fXzUu+AegxXAnl+PmWaMIyV3c7c4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 43/73] pwm: renesas-tpu: Fix late Runtime PM enablement
Date:   Sat, 18 Apr 2020 09:47:45 -0400
Message-Id: <20200418134815.6519-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d5a3c7a4536e1329a758e14340efd0e65252bd3d ]

Runtime PM should be enabled before calling pwmchip_add(), as PWM users
can appear immediately after the PWM chip has been added.
Likewise, Runtime PM should always be disabled after the removal of the
PWM chip, even if the latter failed.

Fixes: 99b82abb0a35b073 ("pwm: Add Renesas TPU PWM driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 4a855a21b782d..8032acc84161a 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -415,16 +415,17 @@ static int tpu_probe(struct platform_device *pdev)
 	tpu->chip.base = -1;
 	tpu->chip.npwm = TPU_CHANNEL_MAX;
 
+	pm_runtime_enable(&pdev->dev);
+
 	ret = pwmchip_add(&tpu->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register PWM chip\n");
+		pm_runtime_disable(&pdev->dev);
 		return ret;
 	}
 
 	dev_info(&pdev->dev, "TPU PWM %d registered\n", tpu->pdev->id);
 
-	pm_runtime_enable(&pdev->dev);
-
 	return 0;
 }
 
@@ -434,12 +435,10 @@ static int tpu_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = pwmchip_remove(&tpu->chip);
-	if (ret)
-		return ret;
 
 	pm_runtime_disable(&pdev->dev);
 
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_OF
-- 
2.20.1

