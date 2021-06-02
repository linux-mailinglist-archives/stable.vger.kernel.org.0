Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE2239864D
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 12:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhFBKVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 06:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhFBKUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 06:20:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235FEC061359;
        Wed,  2 Jun 2021 03:17:56 -0700 (PDT)
Message-Id: <20210602101618.627715436@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622629075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=/Jk8BqEGhKI3fvl0aMu7kY8AMuceHqdD5GPwovljmik=;
        b=R7+6cM+S+Y4Io0oGaI+SSPodwPcKU8HkbqIm+03miq3MYPYI+iNzxGQK+qSkB2jTzXp9aj
        VeVOo56PI4AIi+doJV+4hrqsgaS6KUDSVEjXKUyJrWk99yb5kGTNwQbN1boeWWp4vNtSfG
        dXSsCTWrmMscH2swXmC95GU4I2DOB1JWizq5Et64dG4ULOZJN33+bkn5pVY4iL7mYA5gXO
        2IMfDgRarZFwmnpCoPCyCT172SErFuo3uyQevhMh4ApqUqrTHdj4Al8De+8TMZ6F95x6gg
        XOuc/h+CViQ1fjy6+PeIUplK/R5gfBc3uy7Iy5fLJ2t3H4uK5cMY25yzlSB7qg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622629075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=/Jk8BqEGhKI3fvl0aMu7kY8AMuceHqdD5GPwovljmik=;
        b=o9y2d7a2f6HwbB6JGqTsbHFEee3QJODv2WX9nTv3szfRT7QTdO6m4xGmrxt/xB67bMD8Um
        RGY5kuvQgrzcNcAg==
Date:   Wed, 02 Jun 2021 11:55:46 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>, stable@vger.kernel.org
Subject: [patch 3/8] x86/fpu: Invalidate FPU state after a failed XRSTOR from
 a user buffer
References: <20210602095543.149814064@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

If XRSTOR fails due to sufficiently complicated paging errors (e.g.
concurrent TLB invalidation), it may fault with #PF but still modify
portions of the user extended state.

If this happens in __fpu_restore_sig() with a victim task's FPU registers
loaded and the task is preempted by the victim task, the victim task
resumes with partially corrupt extended state.

Invalidate the FPU registers when XRSTOR fails to prevent this scenario.

Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
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

