Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464443744F1
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhEERDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237121AbhEEQ5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF90D619A5;
        Wed,  5 May 2021 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232765;
        bh=diepQ4xIh+5/x+btqUtYJL380QapuwxQy0qfdc/3hc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvT7X6Icxk+LTDQvWtHp1Wl091VmhEM9JGzNTN0golsrJTEr/GZCG6RHVx8SnkR+4
         6UFoxSN8qgvnGBHEjY+qkgIRNNMKfhcnM1mmi86oX1fRjqEMH5jFZCDBIwRQs+sa/3
         nUn9depesSkEswprwpZZYYVSJzNZPdqxSt4eJvR8i+WB5uYKbMciE+vEbI8JC7RWgi
         yO3UTDK0TxIfFnGlIgsmamqiWolgkECqDopIwRifN3W4IX5ZkZ2Sl+jTLxd+DM4pJu
         CyDMgFEkcNjkXP1ph1rdVhwMbBMuaqKDazrN/TwEy411C8BJfBbLuEfnaxLfba7yfb
         hIwjAJjUo3sIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/46] pinctrl: samsung: use 'int' for register masks in Exynos
Date:   Wed,  5 May 2021 12:38:30 -0400
Message-Id: <20210505163856.3463279-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit fa0c10a5f3a49130dd11281aa27e7e1c8654abc7 ]

The Special Function Registers on all Exynos SoC, including ARM64, are
32-bit wide, so entire driver uses matching functions like readl() or
writel().  On 64-bit ARM using unsigned long for register masks:
1. makes little sense as immediately after bitwise operation it will be
   cast to 32-bit value when calling writel(),
2. is actually error-prone because it might promote other operands to
   64-bit.

Addresses-Coverity: Unintentional integer overflow
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Link: https://lore.kernel.org/r/20210408195029.69974-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 84501c785473..1cf31fe2674d 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -55,7 +55,7 @@ static void exynos_irq_mask(struct irq_data *irqd)
 	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
 	unsigned long reg_mask = our_chip->eint_mask + bank->eint_offset;
-	unsigned long mask;
+	unsigned int mask;
 	unsigned long flags;
 
 	spin_lock_irqsave(&bank->slock, flags);
@@ -83,7 +83,7 @@ static void exynos_irq_unmask(struct irq_data *irqd)
 	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
 	unsigned long reg_mask = our_chip->eint_mask + bank->eint_offset;
-	unsigned long mask;
+	unsigned int mask;
 	unsigned long flags;
 
 	/*
@@ -474,7 +474,7 @@ static void exynos_irq_eint0_15(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static inline void exynos_irq_demux_eint(unsigned long pend,
+static inline void exynos_irq_demux_eint(unsigned int pend,
 						struct irq_domain *domain)
 {
 	unsigned int irq;
@@ -491,8 +491,8 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct exynos_muxed_weint_data *eintd = irq_desc_get_handler_data(desc);
-	unsigned long pend;
-	unsigned long mask;
+	unsigned int pend;
+	unsigned int mask;
 	int i;
 
 	chained_irq_enter(chip, desc);
-- 
2.30.2

