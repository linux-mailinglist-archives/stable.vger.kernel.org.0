Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7556B3C55BB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245596AbhGLILt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353893AbhGLIDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E77961D15;
        Mon, 12 Jul 2021 07:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076712;
        bh=LHEj45y8sV3DOsoSKt9HvnE/fEOlNGrz/bkuCvnvqNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEYZx465sNMmlCD5vuVx2RWkDL3AU0DtfbxORwTgSqkJNtdmynINLS5liHUyBxOWM
         4sCU2eNeXmTFsvhYzbm7HK9mlZkHZHXc8PDN+WGaIfxF7DCIaKNE4OtW+W5pYT2HCV
         xRWu3gB39BMp3/Skf4H+O9jabYwLYEyztiiDTeok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 762/800] powerpc/64s/interrupt: preserve regs->softe for NMI interrupts
Date:   Mon, 12 Jul 2021 08:13:05 +0200
Message-Id: <20210712061047.854868957@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 59f704408d65..a26aad41ef3e 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -186,6 +186,7 @@ struct interrupt_nmi_state {
 	u8 irq_soft_mask;
 	u8 irq_happened;
 	u8 ftrace_enabled;
+	u64 softe;
 #endif
 };
 
@@ -211,6 +212,7 @@ static inline void interrupt_nmi_enter_prepare(struct pt_regs *regs, struct inte
 #ifdef CONFIG_PPC64
 	state->irq_soft_mask = local_paca->irq_soft_mask;
 	state->irq_happened = local_paca->irq_happened;
+	state->softe = regs->softe;
 
 	/*
 	 * Set IRQS_ALL_DISABLED unconditionally so irqs_disabled() does
@@ -263,6 +265,7 @@ static inline void interrupt_nmi_exit_prepare(struct pt_regs *regs, struct inter
 
 	/* Check we didn't change the pending interrupt mask. */
 	WARN_ON_ONCE((state->irq_happened | PACA_IRQ_HARD_DIS) != local_paca->irq_happened);
+	regs->softe = state->softe;
 	local_paca->irq_happened = state->irq_happened;
 	local_paca->irq_soft_mask = state->irq_soft_mask;
 #endif
-- 
2.30.2



