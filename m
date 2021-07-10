Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A7A3C3124
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhGJCkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235896AbhGJCju (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15B1461453;
        Sat, 10 Jul 2021 02:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884582;
        bh=KotAUrAl+RS3cUxE3mRhWKLWrAvMmX+ljQlrGK8O/Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hhg6Gc45STzJSmWZuFicY5p7B4mjT2KXgymo/jJUUCjlcpsHR6ArgH3TGh6bgcwfd
         p1+cg93QSrGmyYkkmhrRxLszFJNroyQhmas4jAY7tvH7cUwS/tPgOtKp0VYuJS3K8r
         RfH6uD1QEC+JnY1nIA3ENVbL8aFyvZoJFvoDJeIRTF8ehOPg8YD9aathbv34+w3GGG
         NiG5Co5SfWZ7eBnTtui69q/WgV8MO/QqDD1Oq3x9vmJAiASMC+MWftJtrA2yiwef3O
         4F4hAMcCT1bjxvVVhbIWGChH3a5dh18PJurXu0oIBug4qTWzfuYfFXg69V2suxBuvi
         aWbeN95LYxnFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 14/26] gpio: zynq: Check return value of pm_runtime_get_sync
Date:   Fri,  9 Jul 2021 22:35:52 -0400
Message-Id: <20210710023604.3172486-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
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
index 6b4d10d6e10f..5038d771ac6e 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -778,8 +778,11 @@ static int zynq_gpio_probe(struct platform_device *pdev)
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

