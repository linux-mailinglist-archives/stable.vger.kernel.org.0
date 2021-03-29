Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B027334C72A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhC2INI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhC2ILl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581AC61494;
        Mon, 29 Mar 2021 08:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005500;
        bh=IrGIXmQxI09MYQmttRJ9qPN1HtP2WUP1gbuUnWj39mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOVNkDJ7J33AXfSUErCMbdeC/yIHizWc42sJJt3qVFsWg8ZDyB0NKYAZMs1VC+90b
         71Y4BmbchUMBl6ChDJajJdyp1++oSPYk9WDKnk/ehSRtI7+Q7SUFT2iuX9FC0TvAG8
         kIfCTCQp6xmFGZ2HVl+zaGtKj5L95JLTgXqo6Kts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/111] irqchip/ingenic: Add support for the JZ4760
Date:   Mon, 29 Mar 2021 09:57:32 +0200
Message-Id: <20210329075615.988295818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6d05cefe9d79..02a82723a57a 100644
--- a/drivers/irqchip/irq-ingenic-tcu.c
+++ b/drivers/irqchip/irq-ingenic-tcu.c
@@ -179,4 +179,5 @@ static int __init ingenic_tcu_irq_init(struct device_node *np,
 }
 IRQCHIP_DECLARE(jz4740_tcu_irq, "ingenic,jz4740-tcu", ingenic_tcu_irq_init);
 IRQCHIP_DECLARE(jz4725b_tcu_irq, "ingenic,jz4725b-tcu", ingenic_tcu_irq_init);
+IRQCHIP_DECLARE(jz4760_tcu_irq, "ingenic,jz4760-tcu", ingenic_tcu_irq_init);
 IRQCHIP_DECLARE(jz4770_tcu_irq, "ingenic,jz4770-tcu", ingenic_tcu_irq_init);
diff --git a/drivers/irqchip/irq-ingenic.c b/drivers/irqchip/irq-ingenic.c
index dda512dfe2c1..31bc11f15bfa 100644
--- a/drivers/irqchip/irq-ingenic.c
+++ b/drivers/irqchip/irq-ingenic.c
@@ -168,6 +168,7 @@ static int __init intc_2chip_of_init(struct device_node *node,
 {
 	return ingenic_intc_of_init(node, 2);
 }
+IRQCHIP_DECLARE(jz4760_intc, "ingenic,jz4760-intc", intc_2chip_of_init);
 IRQCHIP_DECLARE(jz4770_intc, "ingenic,jz4770-intc", intc_2chip_of_init);
 IRQCHIP_DECLARE(jz4775_intc, "ingenic,jz4775-intc", intc_2chip_of_init);
 IRQCHIP_DECLARE(jz4780_intc, "ingenic,jz4780-intc", intc_2chip_of_init);
-- 
2.30.1



