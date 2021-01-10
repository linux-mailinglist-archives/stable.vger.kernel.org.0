Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035922F0673
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 11:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbhAJKaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 05:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbhAJKaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 05:30:08 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACFBC061786;
        Sun, 10 Jan 2021 02:29:28 -0800 (PST)
Date:   Sun, 10 Jan 2021 10:29:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610274564;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJQwAz4yGauhyMhrutcMS61zHMr6Sabzfpt4nuGb92w=;
        b=Kg+LZXTINDXiQCSW61SayPC+8qdrnrIEyhhHx6Sq9lvQ//sabBCG0DEoJjPbfoa2DvB3oy
        VGBnAS0EnkONgHTx5iLgtPxQozvLMzuhbxCmlzdH+x+AMnWSpM1BFkZoHvqZaeLhhCnTKz
        aeholSGx65+YzkN52unXQfLKgLj8CcFOV0dxM5VlIY+l8DQW5UaDMGcZl0pF52LUDB/F55
        Eh6buWRNn+cBSONpihf0jBIipLPER+Ytd/Fv2JbC0YIGoitHMGGmkZIDZ/XeEwhKNXTdob
        ucc4kurmENHh5JH2lOH8AaG+hw1IVyYbbMWubRUxnn2/PmqP/uqOU8Oi1dIYTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610274564;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJQwAz4yGauhyMhrutcMS61zHMr6Sabzfpt4nuGb92w=;
        b=YXEvQObSSXyegjgp6kltNp1vaATBuYc6ZxJqVJrzFA2MmISzrZHKq6mCmsbGYn/YEx4U+4
        OOEfY77/XUpPQnCA==
From:   "irqchip-bot for Mathias Kresin" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/mips-cpu: Set IPI domain parent chip
Cc:     <stable@vger.kernel.org>, Mathias Kresin <dev@kresin.me>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20210107213603.1637781-1-dev@kresin.me>
References: <20210107213603.1637781-1-dev@kresin.me>
MIME-Version: 1.0
Message-ID: <161027456251.414.3026056291168643147.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam: Yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     599b3063adf4bf041a87a69244ee36aded0d878f
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/599b3063adf4bf041a87a69244ee36aded0d878f
Author:        Mathias Kresin <dev@kresin.me>
AuthorDate:    Thu, 07 Jan 2021 22:36:03 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sun, 10 Jan 2021 10:20:24 

irqchip/mips-cpu: Set IPI domain parent chip

Since commit 55567976629e ("genirq/irqdomain: Allow partial trimming of
irq_data hierarchy") the irq_data chain is valided.

The irq_domain_trim_hierarchy() function doesn't consider the irq + ipi
domain hierarchy as valid, since the ipi domain has the irq domain set
as parent, but the parent domain has no chip set. Hence the boot ends in
a kernel panic.

Set the chip for the parent domain as it is done in the mips gic irq
driver, to have a valid irq_data chain.

Fixes: 3838a547fda2 ("irqchip: mips-cpu: Introduce IPI IRQ domain support")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210107213603.1637781-1-dev@kresin.me
---
 drivers/irqchip/irq-mips-cpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/irqchip/irq-mips-cpu.c b/drivers/irqchip/irq-mips-cpu.c
index 95d4fd8..0bbb0b2 100644
--- a/drivers/irqchip/irq-mips-cpu.c
+++ b/drivers/irqchip/irq-mips-cpu.c
@@ -197,6 +197,13 @@ static int mips_cpu_ipi_alloc(struct irq_domain *domain, unsigned int virq,
 		if (ret)
 			return ret;
 
+		ret = irq_domain_set_hwirq_and_chip(domain->parent, virq + i, hwirq,
+						    &mips_mt_cpu_irq_controller,
+						    NULL);
+
+		if (ret)
+			return ret;
+
 		ret = irq_set_irq_type(virq + i, IRQ_TYPE_LEVEL_HIGH);
 		if (ret)
 			return ret;
