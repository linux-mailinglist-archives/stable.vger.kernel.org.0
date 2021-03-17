Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390C533E36F
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhCQA4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhCQA4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D32E64F8F;
        Wed, 17 Mar 2021 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942573;
        bh=06AdV+JkCI79bqE8VrXjJjhz6t24lXG9Wq7P9wAxE/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCv43EQmKr1jhTeTNFcS23zvmdyUFpUlBi+Va2x097SZYsh2SGWWe66j8gA28lWUt
         2QrzwlNm1aPrHos20+uBR9g8zPtVZVPGaX5n8EB0TXv4IG9UsxK+FV/mNUWfDBhORD
         n3VILbSRgtqH56xabMqltlBPwA7jwMYAPi7q6dYH8Ka+tQOVTk4+eWkTW7vgqb4HGG
         NbGIqT3Gm6YqmFzm0yazdlVqS6J0pdUdNGfzz+x4ZvdyCbw35M3eu+wZOmKRHDszwO
         mdKlxWAJNIUpS9V5TB01esWTRHlHTtWkaaynp9sfNfifYB+mf2CTiaj2kghzb7a7DN
         0xOCbMJRbovgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 30/61] irqchip/ingenic: Add support for the JZ4760
Date:   Tue, 16 Mar 2021 20:55:04 -0400
Message-Id: <20210317005536.724046-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 5fbecd2389f48e1415799c63130d0cdce1cf3f60 ]

Add support for the interrupt controller found in the JZ4760 SoC, which
works exactly like the one in the JZ4770.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210307172014.73481-2-paul@crapouillou.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ingenic-tcu.c | 1 +
 drivers/irqchip/irq-ingenic.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-ingenic-tcu.c b/drivers/irqchip/irq-ingenic-tcu.c
index 7a7222d4c19c..b938d1d04d96 100644
--- a/drivers/irqchip/irq-ingenic-tcu.c
+++ b/drivers/irqchip/irq-ingenic-tcu.c
@@ -179,5 +179,6 @@ static int __init ingenic_tcu_irq_init(struct device_node *np,
 }
 IRQCHIP_DECLARE(jz4740_tcu_irq, "ingenic,jz4740-tcu", ingenic_tcu_irq_init);
 IRQCHIP_DECLARE(jz4725b_tcu_irq, "ingenic,jz4725b-tcu", ingenic_tcu_irq_init);
+IRQCHIP_DECLARE(jz4760_tcu_irq, "ingenic,jz4760-tcu", ingenic_tcu_irq_init);
 IRQCHIP_DECLARE(jz4770_tcu_irq, "ingenic,jz4770-tcu", ingenic_tcu_irq_init);
 IRQCHIP_DECLARE(x1000_tcu_irq, "ingenic,x1000-tcu", ingenic_tcu_irq_init);
diff --git a/drivers/irqchip/irq-ingenic.c b/drivers/irqchip/irq-ingenic.c
index b61a8901ef72..ea36bb00be80 100644
--- a/drivers/irqchip/irq-ingenic.c
+++ b/drivers/irqchip/irq-ingenic.c
@@ -155,6 +155,7 @@ static int __init intc_2chip_of_init(struct device_node *node,
 {
 	return ingenic_intc_of_init(node, 2);
 }
+IRQCHIP_DECLARE(jz4760_intc, "ingenic,jz4760-intc", intc_2chip_of_init);
 IRQCHIP_DECLARE(jz4770_intc, "ingenic,jz4770-intc", intc_2chip_of_init);
 IRQCHIP_DECLARE(jz4775_intc, "ingenic,jz4775-intc", intc_2chip_of_init);
 IRQCHIP_DECLARE(jz4780_intc, "ingenic,jz4780-intc", intc_2chip_of_init);
-- 
2.30.1

