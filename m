Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1E2376D
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbfETMsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388262AbfETMW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845E521783;
        Mon, 20 May 2019 12:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354978;
        bh=+GH+DCDK/EE36J4OWkKzbGvcyDu4QdcaLRrUrfIowyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynf6dIs9mPD3VHriFfqXPgkRLdqHOddecOCKkbfCeJ/uJUoXZyw3eJ3tiHLt8EupF
         BiwRULXFLU6oBGxsF93vyssC6Q494V6jLLpSG86GODFkRx6Zs/iUVe65fdEkiUjghj
         N09B+zFZWoyHONs2NfLzWOVeRUFkHk7tkaIxlhTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 002/105] x86/speculation/mds: Revert CPU buffer clear on double fault exit
Date:   Mon, 20 May 2019 14:13:08 +0200
Message-Id: <20190520115247.226620319@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 88640e1dcd089879530a49a8d212d1814678dfe7 upstream.

The double fault ESPFIX path doesn't return to user mode at all --
it returns back to the kernel by simulating a #GP fault.
prepare_exit_to_usermode() will run on the way out of
general_protection before running user code.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jon Masters <jcm@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Fixes: 04dcbdb80578 ("x86/speculation/mds: Clear CPU buffers on exit to user")
Link: http://lkml.kernel.org/r/ac97612445c0a44ee10374f6ea79c222fe22a5c4.1557865329.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/x86/mds.rst |    7 -------
 arch/x86/kernel/traps.c   |    8 --------
 2 files changed, 15 deletions(-)

--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -158,13 +158,6 @@ Mitigation points
      mitigated on the return from do_nmi() to provide almost complete
      coverage.
 
-   - Double fault (#DF):
-
-     A double fault is usually fatal, but the ESPFIX workaround, which can
-     be triggered from user space through modify_ldt(2) is a recoverable
-     double fault. #DF uses the paranoid exit path, so explicit mitigation
-     in the double fault handler is required.
-
    - Machine Check Exception (#MC):
 
      Another corner case is a #MC which hits between the CPU buffer clear
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -58,7 +58,6 @@
 #include <asm/alternative.h>
 #include <asm/fpu/xstate.h>
 #include <asm/trace/mpx.h>
-#include <asm/nospec-branch.h>
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
@@ -388,13 +387,6 @@ dotraplinkage void do_double_fault(struc
 		regs->ip = (unsigned long)general_protection;
 		regs->sp = (unsigned long)&gpregs->orig_ax;
 
-		/*
-		 * This situation can be triggered by userspace via
-		 * modify_ldt(2) and the return does not take the regular
-		 * user space exit, so a CPU buffer clear is required when
-		 * MDS mitigation is enabled.
-		 */
-		mds_user_clear_cpu_buffers();
 		return;
 	}
 #endif


