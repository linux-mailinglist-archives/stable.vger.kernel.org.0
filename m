Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695BD420CCA
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhJDNJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235504AbhJDNIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EBCB61B46;
        Mon,  4 Oct 2021 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352545;
        bh=Bu8svrsmivnGJVPTz01gE8C9v2qQNXvFCBohJ4RAK4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jozgPYJP7gNS0J3ok4EjIhsyOQ6eOvlJnNH/BiZ8uKUJjegD/Vo+ZsDIocETc1qvq
         vrY1m0ELNS29V4q7VooqsgHcn0SWutHiWYn8jVB2thqSs2t0oXpK1arheQDnxyCDCZ
         7HQOFj7TNdWmIe5DMUSbag/zOc+MQNrt6SPDbeIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/95] gpio: uniphier: Fix void functions to remove return value
Date:   Mon,  4 Oct 2021 14:51:51 +0200
Message-Id: <20211004125034.251386500@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
index 7fdac9060979..c72ec3ddf90b 100644
--- a/drivers/gpio/gpio-uniphier.c
+++ b/drivers/gpio/gpio-uniphier.c
@@ -197,7 +197,7 @@ static void uniphier_gpio_irq_mask(struct irq_data *data)
 
 	uniphier_gpio_reg_update(priv, UNIPHIER_GPIO_IRQ_EN, mask, 0);
 
-	return irq_chip_mask_parent(data);
+	irq_chip_mask_parent(data);
 }
 
 static void uniphier_gpio_irq_unmask(struct irq_data *data)
@@ -207,7 +207,7 @@ static void uniphier_gpio_irq_unmask(struct irq_data *data)
 
 	uniphier_gpio_reg_update(priv, UNIPHIER_GPIO_IRQ_EN, mask, mask);
 
-	return irq_chip_unmask_parent(data);
+	irq_chip_unmask_parent(data);
 }
 
 static int uniphier_gpio_irq_set_type(struct irq_data *data, unsigned int type)
-- 
2.33.0



