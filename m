Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2474093A9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345628AbhIMO0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346422AbhIMOY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21DA861B44;
        Mon, 13 Sep 2021 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540897;
        bh=xG7jdbEVTdgikYe/GCHx0LOQi5SCpyDAYXBYer+y2NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=129y7urqUdKgfKaW+XWUKHyip1Y654bKTC1+9nhN6zM+0NspYHP+zRpoChzrSTwwP
         YCt7bvFkOVjTFpuirD4UvjhLnkT7q137mpBlA3LB4++Jan0XoyipP+Ep0Zm2xG3JLM
         MKGLhbfLLIMsLe/U7/9qllGeneIumtAH1KJ8KHGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhu <zhuchen@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 062/334] irqchip/loongson-pch-pic: Improve edge triggered interrupt support
Date:   Mon, 13 Sep 2021 15:11:56 +0200
Message-Id: <20210913131115.511564255@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit e5dec38ac5d05d17a7110c8045aa101015281e4d ]

Edge-triggered mode and level-triggered mode need different handlers,
and edge-triggered mode need a specific ack operation. So improve it.

Fixes: ef8c01eb64ca6719da449dab0 ("irqchip: Add Loongson PCH PIC controller")
Signed-off-by: Chen Zhu <zhuchen@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210805132216.3539007-1-chenhuacai@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index f790ca6d78aa..a4eb8a2181c7 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -92,18 +92,22 @@ static int pch_pic_set_type(struct irq_data *d, unsigned int type)
 	case IRQ_TYPE_EDGE_RISING:
 		pch_pic_bitset(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitclr(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		pch_pic_bitset(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitset(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 		pch_pic_bitclr(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitclr(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_level_irq);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		pch_pic_bitclr(priv, PCH_PIC_EDGE, d->hwirq);
 		pch_pic_bitset(priv, PCH_PIC_POL, d->hwirq);
+		irq_set_handler_locked(d, handle_level_irq);
 		break;
 	default:
 		ret = -EINVAL;
@@ -113,11 +117,24 @@ static int pch_pic_set_type(struct irq_data *d, unsigned int type)
 	return ret;
 }
 
+static void pch_pic_ack_irq(struct irq_data *d)
+{
+	unsigned int reg;
+	struct pch_pic *priv = irq_data_get_irq_chip_data(d);
+
+	reg = readl(priv->base + PCH_PIC_EDGE + PIC_REG_IDX(d->hwirq) * 4);
+	if (reg & BIT(PIC_REG_BIT(d->hwirq))) {
+		writel(BIT(PIC_REG_BIT(d->hwirq)),
+			priv->base + PCH_PIC_CLR + PIC_REG_IDX(d->hwirq) * 4);
+	}
+	irq_chip_ack_parent(d);
+}
+
 static struct irq_chip pch_pic_irq_chip = {
 	.name			= "PCH PIC",
 	.irq_mask		= pch_pic_mask_irq,
 	.irq_unmask		= pch_pic_unmask_irq,
-	.irq_ack		= irq_chip_ack_parent,
+	.irq_ack		= pch_pic_ack_irq,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
 	.irq_set_type		= pch_pic_set_type,
 };
-- 
2.30.2



