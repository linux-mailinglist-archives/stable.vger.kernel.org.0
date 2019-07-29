Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14B79762
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390222AbfG2Tv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403902AbfG2Tv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:51:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC9C21655;
        Mon, 29 Jul 2019 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429916;
        bh=D3Un3YhUUOKploS/ndUKvUAHVmkDxg0BX7hk5R9sXrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUAq4nZa5NZe2YmNRAp2T4NgvXqZ5fAguAaU9ZbOqF7s5D256sUs6nDyBq4ZB2koE
         N6qx5CtwoTD+4fiI2f8zxVhNdBAVb3bgiVI002qjvrx3JtDzMk4x1/Zc647QINm0XF
         AFdghZXTXyW2k3e0zFOAJNOg7WkDD2dv7sG6SUSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 137/215] powerpc/irq: Dont WARN continuously in arch_local_irq_restore()
Date:   Mon, 29 Jul 2019 21:22:13 +0200
Message-Id: <20190729190803.318867604@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



