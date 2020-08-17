Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A07624696A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgHQPVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHQPVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:21:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5580D20709;
        Mon, 17 Aug 2020 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677697;
        bh=aKTOyl9duLwPf7+O5+vQT/Ns1nC3HmsArkT1Gs9u4B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpOpBGS3CttHURQmFYvAT7iEKTj8ZFtl/0Q/HYMVxTcim9L2tIIXYt1uA4w9Rx001
         oh56mqe7Egcoa7Rnxw1XXFzWcFDqkArjQsLCc5DnpWf5jUonJ+GUhMr6Nbvb84M5Ns
         AfI89bWO3qtqjQxZSBuTqqwtuv6MASyVo/0AU1gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Marc Zyngier <maz@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 075/464] irqchip/loongson-pch-pic: Fix the misused irq flow handler
Date:   Mon, 17 Aug 2020 17:10:28 +0200
Message-Id: <20200817143837.367100750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit ac62460c24126eb2442e3653a266ebbf05b004d8 ]

Loongson PCH PIC is a standard level triggered PIC, and it need to clear
interrupt during unmask.

Fixes: ef8c01eb64ca6719da449dab0 ("irqchip: Add Loongson PCH PIC controller")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Link: https://lore.kernel.org/r/1596099090-23516-6-git-send-email-chenhc@lemote.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 016f32c4cbe18..9bf6b9a5f7348 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -64,15 +64,6 @@ static void pch_pic_bitclr(struct pch_pic *priv, int offset, int bit)
 	raw_spin_unlock(&priv->pic_lock);
 }
 
-static void pch_pic_eoi_irq(struct irq_data *d)
-{
-	u32 idx = PIC_REG_IDX(d->hwirq);
-	struct pch_pic *priv = irq_data_get_irq_chip_data(d);
-
-	writel(BIT(PIC_REG_BIT(d->hwirq)),
-			priv->base + PCH_PIC_CLR + idx * 4);
-}
-
 static void pch_pic_mask_irq(struct irq_data *d)
 {
 	struct pch_pic *priv = irq_data_get_irq_chip_data(d);
@@ -85,6 +76,9 @@ static void pch_pic_unmask_irq(struct irq_data *d)
 {
 	struct pch_pic *priv = irq_data_get_irq_chip_data(d);
 
+	writel(BIT(PIC_REG_BIT(d->hwirq)),
+			priv->base + PCH_PIC_CLR + PIC_REG_IDX(d->hwirq) * 4);
+
 	irq_chip_unmask_parent(d);
 	pch_pic_bitclr(priv, PCH_PIC_MASK, d->hwirq);
 }
@@ -124,7 +118,6 @@ static struct irq_chip pch_pic_irq_chip = {
 	.irq_mask		= pch_pic_mask_irq,
 	.irq_unmask		= pch_pic_unmask_irq,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_eoi		= pch_pic_eoi_irq,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
 	.irq_set_type		= pch_pic_set_type,
 };
@@ -153,7 +146,7 @@ static int pch_pic_alloc(struct irq_domain *domain, unsigned int virq,
 
 	irq_domain_set_info(domain, virq, hwirq,
 			    &pch_pic_irq_chip, priv,
-			    handle_fasteoi_ack_irq, NULL, NULL);
+			    handle_level_irq, NULL, NULL);
 	irq_set_probe(virq);
 
 	return 0;
-- 
2.25.1



