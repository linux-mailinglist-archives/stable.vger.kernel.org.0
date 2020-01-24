Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78866147F1B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgAXK7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:59:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgAXK7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:59:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43FE2071A;
        Fri, 24 Jan 2020 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863583;
        bh=60uib51bS+yeMkqYX/u4R6lXEo5NGSCOFlJhmdAmbqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z659DngwT5SdA7ghUHgHu9XI7dtsGJRzW8Ny0OCi/nz3Cr8aeMufD6cow+zUWuls8
         470EpAwWCRbNcPSDW2+vq2DV7xac3Mr4Kasd66rzycWJo+drE1/PEOpnPYly+akVHh
         nqpgXJzDtAGov9OBGip7sHu9/fWiuXi7l9TOrx3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/639] signal/ia64: Use the generic force_sigsegv in setup_frame
Date:   Fri, 24 Jan 2020 10:23:22 +0100
Message-Id: <20200124093051.460492282@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 8b9c6b28312cc51a87055e292b11c5aa28f0c935 ]

The ia64 handling of failure to setup a signal frame has been trying
to set overlapping fields in struct siginfo since 2.3.43.  The si_pid
and si_uid fields are stomped when the si_addr field is set.  The
si_code of SI_KERNEL indicates that si_pid and si_uid should be valid,
and that si_addr does not exist.

Being at odds with the definition of SI_KERNEL and with nothing to
indicate that this was a signal frame setup failure there is no way
for userspace to know that si_addr was filled out instead.

In practice failure to setup a signal frame is rare, and si_pid and
si_uid are always set to 0 when si_code is SI_KERNEL so I expect no
one has looked closely enough before to see this weirdness.  Further
the only difference between force_sigsegv_info and the generic
force_sigsegv other than the return code is that force_sigsegv_info
stomps the si_uid and si_pid fields.

Remove the bug and simplify the code by using force_sigsegv in this
case just like other architectures.

Fixes: 2.3.43
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/signal.c | 50 ++++++++++-----------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index d1234a5ba4c55..01fc133b2e4c8 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -231,37 +231,6 @@ rbs_on_sig_stack (unsigned long bsp)
 	return (bsp - current->sas_ss_sp < current->sas_ss_size);
 }
 
-static long
-force_sigsegv_info (int sig, void __user *addr)
-{
-	unsigned long flags;
-	struct siginfo si;
-
-	clear_siginfo(&si);
-	if (sig == SIGSEGV) {
-		/*
-		 * Acquiring siglock around the sa_handler-update is almost
-		 * certainly overkill, but this isn't a
-		 * performance-critical path and I'd rather play it safe
-		 * here than having to debug a nasty race if and when
-		 * something changes in kernel/signal.c that would make it
-		 * no longer safe to modify sa_handler without holding the
-		 * lock.
-		 */
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		current->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
-	si.si_signo = SIGSEGV;
-	si.si_errno = 0;
-	si.si_code = SI_KERNEL;
-	si.si_pid = task_pid_vnr(current);
-	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
-	si.si_addr = addr;
-	force_sig_info(SIGSEGV, &si, current);
-	return 1;
-}
-
 static long
 setup_frame(struct ksignal *ksig, sigset_t *set, struct sigscratch *scr)
 {
@@ -295,15 +264,18 @@ setup_frame(struct ksignal *ksig, sigset_t *set, struct sigscratch *scr)
 			 * instead so we will die with SIGSEGV.
 			 */
 			check_sp = (new_sp - sizeof(*frame)) & -STACK_ALIGN;
-			if (!likely(on_sig_stack(check_sp)))
-				return force_sigsegv_info(ksig->sig, (void __user *)
-							  check_sp);
+			if (!likely(on_sig_stack(check_sp))) {
+				force_sigsegv(ksig->sig, current);
+				return 1;
+			}
 		}
 	}
 	frame = (void __user *) ((new_sp - sizeof(*frame)) & -STACK_ALIGN);
 
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		return force_sigsegv_info(ksig->sig, frame);
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame))) {
+		force_sigsegv(ksig->sig, current);
+		return 1;
+	}
 
 	err  = __put_user(ksig->sig, &frame->arg0);
 	err |= __put_user(&frame->info, &frame->arg1);
@@ -317,8 +289,10 @@ setup_frame(struct ksignal *ksig, sigset_t *set, struct sigscratch *scr)
 	err |= __save_altstack(&frame->sc.sc_stack, scr->pt.r12);
 	err |= setup_sigcontext(&frame->sc, set, scr);
 
-	if (unlikely(err))
-		return force_sigsegv_info(ksig->sig, frame);
+	if (unlikely(err)) {
+		force_sigsegv(ksig->sig, current);
+		return 1;
+	}
 
 	scr->pt.r12 = (unsigned long) frame - 16;	/* new stack pointer */
 	scr->pt.ar_fpsr = FPSR_DEFAULT;			/* reset fpsr for signal handler */
-- 
2.20.1



