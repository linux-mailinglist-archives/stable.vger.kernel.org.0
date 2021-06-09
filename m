Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261E73A17BD
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 16:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238100AbhFIOsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 10:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhFIOsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 10:48:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315CBC06175F;
        Wed,  9 Jun 2021 07:46:50 -0700 (PDT)
Date:   Wed, 09 Jun 2021 14:46:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623250008;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8RqiFPS5iKUzoNRDjUGgWjETur5unlhvBc2XMo3SK8=;
        b=IaqTkKroP61ri6LT12Vw8mzm2ZmRD1LfnalBspuK4DgCA8caraF2VIwJhp7SsMtEyFR1e8
        5GlkmZscH7j1romuQceq3ONrzTmGsvrNTVblbjriXW21lso/VY4GrWXfKIeesVcpKTkMXa
        XB5bBTKPw3ip0JUYJaztE3wPWEQfwkJW57C7RGq5MuHUYBIn8XRb0qqidkq+17g66bL6YE
        L0Ok4dey0N0dlk0o8jCsJq0zjBcntgigMMJqXrNbchV2rcN/0Dj61wiZpomV6fUF9JGnj8
        FzC4O1JN01GnVtOLraYm4s45dLXy1kH99fnY57ik+qktPpAsvao40JI0C/Pf6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623250008;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8RqiFPS5iKUzoNRDjUGgWjETur5unlhvBc2XMo3SK8=;
        b=OEoiSllh4xyrNjXkGGBUZ74VDTEDcAAj3uHAIV76E/LxMjoqShnuNEJYfv59tkJocgPHH3
        2UjlobCUwQwUbtCQ==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Invalidate FPU state after a failed XRSTOR
 from a user buffer
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210608144345.758116583@linutronix.de>
References: <20210608144345.758116583@linutronix.de>
MIME-Version: 1.0
Message-ID: <162325000806.29796.8910243345894312766.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     d8778e393afa421f1f117471144f8ce6deb6953a
Gitweb:        https://git.kernel.org/tip/d8778e393afa421f1f117471144f8ce6deb6953a
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Tue, 08 Jun 2021 16:36:19 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Jun 2021 09:49:38 +02:00

x86/fpu: Invalidate FPU state after a failed XRSTOR from a user buffer

Both Intel and AMD consider it to be architecturally valid for XRSTOR to
fail with #PF but nonetheless change the register state.  The actual
conditions under which this might occur are unclear [1], but it seems
plausible that this might be triggered if one sibling thread unmaps a page
and invalidates the shared TLB while another sibling thread is executing
XRSTOR on the page in question.

__fpu__restore_sig() can execute XRSTOR while the hardware registers
are preserved on behalf of a different victim task (using the
fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
modify the registers.

If this happens, then there is a window in which __fpu__restore_sig()
could schedule out and the victim task could schedule back in without
reloading its own FPU registers. This would result in part of the FPU
state that __fpu__restore_sig() was attempting to load leaking into the
victim task's user-visible state.

Invalidate preserved FPU registers on XRSTOR failure to prevent this
situation from corrupting any state.

[1] Frequent readers of the errata lists might imagine "complex
    microarchitectural conditions".

Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210608144345.758116583@linutronix.de
---
 arch/x86/kernel/fpu/signal.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index d5bc96a..4ab9aeb 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -369,6 +369,25 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			fpregs_unlock();
 			return 0;
 		}
+
+		/*
+		 * The above did an FPU restore operation, restricted to
+		 * the user portion of the registers, and failed, but the
+		 * microcode might have modified the FPU registers
+		 * nevertheless.
+		 *
+		 * If the FPU registers do not belong to current, then
+		 * invalidate the FPU register state otherwise the task might
+		 * preempt current and return to user space with corrupted
+		 * FPU registers.
+		 *
+		 * In case current owns the FPU registers then no further
+		 * action is required. The fixup below will handle it
+		 * correctly.
+		 */
+		if (test_thread_flag(TIF_NEED_FPU_LOAD))
+			__cpu_invalidate_fpregs_state();
+
 		fpregs_unlock();
 	} else {
 		/*
