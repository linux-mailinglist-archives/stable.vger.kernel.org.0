Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0557E3A982
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733272AbfFIRBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388053AbfFIRB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACB2208E3;
        Sun,  9 Jun 2019 17:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099688;
        bh=vV1Hfz1zz1l1400N7Qr1vuy6Ki8c8O7+nMmPUkA9T0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSIy/su6Cc/S8zFq8eb8uXTfpja2F08yxCE538V/Je/SUET4VY2hDecoKL+FB45ft
         NAhq6OSrVMPTy1mmhEvBVz7Iro853z/9bG4lzMWmA2iaLW/G5Tjv03wEs2Klfw9ayZ
         9gp+CunK/ik1/wrEbLrC7xKUPB+M/PtoJDVNp/OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Nicolai Stange <nstange@suse.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 129/241] x86/irq/64: Limit IST stack overflow check to #DB stack
Date:   Sun,  9 Jun 2019 18:41:11 +0200
Message-Id: <20190609164151.522767573@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7dbcf2b0b770eeb803a416ee8dcbef78e6389d40 ]

Commit

  37fe6a42b343 ("x86: Check stack overflow in detail")

added a broad check for the full exception stack area, i.e. it considers
the full exception stack area as valid.

That's wrong in two aspects:

 1) It does not check the individual areas one by one

 2) #DF, NMI and #MCE are not enabling interrupts which means that a
    regular device interrupt cannot happen in their context. In fact if a
    device interrupt hits one of those IST stacks that's a bug because some
    code path enabled interrupts while handling the exception.

Limit the check to the #DB stack and consider all other IST stacks as
'overflow' or invalid.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Nicolai Stange <nstange@suse.de>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190414160143.682135110@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/irq_64.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 206d0b90a3ab1..e39d7197f9fb2 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -25,9 +25,18 @@ int sysctl_panic_on_stackoverflow;
 /*
  * Probabilistic stack overflow check:
  *
- * Only check the stack in process context, because everything else
- * runs on the big interrupt stacks. Checking reliably is too expensive,
- * so we just check from interrupts.
+ * Regular device interrupts can enter on the following stacks:
+ *
+ * - User stack
+ *
+ * - Kernel task stack
+ *
+ * - Interrupt stack if a device driver reenables interrupts
+ *   which should only happen in really old drivers.
+ *
+ * - Debug IST stack
+ *
+ * All other contexts are invalid.
  */
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
@@ -53,8 +62,8 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 		return;
 
 	oist = this_cpu_ptr(&orig_ist);
-	estack_top = (u64)oist->ist[0] - EXCEPTION_STKSZ + STACK_TOP_MARGIN;
-	estack_bottom = (u64)oist->ist[N_EXCEPTION_STACKS - 1];
+	estack_bottom = (u64)oist->ist[DEBUG_STACK];
+	estack_top = estack_bottom - DEBUG_STKSZ + STACK_TOP_MARGIN;
 	if (regs->sp >= estack_top && regs->sp <= estack_bottom)
 		return;
 
-- 
2.20.1



