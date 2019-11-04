Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B35EF177
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 00:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfKDX4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 18:56:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39263 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbfKDX4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 18:56:23 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iRmCk-0001NK-1x; Tue, 05 Nov 2019 00:56:14 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A2A191C0105;
        Tue,  5 Nov 2019 00:56:13 +0100 (CET)
Date:   Mon, 04 Nov 2019 23:56:13 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/dumpstack/64: Don't evaluate exception stacks
 before setup
Cc:     Cyrill Gorcunov <gorcunov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.21.1910231950590.1852@nanos.tec.linutronix.de>
References: <alpine.DEB.2.21.1910231950590.1852@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <157291177324.29376.14563915167890708264.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e361362b08cab1098b64b0e5fd8c879f086b3f46
Gitweb:        https://git.kernel.org/tip/e361362b08cab1098b64b0e5fd8c879f086b3f46
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 23 Oct 2019 20:05:49 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 05 Nov 2019 00:51:35 +01:00

x86/dumpstack/64: Don't evaluate exception stacks before setup

Cyrill reported the following crash:

  BUG: unable to handle page fault for address: 0000000000001ff0
  #PF: supervisor read access in kernel mode
  RIP: 0010:get_stack_info+0xb3/0x148

It turns out that if the stack tracer is invoked before the exception stack
mappings are initialized in_exception_stack() can erroneously classify an
invalid address as an address inside of an exception stack:

    begin = this_cpu_read(cea_exception_stacks);  <- 0
    end = begin + sizeof(exception stacks);

i.e. any address between 0 and end will be considered as exception stack
address and the subsequent code will then try to derefence the resulting
stack frame at a non mapped address.

 end = begin + (unsigned long)ep->size;
     ==> end = 0x2000

 regs = (struct pt_regs *)end - 1;
     ==> regs = 0x2000 - sizeof(struct pt_regs *) = 0x1ff0

 info->next_sp   = (unsigned long *)regs->sp;
     ==> Crashes due to accessing 0x1ff0

Prevent this by checking the validity of the cea_exception_stack base
address and bailing out if it is zero.

Fixes: afcd21dad88b ("x86/dumpstack/64: Use cpu_entry_area instead of orig_ist")
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1910231950590.1852@nanos.tec.linutronix.de

---
 arch/x86/kernel/dumpstack_64.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 753b8cf..87b9789 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -94,6 +94,13 @@ static bool in_exception_stack(unsigned long *stack, struct stack_info *info)
 	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
 
 	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
+	/*
+	 * Handle the case where stack trace is collected _before_
+	 * cea_exception_stacks had been initialized.
+	 */
+	if (!begin)
+		return false;
+
 	end = begin + sizeof(struct cea_exception_stacks);
 	/* Bail if @stack is outside the exception stack area. */
 	if (stk < begin || stk >= end)
