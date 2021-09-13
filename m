Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9D44090FA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbhIMN5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244807AbhIMNzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:55:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A109617E6;
        Mon, 13 Sep 2021 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540136;
        bh=qrzyXexcfrVZEZtP//8dIp+/gsabstX13j4gVjlHr9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFos0D0ls9ZxJgS7KNv4spzlO1eIOhO1BYTgT6+lYXxmU4/XLl+I+t4gWvSc8ODq6
         Ss/qJtndx9MphgosLoRDzc3aWTjnjIHBPvjQNTLwG+GLzNGeMJtulzG/z3i1jaL/SO
         xU00z4Wl+jfVaH0MTig8mKzDFL+AbmPgMeGuw91M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 067/300] irqchip/gic-v3: Fix priority comparison when non-secure priorities are used
Date:   Mon, 13 Sep 2021 15:12:08 +0200
Message-Id: <20210913131111.626240055@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 8d474deaba2c4dd33a5e2f5be82e6798ffa6b8a5 ]

When non-secure priorities are used, compared to the raw priority set,
the value read back from RPR is also right-shifted by one and the
highest bit set.

Add a macro to do the modifications to the raw priority when doing the
comparison against the RPR value. This corrects the pseudo-NMI behavior
when non-secure priorities in the GIC are used. Tested on 5.10 with
the "IPI as pseudo-NMI" series [1] applied on MT8195.

[1] https://lore.kernel.org/linux-arm-kernel/1604317487-14543-1-git-send-email-sumit.garg@linaro.org/

Fixes: 336780590990 ("irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ == 0")
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
[maz: Added comment contributed by Alex]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210811171505.1502090-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 66d623f91678..20a2d606b4c9 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -100,6 +100,27 @@ EXPORT_SYMBOL(gic_pmr_sync);
 DEFINE_STATIC_KEY_FALSE(gic_nonsecure_priorities);
 EXPORT_SYMBOL(gic_nonsecure_priorities);
 
+/*
+ * When the Non-secure world has access to group 0 interrupts (as a
+ * consequence of SCR_EL3.FIQ == 0), reading the ICC_RPR_EL1 register will
+ * return the Distributor's view of the interrupt priority.
+ *
+ * When GIC security is enabled (GICD_CTLR.DS == 0), the interrupt priority
+ * written by software is moved to the Non-secure range by the Distributor.
+ *
+ * If both are true (which is when gic_nonsecure_priorities gets enabled),
+ * we need to shift down the priority programmed by software to match it
+ * against the value returned by ICC_RPR_EL1.
+ */
+#define GICD_INT_RPR_PRI(priority)					\
+	({								\
+		u32 __priority = (priority);				\
+		if (static_branch_unlikely(&gic_nonsecure_priorities))	\
+			__priority = 0x80 | (__priority >> 1);		\
+									\
+		__priority;						\
+	})
+
 /* ppi_nmi_refs[n] == number of cpus having ppi[n + 16] set as NMI */
 static refcount_t *ppi_nmi_refs;
 
@@ -687,7 +708,7 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		return;
 
 	if (gic_supports_nmi() &&
-	    unlikely(gic_read_rpr() == GICD_INT_NMI_PRI)) {
+	    unlikely(gic_read_rpr() == GICD_INT_RPR_PRI(GICD_INT_NMI_PRI))) {
 		gic_handle_nmi(irqnr, regs);
 		return;
 	}
-- 
2.30.2



