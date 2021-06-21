Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C085E3AF08B
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFUQuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231164AbhFUQrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB9A86120D;
        Mon, 21 Jun 2021 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293225;
        bh=SLdZNVlc3QuvAH3Rngujdew2yvmtAj+wl+Hap5ihrjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXgS3yEJz/PtVIchon+65QdVQexEe3SchNmFxVrm48BDljZLp1hDHj+6q1MR2EBRh
         hG5qeO9WoNIE7APvElWFo8Wl7JwE3fxkkJKtMIhdQfZIdL6p59pXKLW7T/aFsb/kXn
         ViNzNXCtLzMXpV8IwcjTZ0dobs0XqfHoEFT6ZJbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH 5.12 145/178] x86/fpu: Invalidate FPU state after a failed XRSTOR from a user buffer
Date:   Mon, 21 Jun 2021 18:15:59 +0200
Message-Id: <20210621154927.708870613@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit d8778e393afa421f1f117471144f8ce6deb6953a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -369,6 +369,25 @@ static int __fpu__restore_sig(void __use
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


