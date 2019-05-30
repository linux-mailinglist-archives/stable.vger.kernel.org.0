Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5324B2EC7A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbfE3DVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbfE3DVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD68249BA;
        Thu, 30 May 2019 03:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186472;
        bh=e3s4UrEv6xMX5GRkiPYXSaV+FTPoCSQU4s8SkeHOC9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3GmCmTAxHhcLV1OPfLeAILfmRY6g30aDSBqL9zDOvMdwI9gcjpUugZPJfmoymQvl
         rve2bB64yfn5ADg+3GaZp+naE8po7kDVwICG6JfdUIjeDKpdVV4BWCyxbz8Ar8iUv3
         u5DrazS8Ii7VXkcDArJxt6o95f9yfuEYBEhIolSU=
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
Subject: [PATCH 4.9 102/128] x86/uaccess, signal: Fix AC=1 bloat
Date:   Wed, 29 May 2019 20:07:14 -0700
Message-Id: <20190530030452.954507391@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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
index b1a5d252d482a..ca010dfb9682b 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -129,16 +129,6 @@ static int restore_sigcontext(struct pt_regs *regs,
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
@@ -147,6 +137,15 @@ static int restore_sigcontext(struct pt_regs *regs,
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
@@ -458,6 +457,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 {
 	struct rt_sigframe __user *frame;
 	void __user *fp = NULL;
+	unsigned long uc_flags;
 	int err = 0;
 
 	frame = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe), &fp);
@@ -470,9 +470,11 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
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
 
@@ -538,6 +540,7 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
 {
 #ifdef CONFIG_X86_X32_ABI
 	struct rt_sigframe_x32 __user *frame;
+	unsigned long uc_flags;
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
@@ -552,9 +555,11 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
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



