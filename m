Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E2B2C4436
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgKYPlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbgKYPgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CD721D7E;
        Wed, 25 Nov 2020 15:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318593;
        bh=COJWvQprogJhw6tbRAjpeaYUGHO8WEq8+3EtbMG2z0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBXWNie8w9v8GPwD5TncQw99Xo7nsLj07nmtDfrpGIm7khJO+kqDNKYnGh31nDmqU
         3h3k7HDUtXGRWh1Fm2Q/LHIt/8kg0jvrIQbjOxlRwZ+Gt3Vzc3cVJBPufYhDXNbP5H
         PfUwuRUEp87QFuxPBjS5cnnoPc/H4u0NMHM9HUg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 31/33] x86/dumpstack: Do not try to access user space code of other tasks
Date:   Wed, 25 Nov 2020 10:35:48 -0500
Message-Id: <20201125153550.810101-31-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 860aaabac8235cfde10fe556aa82abbbe3117888 ]

sysrq-t ends up invoking show_opcodes() for each task which tries to access
the user space code of other processes, which is obviously bogus.

It either manages to dump where the foreign task's regs->ip points to in a
valid mapping of the current task or triggers a pagefault and prints "Code:
Bad RIP value.". Both is just wrong.

Add a safeguard in copy_code() and check whether the @regs pointer matches
currents pt_regs. If not, do not even try to access it.

While at it, add commentary why using copy_from_user_nmi() is safe in
copy_code() even if the function name suggests otherwise.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201117202753.667274723@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ea8d51ec251bb..4da8345d34bb0 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -77,6 +77,9 @@ static int copy_code(struct pt_regs *regs, u8 *buf, unsigned long src,
 	if (!user_mode(regs))
 		return copy_from_kernel_nofault(buf, (u8 *)src, nbytes);
 
+	/* The user space code from other tasks cannot be accessed. */
+	if (regs != task_pt_regs(current))
+		return -EPERM;
 	/*
 	 * Make sure userspace isn't trying to trick us into dumping kernel
 	 * memory by pointing the userspace instruction pointer at it.
@@ -84,6 +87,12 @@ static int copy_code(struct pt_regs *regs, u8 *buf, unsigned long src,
 	if (__chk_range_not_ok(src, nbytes, TASK_SIZE_MAX))
 		return -EINVAL;
 
+	/*
+	 * Even if named copy_from_user_nmi() this can be invoked from
+	 * other contexts and will not try to resolve a pagefault, which is
+	 * the correct thing to do here as this code can be called from any
+	 * context.
+	 */
 	return copy_from_user_nmi(buf, (void __user *)src, nbytes);
 }
 
@@ -114,13 +123,19 @@ void show_opcodes(struct pt_regs *regs, const char *loglvl)
 	u8 opcodes[OPCODE_BUFSIZE];
 	unsigned long prologue = regs->ip - PROLOGUE_SIZE;
 
-	if (copy_code(regs, opcodes, prologue, sizeof(opcodes))) {
-		printk("%sCode: Unable to access opcode bytes at RIP 0x%lx.\n",
-		       loglvl, prologue);
-	} else {
+	switch (copy_code(regs, opcodes, prologue, sizeof(opcodes))) {
+	case 0:
 		printk("%sCode: %" __stringify(PROLOGUE_SIZE) "ph <%02x> %"
 		       __stringify(EPILOGUE_SIZE) "ph\n", loglvl, opcodes,
 		       opcodes[PROLOGUE_SIZE], opcodes + PROLOGUE_SIZE + 1);
+		break;
+	case -EPERM:
+		/* No access to the user space stack of other tasks. Ignore. */
+		break;
+	default:
+		printk("%sCode: Unable to access opcode bytes at RIP 0x%lx.\n",
+		       loglvl, prologue);
+		break;
 	}
 }
 
-- 
2.27.0

