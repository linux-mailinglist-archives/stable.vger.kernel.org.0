Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5753AF020
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhFUQqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233328AbhFUQoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB8B61451;
        Mon, 21 Jun 2021 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293133;
        bh=vv8cfs3W2ydhqoEwHQRbkUvo8zVx5jqdBMYeL/0XmSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M02hQbpXx61cChXNn37+2+tecMBuRijA7l0RLYOf7aYQBIens3pslV5G8MdntpQRL
         4xVfyO/vsj3LbyqP+BIRJKjG/pddJgJ5VIpK11AQu/4DT847eDEaRKj7nU4PCj3L0X
         WSPjyB4r9M+VokGh4VEC00txDzqwzoy6rKCQpbMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 111/178] irqchip/gic-v3: Workaround inconsistent PMR setting on NMI entry
Date:   Mon, 21 Jun 2021 18:15:25 +0200
Message-Id: <20210621154926.545369384@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 382e6e177bc1c02473e56591fe5083ae1e4904f6 ]

The arm64 entry code suffers from an annoying issue on taking
a NMI, as it sets PMR to a value that actually allows IRQs
to be acknowledged. This is done for consistency with other parts
of the code, and is in the process of being fixed. This shouldn't
be a problem, as we are not enabling interrupts whilst in NMI
context.

However, in the infortunate scenario that we took a spurious NMI
(retired before the read of IAR) *and* that there is an IRQ pending
at the same time, we'll ack the IRQ in NMI context. Too bad.

In order to avoid deadlocks while running something like perf,
teach the GICv3 driver about this situation: if we were in
a context where no interrupt should have fired, transiently
set PMR to a value that only allows NMIs before acking the pending
interrupt, and restore the original value after that.

This papers over the core issue for the time being, and makes
NMIs great again. Sort of.

Fixes: 4d6a38da8e79e94c ("arm64: entry: always set GIC_PRIO_PSR_I_SET during entry")
Co-developed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/lkml/20210610145731.1350460-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 00404024d7cd..fea237838bb0 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -642,11 +642,45 @@ static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 		nmi_exit();
 }
 
+static u32 do_read_iar(struct pt_regs *regs)
+{
+	u32 iar;
+
+	if (gic_supports_nmi() && unlikely(!interrupts_enabled(regs))) {
+		u64 pmr;
+
+		/*
+		 * We were in a context with IRQs disabled. However, the
+		 * entry code has set PMR to a value that allows any
+		 * interrupt to be acknowledged, and not just NMIs. This can
+		 * lead to surprising effects if the NMI has been retired in
+		 * the meantime, and that there is an IRQ pending. The IRQ
+		 * would then be taken in NMI context, something that nobody
+		 * wants to debug twice.
+		 *
+		 * Until we sort this, drop PMR again to a level that will
+		 * actually only allow NMIs before reading IAR, and then
+		 * restore it to what it was.
+		 */
+		pmr = gic_read_pmr();
+		gic_pmr_mask_irqs();
+		isb();
+
+		iar = gic_read_iar();
+
+		gic_write_pmr(pmr);
+	} else {
+		iar = gic_read_iar();
+	}
+
+	return iar;
+}
+
 static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
 	u32 irqnr;
 
-	irqnr = gic_read_iar();
+	irqnr = do_read_iar(regs);
 
 	/* Check for special IDs first */
 	if ((irqnr >= 1020 && irqnr <= 1023))
-- 
2.30.2



