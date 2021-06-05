Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BA639CBDD
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 02:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFFAeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 20:34:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32982 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhFFAeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 20:34:12 -0400
Message-Id: <20210606001323.213119142@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622939542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=2VF+NDL8aHdPcXubNDnSyn1t+1GOHiiBi2fdFTg3nOM=;
        b=jiiyTGEKqvRF7f1KpsKdYkwiYL4Aal3GwsvEHPf1FjsQC7FKS2WNILCVOA+VHphUf6mmvw
        c3Jt9P5JWXNQ8nRXZp8ViJz6A6ZfYCIpdACQpiLURm3d0NOE2U4NvUxBLFWNHPb1AejRpq
        s3NnaGRmfLpDdSQLIkh1jXxKi+dHgbHOp4rkNZbo6fE8cU7cM4LGl8goY/k3CGpJzzhfww
        7WSWjfd+pwKNbXFEgf8+KUDOq23sFEz6tOTQAtn3qWPxZv+bnh9QeXW+L7vzqDinNxbEM8
        mk5q0JHS+yEgFMV8yOpJ+GOKom0QsZymfQIn8isjI8lOkU/apYl+hsC5ns8ceg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622939542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=2VF+NDL8aHdPcXubNDnSyn1t+1GOHiiBi2fdFTg3nOM=;
        b=AdKrueCoATMjJEwt8Hg+P15B3Q9oo77qvB98uiqKQ4eq/HD86VLeZFI2K/iH8nMdZtrz7a
        F0ZBCi2XRdXcgdAg==
Date:   Sun, 06 Jun 2021 01:47:45 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: [patch V2 03/14] x86/fpu: Invalidate FPU state after a failed XRSTOR
 from a user buffer
References: <20210605234742.712464974@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

Both Intel and AMD consider it to be architecturally valid for XRSTOR to
fail with #PF but nonetheless change the register state.  The actual
conditions under which this might occur are unclear [1], but it seems
plausible that this might be triggered if one sibling thread unmaps a page
and invalidates the shared TLB while another sibling thread is executing
XRSTOR on the page in question.

__fpu__restore_sig() can execute XRSTOR while the hardware registers are
preserved on behalf of a different victim task (using the
fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
modify the registers.  If this happens, then there is a window in which
__fpu__restore_sig() could schedule out and the victim task could schedule
back in without reloading its own FPU registers.  This would result in part
of the FPU state that __fpu__restore_sig() was attempting to load leaking
into the victim task's user-visible state.

Invalidate preserved FPU registers on XRSTOR failure to prevent this
situation from corrupting any state.

[1] Frequent readers of the errata lists might imagine "complex
    microarchitectural conditions"

Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
V2: Amend changelog - Borislav
---
 arch/x86/kernel/fpu/signal.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -369,6 +369,27 @@ static int __fpu__restore_sig(void __use
 			fpregs_unlock();
 			return 0;
 		}
+
+		if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
+			/*
+			 * The FPU registers do not belong to current, and
+			 * we just did an FPU restore operation, restricted
+			 * to the user portion of the register file, and
+			 * failed.  In the event that the ucode was
+			 * unfriendly and modified the registers at all, we
+			 * need to make sure that we aren't corrupting an
+			 * innocent non-current task's registers.
+			 */
+			__cpu_invalidate_fpregs_state();
+		} else {
+			/*
+			 * As above, we may have just clobbered current's
+			 * user FPU state.  We will either successfully
+			 * load it or clear it below, so no action is
+			 * required here.
+			 */
+		}
+
 		fpregs_unlock();
 	} else {
 		/*

