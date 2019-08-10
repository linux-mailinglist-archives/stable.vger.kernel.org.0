Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1418188DC0
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfHJUso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54792 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbfHJUoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00053a-Ko; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003ic-Rh; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Brian Gerst" <brgerst@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Wanpeng Li" <wanpeng.li@hotmail.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.374059540@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 124/157] x86/entry/64: Fix context tracking state
 warning when load_gs_index fails
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wanpeng Li <wanpeng.li@hotmail.com>

commit 2fa5f04f85730d0c4f49f984b7efeb4f8d5bd1fc upstream.

This warning:

 WARNING: CPU: 0 PID: 3331 at arch/x86/entry/common.c:45 enter_from_user_mode+0x32/0x50
 CPU: 0 PID: 3331 Comm: ldt_gdt_64 Not tainted 4.8.0-rc7+ #13
 Call Trace:
  dump_stack+0x99/0xd0
  __warn+0xd1/0xf0
  warn_slowpath_null+0x1d/0x20
  enter_from_user_mode+0x32/0x50
  error_entry+0x6d/0xc0
  ? general_protection+0x12/0x30
  ? native_load_gs_index+0xd/0x20
  ? do_set_thread_area+0x19c/0x1f0
  SyS_set_thread_area+0x24/0x30
  do_int80_syscall_32+0x7c/0x220
  entry_INT80_compat+0x38/0x50

... can be reproduced by running the GS testcase of the ldt_gdt test unit in
the x86 selftests.

do_int80_syscall_32() will call enter_form_user_mode() to convert context
tracking state from user state to kernel state. The load_gs_index() call
can fail with user gsbase, gsbase will be fixed up and proceed if this
happen.

However, enter_from_user_mode() will be called again in the fixed up path
though it is context tracking kernel state currently.

This patch fixes it by just fixing up gsbase and telling lockdep that IRQs
are off once load_gs_index() failed with user gsbase.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1475197266-3440-1-git-send-email-wanpeng.li@hotmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16 as dependency of commit 18ec54fdd6d1
 "x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations":
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/entry_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1447,7 +1447,6 @@ ENTRY(error_entry)
 	testl $3,CS+8(%rsp)
 	jz	.Lerror_kernelspace
 
-.Lerror_entry_from_usermode_swapgs:
 	/*
 	 * We entered from user mode or we're pretending to have entered
 	 * from user mode due to an IRET fault.
@@ -1480,7 +1479,8 @@ ENTRY(error_entry)
 	 * gsbase and proceed.  We'll fix up the exception and land in
 	 * gs_change's error handler with kernel gsbase.
 	 */
-	jmp	.Lerror_entry_from_usermode_swapgs
+	SWAPGS
+	jmp .Lerror_entry_done
 
 .Lbstep_iret:
 	/* Fix truncated RIP */

