Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7063BBBD0
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhGELCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231388AbhGELCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB2F9613BA;
        Mon,  5 Jul 2021 11:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482801;
        bh=EJQaKN59+x9KgDJMx8M091LYcYzwiV6zoqt125gDOjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUbYWQhsHbw1ZFBVa0vPnkxSPFsQllRvTs6n2WGgdV9Me7c8cZYHyDAPA2HSEXmSh
         Icfik/6KxWIbkDM11yMmvw2Kej6JJ1Ofb5fEANZFWBwLLAI4dK8K2sxpV5MbdXBltx
         wO8307X1q1Nt9YBqF8cBshm+eXbp4dMvuJRiAKbV8C4bJIXVslpnKUWzkwMS14HR1J
         Ox/zkr/89eGiacpYA4TL9D++DBwQnvDMo53LS4KYLAP2vE2uNkbr61HQhd8tPPfM1G
         zEu0R2XLM2wWBe18iMD7+0SqMjbODY7PrQZT94F/OD60pbDDDGDSKJh0mhVnQGX4sj
         Pqlb48iCGJYxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Michal Koziel <michal.koziel@emlogic.no>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 2/7] gpio: mxc: Fix disabled interrupt wake-up support
Date:   Mon,  5 Jul 2021 06:59:52 -0400
Message-Id: <20210705105957.1513284-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
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
index 643f4c557ac2..ba6ed2a413f5 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -361,7 +361,7 @@ static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = gpio_set_irq_type;
 	ct->chip.irq_set_wake = gpio_set_wake_irq;
-	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND;
+	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND;
 	ct->regs.ack = GPIO_ISR;
 	ct->regs.mask = GPIO_IMR;
 
-- 
2.30.2

