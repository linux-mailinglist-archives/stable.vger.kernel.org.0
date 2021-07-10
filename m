Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5103C2F4D
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhGJCbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhGJC3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F1C061419;
        Sat, 10 Jul 2021 02:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883946;
        bh=ryTTaVA44sGuLatGbFmEcoxmJyTLZaMZkUGnrbDWVsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCMQSpbKGPDE0Qd7nMh+MB6aFoxO4WoJhCUpXYz4nFkK+n+RHlwyd7IOdXkGdBrMI
         5kQ7t+xmf2yAPm3e0FPvrqTLfTu86DkGdbH0KxBdm2euvm+ir+uxro7Pd7RGvePzYN
         RzYTVXSJxZZ17+R8wwEV2vX3MtZbh1uxeUoF2Z1oS27judiiYg6EESkLnhrf6CK1+Q
         XFMBOidRY/I9ymir+ONaG8hUpW50ZGkhFsIMGhoyee59zRM1/9/ttcizq67/FEvX5Q
         0dZC+2HsjlUoS9Tpuki4Ybvt8fLN03MLO7rztTE7Jy1t6A44ueonYtJvgsEyPSinpK
         cc+Hv3hPqnhKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 59/93] gpio: zynq: Check return value of pm_runtime_get_sync
Date:   Fri,  9 Jul 2021 22:23:53 -0400
Message-Id: <20210710022428.3169839-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

[ Upstream commit a51b2fb94b04ab71e53a71b9fad03fa826941254 ]

Return value of "pm_runtime_get_sync" API was neither captured nor checked.
Fixed it by capturing the return value and then checking for any warning.

Addresses-Coverity: "check_return"
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index 3521c1dc3ac0..fb8684d70fe3 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1001,8 +1001,11 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 static int zynq_gpio_remove(struct platform_device *pdev)
 {
 	struct zynq_gpio *gpio = platform_get_drvdata(pdev);
+	int ret;
 
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);
-- 
2.30.2

