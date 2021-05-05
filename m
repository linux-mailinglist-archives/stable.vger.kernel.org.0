Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D12374534
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhEEREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237779AbhEERBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCBE619D2;
        Wed,  5 May 2021 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232831;
        bh=lRWOFZZdFcXJHZioD0M718stWo9ko2E+ZUUFumUjtZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4C+LINtdAXkKKxHNdw3Il+3KURqtSUWv99oXkZZIHnaRc8JmACEjJixvUveVVL7F
         161kzzSCOMrrOujR2iRTTiPPMxyfmk4r9jsAkI+K2lFKklEit5wIAn4OiyMup0rFNo
         0GkJGOZm6iSDvVR3LDc8tLyd/VGDl5BKYIzlkvzAT8ueZh1wqXj+uflwHBkWXDOss+
         pqQr1j/wyRwO8JAhOB1afXZIi8V/qU8pKZ6RARkcvUnry5sxGauFOlTeKJ2bLjkBiP
         w3DM46mlZ4XAgY9VCnBA0ugaSvv5Ztbo4cMSfRXVNQRSo8HAgcs/8eJpSeJN8HzF+P
         TaFZrgsLGuNEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/32] pinctrl: samsung: use 'int' for register masks in Exynos
Date:   Wed,  5 May 2021 12:39:50 -0400
Message-Id: <20210505164004.3463707-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index 24956f6c6324..7f764f751c4f 100644
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
@@ -482,7 +482,7 @@ static void exynos_irq_eint0_15(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static inline void exynos_irq_demux_eint(unsigned long pend,
+static inline void exynos_irq_demux_eint(unsigned int pend,
 						struct irq_domain *domain)
 {
 	unsigned int irq;
@@ -499,8 +499,8 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
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

