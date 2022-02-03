Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B84A8E04
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354185AbiBCUfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiBCUdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BD8C061795;
        Thu,  3 Feb 2022 12:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 934CD61B0F;
        Thu,  3 Feb 2022 20:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49982C340F4;
        Thu,  3 Feb 2022 20:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920389;
        bh=1M2WJ0LX7TAAjDwL4gYcineyz/ebR0L2eize8IzicgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqsm890PtTB2zTkn5hDD+KrahHHK6b7ucCvUAOMmVdrtk2sG2IxdJWkjeppBEKEB4
         K0h4xdkviQDr+V0P5vWg3q3+EzfXN+B+lJx8wKN7S3AEbAQfGk9Eki34xmTSros66s
         pZ+TnLDdWuOsXHJnO+BqV75/yik6EBzVJp7yn/npUXLnRtiCfdT15DsRg1d9E5HN3T
         lVbusa2jlISPsAnlyJtw8scK6L/HVLdbBTfu8xXkb9gOVHSZYwj++m5jiERNNS2Pbr
         j4hFlFKZEyVuGAfsjqwXTNaxaQbfOaNDhCBcpdLTgu2mvbV0JyDvJ2vktvjCLu/6zo
         COUS+PHUGJa+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sander Vanheule <sander@svanheule.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.15 14/41] irqchip/realtek-rtl: Service all pending interrupts
Date:   Thu,  3 Feb 2022 15:32:18 -0500
Message-Id: <20220203203245.3007-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 960dd884ddf5621ae6284cd3a42724500a97ae4c ]

Instead of only servicing the lowest pending interrupt line, make sure
all pending SoC interrupts are serviced before exiting the chained
handler. This adds a small overhead if only one interrupt is pending,
but should prevent rapid re-triggering of the handler.

Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/5082ad3cb8b4eedf55075561b93eff6570299fe1.1641739718.git.sander@svanheule.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index fd9f275592d29..1500278fa82d5 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -76,16 +76,20 @@ static void realtek_irq_dispatch(struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct irq_domain *domain;
-	unsigned int pending;
+	unsigned long pending;
+	unsigned int soc_int;
 
 	chained_irq_enter(chip, desc);
 	pending = readl(REG(RTL_ICTL_GIMR)) & readl(REG(RTL_ICTL_GISR));
+
 	if (unlikely(!pending)) {
 		spurious_interrupt();
 		goto out;
 	}
+
 	domain = irq_desc_get_handler_data(desc);
-	generic_handle_domain_irq(domain, __ffs(pending));
+	for_each_set_bit(soc_int, &pending, 32)
+		generic_handle_domain_irq(domain, soc_int);
 
 out:
 	chained_irq_exit(chip, desc);
-- 
2.34.1

