Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C33A134C0B
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgAHTqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:02 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43400 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730382AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006nu-54; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dlU-DW; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "James Morse" <james.morse@arm.com>,
        "Will Deacon" <will.deacon@arm.com>
Date:   Wed, 08 Jan 2020 19:43:11 +0000
Message-ID: <lsq.1578512578.649061268@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 13/63] arm64: mm: Add trace_irqflags annotations to
 do_debug_exception()
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit 6afedcd23cfd7ac56c011069e4a8db37b46e4623 upstream.

With CONFIG_PROVE_LOCKING, CONFIG_DEBUG_LOCKDEP and CONFIG_TRACE_IRQFLAGS
enabled, lockdep will compare current->hardirqs_enabled with the flags from
local_irq_save().

When a debug exception occurs, interrupts are disabled in entry.S, but
lockdep isn't told, resulting in:
DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
------------[ cut here ]------------
WARNING: at ../kernel/locking/lockdep.c:3523
Modules linked in:
CPU: 3 PID: 1752 Comm: perf Not tainted 4.5.0-rc4+ #2204
Hardware name: ARM Juno development board (r1) (DT)
task: ffffffc974868000 ti: ffffffc975f40000 task.ti: ffffffc975f40000
PC is at check_flags.part.35+0x17c/0x184
LR is at check_flags.part.35+0x17c/0x184
pc : [<ffffff80080fc93c>] lr : [<ffffff80080fc93c>] pstate: 600003c5
[...]
---[ end trace 74631f9305ef5020 ]---
Call trace:
[<ffffff80080fc93c>] check_flags.part.35+0x17c/0x184
[<ffffff80080ffe30>] lock_acquire+0xa8/0xc4
[<ffffff8008093038>] breakpoint_handler+0x118/0x288
[<ffffff8008082434>] do_debug_exception+0x3c/0xa8
[<ffffff80080854b4>] el1_dbg+0x18/0x6c
[<ffffff80081e82f4>] do_filp_open+0x64/0xdc
[<ffffff80081d6e60>] do_sys_open+0x140/0x204
[<ffffff80081d6f58>] SyS_openat+0x10/0x18
[<ffffff8008085d30>] el0_svc_naked+0x24/0x28
possible reason: unannotated irqs-off.
irq event stamp: 65857
hardirqs last  enabled at (65857): [<ffffff80081fb1c0>] lookup_mnt+0xf4/0x1b4
hardirqs last disabled at (65856): [<ffffff80081fb188>] lookup_mnt+0xbc/0x1b4
softirqs last  enabled at (65790): [<ffffff80080bdca4>] __do_softirq+0x1f8/0x290
softirqs last disabled at (65757): [<ffffff80080be038>] irq_exit+0x9c/0xd0

This patch adds the annotations to do_debug_exception(), while trying not
to call trace_hardirqs_off() if el1_dbg() interrupted a task that already
had irqs disabled.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/mm/fault.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -518,18 +518,31 @@ asmlinkage int __exception do_debug_exce
 {
 	const struct fault_info *inf = debug_fault_info + DBG_ESR_EVT(esr);
 	struct siginfo info;
+	int rv;
 
-	if (!inf->fn(addr, esr, regs))
-		return 1;
+	/*
+	 * Tell lockdep we disabled irqs in entry.S. Do nothing if they were
+	 * already disabled to preserve the last enabled/disabled addresses.
+	 */
+	if (interrupts_enabled(regs))
+		trace_hardirqs_off();
 
-	pr_alert("Unhandled debug exception: %s (0x%08x) at 0x%016lx\n",
-		 inf->name, esr, addr);
+	if (!inf->fn(addr, esr, regs)) {
+		rv = 1;
+	} else {
+		pr_alert("Unhandled debug exception: %s (0x%08x) at 0x%016lx\n",
+			 inf->name, esr, addr);
 
-	info.si_signo = inf->sig;
-	info.si_errno = 0;
-	info.si_code  = inf->code;
-	info.si_addr  = (void __user *)addr;
-	arm64_notify_die("", regs, &info, 0);
+		info.si_signo = inf->sig;
+		info.si_errno = 0;
+		info.si_code  = inf->code;
+		info.si_addr  = (void __user *)addr;
+		arm64_notify_die("", regs, &info, 0);
+		rv = 0;
+	}
 
-	return 0;
+	if (interrupts_enabled(regs))
+		trace_hardirqs_on();
+
+	return rv;
 }

