Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40407257D8F
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHaPaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbgHaPaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3184020936;
        Mon, 31 Aug 2020 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887817;
        bh=x2ZL+9z3yoSFuBrSRbMbhuMdewZjuNnz87joNEjtnKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1S2WPViwO+9R9v7+6iY6J5FIryhTWCP+3jJ8VkJ+ZWgxwIUXgld1YJsHinSZMX87
         FVj1pb4ALZ2CxujurIBz7kufboRygKh4O1UGQtc5lkB3hA+VcyEKNLHDnBQHAmkTTp
         ZwzHiCnwI5LfkgSNCgTBVL1Q9RLkePx4pImbqgEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 29/42] irqchip/ingenic: Leave parent IRQ unmasked on suspend
Date:   Mon, 31 Aug 2020 11:29:21 -0400
Message-Id: <20200831152934.1023912-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

