Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1049B3A971
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfFIRKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbfFIRCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B895F206C3;
        Sun,  9 Jun 2019 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099769;
        bh=XjZM19HsHA3AL/XZJvRGvAdfoEQZhw+DsvrY4c2CoAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfannJtVtqQSRh/YE2NlV2Kb/P8N0IJQg0T2QD0nm8t+iVinfcKiuXpxCBu0EUIUW
         B1kHbJq4w9fYNjjZ8gEn8hQDHrBFBdFMAAofywten98Uf7Hyp8nlh8npFywcjbCOq/
         /92iPErFTbgzWC1Ibivt8SDhSJOTKlvct+XL0w8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 159/241] x86/ia32: Fix ia32_restore_sigcontext() AC leak
Date:   Sun,  9 Jun 2019 18:41:41 +0200
Message-Id: <20190609164152.354047157@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 67a0514afdbb8b2fc70b771b8c77661a9cb9d3a9 ]

Objtool spotted that we call native_load_gs_index() with AC set.
Re-arrange the code to avoid that.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/ia32/ia32_signal.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0552884da18db..a7b9acd709dbc 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -60,9 +60,8 @@
 } while (0)
 
 #define RELOAD_SEG(seg)		{		\
-	unsigned int pre = GET_SEG(seg);	\
+	unsigned int pre = (seg) | 3;		\
 	unsigned int cur = get_user_seg(seg);	\
-	pre |= 3;				\
 	if (pre != cur)				\
 		set_user_seg(seg, pre);		\
 }
@@ -71,6 +70,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   struct sigcontext_32 __user *sc)
 {
 	unsigned int tmpflags, err = 0;
+	u16 gs, fs, es, ds;
 	void __user *buf;
 	u32 tmp;
 
@@ -78,16 +78,10 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	current->restart_block.fn = do_no_restart_syscall;
 
 	get_user_try {
-		/*
-		 * Reload fs and gs if they have changed in the signal
-		 * handler.  This does not handle long fs/gs base changes in
-		 * the handler, but does not clobber them at least in the
-		 * normal case.
-		 */
-		RELOAD_SEG(gs);
-		RELOAD_SEG(fs);
-		RELOAD_SEG(ds);
-		RELOAD_SEG(es);
+		gs = GET_SEG(gs);
+		fs = GET_SEG(fs);
+		ds = GET_SEG(ds);
+		es = GET_SEG(es);
 
 		COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 		COPY(dx); COPY(cx); COPY(ip); COPY(ax);
@@ -105,6 +99,17 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 		buf = compat_ptr(tmp);
 	} get_user_catch(err);
 
+	/*
+	 * Reload fs and gs if they have changed in the signal
+	 * handler.  This does not handle long fs/gs base changes in
+	 * the handler, but does not clobber them at least in the
+	 * normal case.
+	 */
+	RELOAD_SEG(gs);
+	RELOAD_SEG(fs);
+	RELOAD_SEG(ds);
+	RELOAD_SEG(es);
+
 	err |= fpu__restore_sig(buf, 1);
 
 	force_iret();
-- 
2.20.1



