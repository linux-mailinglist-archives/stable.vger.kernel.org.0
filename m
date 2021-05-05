Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC054374125
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhEEQgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhEEQeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8454461432;
        Wed,  5 May 2021 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232359;
        bh=B+EMqvSUBUldqZ6ClL7veoudJmVUUSPY1yhJymXxLwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ci+VNHpbMLyOjkOt+WN3mkr/R0g2c2j/crp9bQP62qH2dsfu/bhMItFH/rHU2Nk2P
         A20xhFMuQW1h65AqNjKD2/nyDWmOp1u7azsw/orLHpKYzydQ6p58ExURfalj8QLNG1
         Ah3eWeqbN03e20e0A8i8mYWehujz/7mY2+vKapmtCYP3F4fw5tHmUs9n3yGImvVs2L
         CNntwrKvr83HYoO5lmZr3j4XqMQIGthAZGRR0bCWVvGSKNAKJLDZwegg43tKrlc+/R
         dRj2RzXgnUzkSlE7rFIn2Pgy7GxqmcRbiILBzEMETgLYvUHG7R+2FzUidTk/yThN9E
         4QUXSzJ0pcq3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 054/116] pinctrl: samsung: use 'int' for register masks in Exynos
Date:   Wed,  5 May 2021 12:30:22 -0400
Message-Id: <20210505163125.3460440-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 0cd7f33cdf25..2b99f4130e1e 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -55,7 +55,7 @@ static void exynos_irq_mask(struct irq_data *irqd)
 	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
 	unsigned long reg_mask = our_chip->eint_mask + bank->eint_offset;
-	unsigned long mask;
+	unsigned int mask;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&bank->slock, flags);
@@ -83,7 +83,7 @@ static void exynos_irq_unmask(struct irq_data *irqd)
 	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
 	unsigned long reg_mask = our_chip->eint_mask + bank->eint_offset;
-	unsigned long mask;
+	unsigned int mask;
 	unsigned long flags;
 
 	/*
@@ -483,7 +483,7 @@ static void exynos_irq_eint0_15(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static inline void exynos_irq_demux_eint(unsigned long pend,
+static inline void exynos_irq_demux_eint(unsigned int pend,
 						struct irq_domain *domain)
 {
 	unsigned int irq;
@@ -500,8 +500,8 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
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

