Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47EC25243F
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 01:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHYXk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 19:40:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53304 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHYXkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 19:40:55 -0400
Date:   Tue, 25 Aug 2020 23:40:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598398852;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPofC/mNiI2Z9O9R2vvD27OIixjj0OZ26R+kQL5kuWI=;
        b=rZj8U1DjSc8cdX1izZjQhEAzjkOHXk29+Nu1mYo97v+/81JDhSyCr+/7PZUbn2Ehpze2Lb
        8xVVpusjr98Ee3TG7AQDm0VZa6Qly9uxxIEpqSLO5+F7UXe4zi/gof3VBJOUDzI28w0leG
        PqfSrnmFY7236eq0/CPYUzW7P37m+ARDR/JHwf11d9OmH6YYPml70cGPBo0Vy2tu4d791t
        vfJmPQIcdFJAD3KFPu6jAuJ3KtYryfJ9tBe4QtjKqUuqCsfNp9ojCQu2sL1ipD2cB/+kCw
        NDtzr2/w0AgcHX8G36EWAOH6N7t7Y+hCCvwZYPim8Ci6qosJ+S/kAbAL6e9iEA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598398852;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPofC/mNiI2Z9O9R2vvD27OIixjj0OZ26R+kQL5kuWI=;
        b=X6O3vuxykxKwrRkuHySdIbp38ur5hcehEjoEdqOWMaN0k6a35pbPzJc93CCRxM1K/LeXcL
        gBEFao74rfSO6kDA==
From:   "tip-bot2 for qiuguorui1" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] irqchip/stm32-exti: Avoid losing interrupts due to
 clearing pending bits by mistake
Cc:     qiuguorui1 <qiuguorui1@huawei.com>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v4.18+@tip-bot2.tec.linutronix.de, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200820031629.15582-1-qiuguorui1@huawei.com>
References: <20200820031629.15582-1-qiuguorui1@huawei.com>
MIME-Version: 1.0
Message-ID: <159839885185.389.17904618428201059406.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     e579076ac0a3bebb440fab101aef3c42c9f4c709
Gitweb:        https://git.kernel.org/tip/e579076ac0a3bebb440fab101aef3c42c9f4c709
Author:        qiuguorui1 <qiuguorui1@huawei.com>
AuthorDate:    Thu, 20 Aug 2020 11:16:29 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Tue, 25 Aug 2020 10:57:05 +01:00

irqchip/stm32-exti: Avoid losing interrupts due to clearing pending bits by mistake

In the current code, when the eoi callback of the exti clears the pending
bit of the current interrupt, it will first read the values of fpr and
rpr, then logically OR the corresponding bit of the interrupt number,
and finally write back to fpr and rpr.

We found through experiments that if two exti interrupts,
we call them int1/int2, arrive almost at the same time. in our scenario,
the time difference is 30 microseconds, assuming int1 is triggered first.

there will be an extreme scenario: both int's pending bit are set to 1,
the irq handle of int1 is executed first, and eoi handle is then executed,
at this moment, all pending bits are cleared, but the int 2 has not
finally been reported to the cpu yet, which eventually lost int2.

According to stm32's TRM description about rpr and fpr: Writing a 1 to this
bit will trigger a rising edge event on event x, Writing 0 has no
effect.

Therefore, when clearing the pending bit, we only need to clear the
pending bit of the irq.

Fixes: 927abfc4461e7 ("irqchip/stm32: Add stm32mp1 support with hierarchy domain")
Signed-off-by: qiuguorui1 <qiuguorui1@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # v4.18+
Link: https://lore.kernel.org/r/20200820031629.15582-1-qiuguorui1@huawei.com
---
 drivers/irqchip/irq-stm32-exti.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-stm32-exti.c b/drivers/irqchip/irq-stm32-exti.c
index 03a36be..0c2c61d 100644
--- a/drivers/irqchip/irq-stm32-exti.c
+++ b/drivers/irqchip/irq-stm32-exti.c
@@ -416,6 +416,16 @@ static void stm32_irq_ack(struct irq_data *d)
 	irq_gc_unlock(gc);
 }
 
+/* directly set the target bit without reading first. */
+static inline void stm32_exti_write_bit(struct irq_data *d, u32 reg)
+{
+	struct stm32_exti_chip_data *chip_data = irq_data_get_irq_chip_data(d);
+	void __iomem *base = chip_data->host_data->base;
+	u32 val = BIT(d->hwirq % IRQS_PER_BANK);
+
+	writel_relaxed(val, base + reg);
+}
+
 static inline u32 stm32_exti_set_bit(struct irq_data *d, u32 reg)
 {
 	struct stm32_exti_chip_data *chip_data = irq_data_get_irq_chip_data(d);
@@ -449,9 +459,9 @@ static void stm32_exti_h_eoi(struct irq_data *d)
 
 	raw_spin_lock(&chip_data->rlock);
 
-	stm32_exti_set_bit(d, stm32_bank->rpr_ofst);
+	stm32_exti_write_bit(d, stm32_bank->rpr_ofst);
 	if (stm32_bank->fpr_ofst != UNDEF_REG)
-		stm32_exti_set_bit(d, stm32_bank->fpr_ofst);
+		stm32_exti_write_bit(d, stm32_bank->fpr_ofst);
 
 	raw_spin_unlock(&chip_data->rlock);
 
