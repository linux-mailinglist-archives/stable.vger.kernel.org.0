Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFB74290F1
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241285AbhJKOON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241841AbhJKOMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:12:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBEBC610C8;
        Mon, 11 Oct 2021 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961014;
        bh=+S2fTVAapzqKR2kMYhB+gS1yBxRZMlUinhch4n/ZHKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWJk0iIHinwo+T+52oCwb0X06P2DoI31ycLm61gqHLQNrZYW1/8gfg+COvSf3wXE0
         XHbDugO5ARU+ENbq+RPu6acj7/YMcothmWunec10fSbTAoSLlGyS0xT+5BRYDtn2iB
         U+wQVk9Q6qp6/W24/bzKRKSBvWPdKG395APx8ZUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 140/151] powerpc/traps: do not enable irqs in _exception
Date:   Mon, 11 Oct 2021 15:46:52 +0200
Message-Id: <20211011134522.336301949@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit d0afd44c05f8f4e4c91487c02d43c87a31552462 ]

_exception can be called by machine check handlers when the MCE hits
user code (e.g., pseries and powernv). This will enable local irqs
because, which is a dicey thing to do in NMI or hard irq context.

This seemed to worked out okay because a userspace MCE can basically be
treated like a synchronous interrupt (after async / imprecise MCEs are
filtered out). Since NMI and hard irq handlers have started growing
nmi_enter / irq_enter, and more irq state sanity checks, this has
started to cause problems (or at least trigger warnings).

The Fixes tag to the commit which introduced this rather than try to
work out exactly which commit was the first that could possibly cause a
problem because that may be difficult to prove.

Fixes: 9f2f79e3a3c1 ("powerpc: Disable interrupts in 64-bit kernel FP and vector faults")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211004145642.1331214-3-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d56254f05e17..4ac85ab15ad7 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -341,10 +341,16 @@ static bool exception_common(int signr, struct pt_regs *regs, int code,
 		return false;
 	}
 
-	show_signal_msg(signr, regs, code, addr);
+	/*
+	 * Must not enable interrupts even for user-mode exception, because
+	 * this can be called from machine check, which may be a NMI or IRQ
+	 * which don't like interrupts being enabled. Could check for
+	 * in_hardirq || in_nmi perhaps, but there doesn't seem to be a good
+	 * reason why _exception() should enable irqs for an exception handler,
+	 * the handlers themselves do that directly.
+	 */
 
-	if (arch_irqs_disabled())
-		interrupt_cond_local_irq_enable(regs);
+	show_signal_msg(signr, regs, code, addr);
 
 	current->thread.trap_nr = code;
 
-- 
2.33.0



