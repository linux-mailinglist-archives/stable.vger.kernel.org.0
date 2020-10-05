Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2128399A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgJEP1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbgJEP10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:27:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003592074F;
        Mon,  5 Oct 2020 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911645;
        bh=k6Hm6Lzc5HTMIx8sdOb8L7kYqltZcdlVWn+hzd2uRoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6yY5CoEzYwoUr+Z6Hm+xUj2sbdgrsh21ppIA77iTWTadKevH6HdZMFxVtZR4D5e2
         CKPNjUJaFd8DOCOPdPBFLfePItRvKc5Mo1MsTTmiMoYt43iaCeLRF+IR5JSlzyIRBp
         qvZ+gy6aOAwS0N7jHSQjyyMqpaSScL95bfAbbtds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taiping Lai <taiping.lai@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/38] gpio: sprd: Clear interrupt when setting the type as edge
Date:   Mon,  5 Oct 2020 17:26:40 +0200
Message-Id: <20201005142109.783289020@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
References: <20201005142108.650363140@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taiping Lai <taiping.lai@unisoc.com>

[ Upstream commit 5fcface659aab7eac4bd65dd116d98b8f7bb88d5 ]

The raw interrupt status of GPIO maybe set before the interrupt is enabled,
which would trigger the interrupt event once enabled it from user side.
This is the case for edge interrupts only. Adding a clear operation when
setting interrupt type can avoid that.

There're a few considerations for the solution:
1) This issue is for edge interrupt only; The interrupts requested by users
   are IRQ_TYPE_LEVEL_HIGH as default, so clearing interrupt when request
   is useless.
2) The interrupt type can be set to edge when request and following up
   with clearing it though, but the problem is still there once users set
   the interrupt type to level trggier.
3) We can add a clear operation after each time of setting interrupt
   enable bit, but it is redundant for level trigger interrupt.

Therefore, the solution is this patch seems the best for now.

Fixes: 9a3821c2bb47 ("gpio: Add GPIO driver for Spreadtrum SC9860 platform")
Signed-off-by: Taiping Lai <taiping.lai@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sprd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-sprd.c b/drivers/gpio/gpio-sprd.c
index 55072d2b367fa..4d53347adcafa 100644
--- a/drivers/gpio/gpio-sprd.c
+++ b/drivers/gpio/gpio-sprd.c
@@ -149,17 +149,20 @@ static int sprd_gpio_irq_set_type(struct irq_data *data,
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IS, 0);
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IBE, 0);
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IEV, 1);
+		sprd_gpio_update(chip, offset, SPRD_GPIO_IC, 1);
 		irq_set_handler_locked(data, handle_edge_irq);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IS, 0);
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IBE, 0);
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IEV, 0);
+		sprd_gpio_update(chip, offset, SPRD_GPIO_IC, 1);
 		irq_set_handler_locked(data, handle_edge_irq);
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IS, 0);
 		sprd_gpio_update(chip, offset, SPRD_GPIO_IBE, 1);
+		sprd_gpio_update(chip, offset, SPRD_GPIO_IC, 1);
 		irq_set_handler_locked(data, handle_edge_irq);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-- 
2.25.1



