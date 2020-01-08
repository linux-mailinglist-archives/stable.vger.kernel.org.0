Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9B134BE1
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgAHTrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:47:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43796 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730471AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHE-0006p6-3X; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007do9-TE; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>
Date:   Wed, 08 Jan 2020 19:43:44 +0000
Message-ID: <lsq.1578512578.444365079@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 46/63] arm64: debug: Don't propagate UNKNOWN FAR into
 si_code for debug signals
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

From: Will Deacon <will.deacon@arm.com>

commit b9a4b9d084d978f80eb9210727c81804588b42ff upstream.

FAR_EL1 is UNKNOWN for all debug exceptions other than those caused by
taking a hardware watchpoint. Unfortunately, if a debug handler returns
a non-zero value, then we will propagate the UNKNOWN FAR value to
userspace via the si_addr field of the SIGTRAP siginfo_t.

Instead, let's set si_addr to take on the PC of the faulting instruction,
which we have available in the current pt_regs.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/mm/fault.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -512,11 +512,12 @@ void __init hook_debug_fault_code(int nr
 	debug_fault_info[nr].name	= name;
 }
 
-asmlinkage int __exception do_debug_exception(unsigned long addr,
+asmlinkage int __exception do_debug_exception(unsigned long addr_if_watchpoint,
 					      unsigned int esr,
 					      struct pt_regs *regs)
 {
 	const struct fault_info *inf = debug_fault_info + DBG_ESR_EVT(esr);
+	unsigned long pc = instruction_pointer(regs);
 	struct siginfo info;
 	int rv;
 
@@ -527,16 +528,16 @@ asmlinkage int __exception do_debug_exce
 	if (interrupts_enabled(regs))
 		trace_hardirqs_off();
 
-	if (!inf->fn(addr, esr, regs)) {
+	if (!inf->fn(addr_if_watchpoint, esr, regs)) {
 		rv = 1;
 	} else {
 		pr_alert("Unhandled debug exception: %s (0x%08x) at 0x%016lx\n",
-			 inf->name, esr, addr);
+			 inf->name, esr, pc);
 
 		info.si_signo = inf->sig;
 		info.si_errno = 0;
 		info.si_code  = inf->code;
-		info.si_addr  = (void __user *)addr;
+		info.si_addr  = (void __user *)pc;
 		arm64_notify_die("", regs, &info, 0);
 		rv = 0;
 	}

