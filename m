Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B51BCBE2
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgD1TAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 15:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgD1S1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77DD20B1F;
        Tue, 28 Apr 2020 18:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098424;
        bh=PMTvBFQ0x9YqKY+5Qb8S07kDaFrBmGmU4R7NP/CG0k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPh8vrbCo88AvQlWqMhjYuhznH8uHOIrESKUeWz1ZcmKkE7n6jMmEgmvmh4h1K5dg
         1PXZYcgZoMv+QwS2IPK2Hok55nLLjss++8i6zTxiAHouyyoZeMBZ4mXOMGH9KFopZd
         gD3M8lEL+N0Z22IZthEpemKCqBZceevqzuCjfdyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 033/167] pwm: renesas-tpu: Fix late Runtime PM enablement
Date:   Tue, 28 Apr 2020 20:23:29 +0200
Message-Id: <20200428182229.386164354@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



