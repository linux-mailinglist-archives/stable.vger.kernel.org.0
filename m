Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7801D1F274
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfEOLLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfEOLLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C6DA20843;
        Wed, 15 May 2019 11:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918662;
        bh=fPtg07mn5JXl1EnPfOeUz+GMrsIXGxbmZlTK9Er5cfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jd+oaGlUMSQAbJb2y9im+COaccDk8ckbSUmPUw0DV0CXFvPupMu95WUoGiMmjcs8p
         oTlOSZxT7eaDCShk2HKbw0W3mZRiDa1EGMwrujL0GDw6a6eu0Jvj+sxUFHsgfPuI6I
         /LyI2W08Rt4EPQZDHKY6lclfVuFZWzTGn904NtRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Dave Stewart <david.c.stewart@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 218/266] x86/speculation: Avoid __switch_to_xtra() calls
Date:   Wed, 15 May 2019 12:55:25 +0200
Message-Id: <20190515090730.359208837@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/thread_info.h |   13 +++++++++++--
 arch/x86/kernel/process.h          |   15 +++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -150,9 +150,18 @@ struct thread_info {
 	_TIF_NOHZ)
 
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


