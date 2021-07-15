Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F3C3C9E30
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhGOMIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhGOMIL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E025611C0;
        Thu, 15 Jul 2021 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626350717;
        bh=WSVDOXNMjrSxLDE+CFjPOlBKMuSeK1c9nWbvyN/53WI=;
        h=Subject:To:Cc:From:Date:From;
        b=umL0DyXETaSAY+U4+RuLTfobVkDlBcODUypc/eGjEMYBjsfNn0zHnLOIwpW0n//wH
         BWq4QPhhuQZMIiC0v7MPVpWPrCN55Y54TSfz5ZLl4JFiwL/k+vSP9XVng4EF85xp3h
         bTLxEFaC4pfTzafkUtFHq//yTFW/1wkDIm9Wx8mM=
Subject: FAILED: patch "[PATCH] powerpc/kprobes: Fix Oops by passing ppc_inst as a pointer to" failed to apply to 5.13-stable tree
To:     naveen.n.rao@linux.vnet.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:04:14 +0200
Message-ID: <162635065452194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 511eea5e2ccdfdbf3d626bde0314e551f247dd18 Mon Sep 17 00:00:00 2001
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Date: Wed, 23 Jun 2021 05:23:30 +0000
Subject: [PATCH] powerpc/kprobes: Fix Oops by passing ppc_inst as a pointer to
 emulate_step() on ppc32

Trying to use a kprobe on ppc32 results in the below splat:
    BUG: Unable to handle kernel data access on read at 0x7c0802a6
    Faulting instruction address: 0xc002e9f0
    Oops: Kernel access of bad area, sig: 11 [#1]
    BE PAGE_SIZE=4K PowerPC 44x Platform
    Modules linked in:
    CPU: 0 PID: 89 Comm: sh Not tainted 5.13.0-rc1-01824-g3a81c0495fdb #7
    NIP:  c002e9f0 LR: c0011858 CTR: 00008a47
    REGS: c292fd50 TRAP: 0300   Not tainted  (5.13.0-rc1-01824-g3a81c0495fdb)
    MSR:  00009000 <EE,ME>  CR: 24002002  XER: 20000000
    DEAR: 7c0802a6 ESR: 00000000
    <snip>
    NIP [c002e9f0] emulate_step+0x28/0x324
    LR [c0011858] optinsn_slot+0x128/0x10000
    Call Trace:
     opt_pre_handler+0x7c/0xb4 (unreliable)
     optinsn_slot+0x128/0x10000
     ret_from_syscall+0x0/0x28

The offending instruction is:
    81 24 00 00     lwz     r9,0(r4)

Here, we are trying to load the second argument to emulate_step():
struct ppc_inst, which is the instruction to be emulated. On ppc64,
structures are passed in registers when passed by value. However, per
the ppc32 ABI, structures are always passed to functions as pointers.
This isn't being adhered to when setting up the call to emulate_step()
in the optprobe trampoline. Fix the same.

Fixes: eacf4c0202654a ("powerpc: Enable OPTPROBES on PPC32")
Cc: stable@vger.kernel.org
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5bdc8cbc9a95d0779e27c9ddbf42b40f51f883c0.1624425798.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/kernel/optprobes.c b/arch/powerpc/kernel/optprobes.c
index 8b9f82dc6ece..c79899abcec8 100644
--- a/arch/powerpc/kernel/optprobes.c
+++ b/arch/powerpc/kernel/optprobes.c
@@ -228,8 +228,12 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *p)
 	/*
 	 * 3. load instruction to be emulated into relevant register, and
 	 */
-	temp = ppc_inst_read(p->ainsn.insn);
-	patch_imm_load_insns(ppc_inst_as_ulong(temp), 4, buff + TMPL_INSN_IDX);
+	if (IS_ENABLED(CONFIG_PPC64)) {
+		temp = ppc_inst_read(p->ainsn.insn);
+		patch_imm_load_insns(ppc_inst_as_ulong(temp), 4, buff + TMPL_INSN_IDX);
+	} else {
+		patch_imm_load_insns((unsigned long)p->ainsn.insn, 4, buff + TMPL_INSN_IDX);
+	}
 
 	/*
 	 * 4. branch back from trampoline

