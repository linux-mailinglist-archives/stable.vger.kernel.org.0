Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D56D43A2B6
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhJYTvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236134AbhJYTti (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA7C661108;
        Mon, 25 Oct 2021 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190908;
        bh=5pE0lFSjvAajVgu0Aa+jEAe8SoNog+r8Es7wuCC9jg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mt8rq4a/xE7gYFT/NdI0zW5Z5rRmNqqlOBJHzxwvRVP3RLFXXgtDDJcyYu6ou6uxR
         /E6lbwKIMWp5X8dPdMKGXp+eOSKUha0lWd7n6DBZfL7npUi8CVvI0E0bjEqOEwx4Yn
         6YMBxIRwK4d67MwpBk0m5DT2GNGvPKF2YGQcOBCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 099/169] powerpc/idle: Dont corrupt back chain when going idle
Date:   Mon, 25 Oct 2021 21:14:40 +0200
Message-Id: <20211025191030.390317661@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
@@ -126,14 +126,16 @@ _GLOBAL(idle_return_gpr_loss)
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


