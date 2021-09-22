Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FC414A86
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 15:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhIVN3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 09:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhIVN3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 09:29:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E720BC061574;
        Wed, 22 Sep 2021 06:27:33 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:27:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632317252;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpRgqMivdHLlYEWE2+g1ZVlcHk1NH8+G53qNLEtX2Hk=;
        b=M5eOx1wPlrkyTlHSBat8g768p0+6vZe9kaySnzEx8hxuga9nFxhrvZWqcmp6k9jGXjpe9E
        3oJNqKY+yJTb4PsqVVwzaZFeekwPwtBskJkYcwfLZ/2RIktGKHb532zU84YpTqJezvuc1f
        d3qXLxZrnmJ5Na2BvF2yd0ixVsqd5vhjsUL3Vv0vrgts7ObgsGbOwHuqzRH95vAmBzbGA9
        VXj+i/Z8iH8kkiW2HQI/R8CJAJw+LMsehZLR5wZpYkV5uFCTXD4oUlAif7qM2xxIdlbzCz
        lkuHXu0ghRH9LAffix3xE8MdPHz+oM29JmAYiueYJAzSD4apZgU8HgrTw89DUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632317252;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpRgqMivdHLlYEWE2+g1ZVlcHk1NH8+G53qNLEtX2Hk=;
        b=5VB97t4iM4EOx3pXpd/bJrRvGB2yxB5Yl7LhSK7KFuYnLofjtpteaxSszMMnbtPEG1YwBZ
        dtDd36ZNCBQgvJCQ==
From:   "irqchip-bot for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-fixes] irqchip/armada-370-xp: Fix ack/eoi breakage
Cc:     Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        stable@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <87tuiexq5f.fsf@pengutronix.de>
References: <87tuiexq5f.fsf@pengutronix.de>
MIME-Version: 1.0
Message-ID: <163231725142.25758.2149176208397573828.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-fixes branch of irqchip:

Commit-ID:     2a7313dc81e88adc7bb09d0f056985fa8afc2b89
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/2a7313dc81e88adc7bb09d0f056985fa8afc2b89
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Wed, 22 Sep 2021 14:19:41 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Wed, 22 Sep 2021 14:24:49 +01:00

irqchip/armada-370-xp: Fix ack/eoi breakage

When converting the driver to using handle_percpu_devid_irq,
we forgot to repaint the irq_eoi() callback into irq_ack(),
as handle_percpu_devid_fasteoi_ipi() was actually using EOI
really early in the handling. Yes this was a stupid idea.

Fix this by using the HW ack method as irq_ack().

Fixes: e52e73b7e9f7 ("irqchip/armada-370-xp: Make IPIs use handle_percpu_devid_irq()")
Reported-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Tested-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87tuiexq5f.fsf@pengutronix.de
---
 drivers/irqchip/irq-armada-370-xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 7557ab5..53e0fb0 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -359,16 +359,16 @@ static void armada_370_xp_ipi_send_mask(struct irq_data *d,
 		ARMADA_370_XP_SW_TRIG_INT_OFFS);
 }
 
-static void armada_370_xp_ipi_eoi(struct irq_data *d)
+static void armada_370_xp_ipi_ack(struct irq_data *d)
 {
 	writel(~BIT(d->hwirq), per_cpu_int_base + ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 }
 
 static struct irq_chip ipi_irqchip = {
 	.name		= "IPI",
+	.irq_ack	= armada_370_xp_ipi_ack,
 	.irq_mask	= armada_370_xp_ipi_mask,
 	.irq_unmask	= armada_370_xp_ipi_unmask,
-	.irq_eoi	= armada_370_xp_ipi_eoi,
 	.ipi_send_mask	= armada_370_xp_ipi_send_mask,
 };
 
