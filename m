Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032196DA58
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfGSEBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbfGSEBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436D021873;
        Fri, 19 Jul 2019 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508890;
        bh=3gyWvW9TWKvGDCP/N8AuBPzV+BDaoFgHHsIs/6XfNHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNFa4S2FEI33fcqOBuNsniCnQW5VTRLPSEIFkQn6vTbi+fqK2rk7JOthsjhQFO0xT
         igw1c4lvc/P46ViG/ZWdxLy8NxEaa8IAwlpUpAj0DyMF3kbWDv7+BVV9T36km8srK/
         SMkMyiBnGotiveD36CObaDFylP03CnyqBYown0Kw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 140/171] powerpc/irq: Don't WARN continuously in arch_local_irq_restore()
Date:   Thu, 18 Jul 2019 23:56:11 -0400
Message-Id: <20190719035643.14300-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 0fc12c022ad25532b66bf6f6c818ee1c1d63e702 ]

When CONFIG_PPC_IRQ_SOFT_MASK_DEBUG is enabled (uncommon), we have a
series of WARN_ON's in arch_local_irq_restore().

These are "should never happen" conditions, but if they do happen they
can flood the console and render the system unusable. So switch them
to WARN_ON_ONCE().

Fixes: e2b36d591720 ("powerpc/64: Don't trace code that runs with the soft irq mask unreconciled")
Fixes: 9b81c0211c24 ("powerpc/64s: make PACA_IRQ_HARD_DIS track MSR[EE] closely")
Fixes: 7c0482e3d055 ("powerpc/irq: Fix another case of lazy IRQ state getting out of sync")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190708061046.7075-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/irq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index bc68c53af67c..5645bc9cbc09 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -255,7 +255,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	irq_happened = get_irq_happened();
 	if (!irq_happened) {
 #ifdef CONFIG_PPC_IRQ_SOFT_MASK_DEBUG
-		WARN_ON(!(mfmsr() & MSR_EE));
+		WARN_ON_ONCE(!(mfmsr() & MSR_EE));
 #endif
 		return;
 	}
@@ -268,7 +268,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	 */
 	if (!(irq_happened & PACA_IRQ_HARD_DIS)) {
 #ifdef CONFIG_PPC_IRQ_SOFT_MASK_DEBUG
-		WARN_ON(!(mfmsr() & MSR_EE));
+		WARN_ON_ONCE(!(mfmsr() & MSR_EE));
 #endif
 		__hard_irq_disable();
 #ifdef CONFIG_PPC_IRQ_SOFT_MASK_DEBUG
@@ -279,7 +279,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 		 * warn if we are wrong. Only do that when IRQ tracing
 		 * is enabled as mfmsr() can be costly.
 		 */
-		if (WARN_ON(mfmsr() & MSR_EE))
+		if (WARN_ON_ONCE(mfmsr() & MSR_EE))
 			__hard_irq_disable();
 #endif
 	}
-- 
2.20.1

