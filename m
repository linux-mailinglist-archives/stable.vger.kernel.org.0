Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A296929BDBB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812916AbgJ0Qqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368854AbgJ0PmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E58792231B;
        Tue, 27 Oct 2020 15:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813321;
        bh=7rwh9ZMG+d1y23DyeDVmbYql2ny56E1HuVwnfG6azQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0FoSyB4JozOfwDx1qldhFItra+6kJpmgapdrNgz2K8MRwuspI1SSroNhu5pi4Ogd
         l0G+I7ni8rQ6AcQmrDQEr5Ky5jlGrV0+B0K8Vqm+QsZUv8phPlrdWyhxmKiPQYheLA
         Bgys+T3NkarjHKG/p697HhCXJTBKj5dYABH8vgu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 482/757] powerpc/64: fix irq replay pt_regs->softe value
Date:   Tue, 27 Oct 2020 14:52:12 +0100
Message-Id: <20201027135513.091249938@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 2b48e96be2f9f7151197fd25dc41487054bc6f5b ]

Replayed interrupts get an "artificial" struct pt_regs constructed to
pass to interrupt handler functions. This did not get the softe field
set correctly, it's as though the interrupt has hit while irqs are
disabled. It should be IRQS_ENABLED.

This is possibly harmless, asynchronous handlers should not be testing
if irqs were disabled, but it might be possible for example some code
is shared with synchronous or NMI handlers, and it makes more sense if
debug output looks at this.

Fixes: 3282a3da25bd ("powerpc/64: Implement soft interrupt replay in C")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200915114650.3980244-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 77019699606a5..3fdad93368858 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -214,7 +214,7 @@ void replay_soft_interrupts(void)
 	struct pt_regs regs;
 
 	ppc_save_regs(&regs);
-	regs.softe = IRQS_ALL_DISABLED;
+	regs.softe = IRQS_ENABLED;
 
 again:
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
-- 
2.25.1



