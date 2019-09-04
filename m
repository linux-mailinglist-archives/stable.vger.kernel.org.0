Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D080BA8F7C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388213AbfIDSDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387901AbfIDSDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:03:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E292B22CF7;
        Wed,  4 Sep 2019 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620233;
        bh=lzn6b7vPEaXnHu1ZR4rCW/k7BJM6JSfDzEIh82wT6t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Px0ZpmTZJMgOK7OV5V/7r/fSwJ4S7XSPBZ45MXg+ShFnL6jcjGHy6750X8llAZcgz
         5xnEMZL9QvWrXQbeR5lAo7FS3fwxuLTfwvA2WuhJtDDe9ZH0FzhWbVYHbFvwRaqjo3
         TrnncXfie2ZeARCcX5TlzyxJ+0If2kvwk19ZrBC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Mayr <me@sam.st>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Dmitry Safonov <dsafonov@virtuozzo.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/57] uprobes/x86: Fix detection of 32-bit user mode
Date:   Wed,  4 Sep 2019 19:54:06 +0200
Message-Id: <20190904175305.731676987@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9212ec7d8357ea630031e89d0d399c761421c83b ]

32-bit processes running on a 64-bit kernel are not always detected
correctly, causing the process to crash when uretprobes are installed.

The reason for the crash is that in_ia32_syscall() is used to determine the
process's mode, which only works correctly when called from a syscall.

In the case of uretprobes, however, the function is called from a exception
and always returns 'false' on a 64-bit kernel. In consequence this leads to
corruption of the process's return address.

Fix this by using user_64bit_mode() instead of in_ia32_syscall(), which
is correct in any situation.

[ tglx: Add a comment and the following historical info ]

This should have been detected by the rename which happened in commit

  abfb9498ee13 ("x86/entry: Rename is_{ia32,x32}_task() to in_{ia32,x32}_syscall()")

which states in the changelog:

    The is_ia32_task()/is_x32_task() function names are a big misnomer: they
    suggests that the compat-ness of a system call is a task property, which
    is not true, the compatness of a system call purely depends on how it
    was invoked through the system call layer.
    .....

and then it went and blindly renamed every call site.

Sadly enough this was already mentioned here:

   8faaed1b9f50 ("uprobes/x86: Introduce sizeof_long(), cleanup adjust_ret_addr() and
arch_uretprobe_hijack_return_addr()")

where the changelog says:

    TODO: is_ia32_task() is not what we actually want, TS_COMPAT does
    not necessarily mean 32bit. Fortunately syscall-like insns can't be
    probed so it actually works, but it would be better to rename and
    use is_ia32_frame().

and goes all the way back to:

    0326f5a94dde ("uprobes/core: Handle breakpoint and singlestep exceptions")

Oh well. 7+ years until someone actually tried a uretprobe on a 32bit
process on a 64bit kernel....

Fixes: 0326f5a94dde ("uprobes/core: Handle breakpoint and singlestep exceptions")
Signed-off-by: Sebastian Mayr <me@sam.st>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190728152617.7308-1-me@sam.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index b9a8f34b5e5ab..7a87ef1f5b5e6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -518,9 +518,12 @@ struct uprobe_xol_ops {
 	void	(*abort)(struct arch_uprobe *, struct pt_regs *);
 };
 
-static inline int sizeof_long(void)
+static inline int sizeof_long(struct pt_regs *regs)
 {
-	return in_ia32_syscall() ? 4 : 8;
+	/*
+	 * Check registers for mode as in_xxx_syscall() does not apply here.
+	 */
+	return user_64bit_mode(regs) ? 8 : 4;
 }
 
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
@@ -531,9 +534,9 @@ static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 static int push_ret_address(struct pt_regs *regs, unsigned long ip)
 {
-	unsigned long new_sp = regs->sp - sizeof_long();
+	unsigned long new_sp = regs->sp - sizeof_long(regs);
 
-	if (copy_to_user((void __user *)new_sp, &ip, sizeof_long()))
+	if (copy_to_user((void __user *)new_sp, &ip, sizeof_long(regs)))
 		return -EFAULT;
 
 	regs->sp = new_sp;
@@ -566,7 +569,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 		long correction = utask->vaddr - utask->xol_vaddr;
 		regs->ip += correction;
 	} else if (auprobe->defparam.fixups & UPROBE_FIX_CALL) {
-		regs->sp += sizeof_long(); /* Pop incorrect return address */
+		regs->sp += sizeof_long(regs); /* Pop incorrect return address */
 		if (push_ret_address(regs, utask->vaddr + auprobe->defparam.ilen))
 			return -ERESTART;
 	}
@@ -675,7 +678,7 @@ static int branch_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
 	 * We could also restore ->ip and try to call branch_emulate_op() again.
 	 */
-	regs->sp += sizeof_long();
+	regs->sp += sizeof_long(regs);
 	return -ERESTART;
 }
 
@@ -966,7 +969,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 unsigned long
 arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
 {
-	int rasize = sizeof_long(), nleft;
+	int rasize = sizeof_long(regs), nleft;
 	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
 
 	if (copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize))
-- 
2.20.1



