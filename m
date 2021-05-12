Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49A37CE67
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbhELRFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237882AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8B5619A3;
        Wed, 12 May 2021 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836012;
        bh=y5HAnkfjz1fAF+Y1qZGioFpODtf9bMSHa7OQBJmQ2Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZFafd3nUVdI9FpVzxM/Vw2MtW/2u7+ltHPgo7K7aYVGDXNgbZhG/cbA76VfF2E7b
         de7bmlAByp0uI+6SPCiIxn31M6S/yVrfnZXbGCKDoldfIR2TY48bChFJH/ngbmzY3E
         tFMq2R6yEjCJSlAcUAFt5C3f65d2IHGhEUoMGDyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 575/677] powerpc/syscall: switch user_exit_irqoff and trace_hardirqs_off order
Date:   Wed, 12 May 2021 16:50:21 +0200
Message-Id: <20210512144856.493382834@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5a5a893c4ad897b8a36f846602895515b7407a71 ]

user_exit_irqoff() -> __context_tracking_exit -> vtime_user_exit
warns in __seqprop_assert due to lockdep thinking preemption is enabled
because trace_hardirqs_off() has not yet been called.

Switch the order of these two calls, which matches their ordering in
interrupt_enter_prepare.

Fixes: 5f0b6ac3905f ("powerpc/64/syscall: Reconcile interrupts")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210316104206.407354-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index c475a229a42a..352346e14a08 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -34,11 +34,11 @@ notrace long system_call_exception(long r3, long r4, long r5,
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
 		BUG_ON(irq_soft_mask_return() != IRQS_ALL_DISABLED);
 
+	trace_hardirqs_off(); /* finish reconciling */
+
 	CT_WARN_ON(ct_state() == CONTEXT_KERNEL);
 	user_exit_irqoff();
 
-	trace_hardirqs_off(); /* finish reconciling */
-
 	if (!IS_ENABLED(CONFIG_BOOKE) && !IS_ENABLED(CONFIG_40x))
 		BUG_ON(!(regs->msr & MSR_RI));
 	BUG_ON(!(regs->msr & MSR_PR));
-- 
2.30.2



