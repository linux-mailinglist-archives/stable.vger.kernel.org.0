Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A92D3BBBC0
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhGELCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhGELCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0A561452;
        Mon,  5 Jul 2021 10:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482779;
        bh=YKmwurZwGMWzcmhMkRf94jfggcgdhpnkZCsw9DLpBAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHp/WHSeHzjKXDiQu9hmUkapG0lolQ6gigRHymVcPLgOSSr13Eis2Tm0ZzJw9e0xS
         qR3v5TZJHuYuYOAvB0wGR8NUN1EhQIVASwZscU6amOzQJp7sbXXUhZcBywJ/XZMiYh
         lZaHEUJYLbSdcCre9RDwZSxXWvivC7JkisGJgrFj1gUyUTBAtiqk8Bri5qe+LY/UjZ
         jozF8jDCvgq6ObRMuCQnnFzqxKbIS7YVgDkGyPXHilD5A8XfOwYDfMHNwMvNAnKaFH
         9jtI64orKaVRBmQfjP5RCFzP3jDWqjykLaTKARa72oZHLd3juLKhnVIIZoQocq+45Y
         K1d4I+8/opO9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Michal Koziel <michal.koziel@emlogic.no>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 3/7] gpio: mxc: Fix disabled interrupt wake-up support
Date:   Mon,  5 Jul 2021 06:59:30 -0400
Message-Id: <20210705105934.1513188-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
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

