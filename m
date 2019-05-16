Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A1C20C54
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfEPQD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42518 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbfEPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:43 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImG-0006zQ-MV; Thu, 16 May 2019 16:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Qa-5P; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Jon Masters" <jcm@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.731637659@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 53/86] x86/speculation: Split out TIF update
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

commit e6da8bb6f9abb2628381904b24163c770e630bac upstream.

The update of the TIF_SSBD flag and the conditional speculation control MSR
update is done in the ssb_prctl_set() function directly. The upcoming prctl
support for controlling indirect branch speculation via STIBP needs the
same mechanism.

Split the code out and make it reusable. Reword the comment about updates
for other tasks.

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
Link: https://lkml.kernel.org/r/20181125185005.652305076@linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -760,10 +760,29 @@ static void ssb_select_mitigation(void)
 #undef pr_fmt
 #define pr_fmt(fmt)     "Speculation prctl: " fmt
 
-static int ssb_prctl_set(struct task_struct *task, unsigned long ctrl)
+static void task_update_spec_tif(struct task_struct *tsk, int tifbit, bool on)
 {
 	bool update;
 
+	if (on)
+		update = !test_and_set_tsk_thread_flag(tsk, tifbit);
+	else
+		update = test_and_clear_tsk_thread_flag(tsk, tifbit);
+
+	/*
+	 * Immediately update the speculation control MSRs for the current
+	 * task, but for a non-current task delay setting the CPU
+	 * mitigation until it is scheduled next.
+	 *
+	 * This can only happen for SECCOMP mitigation. For PRCTL it's
+	 * always the current task.
+	 */
+	if (tsk == current && update)
+		speculation_ctrl_update_current();
+}
+
+static int ssb_prctl_set(struct task_struct *task, unsigned long ctrl)
+{
 	if (ssb_mode != SPEC_STORE_BYPASS_PRCTL &&
 	    ssb_mode != SPEC_STORE_BYPASS_SECCOMP)
 		return -ENXIO;
@@ -774,28 +793,20 @@ static int ssb_prctl_set(struct task_str
 		if (task_spec_ssb_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ssb_disable(task);
-		update = test_and_clear_tsk_thread_flag(task, TIF_SSBD);
+		task_update_spec_tif(task, TIF_SSBD, false);
 		break;
 	case PR_SPEC_DISABLE:
 		task_set_spec_ssb_disable(task);
-		update = !test_and_set_tsk_thread_flag(task, TIF_SSBD);
+		task_update_spec_tif(task, TIF_SSBD, true);
 		break;
 	case PR_SPEC_FORCE_DISABLE:
 		task_set_spec_ssb_disable(task);
 		task_set_spec_ssb_force_disable(task);
-		update = !test_and_set_tsk_thread_flag(task, TIF_SSBD);
+		task_update_spec_tif(task, TIF_SSBD, true);
 		break;
 	default:
 		return -ERANGE;
 	}
-
-	/*
-	 * If being set on non-current task, delay setting the CPU
-	 * mitigation until it is next scheduled.
-	 */
-	if (task == current && update)
-		speculation_ctrl_update_current();
-
 	return 0;
 }
 

