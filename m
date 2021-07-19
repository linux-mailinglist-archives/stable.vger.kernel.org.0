Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4F3CE101
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347318AbhGSPTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347161AbhGSPPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48BB960FDA;
        Mon, 19 Jul 2021 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710184;
        bh=1lRDiCc8YbkpHq7VPWj7qmsoIYu99lImpAU5h12Bcns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g35X4ViByXFJ7ICXwWAd5ey2AppwkqBcIh6im6TqzWmZExqNbSo406bAoEYXMKVVu
         LdGFSveG2dV8H/RI109vOv7i4INcr996m3SR6faFIOq2KnsBAkx1Q8NkzyPrVRvXZl
         A9GdwwgFMjd98bhZ8jDnHIQ4TXpZAP+asrp9UtyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/243] gpio: zynq: Check return value of pm_runtime_get_sync
Date:   Mon, 19 Jul 2021 16:51:46 +0200
Message-Id: <20210719144943.389199838@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1001,8 +1001,11 @@ err_pm_dis:
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



