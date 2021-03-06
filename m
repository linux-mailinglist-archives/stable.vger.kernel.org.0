Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8A32FAA0
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 13:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhCFMTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 07:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhCFMSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 07:18:55 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A401C06174A;
        Sat,  6 Mar 2021 04:18:55 -0800 (PST)
Date:   Sat, 06 Mar 2021 12:18:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615033133;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swRG/lx6ZVeZhXLtw+XF0xoUI0mK+OTa5IpeAqMH+8A=;
        b=KiDB7skkMxT2rUea6cms31lVqrOMWVkQlQPuVuSpwrStbFuZlEsKdUHAA0L9s7EeT+WczJ
        8ovztZ3bD1M47EoUvJK6lfn2HHTNTKIakDpCiNK2gI2WpCFGCeGeX0dL1CU/ktGbVnqOTa
        +96FMHot2w6w84WmoZ0noMHYR8GsR56Xo+la9MeHps4NvoL9jRiVk16lUJZqkk8OPGcfNt
        U1FRxqIeJ4Fr8U9CO9jBkzF6fC2oKlFITBTyJwNzD8R8tSDM2kPv5WsYrw411uVBwEXHS3
        NkBuSL1VhuNiLaX0OssUhradakPbYaVaV+R357nZ8v7XsyLyyR2jSNODck2E6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615033133;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swRG/lx6ZVeZhXLtw+XF0xoUI0mK+OTa5IpeAqMH+8A=;
        b=9utgGPWwrrfbkJ179KsUqsID3EDZnCIYP3VngOC56G3C0Bl+k0zxDsvend1Cj4TcR/AksW
        CtCvwrSzp0WIiiCw==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Fix entry/exit mismatch on failed fast
 32-bit syscalls
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
References: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <161503313284.398.1974484550470289869.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5d5675df792ff67e74a500c4c94db0f99e6a10ef
Gitweb:        https://git.kernel.org/tip/5d5675df792ff67e74a500c4c94db0f99e6a10ef
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Thu, 04 Mar 2021 11:05:54 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 06 Mar 2021 13:10:06 +01:00

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
Signed-off-by: Borislav Petkov <bp@suse.de>
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
 
