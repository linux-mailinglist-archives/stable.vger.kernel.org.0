Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B84E3C5091
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243347AbhGLHdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344264AbhGLH33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BDA61447;
        Mon, 12 Jul 2021 07:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074693;
        bh=KnpKEovV7BiAc2Ywha0809EFpAwS8BcmaHqmn5casqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8JxeJgkcI6Z7LKrtp9YJeSTwV6r0wsHMMDEy4iV3wFNwiWEj5YeSWVzhNWighezo
         yUPzAQAmF+sNgqulRk6kTx5EchU6TG8epH5vJrLJ4xx3wX5iZ24KqabDVkvYvhtR1j
         bSDfpWog8VL4nXpGeDf795SAUNXGKfTqZBcK0kLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 663/700] powerpc/64s/interrupt: preserve regs->softe for NMI interrupts
Date:   Mon, 12 Jul 2021 08:12:26 +0200
Message-Id: <20210712061046.443498057@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 1b0482229c302a3c6afd00d6b3bf0169cf279b44 ]

If an NMI interrupt hits in an implicit soft-masked region, regs->softe
is modified to reflect that. This may not be necessary for correctness
at the moment, but it is less surprising and it's unhelpful when
debugging or adding checks.

Make sure this is changed back to how it was found before returning.

Fixes: 4ec5feec1ad0 ("powerpc/64s: Make NMI record implicitly soft-masked code as irqs disabled")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210630074621.2109197-6-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index 31ed5356590a..6d15728f0680 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -120,6 +120,7 @@ struct interrupt_nmi_state {
 	u8 irq_happened;
 #endif
 	u8 ftrace_enabled;
+	u64 softe;
 #endif
 };
 
@@ -129,6 +130,7 @@ static inline void interrupt_nmi_enter_prepare(struct pt_regs *regs, struct inte
 #ifdef CONFIG_PPC_BOOK3S_64
 	state->irq_soft_mask = local_paca->irq_soft_mask;
 	state->irq_happened = local_paca->irq_happened;
+	state->softe = regs->softe;
 
 	/*
 	 * Set IRQS_ALL_DISABLED unconditionally so irqs_disabled() does
@@ -178,6 +180,7 @@ static inline void interrupt_nmi_exit_prepare(struct pt_regs *regs, struct inter
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* Check we didn't change the pending interrupt mask. */
 	WARN_ON_ONCE((state->irq_happened | PACA_IRQ_HARD_DIS) != local_paca->irq_happened);
+	regs->softe = state->softe;
 	local_paca->irq_happened = state->irq_happened;
 	local_paca->irq_soft_mask = state->irq_soft_mask;
 #endif
-- 
2.30.2



