Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFF9499059
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358428AbiAXT7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41030 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358524AbiAXTzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:55:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 368CCB81249;
        Mon, 24 Jan 2022 19:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0DAC340E5;
        Mon, 24 Jan 2022 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054122;
        bh=98zH9u/dBMHoLBSmD4N4UIOlb0RnvHJAmJkIuGxkAPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sl/VVDtLUE0V4i77dHsdyO1PQe04HcHOyp7JgNa/spRMqEyDN71j33j0KG4Ly5IMZ
         Zv0iFAIrkj13MITBE/ZKfKI1WNauXYRwOiYcWuQzzztOibH7W9TmzZGP2ime2tVDdx
         Rr0pK7iNauYA6Fy5vn/oNFw5OmfMdtpq4ewDNis8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/563] powerpc/irq: Add helper to set regs->softe
Date:   Mon, 24 Jan 2022 19:40:17 +0100
Message-Id: <20220124184033.139559555@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit fb5608fd117a8b48752d2b5a7e70847c1ed33d33 ]

regs->softe doesn't exist on PPC32.

Add irq_soft_mask_regs_set_state() helper to set regs->softe.
This helper will void on PPC32.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5f37d1177a751fdbca79df461d283850ca3a34a2.1612796617.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hw_irq.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 0363734ff56e0..da94cab528dd4 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -38,6 +38,8 @@
 #define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE)
 #endif
 
+#endif /* CONFIG_PPC64 */
+
 /*
  * flags for paca->irq_soft_mask
  */
@@ -46,8 +48,6 @@
 #define IRQS_PMI_DISABLED	2
 #define IRQS_ALL_DISABLED	(IRQS_DISABLED | IRQS_PMI_DISABLED)
 
-#endif /* CONFIG_PPC64 */
-
 #ifndef __ASSEMBLY__
 
 extern void replay_system_reset(void);
@@ -296,6 +296,10 @@ extern void irq_set_pending_from_srr1(unsigned long srr1);
 
 extern void force_external_irq_replay(void);
 
+static inline void irq_soft_mask_regs_set_state(struct pt_regs *regs, unsigned long val)
+{
+	regs->softe = val;
+}
 #else /* CONFIG_PPC64 */
 
 static inline unsigned long arch_local_save_flags(void)
@@ -364,6 +368,9 @@ static inline bool arch_irq_disabled_regs(struct pt_regs *regs)
 
 static inline void may_hard_irq_enable(void) { }
 
+static inline void irq_soft_mask_regs_set_state(struct pt_regs *regs, unsigned long val)
+{
+}
 #endif /* CONFIG_PPC64 */
 
 #define ARCH_IRQ_INIT_FLAGS	IRQ_NOREQUEST
-- 
2.34.1



