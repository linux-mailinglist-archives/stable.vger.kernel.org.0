Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5643E8110
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhHJRzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236195AbhHJRws (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F8C6136A;
        Tue, 10 Aug 2021 17:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617415;
        bh=ySdgxvltRO98Yof6wxQm2ulBxYe/gQDIxZkggTO7v6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPoirRpuPawjiT6lPpx+WQ9rSXykybUnwg43vl6pPbpyouR0kkS3nivIN37+zxt3d
         +P6OyoL27PwO/2vUytJAQP+h99Gl1gXyu+2H2oqZB9ku/SKIeARe+y0zJMQN+wuTTJ
         zlqEL39iKOEoePLkneZiDthFL2bwt1DkIoq6NY3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/175] gpio: tqmx86: really make IRQ optional
Date:   Tue, 10 Aug 2021 19:29:16 +0200
Message-Id: <20210810173002.529271935@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 9b87f43537acfa24b95c236beba0f45901356eb2 ]

The tqmx86 MFD driver was passing IRQ 0 for "no IRQ" in the past. This
causes warnings with newer kernels.

Prepare the gpio-tqmx86 driver for the fixed MFD driver by handling a
missing IRQ properly.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index 5022e0ad0fae..0f5d17f343f1 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -238,8 +238,8 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
+	irq = platform_get_irq_optional(pdev, 0);
+	if (irq < 0 && irq != -ENXIO)
 		return irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -278,7 +278,7 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 
-	if (irq) {
+	if (irq > 0) {
 		struct irq_chip *irq_chip = &gpio->irq_chip;
 		u8 irq_status;
 
-- 
2.30.2



