Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6E320C51
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfEPQD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42520 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbfEPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:43 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImG-0006zU-Ly; Thu, 16 May 2019 16:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001QR-24; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>, "Ingo Molnar" <mingo@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.122628530@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 51/86] x86/speculation: Avoid __switch_to_xtra() calls
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5635d99953f04b550738f6f4c1c532667c3fd872 upstream.

The TIF_SPEC_IB bit does not need to be evaluated in the decision to invoke
__switch_to_xtra() when:

 - CONFIG_SMP is disabled

 - The conditional STIPB mode is disabled

The TIF_SPEC_IB bit still controls IBPB in both cases so the TIF work mask
checks might invoke __switch_to_xtra() for nothing if TIF_SPEC_IB is the
only set bit in the work masks.

Optimize it out by masking the bit at compile time for CONFIG_SMP=n and at
run time when the static key controlling the conditional STIBP mode is
disabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185005.374062201@linutronix.de
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/thread_info.h | 13 +++++++++++--
 arch/x86/kernel/process.h          | 15 +++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -149,9 +149,18 @@ struct thread_info {
 	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW							\
+#define _TIF_WORK_CTXSW_BASE						\
 	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP|			\
-	 _TIF_SSBD|_TIF_SPEC_IB)
+	 _TIF_SSBD)
+
+/*
+ * Avoid calls to __switch_to_xtra() on UP as STIBP is not evaluated.
+ */
+#ifdef CONFIG_SMP
+# define _TIF_WORK_CTXSW	(_TIF_WORK_CTXSW_BASE | _TIF_SPEC_IB)
+#else
+# define _TIF_WORK_CTXSW	(_TIF_WORK_CTXSW_BASE)
+#endif
 
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
--- a/arch/x86/kernel/process.h
+++ b/arch/x86/kernel/process.h
@@ -2,6 +2,8 @@
 //
 // Code shared between 32 and 64 bit
 
+#include <asm/spec-ctrl.h>
+
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p);
 
 /*
@@ -14,6 +16,19 @@ static inline void switch_to_extra(struc
 	unsigned long next_tif = task_thread_info(next)->flags;
 	unsigned long prev_tif = task_thread_info(prev)->flags;
 
+	if (IS_ENABLED(CONFIG_SMP)) {
+		/*
+		 * Avoid __switch_to_xtra() invocation when conditional
+		 * STIPB is disabled and the only different bit is
+		 * TIF_SPEC_IB. For CONFIG_SMP=n TIF_SPEC_IB is not
+		 * in the TIF_WORK_CTXSW masks.
+		 */
+		if (!static_branch_likely(&switch_to_cond_stibp)) {
+			prev_tif &= ~_TIF_SPEC_IB;
+			next_tif &= ~_TIF_SPEC_IB;
+		}
+	}
+
 	/*
 	 * __switch_to_xtra() handles debug registers, i/o bitmaps,
 	 * speculation mitigations etc.

