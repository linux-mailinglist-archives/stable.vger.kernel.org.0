Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5AF419C17
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhI0RZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237262AbhI0RWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC67A6135A;
        Mon, 27 Sep 2021 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762868;
        bh=Vz+vKDRxCrFDPy7H8iM4rshq2PBP9JiG/4MPfVshD8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJmyZbAfWJrXhhYYoh4P5cSEvWE+5bysiOsupMtHmXwTdtjfTFg8DwQc1WgxpAOV8
         pfv4NxxRDFfx+u2sp9O0iT05RcEatMUiA69RI5VRwluFUVVmxu1yOYOGyw2xc5G8fR
         GdXsRnkx20qsadr7pWSwFdFNIYJtRkeVz7TkKlEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 081/162] gpio: uniphier: Fix void functions to remove return value
Date:   Mon, 27 Sep 2021 19:02:07 +0200
Message-Id: <20210927170236.252669925@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 2dd824cca3407bc9a2bd11b00f6e117b66fcfcf1 ]

The return type of irq_chip.irq_mask() and irq_chip.irq_unmask() should
be void.

Fixes: dbe776c2ca54 ("gpio: uniphier: add UniPhier GPIO controller driver")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-uniphier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-uniphier.c b/drivers/gpio/gpio-uniphier.c
index f99f3c10bed0..39dca147d587 100644
--- a/drivers/gpio/gpio-uniphier.c
+++ b/drivers/gpio/gpio-uniphier.c
@@ -184,7 +184,7 @@ static void uniphier_gpio_irq_mask(struct irq_data *data)
 
 	uniphier_gpio_reg_update(priv, UNIPHIER_GPIO_IRQ_EN, mask, 0);
 
-	return irq_chip_mask_parent(data);
+	irq_chip_mask_parent(data);
 }
 
 static void uniphier_gpio_irq_unmask(struct irq_data *data)
@@ -194,7 +194,7 @@ static void uniphier_gpio_irq_unmask(struct irq_data *data)
 
 	uniphier_gpio_reg_update(priv, UNIPHIER_GPIO_IRQ_EN, mask, mask);
 
-	return irq_chip_unmask_parent(data);
+	irq_chip_unmask_parent(data);
 }
 
 static int uniphier_gpio_irq_set_type(struct irq_data *data, unsigned int type)
-- 
2.33.0



