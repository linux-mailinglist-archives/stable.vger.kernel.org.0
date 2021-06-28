Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0023B6A40
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhF1VXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237928AbhF1VX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C9361CF1;
        Mon, 28 Jun 2021 21:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915262;
        bh=EJQaKN59+x9KgDJMx8M091LYcYzwiV6zoqt125gDOjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byn9cMmhwbaxb5LUjHgxJWLPKS+ql4cfz/EY2mvAjuc7zcbbZv0qrN3CFphjSjepp
         Dozq3kO75rfahId37cwwJep85uvv9ZFL/1vYPKE28P8IAoIhrhv/FuSld7B5kFMj11
         YvW0M4Uvr5T7xGJZl0S1lFpUi0Xpln360+sXzLmdQYvuAddikq6LjP7pERSdx6+d99
         BTfjqGfdDXKLHVTeC6hs5cFsN1qmbZcf5dswenTwjnoZ8U35RovfB1gIH2vutyge01
         K2oEOPxH1kBuROQjzO/59GnBzEhw/CONe+q+Pu3lwGrs/MEhMBTsiZi2fEuEXDqt8R
         hf4sdKsIhlNiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Michal Koziel <michal.koziel@emlogic.no>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/4] gpio: mxc: Fix disabled interrupt wake-up support
Date:   Mon, 28 Jun 2021 17:20:56 -0400
Message-Id: <20210628212059.43361-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212059.43361-1-sashal@kernel.org>
References: <20210628212059.43361-1-sashal@kernel.org>
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

