Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6772513E2EB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgAPQ5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgAPQzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C1E422464;
        Thu, 16 Jan 2020 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193720;
        bh=ZTZnZ4ts1FJ1yy0xRdzO/bsNkPsXK5va8GxiQQXGiDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxT9BHJW+RgKfWAyDd+aCmqqiqkiToz1MwnAICMTgQzSqP6To9ywjtf+VkFmefgX9
         bh+pVI8dtUohjPmYWGwaE7I6JbpR6OIxt/V52HoCaPOBseGsVwDAmKjbCX7IGIcGT3
         1kp/T2xriE4YpzFm8nVN/iC9ty50RCe75MQwywqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 015/671] signal/ia64: Use the generic force_sigsegv in setup_frame
Date:   Thu, 16 Jan 2020 11:44:06 -0500
Message-Id: <20200116165502.8838-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
index d1234a5ba4c5..01fc133b2e4c 100644
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

