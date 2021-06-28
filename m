Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4523B6A2F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbhF1VX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237866AbhF1VXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1364461D06;
        Mon, 28 Jun 2021 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915255;
        bh=YKmwurZwGMWzcmhMkRf94jfggcgdhpnkZCsw9DLpBAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzB/Ckt28AtAg30bMmDykdhYzO7+V7/zsFzPdr1mJE7Whec/DhKCVk5eqk1iD+FOS
         cfjfVou5RidgDM3AGX8ZbcHlcCzX+4S/nBhETF1yiGkagrFilxr6Hr25KxpChkxDQ1
         RDnPMqjiH412Zi8mMsvXU7ldSOzZTShFq2tllhYMOslkfKCN7L6W/1VFQoOYrGg16x
         ZxaK7H5b9rkMIVOVNmGDJaPPLYDAMnQViTcVL4AwTIo5VT8qmclyatIRBU1KCEXs5q
         V1Z7OesbxtlgWURfpqgNHh/MR1CI4iUGkoR12CC80NIWOh0WXicKlaTLPkwh91A7UC
         4O8UuelsN2m+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Michal Koziel <michal.koziel@emlogic.no>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 3/5] gpio: mxc: Fix disabled interrupt wake-up support
Date:   Mon, 28 Jun 2021 17:20:49 -0400
Message-Id: <20210628212051.43265-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212051.43265-1-sashal@kernel.org>
References: <20210628212051.43265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 3093e6cca3ba7d47848068cb256c489675125181 ]

A disabled/masked interrupt marked as wakeup source must be re-enable
and unmasked in order to be able to wake-up the host. That can be done
by flaging the irqchip with IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND.

Note: It 'sometimes' works without that change, but only thanks to the
lazy generic interrupt disabling (keeping interrupt unmasked).

Reported-by: Michal Koziel <michal.koziel@emlogic.no>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 157106e1e438..b9fdf05d7669 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -334,7 +334,7 @@ static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = gpio_set_irq_type;
 	ct->chip.irq_set_wake = gpio_set_wake_irq;
-	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND;
+	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND;
 	ct->regs.ack = GPIO_ISR;
 	ct->regs.mask = GPIO_IMR;
 
-- 
2.30.2

