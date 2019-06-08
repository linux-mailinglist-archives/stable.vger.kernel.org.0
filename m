Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF96839F43
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFHLkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfFHLkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A1FA214DA;
        Sat,  8 Jun 2019 11:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994000;
        bh=XNPzqCkMa/JAr9kd8x/BUx/perXm0amxEIG1SLZiqR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKmOGbXpWmOGInuFvsUHT28WtKeNPE2Q1VLjmTGr7M/YHOVg2Uxp38+7e2pvww0IX
         te7miSeQqLWPO8Ruz6JWYBmCuXZGf10lOelhNCHFdmlyRfss9O1DGwdxndUBPo5mKs
         rMDLOOcqvhvsu3Kvwg5wBJUWBF2lNav8pdY5axng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 08/70] pinctrl: intel: Clear interrupt status in mask/unmask callback
Date:   Sat,  8 Jun 2019 07:38:47 -0400
Message-Id: <20190608113950.8033-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 670784fb4ebe54434e263837390e358405031d9e ]

Commit a939bb57cd47 ("pinctrl: intel: implement gpio_irq_enable") was
added because clearing interrupt status bit is required to avoid
unexpected behavior.

Turns out the unmask callback also needs the fix, which can solve weird
IRQ triggering issues on I2C touchpad ELAN1200.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 37 +++++----------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 3b1818184207..717148d2818c 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -913,35 +913,6 @@ static void intel_gpio_irq_ack(struct irq_data *d)
 	}
 }
 
-static void intel_gpio_irq_enable(struct irq_data *d)
-{
-	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
-	struct intel_pinctrl *pctrl = gpiochip_get_data(gc);
-	const struct intel_community *community;
-	const struct intel_padgroup *padgrp;
-	int pin;
-
-	pin = intel_gpio_to_pin(pctrl, irqd_to_hwirq(d), &community, &padgrp);
-	if (pin >= 0) {
-		unsigned int gpp, gpp_offset, is_offset;
-		unsigned long flags;
-		u32 value;
-
-		gpp = padgrp->reg_num;
-		gpp_offset = padgroup_offset(padgrp, pin);
-		is_offset = community->is_offset + gpp * 4;
-
-		raw_spin_lock_irqsave(&pctrl->lock, flags);
-		/* Clear interrupt status first to avoid unexpected interrupt */
-		writel(BIT(gpp_offset), community->regs + is_offset);
-
-		value = readl(community->regs + community->ie_offset + gpp * 4);
-		value |= BIT(gpp_offset);
-		writel(value, community->regs + community->ie_offset + gpp * 4);
-		raw_spin_unlock_irqrestore(&pctrl->lock, flags);
-	}
-}
-
 static void intel_gpio_irq_mask_unmask(struct irq_data *d, bool mask)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -954,15 +925,20 @@ static void intel_gpio_irq_mask_unmask(struct irq_data *d, bool mask)
 	if (pin >= 0) {
 		unsigned int gpp, gpp_offset;
 		unsigned long flags;
-		void __iomem *reg;
+		void __iomem *reg, *is;
 		u32 value;
 
 		gpp = padgrp->reg_num;
 		gpp_offset = padgroup_offset(padgrp, pin);
 
 		reg = community->regs + community->ie_offset + gpp * 4;
+		is = community->regs + community->is_offset + gpp * 4;
 
 		raw_spin_lock_irqsave(&pctrl->lock, flags);
+
+		/* Clear interrupt status first to avoid unexpected interrupt */
+		writel(BIT(gpp_offset), is);
+
 		value = readl(reg);
 		if (mask)
 			value &= ~BIT(gpp_offset);
@@ -1106,7 +1082,6 @@ static irqreturn_t intel_gpio_irq(int irq, void *data)
 
 static struct irq_chip intel_gpio_irqchip = {
 	.name = "intel-gpio",
-	.irq_enable = intel_gpio_irq_enable,
 	.irq_ack = intel_gpio_irq_ack,
 	.irq_mask = intel_gpio_irq_mask,
 	.irq_unmask = intel_gpio_irq_unmask,
-- 
2.20.1

