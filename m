Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E852EEF3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbfE3DvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732016AbfE3DTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF2F248C9;
        Thu, 30 May 2019 03:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186385;
        bh=6LftdqdCwOE0CXY9XVp3kFa+SyP6F6qzttsv7v36EZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huKsPXVMiemKW4g10QsrysZW49Q4Tl17KAnVS7nLb14UsEVwqsAlLb3fdHPMPHBOt
         AvMVoBm3gF2TSzkLZyRtyQRT64cYhOAebif5D1T6qvzhmKBXaJGxXIloyDOaryFgSt
         b/Jvk1fYw7HCoywLzTnG2IaiW4i0ejmAHsswW6Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 153/193] x86/uaccess, signal: Fix AC=1 bloat
Date:   Wed, 29 May 2019 20:06:47 -0700
Message-Id: <20190530030509.655232817@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 88e4718275c1bddca6f61f300688b4553dc8584b ]

Occasionally GCC is less agressive with inlining and the following is
observed:

  arch/x86/kernel/signal.o: warning: objtool: restore_sigcontext()+0x3cc: call to force_valid_ss.isra.5() with UACCESS enabled
  arch/x86/kernel/signal.o: warning: objtool: do_signal()+0x384: call to frame_uc_flags.isra.0() with UACCESS enabled

Cure this by moving this code out of the AC=1 region, since it really
isn't needed for the user access.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/signal.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4cdc0b27ec82f..01741834fd6a0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -131,16 +131,6 @@ static int restore_sigcontext(struct pt_regs *regs,
 		COPY_SEG_CPL3(cs);
 		COPY_SEG_CPL3(ss);
 
-#ifdef CONFIG_X86_64
-		/*
-		 * Fix up SS if needed for the benefit of old DOSEMU and
-		 * CRIU.
-		 */
-		if (unlikely(!(uc_flags & UC_STRICT_RESTORE_SS) &&
-			     user_64bit_mode(regs)))
-			force_valid_ss(regs);
-#endif
-
 		get_user_ex(tmpflags, &sc->flags);
 		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
 		regs->orig_ax = -1;		/* disable syscall checks */
@@ -149,6 +139,15 @@ static int restore_sigcontext(struct pt_regs *regs,
 		buf = (void __user *)buf_val;
 	} get_user_catch(err);
 
+#ifdef CONFIG_X86_64
+	/*
+	 * Fix up SS if needed for the benefit of old DOSEMU and
+	 * CRIU.
+	 */
+	if (unlikely(!(uc_flags & UC_STRICT_RESTORE_SS) && user_64bit_mode(regs)))
+		force_valid_ss(regs);
+#endif
+
 	err |= fpu__restore_sig(buf, IS_ENABLED(CONFIG_X86_32));
 
 	force_iret();
@@ -460,6 +459,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 {
 	struct rt_sigframe __user *frame;
 	void __user *fp = NULL;
+	unsigned long uc_flags;
 	int err = 0;
 
 	frame = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe), &fp);
@@ -472,9 +472,11 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+	uc_flags = frame_uc_flags(regs);
+
 	put_user_try {
 		/* Create the ucontext.  */
-		put_user_ex(frame_uc_flags(regs), &frame->uc.uc_flags);
+		put_user_ex(uc_flags, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
 		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
@@ -540,6 +542,7 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 {
 #ifdef CONFIG_X86_X32_ABI
 	struct rt_sigframe_x32 __user *frame;
+	unsigned long uc_flags;
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
@@ -554,9 +557,11 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 			return -EFAULT;
 	}
 
+	uc_flags = frame_uc_flags(regs);
+
 	put_user_try {
 		/* Create the ucontext.  */
-		put_user_ex(frame_uc_flags(regs), &frame->uc.uc_flags);
+		put_user_ex(uc_flags, &frame->uc.uc_flags);
 		put_user_ex(0, &frame->uc.uc_link);
 		compat_save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 		put_user_ex(0, &frame->uc.uc__pad0);
-- 
2.20.1



