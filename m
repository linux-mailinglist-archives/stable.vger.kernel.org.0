Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC94CFA80
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbiCGKWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240793AbiCGKT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:19:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79E86622C;
        Mon,  7 Mar 2022 01:57:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B374C60BAF;
        Mon,  7 Mar 2022 09:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1EAC340F3;
        Mon,  7 Mar 2022 09:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647079;
        bh=YD3MXLQIQr/JqZEO7ZzfsiIS3V636Ue2jI9mSt6slXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0Le6pcXrdJxGs/IkMzOGT8m9B/z6GH54ZT31jhnhBu3uJ1V5y8/VRTL/1T1CLvNN
         GrSEixebweOAcg02nEuTCq5XNpyIBz40OUfMEw8pNqlAK2EU9ARUwFnJZjKjg6jAGS
         sEs8kGnMIFoPZwwOtddKuZfShRfGoWjwYcpEFOmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.16 184/186] s390/ftrace: fix arch_ftrace_get_regs implementation
Date:   Mon,  7 Mar 2022 10:20:22 +0100
Message-Id: <20220307091659.226167182@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 1389f17937a03fe4ec71b094e1aa6530a901963e upstream.

arch_ftrace_get_regs is supposed to return a struct pt_regs pointer
only if the pt_regs structure contains all register contents, which
means it must have been populated when created via ftrace_regs_caller.

If it was populated via ftrace_caller the contents are not complete
(the psw mask part is missing), and therefore a NULL pointer needs be
returned.

The current code incorrectly always returns a struct pt_regs pointer.

Fix this by adding another pt_regs flag which indicates if the
contents are complete, and fix arch_ftrace_get_regs accordingly.

Fixes: 894979689d3a ("s390/ftrace: provide separate ftrace_caller/ftrace_regs_caller implementations")
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/ftrace.h |   10 ++++++----
 arch/s390/include/asm/ptrace.h |    2 ++
 arch/s390/kernel/ftrace.c      |    2 +-
 arch/s390/kernel/mcount.S      |    9 +++++++++
 4 files changed, 18 insertions(+), 5 deletions(-)

--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -47,15 +47,17 @@ struct ftrace_regs {
 
 static __always_inline struct pt_regs *arch_ftrace_get_regs(struct ftrace_regs *fregs)
 {
-	return &fregs->regs;
+	struct pt_regs *regs = &fregs->regs;
+
+	if (test_pt_regs_flag(regs, PIF_FTRACE_FULL_REGS))
+		return regs;
+	return NULL;
 }
 
 static __always_inline void ftrace_instruction_pointer_set(struct ftrace_regs *fregs,
 							   unsigned long ip)
 {
-	struct pt_regs *regs = arch_ftrace_get_regs(fregs);
-
-	regs->psw.addr = ip;
+	fregs->regs.psw.addr = ip;
 }
 
 /*
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -15,11 +15,13 @@
 #define PIF_EXECVE_PGSTE_RESTART	1	/* restart execve for PGSTE binaries */
 #define PIF_SYSCALL_RET_SET		2	/* return value was set via ptrace */
 #define PIF_GUEST_FAULT			3	/* indicates program check in sie64a */
+#define PIF_FTRACE_FULL_REGS		4	/* all register contents valid (ftrace) */
 
 #define _PIF_SYSCALL			BIT(PIF_SYSCALL)
 #define _PIF_EXECVE_PGSTE_RESTART	BIT(PIF_EXECVE_PGSTE_RESTART)
 #define _PIF_SYSCALL_RET_SET		BIT(PIF_SYSCALL_RET_SET)
 #define _PIF_GUEST_FAULT		BIT(PIF_GUEST_FAULT)
+#define _PIF_FTRACE_FULL_REGS		BIT(PIF_FTRACE_FULL_REGS)
 
 #ifndef __ASSEMBLY__
 
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -291,7 +291,7 @@ void kprobe_ftrace_handler(unsigned long
 
 	regs = ftrace_get_regs(fregs);
 	p = get_kprobe((kprobe_opcode_t *)ip);
-	if (unlikely(!p) || kprobe_disabled(p))
+	if (!regs || unlikely(!p) || kprobe_disabled(p))
 		goto out;
 
 	if (kprobe_running()) {
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -27,6 +27,7 @@ ENDPROC(ftrace_stub)
 #define STACK_PTREGS_GPRS	(STACK_PTREGS + __PT_GPRS)
 #define STACK_PTREGS_PSW	(STACK_PTREGS + __PT_PSW)
 #define STACK_PTREGS_ORIG_GPR2	(STACK_PTREGS + __PT_ORIG_GPR2)
+#define STACK_PTREGS_FLAGS	(STACK_PTREGS + __PT_FLAGS)
 #ifdef __PACK_STACK
 /* allocate just enough for r14, r15 and backchain */
 #define TRACED_FUNC_FRAME_SIZE	24
@@ -57,6 +58,14 @@ ENDPROC(ftrace_stub)
 	.if \allregs == 1
 	stg	%r14,(STACK_PTREGS_PSW)(%r15)
 	stosm	(STACK_PTREGS_PSW)(%r15),0
+#ifdef CONFIG_HAVE_MARCH_Z10_FEATURES
+	mvghi	STACK_PTREGS_FLAGS(%r15),_PIF_FTRACE_FULL_REGS
+#else
+	lghi	%r14,_PIF_FTRACE_FULL_REGS
+	stg	%r14,STACK_PTREGS_FLAGS(%r15)
+#endif
+	.else
+	xc	STACK_PTREGS_FLAGS(8,%r15),STACK_PTREGS_FLAGS(%r15)
 	.endif
 
 	lg	%r14,(__SF_GPRS+8*8)(%r1)	# restore original return address


