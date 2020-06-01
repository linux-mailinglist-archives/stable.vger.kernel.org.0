Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE141EAB3D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgFASPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbgFASPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A872F2068D;
        Mon,  1 Jun 2020 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035330;
        bh=fbp5eN4Hnuv3+bR/hO5F+wm3gfMFLymjiWDBZD1oZEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELI+eDlvB+oBZetjBl1RI9/HvA6ij2ejP2aRsL/CqFeQ0MdYKIYcgW//vf2TEwyXS
         viit+sOYd08U8odtmjMyWz8HZ1PLmpFXpNAA1n3qu/BOIXjGP80GbrGU752Iwp81Kn
         NZeZWuWKo+G8lbkUTnH8DXyx8LXFDiAq1xQOC6t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 111/177] gpio: pxa: Fix return value of pxa_gpio_probe()
Date:   Mon,  1 Jun 2020 19:54:09 +0200
Message-Id: <20200601174057.876910842@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
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



