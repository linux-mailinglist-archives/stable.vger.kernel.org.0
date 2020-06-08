Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390EE1F2BBC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgFHXSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgFHXSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F6D20870;
        Mon,  8 Jun 2020 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658314;
        bh=fbp5eN4Hnuv3+bR/hO5F+wm3gfMFLymjiWDBZD1oZEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbTIZHd7GkhRUrzCvODtziT1b//1+VHPOXMlUBt1dsPWNzdb/1U3Ep2KhHZxDGMDi
         BZdAYjGlpPKYKkHEUCI/x0xLArcIUvbcJmYs/vo2DLi5jCk3OCR3TIQAbZD/FXvoTd
         qzT5d5Sa+bG5HRay2VUSO3TN1UK/QuuTH52qwUJs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 315/606] gpio: pxa: Fix return value of pxa_gpio_probe()
Date:   Mon,  8 Jun 2020 19:07:20 -0400
Message-Id: <20200608231211.3363633-315-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 558ab2e8155e5f42ca0a6407957cd4173dc166cc ]

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Fixes: 542c25b7a209 ("drivers: gpio: pxa: use devm_platform_ioremap_resource()")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pxa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 9888b62f37af..432c487f77b4 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -663,8 +663,8 @@ static int pxa_gpio_probe(struct platform_device *pdev)
 	pchip->irq1 = irq1;
 
 	gpio_reg_base = devm_platform_ioremap_resource(pdev, 0);
-	if (!gpio_reg_base)
-		return -EINVAL;
+	if (IS_ERR(gpio_reg_base))
+		return PTR_ERR(gpio_reg_base);
 
 	clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
-- 
2.25.1

