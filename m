Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF0B43A105
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhJYThA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235775AbhJYTc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D926112F;
        Mon, 25 Oct 2021 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190117;
        bh=vdPbPSGV3LYyfWiHle/leoJkfxMpJveapwJ+l5NPmDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zpwec9BQ0P5x4M6LNIVnQlSzFN/xZCHSTLIJWdj5Y6g5tjVHBpR7YqJT9/+zPGmQC
         eijDQgrxqQ1eqEpuiDOxX+gFihaeItTz7RtBP6VmqpaCrNdBGgEpRkVJHxWuRkqGWI
         e80GNvvBAGRJ9fsB40/u0u0PV4q857H7Q9LZx8BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 38/58] powerpc/idle: Dont corrupt back chain when going idle
Date:   Mon, 25 Oct 2021 21:14:55 +0200
Message-Id: <20211025190943.760074275@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 496c5fe25c377ddb7815c4ce8ecfb676f051e9b6 upstream.

In isa206_idle_insn_mayloss() we store various registers into the stack
red zone, which is allowed.

However inside the IDLE_STATE_ENTER_SEQ_NORET macro we save r2 again,
to 0(r1), which corrupts the stack back chain.

We used to do the same in isa206_idle_insn_mayloss() itself, but we
fixed that in 73287caa9210 ("powerpc64/idle: Fix SP offsets when saving
GPRs"), however we missed that the macro also corrupts the back chain.

Corrupting the back chain is bad for debuggability but doesn't
necessarily cause a bug.

However we recently changed the stack handling in some KVM code, and it
now relies on the stack back chain being valid when it returns. The
corruption causes that code to return with r1 pointing somewhere in
kernel data, at some point LR is restored from the stack and we branch
to NULL or somewhere else invalid.

Only affects Power8 hosts running KVM guests, with dynamic_mt_modes
enabled (which it is by default).

The fixes tag below points to the commit that changed the KVM stack
handling, exposing this bug. The actual corruption of the back chain has
always existed since 948cf67c4726 ("powerpc: Add NAP mode support on
Power7 in HV mode").

Fixes: 9b4416c5095c ("KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211020094826.3222052-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/idle_book3s.S |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -124,14 +124,16 @@ _GLOBAL(idle_return_gpr_loss)
 /*
  * This is the sequence required to execute idle instructions, as
  * specified in ISA v2.07 (and earlier). MSR[IR] and MSR[DR] must be 0.
- *
- * The 0(r1) slot is used to save r2 in isa206, so use that here.
+ * We have to store a GPR somewhere, ptesync, then reload it, and create
+ * a false dependency on the result of the load. It doesn't matter which
+ * GPR we store, or where we store it. We have already stored r2 to the
+ * stack at -8(r1) in isa206_idle_insn_mayloss, so use that.
  */
 #define IDLE_STATE_ENTER_SEQ_NORET(IDLE_INST)			\
 	/* Magic NAP/SLEEP/WINKLE mode enter sequence */	\
-	std	r2,0(r1);					\
+	std	r2,-8(r1);					\
 	ptesync;						\
-	ld	r2,0(r1);					\
+	ld	r2,-8(r1);					\
 236:	cmpd	cr0,r2,r2;					\
 	bne	236b;						\
 	IDLE_INST;						\


