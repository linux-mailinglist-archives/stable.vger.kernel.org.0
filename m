Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692562F2EF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfE3DOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfE3DOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0879D24555;
        Thu, 30 May 2019 03:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186085;
        bh=OxCAIHPoH18e4bJyXWJl8c54vD7RQRBMGt1OQmZG0A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mx4UOKuStnusYIj9/WyzrFXoHOV8uP1soK65zmUJvlm1JmZIa0sSa/b1lGmbTMC2X
         +uUAKKizi+dFRglKWJvZhk48gvqPtk9eOzvaqbvTrBlbBBHS/bGU5mYRH7Jq48A6mz
         jdobiZauJA4mT4mQBbgETg2LXGevAh8FknGPBw9A=
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
Subject: [PATCH 5.0 165/346] x86/irq/64: Limit IST stack overflow check to #DB stack
Date:   Wed, 29 May 2019 20:03:58 -0700
Message-Id: <20190530030549.523431206@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index 0469cd078db15..b50ac9c7397bb 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -26,9 +26,18 @@ int sysctl_panic_on_stackoverflow;
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



