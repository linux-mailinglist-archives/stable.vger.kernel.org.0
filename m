Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4F2065B7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388760AbgFWUJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388757AbgFWUJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4277520DD4;
        Tue, 23 Jun 2020 20:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942987;
        bh=5ZAVH9SdfmQQhgo3sX7+S/z1QXYvRSBynU1C+2z0xYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO3mEKgmOhBA+/EDt66Z5WuHjFql5s6tJB6w0rMrkQtQtIf/Eek3DTBgxmSNuOAVv
         BiWmnqmXjC7rIa2YM+22FfRIzYdVTcIQ5h1MWFwbSpYvUPCHto/dywEq0X3SGq/ve7
         2tqvH/SLIt0RVOtTBYB2jdPnXUPZynjRbJh69pVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 215/477] powerpc/64s/exception: Fix machine check no-loss idle wakeup
Date:   Tue, 23 Jun 2020 21:53:32 +0200
Message-Id: <20200623195417.748191922@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 8a5054d8cbbe03c68dcb0957c291c942132e4101 ]

The architecture allows for machine check exceptions to cause idle
wakeups which resume at the 0x200 address which has to return via
the idle wakeup code, but the early machine check handler is run
first.

The case of a no state-loss sleep is broken because the early
handler uses non-volatile register r1 , which is needed for the wakeup
protocol, but it is not restored.

Fix this by loading r1 from the MCE exception frame before returning
to the idle wakeup code. Also update the comment which has become
stale since the idle rewrite in C.

This crash was found and fix confirmed with a machine check injection
test in qemu powernv model (which is not upstream in qemu yet).

Fixes: 10d91611f426d ("powerpc/64s: Reimplement book3s idle code in C")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200508043408.886394-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index ebeebab74b564..463372046169a 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1225,17 +1225,19 @@ EXC_COMMON_BEGIN(machine_check_idle_common)
 	bl	machine_check_queue_event
 
 	/*
-	 * We have not used any non-volatile GPRs here, and as a rule
-	 * most exception code including machine check does not.
-	 * Therefore PACA_NAPSTATELOST does not need to be set. Idle
-	 * wakeup will restore volatile registers.
+	 * GPR-loss wakeups are relatively straightforward, because the
+	 * idle sleep code has saved all non-volatile registers on its
+	 * own stack, and r1 in PACAR1.
 	 *
-	 * Load the original SRR1 into r3 for pnv_powersave_wakeup_mce.
+	 * For no-loss wakeups the r1 and lr registers used by the
+	 * early machine check handler have to be restored first. r2 is
+	 * the kernel TOC, so no need to restore it.
 	 *
 	 * Then decrement MCE nesting after finishing with the stack.
 	 */
 	ld	r3,_MSR(r1)
 	ld	r4,_LINK(r1)
+	ld	r1,GPR1(r1)
 
 	lhz	r11,PACA_IN_MCE(r13)
 	subi	r11,r11,1
@@ -1244,7 +1246,7 @@ EXC_COMMON_BEGIN(machine_check_idle_common)
 	mtlr	r4
 	rlwinm	r10,r3,47-31,30,31
 	cmpwi	cr1,r10,2
-	bltlr	cr1	/* no state loss, return to idle caller */
+	bltlr	cr1	/* no state loss, return to idle caller with r3=SRR1 */
 	b	idle_return_gpr_loss
 #endif
 
-- 
2.25.1



