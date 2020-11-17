Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2612B62DC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbgKQNcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732300AbgKQNcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019F2207BC;
        Tue, 17 Nov 2020 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619950;
        bh=AufjsZnaraoDT0A1wRYXrs5ZDK489E0BRZL79+EN+2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TasY/79g54GdTBDjjZtKEXnuGglRwX1FcpJYSYHzupMp1vCP/XoT/rBDQCz9GMVVz
         Ct3VRPFqk/MFclP/bNqE3J1WpCpGaiJBWd1WcXf9E1MZtG2ZgvRyx9r6E5rotf8XQo
         QFtZdUWUoylfe2vMOYsYwbAi7T4SzpITRNxzbZNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greentime Hu <greentime.hu@sifive.com>,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 028/255] irqchip/sifive-plic: Fix chip_data access within a hierarchy
Date:   Tue, 17 Nov 2020 14:02:48 +0100
Message-Id: <20201117122140.313789869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

[ Upstream commit f9ac7bbd6e4540dcc6df621b9c9b6eb2e26ded1d ]

The plic driver crashes in plic_irq_unmask() when the interrupt is within a
hierarchy, as it picks the top-level chip_data instead of its local one.

Using irq_data_get_irq_chip_data() instead of irq_get_chip_data() solves
the issue for good.

Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
[maz: rewrote commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Link: https://lore.kernel.org/r/20201029023738.127472-1-greentime.hu@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 4048657ece0ac..6f432d2a5cebd 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -99,7 +99,7 @@ static inline void plic_irq_toggle(const struct cpumask *mask,
 				   struct irq_data *d, int enable)
 {
 	int cpu;
-	struct plic_priv *priv = irq_get_chip_data(d->irq);
+	struct plic_priv *priv = irq_data_get_irq_chip_data(d);
 
 	writel(enable, priv->regs + PRIORITY_BASE + d->hwirq * PRIORITY_PER_ID);
 	for_each_cpu(cpu, mask) {
@@ -115,7 +115,7 @@ static void plic_irq_unmask(struct irq_data *d)
 {
 	struct cpumask amask;
 	unsigned int cpu;
-	struct plic_priv *priv = irq_get_chip_data(d->irq);
+	struct plic_priv *priv = irq_data_get_irq_chip_data(d);
 
 	cpumask_and(&amask, &priv->lmask, cpu_online_mask);
 	cpu = cpumask_any_and(irq_data_get_affinity_mask(d),
@@ -127,7 +127,7 @@ static void plic_irq_unmask(struct irq_data *d)
 
 static void plic_irq_mask(struct irq_data *d)
 {
-	struct plic_priv *priv = irq_get_chip_data(d->irq);
+	struct plic_priv *priv = irq_data_get_irq_chip_data(d);
 
 	plic_irq_toggle(&priv->lmask, d, 0);
 }
@@ -138,7 +138,7 @@ static int plic_set_affinity(struct irq_data *d,
 {
 	unsigned int cpu;
 	struct cpumask amask;
-	struct plic_priv *priv = irq_get_chip_data(d->irq);
+	struct plic_priv *priv = irq_data_get_irq_chip_data(d);
 
 	cpumask_and(&amask, &priv->lmask, mask_val);
 
-- 
2.27.0



