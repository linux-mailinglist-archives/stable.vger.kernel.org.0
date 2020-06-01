Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC61EAD7E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgFASJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbgFASJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3184E206E2;
        Mon,  1 Jun 2020 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034948;
        bh=fbp5eN4Hnuv3+bR/hO5F+wm3gfMFLymjiWDBZD1oZEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2ESWlGWhEl3PFf0bWyCp8f618knM9Dse3VG/XP6rAkGdrwG6BuYNCAYKZrjZUS/N
         qjoIj3IdnAIsy1vQScgpTgK+Hb2dgSJKmRpnKWyU33xZ/cpv/snHQUqf8Ym3Ub74Si
         Rj9gzDaZOg5DqU/wrhLYMI40/263TbXriy7s/HnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/142] gpio: pxa: Fix return value of pxa_gpio_probe()
Date:   Mon,  1 Jun 2020 19:54:02 +0200
Message-Id: <20200601174046.636051642@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



