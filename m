Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0932F96D
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 11:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhCFKoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 05:44:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33932 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhCFKoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 05:44:12 -0500
Date:   Sat, 06 Mar 2021 10:44:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615027450;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBTjD6zV73ekOl/oBSpZFhkXjPYcZvWFowNsPr6svwc=;
        b=lVw0wa8c37WL+uZ5qWILY/Rvzqhx/sYmMzTMMx6J7DAGYH2eJJLsEfNJXZbtCDw+QvOGJV
        nwep/MKrtjPyL88QGKP4LKFxlQkzJtnR8sL4DyUKGxXCuyRatcfZcjkgI0w9dcdOWaVp4d
        y+N2oAVnJt7qdJcsUDZqeqsdxR0FqDqqWDKErhmx6xzgemJOQUVMwA/5XNRamPoHL7XWJ4
        snIxsVbjoQJplate2/OwSafx8Bd4jO+vxa01u+Sc/nVodvmp5BBEppyJ5NFudkE0yM3gg0
        qDvx+7kvXj2/oVfcUMHUaO7NYNaStnjjj1pFaCYM1ZHqDYzMCDYJb8nVKHz7EQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615027450;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBTjD6zV73ekOl/oBSpZFhkXjPYcZvWFowNsPr6svwc=;
        b=u3NMMHs541HvsvOfSl2lFCNKhC+i41t/yAjf2GxhzkovSyvVkBU6O6CKE8Tyx+F80GRvCG
        IEpxEwmhCksBpoCQ==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Fix entry/exit mismatch on failed fast
 32-bit syscalls
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
References: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <161502744987.398.7050665815456355997.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e59ba7bf71a09e474198741563e0e587ae43d1c7
Gitweb:        https://git.kernel.org/tip/e59ba7bf71a09e474198741563e0e587ae43d1c7
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Thu, 04 Mar 2021 11:05:54 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 06 Mar 2021 11:37:00 +01:00

x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls

On a 32-bit fast syscall that fails to read its arguments from user
memory, the kernel currently does syscall exit work but not
syscall entry work.  This confuses audit and ptrace.  For example:

    $ ./tools/testing/selftests/x86/syscall_arg_fault_32
    ...
    strace: pid 264258: entering, ptrace_syscall_info.op == 2
    ...

This is a minimal fix intended for ease of backporting.  A more
complete cleanup is coming.

Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org

---
 arch/x86/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index a2433ae..4efd39a 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
 		regs->ax = -EFAULT;
 
 		instrumentation_end();
-		syscall_exit_to_user_mode(regs);
+		local_irq_disable();
+		irqentry_exit_to_user_mode(regs);
 		return false;
 	}
 
