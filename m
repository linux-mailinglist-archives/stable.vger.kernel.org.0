Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C547791514
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHRGff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 02:35:35 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41685 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726079AbfHRGff (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 02:35:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C194D21C57;
        Sun, 18 Aug 2019 02:35:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 18 Aug 2019 02:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5i/xlB
        bbxbwSCgMbqzph0PfAXskEdOxS4JuggjiSLDQ=; b=ExZKvfCCNIf3mJJpTrez57
        E9SVxFtyZZaF8blTkKc+9om524KS4uoMu0F0W52up2bLRmJT8fY73IUQ2XXykr4Z
        0WYRmkjuuPs+kFHpR+oIKljfrJiiA1ktBSYMnZjGtCweRcLCoVrQaYxdOnVbHG6o
        gtqr0u2RPP1lmZND+eHOvyZEWYoPRtPOe+L/EgCVAP6GLKxBJKdNCTHkebwxj2hX
        cTqVuBF9zmxBNiOMgQAB9cEv/n3l73vgN4B3Mln6jRKiHhaK/syD9Dl38N1mvEOJ
        NNzzML/6oOLtnze5BAE8UzMasyxJJznS+nc+j8Bna7rE8SJiby9jJYRRK7WJH0sw
        ==
X-ME-Sender: <xms:tfFYXd83YY6sRJ9jI9so2XKqWM0-O9r7pU1wT4Y80MdcogqWPfhnIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefiedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:tfFYXRS70no_iGAlFqDvtgrzGDPV6dOVnMdNCeIGZ54VHQ30X972rw>
    <xmx:tfFYXRfwvR2eD_e1jdaeGooRO0bVFT1dfNUGBxfUfuKJE2sL8UvGhA>
    <xmx:tfFYXRCykxjiWvcxI36Rd1ITzwqxN839HzyTA4TBIJqoWU2Pr9ZbGw>
    <xmx:tfFYXcCz_hRlQAE4c88UtoHriZAsE0MEInU9zv6RRe3ZFPRC9JcEJg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 036D5380084;
        Sun, 18 Aug 2019 02:35:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: Correct the initialized flow of FP register" failed to apply to 4.19-stable tree
To:     vincent.chen@sifive.com, anup@brainfault.org, hch@lst.de,
        paul.walmsley@sifive.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Aug 2019 08:35:31 +0200
Message-ID: <156611013139189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8ac71d7e46b94a4fc8ffc6f1c88004cdf24459e8 Mon Sep 17 00:00:00 2001
From: Vincent Chen <vincent.chen@sifive.com>
Date: Wed, 14 Aug 2019 16:23:52 +0800
Subject: [PATCH] riscv: Correct the initialized flow of FP register

  The following two reasons cause FP registers are sometimes not
initialized before starting the user program.
1. Currently, the FP context is initialized in flush_thread() function
   and we expect these initial values to be restored to FP register when
   doing FP context switch. However, the FP context switch only occurs in
   switch_to function. Hence, if this process does not be scheduled out
   and scheduled in before entering the user space, the FP registers
   have no chance to initialize.
2. In flush_thread(), the state of reg->sstatus.FS inherits from the
   parent. Hence, the state of reg->sstatus.FS may be dirty. If this
   process is scheduled out during flush_thread() and initializing the
   FP register, the fstate_save() in switch_to will corrupt the FP context
   which has been initialized until flush_thread().

  To solve the 1st case, the initialization of the FP register will be
completed in start_thread(). It makes sure all FP registers are initialized
before starting the user program. For the 2nd case, the state of
reg->sstatus.FS in start_thread will be set to SR_FS_OFF to prevent this
process from corrupting FP context in doing context save. The FP state is
set to SR_FS_INITIAL in start_trhead().

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 7db91e57a0acd ("RISC-V: Task implementation")
Cc: stable@vger.kernel.org
[paul.walmsley@sifive.com: fixed brace alignment issue reported by
 checkpatch]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 853b65ef656d..949d9cd91dec 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -19,6 +19,12 @@ static inline void __fstate_clean(struct pt_regs *regs)
 	regs->sstatus |= (regs->sstatus & ~(SR_FS)) | SR_FS_CLEAN;
 }
 
+static inline void fstate_off(struct task_struct *task,
+			      struct pt_regs *regs)
+{
+	regs->sstatus = (regs->sstatus & ~SR_FS) | SR_FS_OFF;
+}
+
 static inline void fstate_save(struct task_struct *task,
 			       struct pt_regs *regs)
 {
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index f23794bd1e90..fb3a082362eb 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -64,8 +64,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	unsigned long sp)
 {
 	regs->sstatus = SR_SPIE;
-	if (has_fpu)
+	if (has_fpu) {
 		regs->sstatus |= SR_FS_INITIAL;
+		/*
+		 * Restore the initial value to the FP register
+		 * before starting the user program.
+		 */
+		fstate_restore(current, regs);
+	}
 	regs->sepc = pc;
 	regs->sp = sp;
 	set_fs(USER_DS);
@@ -75,10 +81,11 @@ void flush_thread(void)
 {
 #ifdef CONFIG_FPU
 	/*
-	 * Reset FPU context
+	 * Reset FPU state and context
 	 *	frm: round to nearest, ties to even (IEEE default)
 	 *	fflags: accrued exceptions cleared
 	 */
+	fstate_off(current, task_pt_regs(current));
 	memset(&current->thread.fstate, 0, sizeof(current->thread.fstate));
 #endif
 }

