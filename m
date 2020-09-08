Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15301261EFF
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgIHT57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730554AbgIHPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E8E22574;
        Tue,  8 Sep 2020 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579311;
        bh=x2ZL+9z3yoSFuBrSRbMbhuMdewZjuNnz87joNEjtnKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEwdlOp55irkDpVXzVxRSBrLbgdBgxtEY2TnGjziiXcOIogy2Y8McUN1E9pOFT+XN
         Td7DMctcsmesQ6v7HoKKpD88DqO6E8fRi/3FnaqCyTvEV80zC0F7G0VguGHmfk5nMi
         XVMuzfjlP6Cd4elazCP284ltH0CoEKga3lBBBaa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 025/186] irqchip/ingenic: Leave parent IRQ unmasked on suspend
Date:   Tue,  8 Sep 2020 17:22:47 +0200
Message-Id: <20200908152242.875259657@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 821fc9e261f3af235752f46e59084467cfd440c4 ]

All the wakeup sources we possibly want will go through the interrupt
controller, so the parent IRQ must not be masked during suspend, or
there won't be any way to wake up the system.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200819180602.136969-1-paul@crapouillou.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ingenic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-ingenic.c b/drivers/irqchip/irq-ingenic.c
index 9f3da4260ca65..b61a8901ef722 100644
--- a/drivers/irqchip/irq-ingenic.c
+++ b/drivers/irqchip/irq-ingenic.c
@@ -125,7 +125,7 @@ static int __init ingenic_intc_of_init(struct device_node *node,
 		irq_reg_writel(gc, IRQ_MSK(32), JZ_REG_INTC_SET_MASK);
 	}
 
-	if (request_irq(parent_irq, intc_cascade, 0,
+	if (request_irq(parent_irq, intc_cascade, IRQF_NO_SUSPEND,
 			"SoC intc cascade interrupt", NULL))
 		pr_err("Failed to register SoC intc cascade interrupt\n");
 	return 0;
-- 
2.25.1



