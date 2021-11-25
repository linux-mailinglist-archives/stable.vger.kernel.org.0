Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBCC45DF78
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242265AbhKYRUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242351AbhKYRSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:18:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7240DC0617A0;
        Thu, 25 Nov 2021 09:03:45 -0800 (PST)
Date:   Thu, 25 Nov 2021 17:03:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637859821;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VgVeMn/tzStW43DWFETQfEosJYLh/LxhQ7mM4eGm/k=;
        b=tPIhetP8li86pl5bSf3OR33yHFFky4z0TeNaqep11Fp5OUpSnRsUqd6z5CGEh28zv1wKCM
        feoVA5OZUfGuwUeO8xyfvVyQtdN2/LjnA2IVyo+XK3fdthWi4l2eB2zc5gqL4w8Sj7lUsC
        oitLm4J/d23wthqHUgYgE5fQYXXyfeg3hRYhc0XcVkBQtPIjgkMB0aUlR5G0XLSEM5IJRm
        6cbVCa2OrsoSzJTjc/+PVEYtn70GpnRyJKmLv5vZCDvt05sYze/11rq3/ybw0AXqB3Z8Dy
        qu57dpOggLYJ1jtcKgO9SlHOcnHtvDnRzmYlUoHukcfIpfjiXaMreaM25eHz7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637859821;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VgVeMn/tzStW43DWFETQfEosJYLh/LxhQ7mM4eGm/k=;
        b=dWoyvyUZnjZC/m6g6/mq7DCZRJld56Kx6TSXGWfCH3f3W6NIgdOXkKvdQmZds/T/bqfKm+
        BQhwIdNl+0iuraCQ==
From:   "irqchip-bot for Billy Tsai" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-fixes] irqchip/aspeed-scu: Replace update_bits
 with write_bits.
Cc:     Billy Tsai <billy_tsai@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20211124094348.11621-1-billy_tsai@aspeedtech.com>
References: <20211124094348.11621-1-billy_tsai@aspeedtech.com>
MIME-Version: 1.0
Message-ID: <163785982037.11128.2338335240854330231.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-fixes branch of irqchip:

Commit-ID:     8958389681b929fcc7301e7dc5f0da12e4a256a0
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/8958389681b929fcc7301e7dc5f0da12e4a256a0
Author:        Billy Tsai <billy_tsai@aspeedtech.com>
AuthorDate:    Wed, 24 Nov 2021 17:43:48 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Thu, 25 Nov 2021 16:50:44 

irqchip/aspeed-scu: Replace update_bits with write_bits.

The interrupt status bits are cleared by writing 1, we should force a
write to clear the interrupt without checking if the value has changed.

Fixes: 04f605906ff0 ("irqchip: Add Aspeed SCU interrupt controller")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211124094348.11621-1-billy_tsai@aspeedtech.com
Cc: stable@vger.kernel.org
---
 drivers/irqchip/irq-aspeed-scu-ic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-aspeed-scu-ic.c b/drivers/irqchip/irq-aspeed-scu-ic.c
index f3c6855..18b77c3 100644
--- a/drivers/irqchip/irq-aspeed-scu-ic.c
+++ b/drivers/irqchip/irq-aspeed-scu-ic.c
@@ -76,8 +76,8 @@ static void aspeed_scu_ic_irq_handler(struct irq_desc *desc)
 		generic_handle_domain_irq(scu_ic->irq_domain,
 					  bit - scu_ic->irq_shift);
 
-		regmap_update_bits(scu_ic->scu, scu_ic->reg, mask,
-				   BIT(bit + ASPEED_SCU_IC_STATUS_SHIFT));
+		regmap_write_bits(scu_ic->scu, scu_ic->reg, mask,
+				  BIT(bit + ASPEED_SCU_IC_STATUS_SHIFT));
 	}
 
 	chained_irq_exit(chip, desc);
